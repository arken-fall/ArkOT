// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include <boost/range/adaptor/reversed.hpp>

#include "protocolgame.h"

#include "outputmessage.h"

#include "player.h"
#include "creaturecontainer.h"

#include "accountmanager.h"

#include "configmanager.h"
#include "console.h"
#include "appearances.h"
#include "bestiary.h"
#include "prey.h"
#include "forge.h"
#include "wheel.h"
#include "game.h"
#include "iologindata.h"
#include "iomarket.h"
#include "ban.h"
#include "scheduler.h"

#include <ranges>
#include <fmt/format.h>
#include <gtl/btree.hpp>

extern ConfigManager g_config;
extern CreatureEvents* g_creatureEvents;
extern Chat* g_chat;

using namespace BlackTek::Network;

namespace
{
	// the modern wire only knows creature types 0-5; the extended server
	// types have to collapse onto them or the client throws (and mehah
	// crashes on the null creature that leaves behind). Bosses render as
	// monsters, guild/party summons as hostile summons.
	// the element ids the client shows in the cyclopedia and the analysers
	constexpr std::array<std::pair<CombatType_t, CyclopediaElement>, 8> CyclopediaElements { {
		{ COMBAT_PHYSICALDAMAGE, CyclopediaElement::Physical },
		{ COMBAT_FIREDAMAGE, CyclopediaElement::Fire },
		{ COMBAT_EARTHDAMAGE, CyclopediaElement::Earth },
		{ COMBAT_ENERGYDAMAGE, CyclopediaElement::Energy },
		{ COMBAT_ICEDAMAGE, CyclopediaElement::Ice },
		{ COMBAT_HOLYDAMAGE, CyclopediaElement::Holy },
		{ COMBAT_DEATHDAMAGE, CyclopediaElement::Death },
		{ COMBAT_HEALING, CyclopediaElement::Healing },
	} };

	CyclopediaElement CyclopediaElementOf(CombatType_t combatType) noexcept
	{
		if (combatType == COMBAT_DROWNDAMAGE)
		{
			return CyclopediaElement::Drown;
		}
		if (combatType == COMBAT_LIFEDRAIN)
		{
			return CyclopediaElement::LifeDrain;
		}
		if (combatType == COMBAT_MANADRAIN)
		{
			return CyclopediaElement::ManaDrain;
		}
		const auto it = std::ranges::find(CyclopediaElements, combatType, &std::pair<CombatType_t, CyclopediaElement>::first);
		return it != CyclopediaElements.end() ? it->second : CyclopediaElement::Physical;
	}

	CreatureType_t ModernCreatureType(CreatureType_t type)
	{
		switch (type)
		{
			case CREATURETYPE_SUMMON_GUILD:
			case CREATURETYPE_SUMMON_PARTY:
				return CREATURETYPE_SUMMON_HOSTILE;
			case CREATURETYPE_BOSS:
				return CREATURETYPE_MONSTER;
			default:
				return type;
		}
	}

	std::deque<std::pair<int64_t, uint32_t>> waitList; // (timeout, player guid)
	auto priorityEnd = waitList.end();

	auto findClient(uint32_t guid) 
	{
		std::size_t slot = 1;
		for (auto it = waitList.begin(), end = waitList.end(); it != end; ++it, ++slot) 
		{
			if (it->second == guid) 
			{
				return std::make_pair(it, slot);
			}
		}

		return std::make_pair(waitList.end(), slot);
	}

	constexpr int64_t getWaitTime(std::size_t slot)
	{
		if (slot < 5) 
		{
			return 5;
		} 
		else if (slot < 10) 
		{
			return 10;
		} 
		else if (slot < 20) 
		{
			return 20;
		} 
		else if (slot < 50) 
		{
			return 60;
		} 
		else 
		{
			return 120;
		}
	}

	constexpr int64_t getTimeout(std::size_t slot)
	{
		// timeout is set to 15 seconds longer than expected retry attempt
		return getWaitTime(slot) + 15; // todo: turn magic number into config option
	}

	std::size_t clientLogin(const PlayerConstPtr& player)
	{
		if (player->hasFlag(PlayerFlag_CanAlwaysLogin) or player->getAccountType() >= ACCOUNT_TYPE_GAMEMASTER) 
		{
			return 0;
		}

		uint32_t maxPlayers = static_cast<uint32_t>(g_config.GetNumber(ConfigManager::MAX_PLAYERS));

		if (maxPlayers == 0 or (waitList.empty() and g_game.getPlayersOnline() < maxPlayers)) 
		{
			return 0;
		}

		int64_t time = OTSYS_TIME();

		auto it = waitList.begin();
		while (it != waitList.end()) 
		{
			if ((it->first - time) <= 0) 
			{
				it = waitList.erase(it);
			}
			else 
			{
				++it;
			}
		}

		std::size_t slot;
		std::tie(it, slot) = findClient(player->getGUID());

		if (it != waitList.end()) 
		{
			// If server has capacity for this client, let him in even though his current slot might be higher than 0.
			if ((g_game.getPlayersOnline() + slot) <= maxPlayers) 
			{
				waitList.erase(it);
				return 0;
			}

			//let them wait a bit longer
			it->first = time + (getTimeout(slot) * 1000);
			return slot;
		}


		if (player->isPremium()) 
		{
			priorityEnd = waitList.emplace(priorityEnd, time + (getTimeout(slot + 1) * 1000), player->getGUID());
			return std::distance(waitList.begin(), priorityEnd);
		}
		waitList.emplace_back(time + (getTimeout(waitList.size() + 1) * 1000), player->getGUID());
		return waitList.size();
	}


}

void ProtocolGame::release()
{
	//dispatcher thread
	if (player and player->client == shared_from_this()) 
	{
		player->client.reset();
		player = nullptr;
	}

	OutputMessagePool::getInstance().removeProtocolFromAutosend(shared_from_this());
	Protocol::release();
}

void ProtocolGame::login(uint32_t characterId, uint32_t accountId, OperatingSystem_t operatingSystem)
{
	//dispatcher thread
	const auto& foundPlayer = g_game.getPlayerByGUID(characterId);
	const auto managerEnabled = g_config.GetBoolean(ConfigManager::ENABLE_ACCOUNT_MANAGER);
	const auto isAccountManager = characterId == AccountManager::ID and managerEnabled;
	if (not foundPlayer or g_config.GetBoolean(ConfigManager::ALLOW_CLONES) or isAccountManager)
	{
		player = g_game.MakePlayer(getThis());
		
		player->setID();
		player->setGUID(characterId);

		if (not IOLoginData::preloadPlayer(player))
		{
			disconnectClient("Your character could not be loaded.");
			return;
		}

		if (IOBan::isPlayerNamelocked(player->getGUID()))
		{
			disconnectClient("Your character has been namelocked.");
			return;
		}

		if (g_game.getGameState() == GAME_STATE_CLOSING and not player->hasFlag(PlayerFlag_CanAlwaysLogin))
		{
			disconnectClient("The game is just going down.\nPlease try again later.");
			return;
		}

		if (g_game.getGameState() == GAME_STATE_CLOSED and not player->hasFlag(PlayerFlag_CanAlwaysLogin))
		{
			disconnectClient("Server is currently closed.\nPlease try again later.");
			return;
		}

		if (g_config.GetBoolean(ConfigManager::ONE_PLAYER_ON_ACCOUNT) 
			and characterId != AccountManager::ID 
			and player->getAccountType() < ACCOUNT_TYPE_GAMEMASTER 
			and g_game.getPlayerByAccount(player->getAccount()))
		{
			disconnectClient("You may only login with one character\nof your account at the same time.");
			return;
		}

		if (not player->hasFlag(PlayerFlag_CannotBeBanned))
		{
			BanInfo banInfo;
			if (IOBan::isAccountBanned(accountId, banInfo))
			{
				if (banInfo.reason.empty())
				{
					banInfo.reason = "(none)";
				}

				if (banInfo.expiresAt > 0)
				{
					disconnectClient(fmt::format("Your account has been banned until {:s} by {:s}.\n\nReason specified:\n{:s}", formatDateShort(banInfo.expiresAt), banInfo.bannedBy, banInfo.reason));
				}
				else
				{
					disconnectClient(fmt::format("Your account has been permanently banned by {:s}.\n\nReason specified:\n{:s}", banInfo.bannedBy, banInfo.reason));
				}
				return;
			}
		}

		if (std::size_t currentSlot = clientLogin(player))
		{
			uint8_t retryTime = getWaitTime(currentSlot);
			auto output = OutputMessagePool::getOutputMessage();
			output->add(ServerCode::LoginQueue);
			output->addString(fmt::format("Too many players online.\nYou are at place {:d} on the waiting list.", currentSlot));
			output->addByte(retryTime);
			send(std::move(output));
			disconnect();
			return;
		}

		std::vector<ConditionHandle> initialConditions;

		if (not IOLoginData::loadPlayerById(player, player->getGUID(), &initialConditions))
		{
			// initialConditions auto-releases via ConditionHandle destructors
			disconnectClient("Your character could not be loaded.");
			return;
		}

		player->setOperatingSystem(operatingSystem);

		// Todo : add back position spawn determined by config.lua
		if (isAccountManager)
		{
			// initialConditions auto-releases; account managers don't restore conditions

			player->accountNumber = accountId;
			// sync premium time from player account
			const auto account = IOLoginData::loadAccount(accountId);
			player->premiumEndsAt = account.premiumEndsAt;
			auto x = static_cast<uint16_t>(g_config.GetNumber(ConfigManager::ACCOUNT_MANAGER_POS_X));
			auto y = static_cast<uint16_t>(g_config.GetNumber(ConfigManager::ACCOUNT_MANAGER_POS_Y));
			auto z = static_cast<uint8_t>(g_config.GetNumber(ConfigManager::ACCOUNT_MANAGER_POS_Z));
			if (not g_game.placeCreature(player, Position{ x, y, z }))
			{
				if (not g_game.placeCreature(player, player->getTemplePosition(), false, true))
				{
					disconnectClient("Unable To Spawn Account Manager Please contact Admin!.");
					std::cout << "Account Manager Failed to spawn at location X = " << x << " Y = " << y << " Z = " << z << " \n";
					return;
				}
			}
		}
		else
		{
			if (not g_game.placeCreature(player, player->getLoginPosition()))
			{
				if (not g_game.placeCreature(player, player->getTemplePosition(), false, true))
				{
					// initialConditions auto-releases
					disconnectClient("Temple position is wrong. Contact the administrator.");
					return;
				}
			}

			for (auto& c : initialConditions)
				player->addCondition(std::move(c));
		}

		if (operatingSystem >= CLIENTOS_OTCLIENT_LINUX)
		{
			player->registerCreatureEvent("ExtendedOpcode");
		}

		player->lastIP = player->getIP();
		player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
		acceptPackets = true;
	} 
	else
	{
		if (eventConnect != 0 or not g_config.GetBoolean(ConfigManager::REPLACE_KICK_ON_LOGIN))
		{
			//Already trying to connect
			disconnectClient("You are already logged in.");
			return;
		}

		if (foundPlayer->client)
		{
			foundPlayer->disconnect();
			foundPlayer->isConnecting = true;

			eventConnect = g_scheduler.addEvent(createSchedulerTask(1000, [=, thisPtr = getThis(), playerID = foundPlayer->getID()]()
			{
				thisPtr->connect(playerID, operatingSystem);
			}));
		} 
		else
		{
			connect(foundPlayer->getID(), operatingSystem);
		}
	}
	OutputMessagePool::getInstance().addProtocolToAutosend(shared_from_this());
}

void ProtocolGame::connect(uint32_t playerId, OperatingSystem_t operatingSystem)
{
	eventConnect = 0;
	const auto& foundPlayer = g_game.getPlayerByID(playerId);

	if (not foundPlayer or foundPlayer->client) 
	{
		disconnectClient("You are already logged in.");
		return;
	}

	if (isConnectionExpired()) 
	{
		//ProtocolGame::release() has been called at this point and the Connection object
		//no longer exists, so we return to prevent leakage of the Player.
		return;
	}

	player = foundPlayer;
	g_chat->removeUserFromAllChannels(player);
	player->clearModalWindows();
	player->setOperatingSystem(operatingSystem);
	player->isConnecting = false;

	player->client = getThis();
	sendAddCreature(player, player->getPosition(), 0);
	player->lastIP = player->getIP();
	player->lastLoginSaved = std::max<time_t>(time(nullptr), player->lastLoginSaved + 1);
	player->resetIdleTime();
	acceptPackets = true;
}

void ProtocolGame::logout(bool displayEffect, bool forced)
{
	//dispatcher thread
	if (not player)
	{
		return;
	}

	if (not player->isRemoved())
	{
		if (not forced)
		{
			if (not player->isAccessPlayer())
			{
				if (Zones::ZoneManager::HasWorldFlag(player->getPosition(), Zones::ZoneFlag::NoLogout))
				{
					player->sendCancelMessage(RETURNVALUE_YOUCANNOTLOGOUTHERE);
					return;
				}

				if (not Zones::ZoneManager::HasWorldFlag(player->getPosition(), Zones::ZoneFlag::Protection) and player->hasCondition(CONDITION_INFIGHT))
				{
					player->sendCancelMessage(RETURNVALUE_YOUMAYNOTLOGOUTDURINGAFIGHT);
					return;
				}
			}

			//scripting event - onLogout
			if (not g_creatureEvents->playerLogout(player))
			{
				//Let the script handle the error message
				return;
			}
		}

		if (displayEffect and player->getHealth() > 0 and not player->isInGhostMode())
		{
			g_game.addMagicEffect(player->getPosition(), CONST_ME_POFF);
		}
	}

	disconnect();

	g_game.removeCreature(player);
}

void ProtocolGame::onRecvFirstMessage(NetworkMessage& msg)
{
	if (g_game.getGameState() == GAME_STATE_SHUTDOWN)
	{
		disconnect();
		return;
	}

	OperatingSystem_t operatingSystem = static_cast<OperatingSystem_t>(msg.get<uint16_t>());
	version = msg.get<uint16_t>();

	// The port the client walked in through fixes the framing generation;
	// the version it just claimed has to land in a profile of that same
	// generation or there is nothing to talk about.
	const TransportGeneration generation = usesModernFraming() ? TransportGeneration::Modern : TransportGeneration::Legacy;
	protocol_profile = resolveProfile(version, generation);
	if (not protocol_profile)
	{
		disconnectClient(fmt::format("Only clients with protocol {:s} allowed!", allowedProtocolVersions()));
		return;
	}

	const GameLoginLayout& layout = protocol_profile->loginLayout;

	// Pre-RSA version block. Field ORDER is the #1 source of bogus
	// "RSA decrypt failed" errors, so it is data-driven from the profile:
	// see the layout comment in protocolprofile.h before touching this.
	if (layout.clientVersionU32)
	{
		client_version = msg.get<uint32_t>();
	}

	if (layout.clientVersionString)
	{
		msg.getString(); // display version, e.g. "15.25.15286"
	}

	if (layout.assetHashString)
	{
		msg.getString(); // client asset catalog hash
	}

	if (layout.clientTypeU8)
	{
		msg.skipBytes(1);
	}

	if (layout.contentRevisionU16)
	{
		msg.skipBytes(2); // dat revision
	}

	if (layout.previewStateU8)
	{
		msg.skipBytes(1);
	}

	if (not Protocol::RSA_decrypt(msg))
	{
		disconnect();
		return;
	}

	xtea::key key;
	key[0] = msg.get<uint32_t>();
	key[1] = msg.get<uint32_t>();
	key[2] = msg.get<uint32_t>();
	key[3] = msg.get<uint32_t>();

	// session key dump for harness/packet_diff.py --xtea; dev-rig only
	if (std::getenv("BLACKTEK_DEBUG_XTEA") != nullptr)
	{
		BlackTek::Console::Info("XTEA session key: {:08x} {:08x} {:08x} {:08x}", key[0], key[1], key[2], key[3]);
	}

	enableXTEAEncryption();
	setXTEAKey(std::move(key));

	if (hasFeature(ProtocolFeature::SequenceChecksum))
	{
		setChecksumMode(ChecksumMode::Sequence);
	}

	if (operatingSystem >= CLIENTOS_OTCLIENT_LINUX)
	{
		NetworkMessage opcodeMessage;
		opcodeMessage.add(ServerCode::ExtendedOpcode);
		opcodeMessage.add(CommonCode::Zero); // uint8_t -- 1 byte width
		opcodeMessage.add<SpecialCode>(SpecialCode::Zero); // uint16_t -- 2 byte width
		writeToOutputBuffer(opcodeMessage);
	}

	msg.skipBytes(1); // gamemaster flag

	// Both generations bundle credentials into one string; they just disagree
	// about what goes in it. Legacy 10.98: "acc\npass\ntoken\ntime". Modern: an
	// opaque session key from the login service, or "email\npass[\ntoken[\ntime]]"
	// when an OTClient-family client logs in directly against this server.
	std::string_view accountName;
	std::string_view password;
	std::string_view token;
	uint32_t tokenTime = 0;

	auto credentialString = msg.getString();
	auto sessionArgs = explodeString(credentialString, "\n", 4);

	// A modern credential string without separators is an opaque session key
	// issued by the login webservice; anything with '\n' in it is direct
	// email/password login (OTClient-family clients support both).
	const bool opaqueSessionKey = layout.sessionKeyLogin and sessionArgs.size() < 2;

	if (not opaqueSessionKey)
	{
		if (sessionArgs.size() < 2)
		{
			disconnect();
			return;
		}

		accountName = sessionArgs[0];
		password = sessionArgs[1];

		if (sessionArgs.size() > 2)
		{
			token = sessionArgs[2];
		}

		if (sessionArgs.size() > 3)
		{
			try
			{
				tokenTime = std::stoul(std::string(sessionArgs[3]));
			}
			catch (const std::invalid_argument&) {
				disconnectClient("Malformed token packet.");
				return;
			}
			catch (const std::out_of_range&)
			{
				disconnectClient("Token time is too long.");
				return;
			}
		}
		else if (not layout.sessionKeyLogin)
		{
			// Legacy clients always send all four fields; a short bundle is a
			// malformed packet, not an optional-field situation.
			disconnect();
			return;
		}
	}

	if (layout.sessionKeyLogin and operatingSystem == CLIENTOS_NEW_LINUX)
	{
		// CipSoft's linux client sends two extra strings here; contents
		// currently undocumented (canary skips them the same way).
		msg.getString();
		msg.getString();
	}

	std::string characterName{ msg.getString() };
	uint32_t timeStamp = msg.get<uint32_t>();
	uint8_t randNumber = msg.getByte();

	if (challengeTimestamp != timeStamp or challengeRandom != randNumber)
	{
		disconnect();
		return;
	}

	if (layout.otcV8Probe)
	{
		uint16_t probeLength = msg.get<uint16_t>();
		if (probeLength == 5 and msg.getString(5) == "OTCv8")
		{
			msg.skipBytes(2); // OTCv8 build number
		}
	}

	// the rest touches the database, so it runs on the dispatcher; the
	// credential views point into this message and have to be copied out
	g_dispatcher.addTask([thisPtr = getThis(), accountName = std::string(accountName), password = std::string(password), characterName = std::string(characterName), token = std::string(token), tokenTime, operatingSystem, sessionKey = opaqueSessionKey ? std::string(credentialString) : std::string()]() mutable
	{
		thisPtr->authenticateAndLogin(std::move(accountName), std::move(password), std::move(characterName), std::move(token), tokenTime, operatingSystem, std::move(sessionKey));
	});
}

void ProtocolGame::authenticateAndLogin(std::string accountName, std::string password, std::string characterName, std::string token, uint32_t tokenTime, OperatingSystem_t operatingSystem, std::string sessionKey)
{
	//dispatcher thread
	const bool opaqueSessionKey = not sessionKey.empty();

	if (not opaqueSessionKey
		and accountName.empty()
		and password.empty()
		and g_config.GetBoolean(ConfigManager::ENABLE_ACCOUNT_MANAGER)
		and g_config.GetBoolean(ConfigManager::ENABLE_NO_PASS_LOGIN))
	{
		accountName = g_config.GetString(ConfigManager::ACCOUNT_MANAGER_AUTH);
		password = g_config.GetString(ConfigManager::ACCOUNT_MANAGER_AUTH);
	}

	if (g_game.getGameState() == GAME_STATE_STARTUP)
	{
		disconnectClient("Gameworld is starting up. Please wait.");
		return;
	}

	if (g_game.getGameState() == GAME_STATE_MAINTAIN)
	{
		disconnectClient("Gameworld is under maintenance. Please re-connect in a while.");
		return;
	}

	BanInfo banInfo;
	if (IOBan::isIpBanned(getIP(), banInfo))
	{
		if (banInfo.reason.empty())
		{
			banInfo.reason = "(none)";
		}

		disconnectClient(fmt::format("Your IP has been banned until {:s} by {:s}.\n\nReason specified:\n{:s}", formatDateShort(banInfo.expiresAt), banInfo.bannedBy, banInfo.reason));
		return;
	}

	auto [accountId, characterId] = opaqueSessionKey
		? IOLoginData::sessionKeyAuthentication(sessionKey, characterName)
		: IOLoginData::gameworldAuthentication(accountName, password, characterName, token, tokenTime);
	if (characterName == AccountManager::NAME)
	{
		if (accountId == 0)
		{
			std::tie(accountId, characterId) = IOLoginData::getAccountIdByAccountName(accountName, password, characterName);
		}
	}

	if (accountId == 0)
	{
		if (opaqueSessionKey)
		{
			disconnectClient("Your session has expired. Please log in again.");
			return;
		}

		disconnectClient("Account name or password is not correct.");
		return;
	}

	login(characterId, accountId, operatingSystem);
}

void ProtocolGame::onConnect()
{
	auto output = OutputMessagePool::getOutputMessage();
	static std::random_device rd;
	static std::ranlux24 generator(rd());
	static std::uniform_int_distribution<uint16_t> randNumber(0, 255);

	challengeTimestamp = static_cast<uint32_t>(time(nullptr));
	challengeRandom = randNumber(generator);

	if (usesModernFraming())
	{
		// Modern challenge is a plain 8-byte body; onSendMessage frames it
		// with the adler checksum and the block-count length. The 0x01 lead
		// byte and 0x71 tail are what 13.40+ clients expect on this packet -
		// layout referenced from canary's sendLoginChallenge.
		output->addByte(0x01);
		output->add(ServerCode::Challenge);
		output->add<uint32_t>(challengeTimestamp);
		output->addByte(challengeRandom);
		output->addByte(0x71);

		send(std::move(output));
		return;
	}

	// Skip checksum
	output->skipBytes(sizeof(uint32_t));

	// Packet length & type
	output->add<uint16_t>(6);
	output->add(ServerCode::Challenge);

	// Add timestamp & random number
	output->add<uint32_t>(challengeTimestamp);
	output->addByte(challengeRandom);

	// Go back and write checksum
	output->skipBytes(-12);
	output->add<uint32_t>(adlerChecksum(output->getOutputBuffer() + sizeof(uint32_t), 8));

	send(std::move(output));
}

void ProtocolGame::disconnectClient(const std::string& message) const
{
	auto output = OutputMessagePool::getOutputMessage();
	output->add(ServerCode::LoginOrPendingState);
	output->addString(message);
    send(std::move(output));
	disconnect();
}

void ProtocolGame::writeToOutputBuffer(const NetworkMessage& msg)
{
	auto out = getOutputBuffer(msg.getLength());
	out->append(msg);
}

void ProtocolGame::parsePacket(NetworkMessage& msg)
{
	if (not acceptPackets or g_game.getGameState() == GAME_STATE_SHUTDOWN or msg.getLength() == 0)
	{
		return;
	}

	ClientCode recvbyte = static_cast<ClientCode>(msg.getByte());

	if (not player)
	{
		if (static_cast<ClientCode>(recvbyte) == ClientCode::Exit)
		{
			disconnect();
		}

		return;
	}

	//a dead player can not performs actions
	if (player->isRemoved() or player->getHealth() <= 0)
	{
		if (static_cast<ClientCode>(recvbyte) == ClientCode::Exit)
		{
			disconnect();
			return;
		}

		if (static_cast<ClientCode>(recvbyte) != ClientCode::Logout)
		{
			return;
		}
	}

	auto player_id = player->getID();

	// Account Manager
	if (player->isAccountManager())
	{
		switch (recvbyte)
		{
			case ClientCode::Logout: addGameTask([thisPtr = getThis()]() { thisPtr->logout(true, false); });	break;
			case ClientCode::PingBack: addGameTask([player_id]() { g_game.playerReceivePingBack(player_id); }); break;
			case ClientCode::Ping: addGameTask([player_id]() { g_game.playerReceivePing(player_id); }); break;
			case ClientCode::TextWindow: parseTextWindow(msg); break;
			case ClientCode::ModalWindowAnswer: parseModalWindowAnswer(msg); break;
			default: addGameTask([player_id]() { g_game.doAccountManagerReset(player_id); });	break;
		}

		if (msg.isOverrun())
		{
			disconnect();
		}
		return;
	}


	switch (recvbyte)
	{
		case ClientCode::Logout: addGameTask([thisPtr = getThis()]() { thisPtr->logout(true, false); }); break;
		case ClientCode::PingBack: addGameTask([player_id]() { g_game.playerReceivePingBack(player_id); }); break;
		case ClientCode::Ping: addGameTask([player_id]() { g_game.playerReceivePing(player_id); }); break;
		case ClientCode::ExtendedOpcode: parseExtendedOpcode(msg); break; //otclient extended opcode
		case ClientCode::AutoWalk: parseAutoWalk(msg); break;
		case ClientCode::MoveNorth: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_NORTH); }); break;
		case ClientCode::MoveEast: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_EAST); }); break;
		case ClientCode::MoveSouth: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_SOUTH); }); break;
		case ClientCode::MoveWest: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_WEST); }); break;
		case ClientCode::StopAutoWalk: addGameTask([player_id]() { g_game.playerStopAutoWalk(player_id); }); break;
		case ClientCode::MoveNorthEast: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_NORTHEAST); }); break;
		case ClientCode::MoveSouthEast: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_SOUTHEAST); }); break;
		case ClientCode::MoveSouthWest: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_SOUTHWEST); }); break;
		case ClientCode::MoveNorthWest: addGameTask([player_id]() { g_game.playerMove(player_id, DIRECTION_NORTHWEST); }); break;
		case ClientCode::TurnNorth: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [player_id]() { g_game.playerTurn(player_id, DIRECTION_NORTH); }); break;
		case ClientCode::TurnEast: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [player_id]() { g_game.playerTurn(player_id, DIRECTION_EAST); }); break;
		case ClientCode::TurnSouth: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [player_id]() { g_game.playerTurn(player_id, DIRECTION_SOUTH); }); break;
		case ClientCode::TurnWest: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [player_id]() { g_game.playerTurn(player_id, DIRECTION_WEST); }); break;
		case ClientCode::Teleport: parseTeleport(msg); break;
		case ClientCode::RequestBlessingsDialog: addGameTask([player_id]() { g_game.playerRequestBlessingsDialog(player_id); }); break;
		case ClientCode::CyclopediaCharacterInfo: parseCyclopediaCharacterInfo(msg); break;
		case ClientCode::PreyRequest: addGameTask([player_id]() { if (const auto& p = g_game.getPlayerByID(player_id)) p->sendPreySlots(); }); break;
		case ClientCode::PreyAction: parsePreyAction(msg); break;
		case ClientCode::ForgeEnter: parseForgeAction(msg); break;
		case ClientCode::ForgeBrowseHistory: parseForgeHistory(msg); break;
		case ClientCode::OpenWheel: parseOpenWheel(msg); break;
		case ClientCode::SaveWheel: parseSaveWheel(msg); break;
		case ClientCode::BestiaryRaces: addGameTask([player_id]() { if (const auto& p = g_game.getPlayerByID(player_id)) p->sendBestiaryRaces(); }); break;
		case ClientCode::BestiaryCreatures: parseBestiaryOverview(msg); break;
		case ClientCode::BestiaryMonsterData: parseBestiaryMonsterData(msg); break;
		case ClientCode::BuyCharmRune: parseBuyCharmRune(msg); break;
		case ClientCode::CyclopediaMonsterTracker: parseBestiaryTracker(msg); break;
		case ClientCode::InspectionObject: parseInspectionObject(msg); break;
		case ClientCode::InspectPlayer: parseInspectPlayer(msg); break;
		case ClientCode::EquipObject: parseEquipObject(msg); break;
		case ClientCode::Throw: parseThrow(msg); break;
		case ClientCode::LookInShop: parseLookInShop(msg); break;
		case ClientCode::Purchase: parsePlayerPurchase(msg); break;
		case ClientCode::Sale: parsePlayerSale(msg); break;
		case ClientCode::CloseShop: addGameTask([player_id]() { g_game.playerCloseShop(player_id); }); break;
		case ClientCode::RequestTrade: parseRequestTrade(msg); break;
		case ClientCode::LookInTrade: parseLookInTrade(msg); break;
		case ClientCode::AcceptTrade: addGameTask([player_id]() { g_game.playerAcceptTrade(player_id); }); break;
		case ClientCode::CloseTrade: addGameTask([player_id]() { g_game.playerCloseTrade(player_id); }); break;
		case ClientCode::UseItem: parseUseItem(msg); break;
		case ClientCode::UseItemEx: parseUseItemEx(msg); break;
		case ClientCode::UseWithCreature: parseUseWithCreature(msg); break;
		case ClientCode::RotateItem: parseRotateItem(msg); break;
		case ClientCode::CloseContainer: parseCloseContainer(msg); break;
		case ClientCode::UpArrowContainer: parseUpArrowContainer(msg); break;
		case ClientCode::TextWindow: parseTextWindow(msg); break;
		case ClientCode::HouseWindow: parseHouseWindow(msg); break;
		case ClientCode::WrapItem: parseWrapItem(msg); break;
		case ClientCode::LookAt: parseLookAt(msg); break;
		case ClientCode::LookInBattleList: parseLookInBattleList(msg); break;
		case ClientCode::JoinAggression: /* join aggression */ break;
		case ClientCode::Say: parseSay(msg); break;
		case ClientCode::RequestChannels: addGameTask([player_id]() { g_game.playerRequestChannels(player_id); }); break;
		case ClientCode::OpenChannel: parseOpenChannel(msg); break;
		case ClientCode::CloseChannel: parseCloseChannel(msg); break;
		case ClientCode::OpenPrivateChannel: parseOpenPrivateChannel(msg); break;
		case ClientCode::CloseNpcChannel: addGameTask([player_id]() { g_game.playerCloseNpcChannel(player_id); }); break;
		case ClientCode::FightMode: parseFightModes(msg); break;
		case ClientCode::Attack: parseAttack(msg); break;
		case ClientCode::Follow: parseFollow(msg); break;
		case ClientCode::InviteToParty: parseInviteToParty(msg); break;
		case ClientCode::JoinParty: parseJoinParty(msg); break;
		case ClientCode::RevokePartyInvite: parseRevokePartyInvite(msg); break;
		case ClientCode::PassPartyLeadership: parsePassPartyLeadership(msg); break;
		case ClientCode::LeaveParty: addGameTask([player_id]() { g_game.playerLeaveParty(player_id); }); break;
		case ClientCode::EnableSharedPartyExperience: parseEnableSharedPartyExperience(msg); break;
		case ClientCode::CreatePrivateChannel: addGameTask([player_id]() { g_game.playerCreatePrivateChannel(player_id); }); break;
		case ClientCode::ChannelInvite: parseChannelInvite(msg); break;
		case ClientCode::ChannelExclude: parseChannelExclude(msg); break;
		case ClientCode::CancelAttackAndFollow: addGameTask([player_id]() { g_game.playerCancelAttackAndFollow(player_id); }); break;
		case ClientCode::UpdateTile: /* update tile */ break;
		case ClientCode::UpdateContainer: parseUpdateContainer(msg); break;
		case ClientCode::BrowseField: parseBrowseField(msg); break;
		case ClientCode::SeekInContainer: parseSeekInContainer(msg); break;
		case ClientCode::RequestOutfit: addGameTask([player_id]() { g_game.playerRequestOutfit(player_id); }); break;
		case ClientCode::SetOutfit: parseSetOutfit(msg); break;
		case ClientCode::ToggleMount: parseToggleMount(msg); break;
		case ClientCode::AddVip: parseAddVip(msg); break;
		case ClientCode::RemoveVip: parseRemoveVip(msg); break;
		case ClientCode::EditVip: parseEditVip(msg); break;
		case ClientCode::BugReport: parseBugReport(msg); break;
		case ClientCode::WheelGemAction: parseWheelGemAction(msg); break;
		case ClientCode::StoreOfferDescription: parseStoreOfferDescription(msg); break;
		case ClientCode::StoreEvent: /* the client's store telemetry; nothing to answer */ break;
		case ClientCode::TransferCoins: parseTransferCoins(msg); break;
		///new protocol byte maybe? ///case 0xEE: addGameTask([player_id]() { g_game.playerSay(player_id, 0, TALKTYPE_SAY, "", "hi"); }); break;
		case ClientCode::ShowQuestLog: addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [player_id]() { g_game.playerShowQuestLog(player_id); }); break;
		case ClientCode::QuestLine: parseQuestLine(msg); break;
		case ClientCode::RuleViolationReport: parseRuleViolationReport(msg); break;
		case ClientCode::GetObjectInfo: /* get object info */ break;
		case ClientCode::MarketLeave: parseMarketLeave(); break;
		case ClientCode::MarketBrowse: parseMarketBrowse(msg); break;
		case ClientCode::MarketCreateOffer: parseMarketCreateOffer(msg); break;
		case ClientCode::MarketCancelOffer: parseMarketCancelOffer(msg); break;
		case ClientCode::MarketAcceptOffer: parseMarketAcceptOffer(msg); break;
		case ClientCode::ModalWindowAnswer:   parseModalWindowAnswer(msg); break;
		case ClientCode::GameStoreRequest:    parseGameStoreRequest(msg); break;
		case ClientCode::StoreSelectCategory: parseStoreSelectCategory(msg); break;
		case ClientCode::StoreBuyOffer:       parseStoreBuyOffer(msg); break;
		case ClientCode::StoreOpenHistory:    parseStoreOpenHistory(msg); break;
		case ClientCode::StoreRequestHistory: parseStoreRequestHistory(msg); break;

		default:
			BlackTek::Console::Net::Debug("ProtocolGame::parsePacket: {:s} sent an unhandled opcode 0x{:02X}", player->getName(), static_cast<uint16_t>(recvbyte));
			break;
	}

	if (msg.isOverrun())
	{
		disconnect();
	}
}

void ProtocolGame::GetTileDescription(const TileConstPtr& tile, NetworkMessage& msg)
{
	if (not usesModernLayout())
	{
		msg.add<SpecialCode>(SpecialCode::Zero); //environmental effects (dropped in 12.81+)
	}

	int32_t count;
	if (const auto& ground = tile->getGround())
	{
		addItem(msg, ground);
		count = 1;
	} 
	else
	{
		count = 0;
	}

	const auto& items = tile->getItemList();
	if (items)
	{
		for (auto it = items->getBeginTopItem(), end = items->getEndTopItem(); it != end; ++it)
		{
			addItem(msg, *it);

			if (++count == 10)
			{
				break;
			}
		}
	}

	if (const auto& creatures = tile->getCreatures())
	{
		for (const auto& creature : boost::adaptors::reverse(creatures->getList()))
		{
			if (not player->canSeeCreature(creature) or count >= 10)
			{
				continue;
			}

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);
			++count;
		}
	}

	if (items and count < 10)
	{
		for (auto it = items->getBeginDownItem(), end = items->getEndDownItem(); it != end; ++it)
		{
			addItem(msg, *it);

			if (++count == 10)
			{
				return;
			}
		}
	}
}

void ProtocolGame::GetMapDescription(int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, NetworkMessage& msg)
{
	int32_t skip = -1;
	int32_t startz, endz, zstep;

	if (z > 7)
	{
		startz = z - 2;
		endz = std::min<int32_t>(BlackTek::World::MaxLayers - 1, z + 2);
		zstep = 1;
	} 
	else
	{
		startz = 7;
		endz = 0;
		zstep = -1;
	}

	for (int32_t nz = startz; nz != endz + zstep; nz += zstep)
	{
		GetFloorDescription(msg, x, y, nz, width, height, z - nz, skip);
	}

	if (skip >= 0)
	{
		msg.addByte(skip);
		msg.add(CommonCode::End);
	}
}

void ProtocolGame::GetFloorDescription(NetworkMessage& msg, int32_t x, int32_t y, int32_t z, int32_t width, int32_t height, int32_t offset, int32_t& skip)
{
	for (int32_t nx = 0; nx < width; nx++)
	{
		for (int32_t ny = 0; ny < height; ny++)
		{
			if (const auto& tile = g_game.map.getTile(x + nx + offset, y + ny + offset, z))
			{
				if (skip >= 0)
				{
					msg.addByte(skip);
					msg.add(CommonCode::End);
				}

				skip = 0;
				GetTileDescription(tile, msg);
			}
			else if (skip == 0xFE)
			{
				msg.add(CommonCode::End);
				msg.add(CommonCode::End);
				skip = -1;
			} 
			else
			{
				++skip;
			}
		}
	}
}

void ProtocolGame::checkCreatureAsKnown(uint32_t id, bool& known, uint32_t& removedKnown)
{
	const auto result = knownCreatureSet.Insert(id);
	known = result.known;
	removedKnown = result.evictedId;
}

bool ProtocolGame::canSee(const CreatureConstPtr& creature) const
{
	if (not creature or not player or creature->isRemoved())
	{
		return false;
	}

	if (not player->canSeeCreature(creature))
	{
		return false;
	}

	return canSee(creature->getPosition());
}

bool ProtocolGame::canSee(const Position& pos) const
{
	return canSee(pos.x, pos.y, pos.z);
}

bool ProtocolGame::canSee(int32_t x, int32_t y, int32_t z) const
{
	if (not player)
	{
		return false;
	}

	const Position& myPos = player->getPosition();
	if (myPos.z <= 7)
	{
		//we are on ground level or above (7 -> 0)
		//view is from 7 -> 0
		if (z > 7)
		{
			return false;
		}
	} 
	else
	{ // if (myPos.z >= 8) {
		//we are underground (8 -> 15)
		//view is +/- 2 from the floor we stand on
		if (std::abs(myPos.getZ() - z) > 2)
		{
			return false;
		}
	}

	//negative offset means that the action taken place is on a lower floor than ourself
	int32_t offsetz = myPos.getZ() - z;
	if ((x >= myPos.getX() - Map::maxClientViewportX + offsetz)
		and (x <= myPos.getX() + (Map::maxClientViewportX + 1) + offsetz)
		and	(y >= myPos.getY() - Map::maxClientViewportY + offsetz)
		and (y <= myPos.getY() + (Map::maxClientViewportY + 1) + offsetz))
	{
		return true;
	}
	return false;
}

// Parse methods
void ProtocolGame::parseChannelInvite(NetworkMessage& msg)
{
	auto name = msg.getString();
	addGameTask([playerID = player->getID(), name = std::string{ name }]() { g_game.playerChannelInvite(playerID, name); });
}

void ProtocolGame::parseChannelExclude(NetworkMessage& msg)
{
	auto name = msg.getString();
	addGameTask([=, playerID = player->getID(), name = std::string{ name }]() { g_game.playerChannelExclude(playerID, name); });
}

void ProtocolGame::parseOpenChannel(NetworkMessage& msg)
{
	uint16_t channelID = msg.get<uint16_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerOpenChannel(playerID, channelID); });
}

void ProtocolGame::parseCloseChannel(NetworkMessage& msg)
{
	uint16_t channelID = msg.get<uint16_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerCloseChannel(playerID, channelID); });
}

void ProtocolGame::parseOpenPrivateChannel(NetworkMessage& msg)
{
	auto receiver = msg.getString();
	addGameTask([playerID = player->getID(), receiver = std::string{ receiver }]() { g_game.playerOpenPrivateChannel(playerID, receiver); });
}

void ProtocolGame::parseAutoWalk(NetworkMessage& msg)
{
	uint8_t numdirs = msg.getByte();
	if (numdirs == 0 or (msg.getBufferPosition() + numdirs) != (msg.getLength() + 8))
	{
		return;
	}

	msg.skipBytes(numdirs);
	std::vector<Direction> path;
	path.reserve(numdirs);

	for (uint8_t i = 0; i < numdirs; ++i)
	{
		uint8_t rawdir = msg.getPreviousByte();
		switch (rawdir)
		{
			case 1: path.push_back(DIRECTION_EAST); break;
			case 2: path.push_back(DIRECTION_NORTHEAST); break;
			case 3: path.push_back(DIRECTION_NORTH); break;
			case 4: path.push_back(DIRECTION_NORTHWEST); break;
			case 5: path.push_back(DIRECTION_WEST); break;
			case 6: path.push_back(DIRECTION_SOUTHWEST); break;
			case 7: path.push_back(DIRECTION_SOUTH); break;
			case 8: path.push_back(DIRECTION_SOUTHEAST); break;
			default: break;
		}
	}

	if (path.empty())
	{
		return;
	}

	addGameTask([playerID = player->getID(), path = std::move(path)]() { g_game.playerAutoWalk(playerID, path); });
}

void ProtocolGame::parseSetOutfit(NetworkMessage& msg)
{
	// 12.81+ leads with the window type (0 outfit, 1 podium) and follows
	// the mount with its colours, a mounted flag, the familiar and a
	// randomize-mount flag; only the outfit and mount matter here
	const bool modern = usesModernLayout();
	if (modern)
	{
		msg.getByte();
	}

	Outfit_t newOutfit;
	newOutfit.lookType = msg.get<uint16_t>();
	newOutfit.lookHead = msg.getByte();
	newOutfit.lookBody = msg.getByte();
	newOutfit.lookLegs = msg.getByte();
	newOutfit.lookFeet = msg.getByte();
	newOutfit.lookAddons = msg.getByte();
	newOutfit.lookMount = msg.get<uint16_t>();
	if (modern)
	{
		msg.skipBytes(4); // mount colours
		msg.getByte(); // mounted
		msg.get<uint16_t>(); // familiar
		msg.getByte(); // randomize mount
	}
	addGameTask([=, playerID = player->getID()]() { g_game.playerChangeOutfit(playerID, newOutfit); });
}

void ProtocolGame::parseToggleMount(NetworkMessage& msg)
{
	bool mount = msg.getByte() != 0;
	addGameTask([=, playerID = player->getID()]() { g_game.playerToggleMount(playerID, mount); });
}

void ProtocolGame::parseUseItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = getItemId(msg);
	uint8_t stackpos = msg.getByte();
	uint8_t index = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerUseItem(playerID, pos, stackpos, index, spriteId); });
}

void ProtocolGame::parseUseItemEx(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t fromSpriteId = getItemId(msg);
	uint8_t fromStackPos = msg.getByte();
	Position toPos = msg.getPosition();
	uint16_t toSpriteId = getItemId(msg);
	uint8_t toStackPos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]()
	{
		g_game.playerUseItemEx(playerID, fromPos, fromStackPos, fromSpriteId, toPos, toStackPos, toSpriteId);
	});
}

void ProtocolGame::parseUseWithCreature(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t spriteId = getItemId(msg);
	uint8_t fromStackPos = msg.getByte();
	uint32_t creatureId = msg.get<uint32_t>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]()
	{
		g_game.playerUseWithCreature(playerID, fromPos, fromStackPos, creatureId, spriteId);
	});
}

void ProtocolGame::parseCloseContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.getByte();
	addGameTask([=, playerID = player->getID()]() { g_game.playerCloseContainer(playerID, cid); });
}

void ProtocolGame::parseUpArrowContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.getByte();
	addGameTask([=, playerID = player->getID()]() { g_game.playerMoveUpContainer(playerID, cid); });
}

void ProtocolGame::parseUpdateContainer(NetworkMessage& msg)
{
	uint8_t cid = msg.getByte();
	addGameTask([=, playerID = player->getID()]() { g_game.playerUpdateContainer(playerID, cid); });
}

void ProtocolGame::parseThrow(NetworkMessage& msg)
{
	Position fromPos = msg.getPosition();
	uint16_t spriteId = getItemId(msg);
	uint8_t fromStackpos = msg.getByte();
	Position toPos = msg.getPosition();
	uint8_t count = msg.getByte();

	if (toPos != fromPos)
	{
		addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]()
		{
			g_game.playerMoveRequest(playerID, fromPos, spriteId, fromStackpos, toPos, count);
		});
	}
}

void ProtocolGame::parseLookAt(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	msg.skipBytes(2); // spriteId
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerLookAt(playerID, pos, stackpos); });
}

void ProtocolGame::parseLookInBattleList(NetworkMessage& msg)
{
	uint32_t creatureID = msg.get<uint32_t>();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerLookInBattleList(playerID, creatureID); });
}

void ProtocolGame::parseSay(NetworkMessage& msg)
{
	std::string_view receiver;
	uint16_t channelId;

	SpeakClasses type = static_cast<SpeakClasses>(msg.getByte());
	switch (type) {
		case TALKTYPE_PRIVATE_TO:
		case TALKTYPE_PRIVATE_RED_TO:
			receiver = msg.getString();
			channelId = 0;
			break;

		case TALKTYPE_CHANNEL_Y:
		case TALKTYPE_CHANNEL_R1:
			channelId = msg.get<uint16_t>();
			break;

		default:
			channelId = 0;
			break;
	}

	auto text = msg.getString();
	if (text.length() > 255)
	{
		return;
	}

	addGameTask([=, playerID = player->getID(), receiver = std::string{ receiver }, text = std::string{ text }]()
	{
		g_game.playerSay(playerID, channelId, type, receiver, text);
	});
}

void ProtocolGame::parseFightModes(NetworkMessage& msg)
{
	uint8_t rawFightMode = msg.getByte(); // 1 - offensive, 2 - balanced, 3 - defensive
	uint8_t rawChaseMode = msg.getByte(); // 0 - stand while fighting, 1 - chase opponent
	uint8_t rawSecureMode = msg.getByte(); // 0 - can't attack unmarked, 1 - can attack unmarked
	// uint8_t rawPvpMode = msg.getByte(); // pvp mode introduced in 10.0

	fightMode_t fightMode;
	if (rawFightMode == 1)
	{
		fightMode = FIGHTMODE_ATTACK;
	}
	else if (rawFightMode == 2)
	{
		fightMode = FIGHTMODE_BALANCED;
	}
	else
	{
		fightMode = FIGHTMODE_DEFENSE;
	}

	addGameTask([=, playerID = player->getID()]() { g_game.playerSetFightModes(playerID, fightMode, rawChaseMode != 0, rawSecureMode != 0); });
}

void ProtocolGame::parseAttack(NetworkMessage& msg)
{
	uint32_t creatureID = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureID (same as above)
	addGameTask([=, playerID = player->getID()]() { g_game.playerSetAttackedCreature(playerID, creatureID); });
}

void ProtocolGame::parseFollow(NetworkMessage& msg)
{
	uint32_t creatureID = msg.get<uint32_t>();
	// msg.get<uint32_t>(); creatureID (same as above)
	addGameTask([=, playerID = player->getID()]() { g_game.playerFollowCreature(playerID, creatureID); });
}

void ProtocolGame::parseEquipObject(NetworkMessage& msg)
{
	uint16_t spriteID = getItemId(msg);
	if (usesModernLayout())
	{
		// 12.x+ hotkey equips carry a tier or count byte we have no use for
		msg.skipBytes(1);
	}

	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerEquipItem(playerID, spriteID); });
}

void ProtocolGame::parseTextWindow(NetworkMessage& msg)
{
	uint32_t windowTextID = msg.get<uint32_t>();
	auto newText = msg.getString();
	if (not player->isAccountManager())
	{
		addGameTask([playerID = player->getID(), windowTextID, newText = std::string{ newText }]() { g_game.playerWriteItem(playerID, windowTextID, newText); });
	}
	else
	{
		if (player->getAccount() == 1)
		{
			addGameTask([windowTextID, playerID = player->getID(), newText = std::string{ newText }]() { g_game.onAccountManagerRecieveText(playerID, windowTextID, newText); });
		} 
		else
		{
			addGameTask([windowTextID, playerID = player->getID(), newText = std::string{ newText }]() { g_game.onPrivateAccountManagerRecieveText(playerID, windowTextID, newText); });
		}
	}
}

void ProtocolGame::parseHouseWindow(NetworkMessage& msg)
{
	uint8_t doorId = msg.getByte();
	uint32_t id = msg.get<uint32_t>();
	auto text = msg.getString();
	addGameTask([=, playerID = player->getID(), text = std::string{ text }]() { g_game.playerUpdateHouseWindow(playerID, doorId, id, text); });
}

void ProtocolGame::parseWrapItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = getItemId(msg);
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerWrapItem(playerID, pos, stackpos, spriteId); });
}

void ProtocolGame::parseLookInShop(NetworkMessage& msg)
{
	uint16_t id = getItemId(msg);
	uint8_t count = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerLookInShop(playerID, id, count); });
}

void ProtocolGame::parseCyclopediaCharacterInfo(NetworkMessage& msg)
{
	uint32_t characterId = msg.get<uint32_t>();
	uint8_t infoType = msg.getByte();
	uint16_t entriesPerPage = 0;
	uint16_t page = 0;
	if (infoType == static_cast<uint8_t>(CyclopediaInfoCode::RecentDeaths) or infoType == static_cast<uint8_t>(CyclopediaInfoCode::RecentPvpKills))
	{
		entriesPerPage = std::min<uint16_t>(30, std::max<uint16_t>(5, msg.get<uint16_t>()));
		page = std::max<uint16_t>(1, msg.get<uint16_t>());
	}
	addGameTask([=, playerID = player->getID()]() { g_game.playerCyclopediaCharacterInfo(playerID, characterId, infoType, entriesPerPage, page); });
}

void ProtocolGame::parsePreyAction(NetworkMessage& msg)
{
	using Action = BlackTek::Prey::System::Action;
	const uint8_t slotId = msg.getByte();
	const uint8_t action = msg.getByte();
	uint8_t index = 0;
	uint16_t raceId = 0;
	uint8_t option = 0;
	if (action == std::to_underlying(Action::MonsterSelection))
	{
		index = msg.getByte();
	}
	else if (action == std::to_underlying(Action::Option))
	{
		option = msg.getByte();
	}
	else if (action == std::to_underlying(Action::ChangeFromAll))
	{
		raceId = msg.get<uint16_t>();
	}
	addGameTask([=, playerID = player->getID()]() { g_game.playerPreyAction(playerID, slotId, action, index, raceId, option); });
}

void ProtocolGame::parseBestiaryOverview(NetworkMessage& msg)
{
	const auto& bestiary = BlackTek::Bestiary::Registry::getInstance();
	std::string raceName;
	std::vector<const MonsterType*> monsters;
	if (msg.getByte() != 0)
	{
		// a search: the client lists the race ids it wants, we answer with
		// the ones the character has met
		const uint16_t count = msg.get<uint16_t>();
		for (uint16_t i = 0; i < count; ++i)
		{
			const uint16_t raceId = msg.get<uint16_t>();
			if (const MonsterType* monsterType = bestiary.getMonster(raceId); monsterType and player->getBestiaryKills(raceId) > 0)
			{
				monsters.push_back(monsterType);
			}
		}
	}
	else
	{
		raceName = msg.getString();
		const auto race = BlackTek::Bestiary::ParseRace(raceName);
		monsters = race != BlackTek::Bestiary::Registry::Race::None ? bestiary.getRaceMembers(race) : bestiary.findByName(raceName);
	}
	addGameTask([player_id = player->getID(), raceName, monsters]() { if (const auto& p = g_game.getPlayerByID(player_id)) p->sendBestiaryOverview(raceName, monsters); });
}

void ProtocolGame::parseBestiaryMonsterData(NetworkMessage& msg)
{
	uint16_t raceId = msg.get<uint16_t>();
	addGameTask([=, player_id = player->getID()]() { if (const auto& p = g_game.getPlayerByID(player_id)) p->sendBestiaryMonsterData(raceId); });
}

void ProtocolGame::parseBestiaryTracker(NetworkMessage& msg)
{
	uint16_t raceId = msg.get<uint16_t>();
	bool tracking = msg.getByte() != 0;
	addGameTask([=, player_id = player->getID()]() { if (const auto& p = g_game.getPlayerByID(player_id)) p->setBestiaryTracking(raceId, tracking); });
}

void ProtocolGame::parseBuyCharmRune(NetworkMessage& msg)
{
	uint8_t charmId = msg.getByte();
	uint8_t action = msg.getByte();
	uint16_t raceId = msg.get<uint16_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerCharmAction(playerID, charmId, action, raceId); });
}

void ProtocolGame::parseInspectionObject(NetworkMessage& msg)
{
	const uint8_t inspectionType = msg.getByte();
	if (inspectionType == static_cast<uint8_t>(InspectionType::NormalObject))
	{
		Position pos = msg.getPosition();
		addGameTask([=, playerID = player->getID()]() { g_game.playerInspectObject(playerID, pos); });
		return;
	}

	uint16_t itemId = getItemId(msg);
	msg.skipBytes(1); // count
	if (itemId != 0)
	{
		addGameTask([=, playerID = player->getID()]() { g_game.playerInspectItemType(playerID, itemId, inspectionType); });
	}
}

void ProtocolGame::parseInspectPlayer(NetworkMessage& msg)
{
	msg.skipBytes(1); // tab
	uint32_t creatureId = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerInspectCharacter(playerID, creatureId, false); });
}

void ProtocolGame::parseTeleport(NetworkMessage& msg)
{
	Position newPosition = msg.getPosition();
	addGameTask([=, playerID = player->getID()]() { g_game.playerTeleport(playerID, newPosition); });
}

void ProtocolGame::parsePlayerPurchase(NetworkMessage& msg)
{
	uint16_t id = getItemId(msg);
	uint8_t count = msg.getByte();
	// 12.90+ clients trade in u16 amounts; the game side still caps at u8
	uint16_t amount = usesModernLayout() ? msg.get<uint16_t>() : msg.getByte();
	bool ignoreCap = msg.getByte() != 0;
	bool inBackpacks = msg.getByte() != 0;
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]()
	{
		g_game.playerPurchaseItem(playerID, id, count, std::min<uint16_t>(amount, std::numeric_limits<uint8_t>::max()), ignoreCap, inBackpacks);
	});
}

void ProtocolGame::parsePlayerSale(NetworkMessage& msg)
{
	uint16_t id = getItemId(msg);
	uint8_t count = msg.getByte();
	uint16_t amount = usesModernLayout() ? msg.get<uint16_t>() : msg.getByte();
	bool ignoreEquipped = msg.getByte() != 0;
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerSellItem(playerID, id, count, std::min<uint16_t>(amount, std::numeric_limits<uint8_t>::max()), ignoreEquipped); });
}

void ProtocolGame::parseRequestTrade(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = getItemId(msg);
	uint8_t stackpos = msg.getByte();
	uint32_t playerId = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerRequestTrade(playerID, pos, stackpos, playerId, spriteId); });
}

void ProtocolGame::parseLookInTrade(NetworkMessage& msg)
{
	bool counterOffer = (static_cast<ClientCode>(msg.getByte()) == ClientCode::CounterOffer);
	uint8_t index = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerLookInTrade(playerID, counterOffer, index); });
}

void ProtocolGame::parseAddVip(NetworkMessage& msg)
{
	auto name = msg.getString();
	addGameTask([playerID = player->getID(), name = std::string{ name }]() { g_game.playerRequestAddVip(playerID, name); });
}

void ProtocolGame::parseRemoveVip(NetworkMessage& msg)
{
	uint32_t guid = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerRequestRemoveVip(playerID, guid); });
}

void ProtocolGame::parseEditVip(NetworkMessage& msg)
{
	uint32_t guid = msg.get<uint32_t>();
	auto description = msg.getString();
	uint32_t icon = std::min<uint32_t>(10, msg.get<uint32_t>()); // 10 is max icon in 9.63
	bool notify = msg.getByte() != 0;
	addGameTask([=, playerID = player->getID(), description = std::string{ description }]() { g_game.playerRequestEditVip(playerID, guid, description, icon, notify); });
}

void ProtocolGame::parseRotateItem(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	uint16_t spriteId = getItemId(msg);
	uint8_t stackpos = msg.getByte();
	addGameTaskTimed(DISPATCHER_TASK_EXPIRATION, [=, playerID = player->getID()]() { g_game.playerRotateItem(playerID, pos, stackpos, spriteId); });
}

void ProtocolGame::parseRuleViolationReport(NetworkMessage& msg)
{
	uint8_t reportType = msg.getByte();
	uint8_t reportReason = msg.getByte();
	auto targetName = msg.getString();
	auto comment = msg.getString();
	std::string_view translation;
	if (reportType == REPORT_TYPE_NAME)
	{
		translation = msg.getString();
	}
	else if (reportType == REPORT_TYPE_STATEMENT)
	{
		translation = msg.getString();
		msg.get<uint32_t>(); // statement id, used to get whatever player have said, we don't log that.
	}

	addGameTask([=, playerID = player->getID(), targetName = std::string{ targetName }, comment = std::string{ comment }, translation = std::string{ translation }]()
	{
		g_game.playerReportRuleViolation(playerID, targetName, reportType, reportReason, comment, translation);
	});
}

void ProtocolGame::parseBugReport(NetworkMessage& msg)
{
	uint8_t category = msg.getByte();
	auto message = msg.getString();

	Position position;
	if (category == BUG_CATEGORY_MAP) {
		position = msg.getPosition();
	}

	addGameTask([=, playerID = player->getID(), message = std::string{ message }]() { g_game.playerReportBug(playerID, message, position, category); });
}

void ProtocolGame::parseDebugAssert(NetworkMessage& msg)
{
	if (debugAssertSent)
	{
		return;
	}

	debugAssertSent = true;

	auto assertLine = msg.getString();
	auto date = msg.getString();
	auto description = msg.getString();
	auto comment = msg.getString();
	addGameTask([playerID = player->getID(), assertLine = std::string{ assertLine }, date = std::string{ date }, description = std::string{ description }, comment = std::string{ comment }]()
	{
		g_game.playerDebugAssert(playerID, assertLine, date, description, comment);
	});
}

void ProtocolGame::parseInviteToParty(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerInviteToParty(playerID, targetID); });
}

void ProtocolGame::parseJoinParty(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerJoinParty(playerID, targetID); });
}

void ProtocolGame::parseRevokePartyInvite(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerRevokePartyInvitation(playerID, targetID); });
}

void ProtocolGame::parsePassPartyLeadership(NetworkMessage& msg)
{
	uint32_t targetID = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerPassPartyLeadership(playerID, targetID); });
}

void ProtocolGame::parseEnableSharedPartyExperience(NetworkMessage& msg)
{
	bool sharedExpActive = msg.getByte() == 1;
	addGameTask([=, playerID = player->getID()]() { g_game.playerEnableSharedPartyExperience(playerID, sharedExpActive); });
}

void ProtocolGame::parseQuestLine(NetworkMessage& msg)
{
	uint16_t questID = msg.get<uint16_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerShowQuestLine(playerID, questID); });
}

void ProtocolGame::parseMarketLeave()
{
	addGameTask([playerID = player->getID()]() { g_game.playerLeaveMarket(playerID); });
}

void ProtocolGame::parseMarketBrowse(NetworkMessage& msg)
{
	if (usesModernLayout())
	{
		// 12.51+ leads with a request byte and only carries an item for a browse
		const auto request = static_cast<MarketRequestCode>(msg.getByte());
		if (request == MarketRequestCode::OwnOffers)
		{
			g_dispatcher.addTask([playerID = player->getID()]() { g_game.playerBrowseMarketOwnOffers(playerID); });
		}
		else if (request == MarketRequestCode::OwnHistory)
		{
			g_dispatcher.addTask([playerID = player->getID()]() { g_game.playerBrowseMarketOwnHistory(playerID); });
		}
		else if (request == MarketRequestCode::BrowseItem)
		{
			if (uint16_t itemId = getMarketItemId(msg); itemId != 0)
			{
				g_dispatcher.addTask([=, playerID = player->getID()]() { g_game.playerBrowseMarket(playerID, itemId); });
			}
		}
		return;
	}

	uint16_t browseId = msg.get<uint16_t>();
	if (browseId == MARKETREQUEST_OWN_OFFERS)
	{
		g_dispatcher.addTask([playerID = player->getID()]() { g_game.playerBrowseMarketOwnOffers(playerID); });
	}
	else if (browseId == MARKETREQUEST_OWN_HISTORY)
	{
		g_dispatcher.addTask([playerID = player->getID()]() { g_game.playerBrowseMarketOwnHistory(playerID); });
	}
	else
	{
		g_dispatcher.addTask([=, playerID = player->getID()]() { g_game.playerBrowseMarket(playerID, browseId); });
	}
}

void ProtocolGame::parseMarketCreateOffer(NetworkMessage& msg)
{
	uint8_t type = msg.getByte();
	uint16_t spriteId = getMarketItemId(msg);
	uint16_t amount = msg.get<uint16_t>();
	// 12.81+ prices are u64 on the wire; the market itself still deals in u32
	uint32_t price = usesModernLayout()
		? static_cast<uint32_t>(std::min<uint64_t>(msg.get<uint64_t>(), std::numeric_limits<uint32_t>::max()))
		: msg.get<uint32_t>();
	bool anonymous = (msg.getByte() != 0);
	if (spriteId == 0)
	{
		return;
	}
	addGameTask([=, playerID = player->getID()]() { g_game.playerCreateMarketOffer(playerID, type, spriteId, amount, price, anonymous); });
}

void ProtocolGame::parseMarketCancelOffer(NetworkMessage& msg)
{
	uint32_t timestamp = msg.get<uint32_t>();
	uint16_t counter = msg.get<uint16_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerCancelMarketOffer(playerID, timestamp, counter); });
}

void ProtocolGame::parseMarketAcceptOffer(NetworkMessage& msg)
{
	uint32_t timestamp = msg.get<uint32_t>();
	uint16_t counter = msg.get<uint16_t>();
	uint16_t amount = msg.get<uint16_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerAcceptMarketOffer(playerID, timestamp, counter, amount); });
}

void ProtocolGame::parseModalWindowAnswer(NetworkMessage& msg)
{
	uint32_t id = msg.get<uint32_t>();
	uint8_t button = msg.getByte();
	uint8_t choice = msg.getByte();
	addGameTask([=, playerID = player->getID()]() { g_game.playerAnswerModalWindow(playerID, id, button, choice); });
}

void ProtocolGame::parseGameStoreRequest(NetworkMessage& /*msg*/)
{
	addGameTask([playerID = player->getID()]() { g_game.openPlayerStore(playerID); });
}

// what the client wants to see: a category by name, the front page, a
// premium or boost tab, one offer, or the results of a search
void ProtocolGame::parseStoreSelectCategory(NetworkMessage& msg)
{
	using Action = BlackTek::Store::System::Action;
	const uint8_t action = msg.getByte();
	std::string text;
	uint8_t subAction = 0;
	uint32_t offerId = 0;
	switch (static_cast<Action>(action))
	{
		case Action::Category:
			text = msg.getString();
			break;
		case Action::PremiumBoost:
		case Action::UsefulThings:
			subAction = msg.getByte();
			break;
		case Action::Offer:
			offerId = msg.get<uint32_t>();
			break;
		case Action::Search:
			text = msg.getString();
			break;
		case Action::Home:
			break;
	}
	addGameTask([=, playerID = player->getID(), textCopy = std::string{ text }]() { g_game.playerStoreBrowse(playerID, action, textCopy, subAction, offerId); });
}

void ProtocolGame::parseStoreBuyOffer(NetworkMessage& msg)
{
	const uint32_t offerId = msg.get<uint32_t>();
	const uint8_t productType = msg.getByte();
	std::string param;
	if (productType == 1 or productType == 2 or productType == 3 or productType == 4)
	{
		param = msg.getString();
	}
	addGameTask([=, playerID = player->getID(), paramCopy = std::string{ param }]() { g_game.playerPurchaseStoreOffer(playerID, offerId, productType, paramCopy); });
}

void ProtocolGame::parseStoreOpenHistory(NetworkMessage& msg)
{
	const uint8_t perPage = msg.getByte();
	addGameTask([=, playerID = player->getID()]() { g_game.playerRequestStoreHistory(playerID, 0, perPage); });
}

void ProtocolGame::parseStoreRequestHistory(NetworkMessage& msg)
{
	const uint32_t page = msg.get<uint32_t>();
	const uint8_t perPage = msg.getByte();
	addGameTask([=, playerID = player->getID()]() { g_game.playerRequestStoreHistory(playerID, page, perPage); });
}

void ProtocolGame::parseStoreOfferDescription(NetworkMessage& msg)
{
	const uint32_t offerId = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerStoreOfferDescription(playerID, offerId); });
}

void ProtocolGame::parseTransferCoins(NetworkMessage& msg)
{
	const std::string recipientName{ msg.getString() };
	const uint32_t amount = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerTransferCoins(playerID, recipientName, amount); });
}

void ProtocolGame::parseBrowseField(NetworkMessage& msg)
{
	Position pos = msg.getPosition();
	addGameTask([=, playerID = player->getID()]() { g_game.playerBrowseField(playerID, pos); });
}

void ProtocolGame::parseSeekInContainer(NetworkMessage& msg)
{
	uint8_t containerId = msg.getByte();
	uint16_t index = msg.get<uint16_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerSeekInContainer(playerID, containerId, index); });
}

// Send methods
void ProtocolGame::sendOpenPrivateChannel(const std::string& receiver)
{
	NetworkMessage msg;
	msg.add(ServerCode::OpenPrivateChannel);
	msg.addString(receiver);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelEvent(uint16_t channelId, const std::string& playerName, ChannelEvent_t channelEvent)
{
	NetworkMessage msg;
	msg.add(ServerCode::ChannelEvent);
	msg.add<uint16_t>(channelId);
	msg.addString(playerName);
	msg.addByte(channelEvent);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureOutfit(const CreatureConstPtr& creature, const Outfit_t& outfit)
{
	if (not canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::CreatureOutfit);
	msg.add<uint32_t>(creature->getID());
	AddOutfit(msg, outfit);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureLight(const CreatureConstPtr& creature)
{
	if (not canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	AddCreatureLight(msg, creature);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendWorldLight(LightInfo lightInfo)
{
	NetworkMessage msg;
	AddWorldLight(msg, lightInfo);
	writeToOutputBuffer(msg);
}

// Todo: should be using this for walkthrough in pz, and gm walkthrough (check and make sure it's used)
void ProtocolGame::sendCreatureWalkthrough(const CreatureConstPtr& creature, bool walkthrough)
{
	if (not canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::CreatureWalkthrough);
	msg.add<uint32_t>(creature->getID());
	msg.add(walkthrough ? CommonCode::False : CommonCode::True);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureShield(const CreatureConstPtr& creature)
{
	if (not canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::CreatureShield);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getPartyShield(creature->getPlayer()));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSkull(const CreatureConstPtr& creature)
{
	if (g_game.getWorldType() != WORLD_TYPE_PVP)
	{
		return;
	}

	if (not canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::CreatureSkull);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(player->getSkullClient(creature));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureType(uint32_t creatureId, uint8_t creatureType)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatureType);
	msg.add<uint32_t>(creatureId);
	if (usesModernLayout())
	{
		msg.addByte(ModernCreatureType(static_cast<CreatureType_t>(creatureType)));
	}
	else
	{
		msg.addByte(creatureType);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureHelpers(uint32_t creatureId, uint16_t helpers)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatureHelpers);
	msg.add<uint32_t>(creatureId);
	msg.add<uint16_t>(helpers);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSquare(const CreatureConstPtr& creature, SquareColor_t color)
{
	if (not canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::CreatureSquare);
	msg.add<uint32_t>(creature->getID());
	msg.add(CommonCode::True); // todo: figure out what this code is supposed to be, assumed a true/false fill in?
	msg.addByte(color);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTutorial(uint8_t tutorialId)
{
	NetworkMessage msg;
	msg.add(ServerCode::Tutorial);
	msg.addByte(tutorialId);
	writeToOutputBuffer(msg);
}

// Todo: there are plenty of secondary values passed along with many of these network messages which we don't have
// documented by way of enums or anything, like the below example, marktype, now, perhaps those are actual enums somewhere
// whether or not they are, the point is, all of these secondary values need to have a well defined range that
// any programmer using the code can reference, so the todo is to come back and find them all, and define them all
void ProtocolGame::sendAddMarker(const Position& pos, uint8_t markType, const std::string& desc)
{
	NetworkMessage msg;
	msg.add(ServerCode::MapMarker);
	msg.addPosition(pos);
	msg.addByte(markType);
	msg.addString(desc);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendReLoginWindow(uint8_t unfairFightReduction)
{
	NetworkMessage msg;
	msg.add(ServerCode::Death);
	msg.add(CommonCode::Zero);
	msg.addByte(unfairFightReduction);
	if (usesModernLayout())
	{
		msg.add(CommonCode::False); // death redemption available (12.81+)
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStats()
{
	NetworkMessage msg;
	AddPlayerStats(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBasicData()
{
	NetworkMessage msg;
	msg.add(ServerCode::BasicData);

	if (player->isPremium())
	{
		msg.add(CommonCode::True);
		msg.add<uint32_t>(g_config.GetBoolean(ConfigManager::FREE_PREMIUM) ? 0 : player->premiumEndsAt);
	} 
	else
	{
		msg.add(CommonCode::Zero);
		msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::Zero));
	}

	msg.addByte(player->getVocation()->getClientId());
	if (version >= 1100)
	{
		msg.addByte(player->getVocation()->getId() != VOCATION_NONE ? 0x01 : 0x00);
	}

	if (usesModernLayout())
	{
		// 13.00+ reads u16 spell ids (GameUshortSpell) and a trailing
		// magic-shield byte; the legacy all-255-spells trick would parse as
		// garbage, so send none until the spell list is really wired up
		msg.add<uint16_t>(0); // number of known spells
		msg.add(CommonCode::Zero); // magic shield active
		writeToOutputBuffer(msg);
		return;
	}

	msg.add<uint16_t>(255); // number of known spells

	// todo: figure out why the hell we send every last spell id
	for (uint8_t spellId = 0; spellId < 255; spellId++)
	{
		msg.addByte(spellId);
	}
	writeToOutputBuffer(msg);
}

// to reduce the size of text message, we can and should make a separate method for handling "channel messages"
void ProtocolGame::AddTextMessage(NetworkMessage& msg, const TextMessage& message)
{
	AddTextMessage(msg, message, shared_modern_layout);
}

void ProtocolGame::AddTextMessage(NetworkMessage& msg, const TextMessage& message, bool modernLayout)
{
	msg.add(ServerCode::TextMessage);
	msg.addByte(message.type);
	switch (message.type)
	{
		case MESSAGE_DAMAGE_DEALT:
		case MESSAGE_DAMAGE_RECEIVED:
		case MESSAGE_DAMAGE_OTHERS:
		{
			msg.addPosition(message.position);
			msg.add<uint32_t>(message.primary.value);
			msg.addByte(message.primary.color);
			msg.add<uint32_t>(message.secondary.value);
			msg.addByte(message.secondary.color);
			break;
		}
		case MESSAGE_HEALED:
		case MESSAGE_HEALED_OTHERS:
		{
			msg.addPosition(message.position);
			msg.add<uint32_t>(message.primary.value);
			msg.addByte(message.primary.color);
			break;
		}
		case MESSAGE_EXPERIENCE:
		case MESSAGE_EXPERIENCE_OTHERS:
		{
			msg.addPosition(message.position);
			if (modernLayout)
			{
				msg.add<uint64_t>(message.primary.value); // 13.32+
			}
			else
			{
				msg.add<uint32_t>(message.primary.value);
			}
			msg.addByte(message.primary.color);
			break;
		}
		case MESSAGE_GUILD:
		case MESSAGE_PARTY_MANAGEMENT:
		case MESSAGE_PARTY:
		{
			msg.add<uint16_t>(message.channelId);
			break;
		}
		default: break;
	}
	msg.addString(message.text);
}

void ProtocolGame::sendTextMessage(const TextMessage& message)
{
	NetworkMessage msg;
	AddTextMessage(msg, message, usesModernLayout());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendClosePrivate(uint16_t channelId)
{
	NetworkMessage msg;
	msg.add(ServerCode::ClosePrivateChannel);
	msg.add<uint16_t>(channelId);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatePrivateChannel(uint16_t channelId, const std::string& channelName)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatePrivateChannel);
	msg.add<uint16_t>(channelId);
	msg.addString(channelName);
	msg.add<SpecialCode>(SpecialCode::True);
	msg.addString(player->getName());
	msg.add<SpecialCode>(SpecialCode::Zero);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelsDialog()
{
	NetworkMessage msg;
	msg.add(ServerCode::ChannelsDialog);

	const ChannelList& list = g_chat->getChannelList(player);
	msg.addByte(list.size());
	for (ChatChannel* channel : list)
	{
		msg.add<uint16_t>(channel->getId());
		msg.addString(channel->getName());
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannel(uint16_t channelId, const std::string& channelName, const UsersMap* channelUsers, const InvitedMap* invitedUsers)
{
	NetworkMessage msg;
	msg.add(ServerCode::SendChannel);

	msg.add<uint16_t>(channelId);
	msg.addString(channelName);

	if (channelUsers)
	{
		msg.add<uint16_t>(channelUsers->size());
		for (const auto& it : *channelUsers)
		{
			msg.addString(it.second->getName());
		}
	} 
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (invitedUsers)
	{
		msg.add<uint16_t>(invitedUsers->size());
		for (const auto& it : *invitedUsers)
		{
			msg.addString(it.second->getName());
		}
	} 
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChannelMessage(const std::string& author, const std::string& text, SpeakClasses type, uint16_t channel)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatureSay);
	msg.add<uint32_t>(0); // statement guid (unused by clients)
	msg.addString(author);
	msg.add<SpecialCode>(SpecialCode::Zero);
	msg.addByte(type);
	msg.add<uint16_t>(channel);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendIcons(uint16_t icons)
{

	NetworkMessage msg;
	msg.add(ServerCode::Icons);
	if (protocol_profile and protocol_profile->generation == TransportGeneration::Modern)
	{
		// mehah parsePlayerState: u64 states for 14.05+ (u32 for 13.40),
		// plus a trailing icon-counter byte since 13.20
		if (protocol_profile->hasFeature(ProtocolFeature::PlayerStateU64))
		{
			msg.add<uint64_t>(icons);
		}
		else
		{
			msg.add<uint32_t>(icons);
		}
		if (protocol_profile->hasFeature(ProtocolFeature::PlayerStateCounter))
		{
			msg.add(CommonCode::Zero); // icons counter
		}
	}
	else
	{
		msg.add<uint16_t>(icons);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendContainer(uint8_t cid, const ContainerConstPtr& container, bool hasParent, uint16_t firstIndex)
{
	NetworkMessage msg;
	msg.add(ServerCode::Container);

	msg.addByte(cid);

	if (container->getOwner()->getID() == ITEM_BROWSEFIELD)
	{
		addItem(msg, ITEM_BAG, 1);
		msg.addString("Browse Field");
	}
	else
	{
		addItem(msg, container->getOwner());
		msg.addString(container->getName());
	}

	msg.addByte(container->capacity());

	msg.add(hasParent ? CommonCode::True : CommonCode::Zero);

	const bool modernContainer = usesModernLayout();
	if (modernContainer)
	{
		msg.add(CommonCode::Zero); // show search icon (12.81+)
	}

	msg.add(container->isUnlocked() ? CommonCode::True : CommonCode::Zero); // Drag and drop
	msg.add(container->hasPagination() ? CommonCode::True : CommonCode::Zero); // Pagination

	uint32_t containerSize = container->size();
	msg.add<uint16_t>(containerSize);
	msg.add<uint16_t>(firstIndex);
	if (firstIndex < containerSize)
	{
		uint8_t itemsToSend = std::min<uint32_t>(std::min<uint32_t>(container->capacity(), containerSize - firstIndex), std::numeric_limits<uint8_t>::max());

		msg.addByte(itemsToSend);
		for (auto it = container->getItemList().begin() + firstIndex, end = it + itemsToSend; it != end; ++it)
		{
			addItem(msg, *it);
		}
	}
	else
	{
		msg.add(CommonCode::Zero);
	}

	if (modernContainer)
	{
		msg.add(CommonCode::Zero); // container filter: selected category (GameContainerFilter, 13.21+)
		msg.add(CommonCode::Zero); // filter category count
		if (version >= 1340)
		{
			msg.add(CommonCode::True); // isMoveable
			msg.add(CommonCode::Zero); // isHolding
		}
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendNpcChatWindow(const NpcPtr& npc)
{
	NetworkMessage msg;
	msg.add(ServerCode::NpcChatWindow);
	msg.add(CommonCode::Zero); // the window is opening
	msg.add(CommonCode::True); // one npc speaks in it
	msg.add<uint32_t>(npc->getID());
	msg.add(CommonCode::Zero); // no dialog buttons of our own
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseNpcChatWindow()
{
	NetworkMessage msg;
	msg.add(ServerCode::NpcChatWindow);
	msg.add(CommonCode::True); // anything but zero closes it
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendShop(const NpcPtr& npc, const ShopInfoList& itemList)
{
	// modern clients title the shop window from the npc this names, and draw its outfit
	if (usesModernLayout())
	{
		sendNpcChatWindow(npc);
	}

	NetworkMessage msg;
	msg.add(ServerCode::NpcShop);
	msg.addString(npc->getName());

	if (usesModernLayout())
	{
		// 12.81+ shops name their currency; BlackTek shops only deal in gold
		addItemId(msg, ITEM_GOLD_COIN);
		msg.add<SpecialCode>(SpecialCode::Zero); // currency name
	}

	uint16_t itemsToSend = std::min<size_t>(itemList.size(), std::numeric_limits<uint16_t>::max());
	msg.add<uint16_t>(itemsToSend);

	uint16_t i = 0;
	for (auto it = itemList.begin(); i < itemsToSend; ++it, ++i)
	{
		AddShopItem(msg, *it);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseShop()
{
	if (usesModernLayout())
	{
		sendCloseNpcChatWindow();
	}

	NetworkMessage msg;
	msg.add(ServerCode::CloseNpcShop);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendResourceBalance(ResourceType type, uint64_t value)
{
	NetworkMessage msg;
	msg.add(ServerCode::ResourceBalance);
	msg.add(type);
	switch (type)
	{
		// the charm balances are the one u32 family in this opcode
		case ResourceType::CharmPoints:
		case ResourceType::MinorCharmEchoes:
		case ResourceType::MaxCharmPoints:
		case ResourceType::MaxMinorCharmEchoes:
			msg.add<uint32_t>(std::min<uint64_t>(value, std::numeric_limits<uint32_t>::max()));
			break;
		default:
			msg.add<uint64_t>(value);
			break;
	}
	writeToOutputBuffer(msg);
}

// the glow on the character's blessing indicator: a bit per blessing held
void ProtocolGame::sendBlessStatus()
{
	uint16_t blessings = 0;
	for (uint8_t blessing = 0; blessing < Player::Blessings::Count; ++blessing)
	{
		if (player->hasBlessing(blessing))
		{
			blessings |= static_cast<uint16_t>(1 << blessing);
		}
	}

	NetworkMessage msg;
	msg.add(ServerCode::BlessStatus);
	msg.add<uint16_t>(blessings);
	msg.addByte(blessings != 0 ? 2 : 1); // 1 disabled, 2 normal, 3 green (12.00+)
	writeToOutputBuffer(msg);
}

// the 12.x blessings window: one row per blessing, then the loss overview
void ProtocolGame::sendBlessDialog()
{
	NetworkMessage msg;
	msg.add(ServerCode::BlessDialog);

	msg.addByte(Player::Blessings::Count);
	for (uint8_t blessing = 0; blessing < Player::Blessings::Count; ++blessing)
	{
		msg.add<uint16_t>(static_cast<uint16_t>(1 << blessing)); // blessing bit
		msg.addByte(player->hasBlessing(blessing) ? 1 : 0); // times held
		msg.add(CommonCode::Zero); // bought in the store
	}

	const uint8_t lossPercent = static_cast<uint8_t>(std::lround(player->getLostPercent() * 100.0));
	msg.add(player->isPremium() ? CommonCode::True : CommonCode::False);
	msg.add(player->isPromoted() ? CommonCode::True : CommonCode::False);
	msg.addByte(lossPercent); // pvp minimum experience loss
	msg.addByte(lossPercent); // pvp maximum experience loss
	msg.addByte(lossPercent); // pve experience loss
	msg.addByte(lossPercent); // pvp equipment loss
	msg.addByte(lossPercent); // pve equipment loss
	msg.add(player->getSkull() != SKULL_NONE ? CommonCode::True : CommonCode::False);
	msg.add(CommonCode::False); // amulet of loss
	msg.add(CommonCode::Zero); // history entries
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterInfo(uint8_t infoType)
{
	switch (static_cast<CyclopediaInfoCode>(infoType))
	{
		case CyclopediaInfoCode::BaseInformation: sendCyclopediaCharacterBaseInformation(); break;
		case CyclopediaInfoCode::GeneralStats: sendCyclopediaCharacterGeneralStats(); break;
		case CyclopediaInfoCode::CombatStats: sendCyclopediaCharacterCombatStats(); break;
		case CyclopediaInfoCode::RecentPvpKills: sendCyclopediaCharacterRecentPvpKills(); break;
		case CyclopediaInfoCode::ItemSummary: sendCyclopediaCharacterItemSummary(); break;
		case CyclopediaInfoCode::OutfitsMounts: sendCyclopediaCharacterOutfitsMounts(); break;
		case CyclopediaInfoCode::StoreSummary: sendCyclopediaCharacterStoreSummary(); break;
		case CyclopediaInfoCode::Badges: sendCyclopediaCharacterBadges(); break;
		case CyclopediaInfoCode::Titles: sendCyclopediaCharacterTitles(); break;
		// the client reads nothing past the header for these two
		case CyclopediaInfoCode::Achievements: sendCyclopediaCharacterHeaderOnly(CyclopediaInfoCode::Achievements); break;
		case CyclopediaInfoCode::Wheel: sendCyclopediaCharacterHeaderOnly(CyclopediaInfoCode::Wheel); break;
		case CyclopediaInfoCode::OffenceStats: sendCyclopediaCharacterOffenceStats(); break;
		case CyclopediaInfoCode::DefenceStats: sendCyclopediaCharacterDefenceStats(); break;
		case CyclopediaInfoCode::MiscStats: sendCyclopediaCharacterMiscStats(); break;
		case CyclopediaInfoCode::Inspection: sendCyclopediaCharacterInspection(); break;
		default: sendCyclopediaCharacterNoData(infoType); break;
	}
}

void ProtocolGame::sendCyclopediaCharacterNoData(uint8_t infoType)
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.addByte(infoType);
	msg.add(CyclopediaErrorCode::NoData);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterHeaderOnly(CyclopediaInfoCode infoType)
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(infoType);
	msg.add(CyclopediaErrorCode::None);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBaseInformation()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::BaseInformation);
	msg.add(CyclopediaErrorCode::None);
	msg.addString(player->getName());
	msg.addString(player->getVocation()->getVocName());
	msg.add<uint16_t>(player->getLevel());
	addOutfitLook(msg, player->getDefaultOutfit()); // read without a mount here
	msg.add(CommonCode::False); // hide stamina
	msg.add(CommonCode::True); // store summary and titles enabled
	msg.add<SpecialCode>(SpecialCode::Zero); // current title
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterGeneralStats()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::GeneralStats);
	msg.add(CyclopediaErrorCode::None);

	msg.add<uint64_t>(player->getExperience());
	msg.add<uint16_t>(player->getLevel());
	if (hasFeature(ProtocolFeature::PlayerLevelPercentU16))
	{
		msg.add<uint16_t>(std::min<uint16_t>(static_cast<uint16_t>(player->getLevelPercent()) * 100, 10000));
	}
	else
	{
		msg.addByte(player->getLevelPercent());
	}
	msg.add<uint16_t>(100); // base xp gain rate
	msg.add<uint16_t>(0); // low level bonus
	msg.add<uint16_t>(0); // store xp boost
	msg.add<uint16_t>(100); // stamina multiplier (100 = x1.0)
	msg.add<uint16_t>(0); // xp boost remaining time
	msg.add(CommonCode::True); // can buy xp boost

	msg.add<uint32_t>(std::max<int32_t>(player->getHealth(), 0));
	msg.add<uint32_t>(std::max<int32_t>(player->getMaxHealth(), 0));
	msg.add<uint32_t>(std::max<int32_t>(player->getMana(), 0));
	msg.add<uint32_t>(std::max<int32_t>(player->getMaxMana(), 0));
	msg.addByte(player->getSoul());
	msg.add<uint16_t>(player->getStaminaMinutes());

	Condition* regenCondition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(regenCondition ? regenCondition->getTicks() / 1000 : 0);
	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);

	msg.add<uint16_t>(player->getSpeed() / 2); // same half-scale as 0xA0
	msg.add<uint16_t>(player->getBaseSpeed() / 2);
	msg.add<uint32_t>(player->getCapacity());
	msg.add<uint32_t>(player->getCapacity()); // base capacity
	msg.add<uint32_t>(player->getFreeCapacity());
	msg.addByte(8); // skills shown
	msg.addByte(1); // magic level first

	msg.add<uint16_t>(std::min<uint32_t>(player->getMagicLevel(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<uint32_t>(player->getBaseMagicLevel(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<uint32_t>(player->getBaseMagicLevel(), std::numeric_limits<uint16_t>::max())); // base + loyalty
	msg.add<uint16_t>(static_cast<uint16_t>(player->getMagicLevelPercent()) * 100);

	// the cyclopedia names skills by CipSoft's own ids, not by our slot order
	static constexpr uint8_t cyclopediaSkillIds[] = { 11, 9, 8, 10, 7, 6, 13 };
	for (uint8_t skill = SKILL_FIRST; skill <= SKILL_LAST; ++skill)
	{
		msg.addByte(cyclopediaSkillIds[skill]);
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(skill), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(skill));
		msg.add<uint16_t>(player->getBaseSkill(skill)); // base + loyalty
		msg.add<uint16_t>(static_cast<uint16_t>(player->getSkillPercent(skill)) * 100);
	}

	msg.add(CommonCode::Zero); // specialized magic levels; none on this server
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterCombatStats()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::CombatStats);
	msg.add(CyclopediaErrorCode::None);

	// 12.81 to 14.05 list the forge skills here; 14.10+ moved them into the
	// character skill stats block of 0xA1 and dropped them from this page
	if (not hasFeature(ProtocolFeature::CharacterSkillStats))
	{
		for (uint8_t forgeSkill = 0; forgeSkill < 4; ++forgeSkill)
		{
			msg.add<uint16_t>(0); // fatal, dodge, momentum, transcendence: level
			msg.add<uint16_t>(0); // base
		}
	}

	msg.add<uint16_t>(0); // cleave percent
	msg.add<uint16_t>(0); // magic shield capacity flat
	msg.add<uint16_t>(0); // magic shield capacity percent
	for (uint8_t range = 1; range <= 5; ++range)
	{
		msg.add<uint16_t>(0); // perfect shot damage at this range
	}
	msg.add<uint16_t>(0); // damage reflection

	uint8_t blessingsHeld = 0;
	for (uint8_t blessing = 0; blessing < Player::Blessings::Count; ++blessing)
	{
		if (player->hasBlessing(blessing))
		{
			++blessingsHeld;
		}
	}
	msg.addByte(blessingsHeld);
	msg.addByte(Player::Blessings::Count);

	const auto& weapon = player->getWeapon();
	msg.add<uint16_t>(weapon ? std::max<int32_t>(weapon->getAttack(), 0) : 0); // weapon max hit
	msg.add(CommonCode::Zero); // weapon element
	msg.add(CommonCode::Zero); // weapon element damage
	msg.add(CommonCode::Zero); // weapon element type
	msg.add<uint16_t>(std::max<int32_t>(player->getArmor(), 0));
	msg.add<uint16_t>(std::max<int32_t>(player->getDefense(), 0));
	msg.addDouble(0.0, 2); // mitigation
	msg.add(CommonCode::Zero); // combat element modifiers
	msg.add(CommonCode::Zero); // active concoctions
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentDeaths(uint16_t page, uint16_t pages, const std::vector<std::pair<uint32_t, std::string>>& entries)
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::RecentDeaths);
	msg.add(CyclopediaErrorCode::None);
	msg.add<uint16_t>(page);
	msg.add<uint16_t>(pages);
	msg.add<uint16_t>(entries.size());
	for (const auto& [timestamp, cause] : entries)
	{
		msg.add<uint32_t>(timestamp);
		msg.addString(cause);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterRecentPvpKills()
{
	// kills are not recorded per player yet, so the page is empty
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::RecentPvpKills);
	msg.add(CyclopediaErrorCode::None);
	msg.add<uint16_t>(1); // page
	msg.add<uint16_t>(0); // pages
	msg.add<uint16_t>(0); // entries
	writeToOutputBuffer(msg);
}

void ProtocolGame::addCyclopediaItemSummary(NetworkMessage& msg, const std::map<uint16_t, uint32_t>& items) const
{
	msg.add<uint16_t>(items.size());
	for (const auto& [itemId, count] : items)
	{
		addMarketItemId(msg, itemId);
		msg.add<uint32_t>(count);
	}
}

void ProtocolGame::sendCyclopediaCharacterItemSummary()
{
	// everything the character carries, then what sits in the depots; the
	// store, stash and inbox columns stay empty until those systems exist
	std::map<uint16_t, uint32_t> inventory;
	gtl::btree_map<uint32_t, uint32_t> carried;
	player->getAllItemTypeCount(carried);
	for (const auto& [itemId, count] : carried)
	{
		if (itemId <= std::numeric_limits<uint16_t>::max())
		{
			inventory[static_cast<uint16_t>(itemId)] = count;
		}
	}

	std::map<uint16_t, uint32_t> depot;
	if (player->depotChests)
	{
		for (const auto& [depotId, chest] : *player->depotChests)
		{
			std::forward_list<ContainerPtr> containerList{ chest };
			do
			{
				ContainerPtr container = containerList.front();
				containerList.pop_front();
				if (not container)
				{
					continue;
				}

				for (const auto& item : container->getItemList())
				{
					if (const auto& inner = item->getContainer())
					{
						containerList.push_front(inner);
					}
					depot[item->getID()] += Item::countByType(item, -1);
				}
			} while (not containerList.empty());
		}
	}

	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::ItemSummary);
	msg.add(CyclopediaErrorCode::None);
	addCyclopediaItemSummary(msg, inventory);
	msg.add<SpecialCode>(SpecialCode::Zero); // store inbox
	msg.add<SpecialCode>(SpecialCode::Zero); // stash
	addCyclopediaItemSummary(msg, depot);
	msg.add<SpecialCode>(SpecialCode::Zero); // inbox
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterOutfitsMounts()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::OutfitsMounts);
	msg.add(CyclopediaErrorCode::None);

	const Outfit_t& currentOutfit = player->getDefaultOutfit();
	std::vector<ProtocolOutfit> protocolOutfits;
	for (const Outfit& outfit : Outfits::getInstance().getOutfits(player->getSex()))
	{
		uint8_t addons;
		if (player->getOutfitAddons(outfit, addons))
		{
			protocolOutfits.emplace_back(outfit.name, outfit.lookType, addons);
		}
	}

	msg.add<uint16_t>(protocolOutfits.size());
	for (const ProtocolOutfit& outfit : protocolOutfits)
	{
		msg.add<uint16_t>(outfit.lookType);
		msg.addString(outfit.name);
		msg.addByte(outfit.addons);
		msg.add(CommonCode::Zero); // source: none (0x01 quest, 0x02 store)
		msg.add<uint32_t>(outfit.lookType == currentOutfit.lookType ? 1000 : 0); // worn
	}
	if (not protocolOutfits.empty())
	{
		msg.addByte(currentOutfit.lookHead);
		msg.addByte(currentOutfit.lookBody);
		msg.addByte(currentOutfit.lookLegs);
		msg.addByte(currentOutfit.lookFeet);
	}

	std::vector<const Mount*> mounts;
	for (const Mount& mount : g_game.mounts.getMounts())
	{
		if (player->hasMount(&mount))
		{
			mounts.push_back(&mount);
		}
	}

	msg.add<uint16_t>(mounts.size());
	for (const Mount* mount : mounts)
	{
		msg.add<uint16_t>(mount->clientId);
		msg.addString(mount->name);
		msg.add(CommonCode::Zero); // source
		msg.add<uint32_t>(mount->clientId == currentOutfit.lookMount ? 1000 : 0); // in use
	}
	if (not mounts.empty())
	{
		msg.add(CommonCode::Zero); // mount head
		msg.add(CommonCode::Zero); // mount body
		msg.add(CommonCode::Zero); // mount legs
		msg.add(CommonCode::Zero); // mount feet
	}

	msg.add<SpecialCode>(SpecialCode::Zero); // familiars
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterStoreSummary()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::StoreSummary);
	msg.add(CyclopediaErrorCode::None);
	msg.add<uint32_t>(0); // store xp boost remaining
	msg.add<uint32_t>(0); // daily reward xp boost remaining

	msg.addByte(Player::Blessings::Count);
	for (uint8_t blessing = 0; blessing < Player::Blessings::Count; ++blessing)
	{
		msg.addString(Player::Blessings::Names[blessing]);
		msg.addByte(player->hasBlessing(blessing) ? 1 : 0);
	}

	msg.add(CommonCode::Zero); // prey slots unlocked
	msg.add(CommonCode::Zero); // prey wildcards
	if (hasFeature(ProtocolFeature::TaskBoard))
	{
		msg.add(CommonCode::False); // permanent weekly task expansion
	}
	msg.add(CommonCode::Zero); // instant reward access
	msg.add(CommonCode::False); // charm expansion
	msg.add(CommonCode::Zero); // hirelings
	msg.add(CommonCode::Zero); // hireling skills
	msg.add(CommonCode::Zero); // hireling outfits
	msg.add<SpecialCode>(SpecialCode::Zero); // house items
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterBadges()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::Badges);
	msg.add(CyclopediaErrorCode::None);
	msg.add(CommonCode::True); // show account information
	msg.add(CommonCode::True); // online
	msg.add(player->isPremium() ? CommonCode::True : CommonCode::False);
	msg.add<SpecialCode>(SpecialCode::Zero); // loyalty title
	msg.add(CommonCode::Zero); // badges
	writeToOutputBuffer(msg);
}

// the 15.x stat pages break every bonus down by source (equipment, wheel,
// imbuement, ...); this server has none of those systems, so the totals are
// the character's plain numbers and every bonus column reads zero
void ProtocolGame::sendCyclopediaCharacterOffenceStats()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::OffenceStats);
	msg.add(CyclopediaErrorCode::None);

	for (uint8_t column = 0; column < 6; ++column)
	{
		msg.addDouble(0.0, 2); // critical chance: total, equipment, flat, imbuement, wheel, concoction
	}
	for (uint8_t column = 0; column < 6; ++column)
	{
		msg.addDouble(0.0, 2); // critical damage: same columns
	}
	for (uint8_t column = 0; column < 5; ++column)
	{
		msg.addDouble(0.0, 2); // life leech: total, equipment, imbuement, wheel, event
	}
	for (uint8_t column = 0; column < 5; ++column)
	{
		msg.addDouble(0.0, 2); // mana leech: same columns
	}
	for (uint8_t column = 0; column < 4; ++column)
	{
		msg.addDouble(0.0, 2); // onslaught: total, base, bonus, event
	}
	msg.addDouble(0.0, 2); // cleave percent
	for (uint8_t range = 0; range < 7; ++range)
	{
		msg.add<uint16_t>(0); // perfect shot damage per range
	}
	msg.add<uint16_t>(0); // flat damage
	msg.add<uint16_t>(0); // flat damage base
	msg.add<uint16_t>(0); // flat damage wheel

	const auto& weapon = player->getWeapon();
	msg.add<uint16_t>(weapon ? std::max<int32_t>(weapon->getAttack(), 0) : 0); // weapon attack
	msg.add<uint16_t>(0); // weapon flat modifier
	msg.add<uint16_t>(0); // weapon damage
	msg.add(CommonCode::Zero); // weapon skill type
	msg.add<uint16_t>(0); // weapon skill level
	msg.add<uint16_t>(0); // weapon skill modifier
	msg.add(CommonCode::Zero); // weapon element
	msg.addDouble(0.0, 2); // weapon element damage
	msg.add(CommonCode::Zero); // weapon element type
	msg.add(CommonCode::Zero); // distance accuracy entries

	msg.addDouble(0.0, 2); // damage against powerful foes
	msg.add<SpecialCode>(SpecialCode::Zero); // damage against specific targets
	msg.add(CommonCode::Zero); // critical chance by element
	msg.addDouble(0.0, 2); // offensive rune damage
	msg.addDouble(0.0, 2); // auto attack damage
	msg.add(CommonCode::Zero); // critical damage by element
	msg.addDouble(0.0, 2); // critical damage on offensive runes
	msg.addDouble(0.0, 2); // critical damage on auto attacks
	msg.add<uint16_t>(0); // life gain on hit
	msg.add<uint16_t>(0); // mana gain on hit
	msg.add<uint16_t>(0); // life gain on kill
	msg.add<uint16_t>(0); // mana gain on kill
	msg.add(CommonCode::Zero); // auto attack extra damage entries
	msg.add(CommonCode::Zero); // spell extra damage entries
	msg.add(CommonCode::Zero); // spell extra healing entries

	msg.addDouble(0.0, 2); // damage to targets above 95% health (15.21+)
	msg.addDouble(0.0, 2); // damage to targets below 30% health
	msg.addDouble(0.0, 2); // armor penetration
	msg.add(CommonCode::Zero); // elemental pierce entries
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterDefenceStats()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::DefenceStats);
	msg.add(CyclopediaErrorCode::None);

	for (uint8_t column = 0; column < 5; ++column)
	{
		msg.addDouble(0.0, 2); // dodge: total, base, bonus, unused, wheel
	}
	msg.add<uint32_t>(0); // magic shield capacity
	msg.add<uint16_t>(0); // magic shield capacity flat
	msg.addDouble(0.0, 2); // magic shield capacity percent
	msg.add<uint16_t>(0); // physical reflection
	msg.add<uint16_t>(std::max<int32_t>(player->getArmor(), 0));
	if (hasFeature(ProtocolFeature::MonkMantra))
	{
		msg.add<uint16_t>(0); // mantra
	}
	msg.add<uint16_t>(std::max<int32_t>(player->getDefense(), 0));
	msg.add<uint16_t>(std::max<int32_t>(player->getDefense(), 0)); // defense from equipment
	msg.add(CommonCode::Zero); // defense skill type
	msg.add<uint16_t>(player->getSkillLevel(SKILL_SHIELD));
	msg.add<uint16_t>(0); // defense from the wheel
	msg.add<uint16_t>(0); // unused
	for (uint8_t column = 0; column < 6; ++column)
	{
		msg.addDouble(0.0, 2); // mitigation: total, base, equipment, shield, wheel, combat tactics
	}
	msg.add(CommonCode::Zero); // elemental resistance entries
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterMiscStats()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::MiscStats);
	msg.add(CyclopediaErrorCode::None);

	for (uint8_t column = 0; column < 5; ++column)
	{
		msg.addDouble(0.0, 2); // momentum: total, base, bonus, wheel, unused
	}
	for (uint8_t column = 0; column < 4; ++column)
	{
		msg.addDouble(0.0, 2); // dodge: total, base, bonus, wheel
	}
	for (uint8_t column = 0; column < 3; ++column)
	{
		msg.addDouble(0.0, 2); // damage reflection: total, base, bonus
	}

	uint8_t blessingsHeld = 0;
	for (uint8_t blessing = 0; blessing < Player::Blessings::Count; ++blessing)
	{
		if (player->hasBlessing(blessing))
		{
			++blessingsHeld;
		}
	}
	msg.addByte(blessingsHeld);
	msg.addByte(Player::Blessings::Count);

	msg.add(CommonCode::Zero); // active concoctions
	msg.add(CommonCode::Zero); // active foods
	msg.add(CommonCode::Zero); // weapon proficiency augments
	msg.add(CommonCode::Zero); // wheel augments
	msg.add(CommonCode::Zero); // equipped augments
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterInspection()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::Inspection);
	msg.add(CyclopediaErrorCode::None);
	addCharacterInspection(msg, player);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreySlots()
{
	for (uint8_t slotId = 0; slotId < BlackTek::Prey::SlotCount; ++slotId)
	{
		sendPreySlot(slotId);
	}
	sendPreyPrices();
	sendResourceBalance(ResourceType::PreyWildcards, player->getPreyWildcards());
}

// a creature on a prey list: its name and how it looks
void ProtocolGame::addPreyMonster(NetworkMessage& msg, uint16_t raceId) const
{
	const MonsterType* monsterType = BlackTek::Bestiary::Registry::getInstance().getMonster(raceId);
	if (not monsterType)
	{
		msg.add<SpecialCode>(SpecialCode::Zero); // name
		msg.add<SpecialCode>(SpecialCode::Zero); // look type
		msg.add<SpecialCode>(SpecialCode::Zero); // look type ex
		return;
	}

	msg.addString(monsterType->name);
	addOutfitLook(msg, monsterType->info.outfit);
}

void ProtocolGame::sendPreySlot(uint8_t slotId)
{
	using SlotState = BlackTek::Prey::Slot::State;
	const auto& slot = player->getPreySlot(slotId);
	const auto& config = BlackTek::Prey::System::getInstance().getConfig();
	const int64_t now = OTSYS_TIME();
	const uint32_t nextFreeReroll = slot.free_reroll_at > now ? static_cast<uint32_t>((slot.free_reroll_at - now) / 60000) : 0; // minutes
	const uint8_t wildcards = static_cast<uint8_t>(std::min<uint32_t>(player->getPreyWildcards(), std::numeric_limits<uint8_t>::max()));

	NetworkMessage msg;
	msg.add(ServerCode::PreyData);
	msg.addByte(slotId);
	msg.add(slot.state);
	switch (slot.state)
	{
		case SlotState::Locked:
			msg.add(config.free_third_slot ? PreyUnlockState::None : PreyUnlockState::Store);
			break;
		case SlotState::Inactive:
			break;
		case SlotState::Active:
			addPreyMonster(msg, slot.selected_race);
			msg.add(slot.bonus);
			msg.add<uint16_t>(slot.percentage);
			msg.addByte(slot.rarity);
			msg.add<uint16_t>(slot.time_left);
			break;
		case SlotState::Selection:
			msg.addByte(slot.race_list.size());
			for (uint16_t raceId : slot.race_list)
			{
				addPreyMonster(msg, raceId);
			}
			break;
		case SlotState::SelectionChangeMonster:
			msg.add(slot.bonus);
			msg.add<uint16_t>(slot.percentage);
			msg.addByte(slot.rarity);
			msg.addByte(slot.race_list.size());
			for (uint16_t raceId : slot.race_list)
			{
				addPreyMonster(msg, raceId);
			}
			break;
		case SlotState::WildcardSelection:
			msg.add(slot.bonus);
			msg.add<uint16_t>(slot.percentage);
			msg.addByte(slot.rarity);
			[[fallthrough]];
		case SlotState::ListSelection:
		{
			// every creature the bestiary knows, for a wildcard pick
			const auto& bestiary = BlackTek::Bestiary::Registry::getInstance();
			std::vector<uint16_t> raceIds;
			for (auto race = static_cast<uint8_t>(BlackTek::Bestiary::Registry::Race::First); race <= static_cast<uint8_t>(BlackTek::Bestiary::Registry::Race::Last); ++race)
			{
				for (const MonsterType* monsterType : bestiary.getRaceMembers(static_cast<BlackTek::Bestiary::Registry::Race>(race)))
				{
					raceIds.push_back(monsterType->info.bestiary.race_id);
				}
			}
			msg.add<uint16_t>(raceIds.size());
			for (uint16_t raceId : raceIds)
			{
				msg.add<uint16_t>(raceId);
			}
			break;
		}
	}

	msg.add<uint32_t>(nextFreeReroll);
	if (slot.state == SlotState::Active)
	{
		msg.add(slot.option); // what happens when the time runs out
	}
	else
	{
		msg.addByte(wildcards);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyTimeLeft(uint8_t slotId)
{
	NetworkMessage msg;
	msg.add(ServerCode::PreyTimeLeft);
	msg.addByte(slotId);
	msg.add<uint16_t>(player->getPreySlot(slotId).time_left);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPreyPrices()
{
	const auto& prey = BlackTek::Prey::System::getInstance();
	NetworkMessage msg;
	msg.add(ServerCode::PreyPrices);
	msg.add<uint32_t>(prey.getRerollPrice(player));
	msg.addByte(static_cast<uint8_t>(prey.getConfig().bonus_reroll_price));
	msg.addByte(static_cast<uint8_t>(prey.getConfig().selection_list_price));
	writeToOutputBuffer(msg);
}

// the client's analyser windows: healing, damage by element, supplies
// consumed, loot dropped and creatures killed
void ProtocolGame::sendImpactTracker(ImpactTrackerCode type, uint32_t amount, CombatType_t combatType, const std::string& target)
{
	if (not hasFeature(ProtocolFeature::HuntAnalytics))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::ImpactTracker);
	msg.add(type);
	msg.add<uint32_t>(amount);
	if (type != ImpactTrackerCode::Heal)
	{
		msg.add(CyclopediaElementOf(combatType));
	}
	if (type == ImpactTrackerCode::DamageReceived)
	{
		msg.addString(target);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSupplyTracker(uint16_t itemId)
{
	if (not hasFeature(ProtocolFeature::HuntAnalytics))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::SupplyTracker);
	msg.add<uint16_t>(Item::items.getModernClientId(itemId));
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendLootTracker(const ItemConstPtr& item)
{
	if (not hasFeature(ProtocolFeature::HuntAnalytics) or not item)
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::LootTracker);
	addItem(msg, item);
	msg.addString(item->getName());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendKillTracker(const std::string& name, const Outfit_t& outfit, const ItemDeque& items)
{
	if (not hasFeature(ProtocolFeature::HuntAnalytics))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::KillTracker);
	msg.addString(name);
	addOutfitLook(msg, outfit);
	msg.addByte(static_cast<uint8_t>(std::min<size_t>(items.size(), std::numeric_limits<uint8_t>::max())));
	for (const auto& item : items | std::views::take(std::numeric_limits<uint8_t>::max()))
	{
		addItem(msg, item);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::parseForgeAction(NetworkMessage& msg)
{
	using Action = BlackTek::Forge::System::Action;
	const uint8_t action = msg.getByte();
	bool convergence = false;
	uint16_t firstItemId = 0;
	uint8_t firstTier = 0;
	uint16_t secondItemId = 0;
	bool improveChance = false;
	bool reduceTierLoss = false;
	if (action == std::to_underlying(Action::Fusion) or action == std::to_underlying(Action::Transfer))
	{
		convergence = msg.getByte() != 0;
		firstItemId = getItemId(msg);
		firstTier = msg.getByte();
		secondItemId = getItemId(msg);
		improveChance = msg.getByte() != 0;
		reduceTierLoss = msg.getByte() != 0;
	}
	addGameTask([=, playerID = player->getID()]() { g_game.playerForgeAction(playerID, action, convergence, firstItemId, firstTier, secondItemId, improveChance, reduceTierLoss); });
}

void ProtocolGame::parseForgeHistory(NetworkMessage& msg)
{
	const uint16_t page = msg.getByte();
	addGameTask([=, playerID = player->getID()]() { g_game.playerForgeHistory(playerID, page); });
}

void ProtocolGame::parseOpenWheel(NetworkMessage& msg)
{
	const uint32_t ownerId = msg.get<uint32_t>();
	addGameTask([=, playerID = player->getID()]() { g_game.playerOpenWheel(playerID, ownerId); });
}

// every slot's points, then one gem index per vessel
void ProtocolGame::parseSaveWheel(NetworkMessage& msg)
{
	using namespace BlackTek::Wheel;
	std::array<uint16_t, SlotCount + 1> points {};
	for (uint8_t slot = 1; slot <= SlotCount; ++slot)
	{
		points[slot] = msg.get<uint16_t>();
	}
	std::array<uint16_t, QuadrantCount> vessels {};
	for (auto& vessel : vessels)
	{
		const bool hasGem = msg.getByte() != 0;
		vessel = hasGem ? msg.get<uint16_t>() : 0xFFFF;
	}
	addGameTask([=, playerID = player->getID()]() { g_game.playerSaveWheel(playerID, points, vessels); });
}

void ProtocolGame::parseWheelGemAction(NetworkMessage& msg)
{
	using GemAction = BlackTek::Wheel::System::GemAction;
	const uint8_t action = msg.getByte();
	uint16_t param = 0;
	uint8_t position = 0;
	switch (static_cast<GemAction>(action))
	{
		case GemAction::Destroy:
		case GemAction::SwitchDomain:
		case GemAction::ToggleLock:
			param = msg.get<uint16_t>();
			break;
		case GemAction::Reveal:
			param = msg.getByte();
			break;
		case GemAction::ImproveGrade:
			param = msg.getByte();
			position = msg.getByte();
			break;
	}
	addGameTask([=, playerID = player->getID()]() { g_game.playerWheelGemAction(playerID, action, param, position); });
}

// the whole wheel: points, scrolls, gems and their grades
void ProtocolGame::sendWheelWindow(uint32_t ownerId)
{
	using namespace BlackTek::Wheel;
	const auto& wheel = System::getInstance();

	NetworkMessage msg;
	msg.add(ServerCode::WheelWindow);
	msg.add<uint32_t>(ownerId);
	const bool canUse = wheel.canOpen(player);
	msg.addByte(canUse ? 1 : 0);
	if (not canUse)
	{
		writeToOutputBuffer(msg);
		return;
	}

	wheel.grantInitialGems(player);
	const auto& state = player->getWheelState();
	const auto vocation = System::getVocation(player);
	msg.addByte(std::to_underlying(wheel.getOptions(player, ownerId)));
	msg.addByte(std::to_underlying(vocation));
	msg.add<uint16_t>(wheel.getPoints(player));
	msg.add<uint16_t>(wheel.getExtraPoints(player));
	for (uint8_t slot = 1; slot <= SlotCount; ++slot)
	{
		msg.add<uint16_t>(state.points[slot]);
	}

	msg.add<uint16_t>(static_cast<uint16_t>(state.scrolls.size()));
	for (const auto itemId : state.scrolls)
	{
		msg.add<uint16_t>(itemId);
		msg.addByte(wheel.getScrollPoints(itemId));
	}

	// 15.x: a quest bonus the monk earns; nobody here has it
	msg.addByte(0);
	msg.add<uint16_t>(0);

	// the gems in their vessels, by their index in the list that follows
	std::vector<uint16_t> placed;
	for (uint16_t index = 0; index < state.gems.size(); ++index)
	{
		if (state.gems[index].vessel != NoVessel)
		{
			placed.push_back(index);
		}
	}
	msg.addByte(static_cast<uint8_t>(placed.size()));
	for (const auto index : placed)
	{
		msg.add<uint16_t>(index);
	}

	msg.add<uint16_t>(static_cast<uint16_t>(state.gems.size()));
	for (uint16_t index = 0; index < state.gems.size(); ++index)
	{
		const auto& gem = state.gems[index];
		msg.add<uint16_t>(index);
		msg.addByte(gem.locked ? 1 : 0);
		msg.addByte(std::to_underlying(gem.domain));
		msg.addByte(std::to_underlying(gem.quality));
		msg.addByte(std::to_underlying(gem.first_modifier));
		if (gem.quality >= Gem::Quality::Regular)
		{
			msg.addByte(std::to_underlying(gem.second_modifier));
		}
		if (gem.quality >= Gem::Quality::Greater)
		{
			msg.addByte(std::to_underlying(gem.supreme_modifier));
		}
	}

	// the grade of every modifier the client lists
	const auto basics = System::basicPositions();
	msg.addByte(static_cast<uint8_t>(basics.size()));
	for (const auto modifier : basics)
	{
		msg.addByte(std::to_underlying(modifier));
		msg.addByte(state.basic_grades[std::to_underlying(modifier)]);
	}
	const auto supremes = System::supremePositions(vocation);
	msg.addByte(static_cast<uint8_t>(supremes.size()));
	for (const auto modifier : supremes)
	{
		msg.addByte(std::to_underlying(modifier));
		msg.addByte(state.supreme_grades[std::to_underlying(modifier)]);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendWheelGemRevealed(uint16_t index)
{
	NetworkMessage msg;
	msg.add(ServerCode::WheelGemRevealed);
	msg.add<uint16_t>(index);
	writeToOutputBuffer(msg);
}

// the price list and the forge's tuning, sent once at login
void ProtocolGame::sendForgeItemClasses()
{
	using namespace BlackTek::Forge;
	const auto& forge = System::getInstance();
	const Config& config = forge.getConfig();

	NetworkMessage msg;
	msg.add(ServerCode::ForgeItemClasses);
	msg.addByte(ClassificationCount);
	for (uint8_t classification = 1; classification <= ClassificationCount; ++classification)
	{
		const auto& tiers = config.prices[classification];
		msg.addByte(classification);
		msg.addByte(static_cast<uint8_t>(tiers.size()));
		for (const auto& [tier, price] : tiers)
		{
			msg.addByte(tier);
			msg.add<uint64_t>(price.regular);
		}
	}

	// exalted cores each tier of the top class asks for
	const auto& topTiers = config.prices[ClassificationCount];
	msg.addByte(static_cast<uint8_t>(topTiers.size()));
	for (const auto& [tier, price] : topTiers)
	{
		msg.addByte(tier);
		msg.addByte(price.cores);
	}

	// convergence prices, fusion then transfer
	msg.addByte(static_cast<uint8_t>(topTiers.size()));
	for (const auto& [tier, price] : topTiers)
	{
		msg.addByte(tier);
		msg.add<uint64_t>(price.convergence_fusion);
	}

	msg.addByte(static_cast<uint8_t>(topTiers.size()));
	for (const auto& [tier, price] : topTiers)
	{
		msg.addByte(tier);
		msg.add<uint64_t>(price.convergence_transfer);
	}

	msg.addByte(config.dust_chance_per_kill);
	msg.addByte(static_cast<uint8_t>(config.dust_per_sliver_batch));
	msg.addByte(static_cast<uint8_t>(config.slivers_per_core));
	msg.addByte(config.slivers_per_batch); // slivers one batch of dust yields
	msg.add<uint16_t>(config.dust_level_max);
	msg.add<uint16_t>(config.dust_level_start);
	msg.addByte(config.fusion_dust_cost);
	msg.addByte(config.convergence_fusion_dust_cost);
	msg.addByte(config.transfer_dust_cost);
	msg.addByte(config.convergence_transfer_dust_cost);
	msg.addByte(config.fusion_base_success);
	msg.addByte(config.fusion_improved_success);
	msg.addByte(config.fusion_tier_loss_reduction);
	writeToOutputBuffer(msg);
}

namespace
{
	// items grouped for the forge window: id -> tier -> count
	using ForgeItemMap = std::map<uint16_t, std::map<uint8_t, uint16_t>>;

	uint16_t ForgeSlotOf(uint16_t itemId)
	{
		uint16_t slot = Item::items[itemId].slotPosition;
		if ((slot & SLOTP_TWO_HAND) != 0)
		{
			slot = SLOTP_HAND;
		}
		return slot;
	}

	void AddForgeItemGroup(NetworkMessage& msg, const ForgeItemMap& items)
	{
		uint16_t count = 0;
		for (const auto& [itemId, tiers] : items)
		{
			count += static_cast<uint16_t>(tiers.size());
		}

		msg.add<uint16_t>(count);
		for (const auto& [itemId, tiers] : items)
		{
			for (const auto& [tier, amount] : tiers)
			{
				msg.add<uint16_t>(Item::items.getModernClientId(itemId));
				msg.addByte(tier);
				msg.add<uint16_t>(amount);
			}
		}
	}
}

// what the character carries, sorted into what the forge can do with it
void ProtocolGame::sendForgeWindow()
{
	using namespace BlackTek::Forge;
	const auto& forge = System::getInstance();
	const uint8_t maxTier = forge.getConfig().max_tier;

	ForgeItemMap fusion;
	std::map<uint16_t, ForgeItemMap> convergenceFusion; // by equipment slot
	ForgeItemMap donors;
	ForgeItemMap receivers;
	std::map<uint8_t, ForgeItemMap> convergenceTransfer; // by classification

	const auto& appearances = BlackTek::Assets::Appearances::getInstance();
	const auto sort = [&](const ItemPtr& item)
	{
		const auto* app = appearances.getObject(Item::items.getModernClientId(item->getID()));
		if (not app or app->classification == 0)
		{
			return;
		}

		const auto classification = static_cast<uint8_t>(std::min<uint32_t>(app->classification, ClassificationCount));
		const uint8_t tier = item->getForgeTier();
		const uint8_t classTop = classification == ClassificationCount ? maxTier : classification;
		if (tier < classTop)
		{
			fusion[item->getID()][tier] += 1;
		}

		if (tier > 1)
		{
			donors[item->getID()][tier] += 1;
		}
		else if (tier == 0)
		{
			receivers[item->getID()][tier] += 1;
		}

		if (classification == ClassificationCount)
		{
			if (tier < maxTier)
			{
				convergenceFusion[ForgeSlotOf(item->getID())][item->getID()][tier] += 1;
			}
			convergenceTransfer[classification][item->getID()][tier] += 1;
		}
	};

	auto carried = std::views::iota(static_cast<int32_t>(CONST_SLOT_FIRST), static_cast<int32_t>(CONST_SLOT_LAST) + 1)
		| std::views::transform([&](int32_t slot) { return player->getInventoryItem(static_cast<slots_t>(slot)); })
		| std::views::filter([](const ItemPtr& item) { return item != nullptr; });
	for (const auto& item : carried)
	{
		sort(item);
		if (const auto& container = item->getContainer())
		{
			for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance())
			{
				sort(*it);
			}
		}
	}

	NetworkMessage msg;
	msg.add(ServerCode::ForgeOpen);

	// fusion: pairs of the same item and tier
	uint16_t fusionCount = 0;
	for (const auto& [itemId, tiers] : fusion)
	{
		for (const auto& [tier, amount] : tiers)
		{
			if (amount >= 2)
			{
				++fusionCount;
			}
		}
	}

	msg.add<uint16_t>(fusionCount);
	for (const auto& [itemId, tiers] : fusion)
	{
		for (const auto& [tier, amount] : tiers)
		{
			if (amount >= 2)
			{
				msg.add(CommonCode::True); // items per line
				msg.add<uint16_t>(Item::items.getModernClientId(itemId));
				msg.addByte(tier);
				msg.add<uint16_t>(amount);
			}
		}
	}

	// convergence fusion: one group per equipment slot
	msg.add<uint16_t>(static_cast<uint16_t>(convergenceFusion.size()));
	for (const auto& [slot, items] : convergenceFusion)
	{
		uint8_t count = 0;
		for (const auto& [itemId, tiers] : items)
		{
			count += static_cast<uint8_t>(tiers.size());
		}

		msg.addByte(count);
		for (const auto& [itemId, tiers] : items)
		{
			for (const auto& [tier, amount] : tiers)
			{
				msg.add<uint16_t>(Item::items.getModernClientId(itemId));
				msg.addByte(tier);
				msg.add<uint16_t>(amount);
			}
		}
	}

	// transfer: each donor with the untiered items of its class and slot
	msg.addByte(static_cast<uint8_t>(donors.size()));
	for (const auto& [donorId, tiers] : donors)
	{
		const auto* donorApp = appearances.getObject(Item::items.getModernClientId(donorId));
		const uint32_t donorClass = donorApp ? donorApp->classification : 0;
		const uint16_t donorSlot = ForgeSlotOf(donorId);

		msg.add<uint16_t>(static_cast<uint16_t>(tiers.size()));
		for (const auto& [tier, amount] : tiers)
		{
			msg.add<uint16_t>(Item::items.getModernClientId(donorId));
			msg.addByte(tier);
			msg.add<uint16_t>(amount);
		}

		std::vector<std::pair<uint16_t, uint16_t>> matches;
		for (const auto& [receiverId, receiverTiers] : receivers)
		{
			const auto* receiverApp = appearances.getObject(Item::items.getModernClientId(receiverId));
			if (receiverApp and receiverApp->classification == donorClass and ForgeSlotOf(receiverId) == donorSlot)
			{
				matches.emplace_back(receiverId, receiverTiers.at(0));
			}
		}

		msg.add<uint16_t>(static_cast<uint16_t>(matches.size()));
		for (const auto& [receiverId, amount] : matches)
		{
			msg.add<uint16_t>(Item::items.getModernClientId(receiverId));
			msg.add<uint16_t>(amount);
		}
	}

	// convergence transfer: one group per classification, donors then receivers
	msg.addByte(static_cast<uint8_t>(convergenceTransfer.size()));
	for (const auto& [classification, items] : convergenceTransfer)
	{
		ForgeItemMap groupDonors;
		ForgeItemMap groupReceivers;
		for (const auto& [itemId, tiers] : items)
		{
			for (const auto& [tier, amount] : tiers)
			{
				(tier > 0 ? groupDonors : groupReceivers)[itemId][tier] = amount;
			}
		}

		AddForgeItemGroup(msg, groupDonors);
		msg.add<uint16_t>(static_cast<uint16_t>(groupReceivers.size()));
		for (const auto& [itemId, tiers] : groupReceivers)
		{
			msg.add<uint16_t>(Item::items.getModernClientId(itemId));
			msg.add<uint16_t>(tiers.at(0));
		}
	}

	msg.add<uint16_t>(player->getForgeDustLevel());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendForgeHistory(uint16_t page)
{
	constexpr uint16_t PerPage = 9;
	uint16_t pages = 0;
	const auto entries = BlackTek::Forge::System::getInstance().getHistory(player, page, PerPage, pages);

	// the client asks for page 0 and shows pages from 1
	NetworkMessage msg;
	msg.add(ServerCode::ForgeHistory);
	msg.add<uint16_t>(page + 1);
	msg.add<uint16_t>(std::max<uint16_t>(pages, 1));
	msg.addByte(static_cast<uint8_t>(entries.size()));
	for (const auto& entry : entries)
	{
		msg.add<uint32_t>(static_cast<uint32_t>(entry.created_at));
		msg.add(entry.action);
		msg.addString(entry.description);
		msg.addByte(entry.success ? std::to_underlying(entry.bonus) : 0);
	}
	writeToOutputBuffer(msg);
}

// a refusal closes the forge window and explains itself
void ProtocolGame::sendForgeError(const std::string& message)
{
	sendTextMessage(TextMessage(MESSAGE_EVENT_ADVANCE, message));

	NetworkMessage msg;
	msg.add(ServerCode::ForgeClose);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendForgeResult(BlackTek::Forge::System::Action action, bool convergence, bool success, uint16_t leftItemId, uint8_t leftTier, uint16_t rightItemId, uint8_t rightTier, BlackTek::Forge::System::Bonus bonus, uint8_t coreCount)
{
	using Action = BlackTek::Forge::System::Action;
	using Bonus = BlackTek::Forge::System::Bonus;

	NetworkMessage msg;
	msg.add(ServerCode::ForgeResult);
	msg.add(action);
	msg.addByte(convergence ? 1 : 0);
	msg.addByte(success ? 1 : 0);
	msg.add<uint16_t>(leftItemId != 0 ? Item::items.getModernClientId(leftItemId) : 0);
	msg.addByte(leftTier);
	msg.add<uint16_t>(rightItemId != 0 ? Item::items.getModernClientId(rightItemId) : 0);
	msg.addByte(rightTier);
	if (action == Action::Transfer)
	{
		msg.add(CommonCode::Zero); // transfers never roll a bonus
	}
	else
	{
		// the client reads the kept cores after CoresKept, and a fresh
		// item after the item-kept bonuses (4-8)
		msg.add(bonus);
		if (bonus == Bonus::CoresKept)
		{
			msg.addByte(coreCount);
		}
		else if (bonus == Bonus::SecondItemKept)
		{
			msg.add<uint16_t>(rightItemId != 0 ? Item::items.getModernClientId(rightItemId) : 0);
			msg.addByte(rightTier);
		}
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendForgeBalances()
{
	const auto& forge = BlackTek::Forge::System::getInstance();
	sendResourceBalance(ResourceType::ForgeDust, player->getForgeDust());
	sendResourceBalance(ResourceType::ForgeSlivers, forge.getSliverId() != 0 ? player->getItemTypeCount(forge.getSliverId()) : 0);
	sendResourceBalance(ResourceType::ForgeCores, forge.getCoreId() != 0 ? player->getItemTypeCount(forge.getCoreId()) : 0);
}

void ProtocolGame::sendBestiaryRaces()
{
	using Race = BlackTek::Bestiary::Registry::Race;
	const auto& bestiary = BlackTek::Bestiary::Registry::getInstance();

	NetworkMessage msg;
	msg.add(ServerCode::BestiaryRaces);
	msg.add<uint16_t>(static_cast<uint16_t>(Race::Last));
	for (auto race = static_cast<uint8_t>(Race::First); race <= static_cast<uint8_t>(Race::Last); ++race)
	{
		const auto& members = bestiary.getRaceMembers(static_cast<Race>(race));
		uint16_t met = 0;
		for (const MonsterType* monsterType : members)
		{
			if (player->getBestiaryKills(monsterType->info.bestiary.race_id) > 0)
			{
				++met;
			}
		}

		msg.addString(std::string(BlackTek::Bestiary::RaceName(static_cast<Race>(race))));
		msg.add<uint16_t>(members.size());
		msg.add<uint16_t>(met);
	}
	writeToOutputBuffer(msg);

	sendBestiaryCharms();
}

void ProtocolGame::sendBestiaryOverview(const std::string& raceName, const std::vector<const MonsterType*>& monsters)
{
	using BlackTek::Bestiary::Registry;
	using Stage = BlackTek::Bestiary::Registry::Stage;

	NetworkMessage msg;
	msg.add(ServerCode::BestiaryOverview);
	msg.addString(raceName);
	msg.add<uint16_t>(monsters.size());
	for (const MonsterType* monsterType : monsters)
	{
		const auto& entry = monsterType->info.bestiary;
		const Stage stage = Registry::getStage(*monsterType, player->getBestiaryKills(entry.race_id));
		msg.add<uint16_t>(entry.race_id);
		msg.add(stage);
		if (stage != Stage::Unknown)
		{
			msg.addByte(entry.occurrence);
		}
		msg.add<SpecialCode>(SpecialCode::Zero); // animus mastery bonus (13.40+)
	}
	msg.add<SpecialCode>(SpecialCode::Zero); // animus mastery points (13.40+)
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBestiaryMonsterData(uint16_t raceId)
{
	using BlackTek::Bestiary::Registry;
	using Stage = BlackTek::Bestiary::Registry::Stage;

	const MonsterType* monsterType = Registry::getInstance().getMonster(raceId);
	if (not monsterType)
	{
		return;
	}

	const auto& entry = monsterType->info.bestiary;
	const uint32_t kills = player->getBestiaryKills(raceId);
	const Stage stage = Registry::getStage(*monsterType, kills);

	NetworkMessage msg;
	msg.add(ServerCode::BestiaryMonsterData);
	msg.add<uint16_t>(raceId);
	msg.addString(entry.class_name);
	msg.add(stage);
	msg.add<SpecialCode>(SpecialCode::Zero); // animus mastery bonus (13.40+)
	msg.add<SpecialCode>(SpecialCode::Zero); // animus mastery points (13.40+)
	msg.add<uint32_t>(kills);
	msg.add<uint16_t>(entry.first_unlock);
	msg.add<uint16_t>(entry.second_unlock);
	msg.add<uint16_t>(entry.to_kill);
	msg.addByte(entry.stars);
	msg.addByte(entry.occurrence);

	// loot rows: the rarer the drop, the later the stage that reveals it
	const auto& lootItems = monsterType->info.lootItems;
	msg.addByte(std::min<size_t>(lootItems.size(), std::numeric_limits<uint8_t>::max()));
	uint8_t written = 0;
	for (const LootBlock& loot : lootItems)
	{
		if (written++ == std::numeric_limits<uint8_t>::max())
		{
			break;
		}

		const uint8_t difficulty = Registry::getLootDifficulty(loot.chance);
		const bool revealed = stage == Stage::Complete
			or (stage == Stage::Known and difficulty < 3)
			or (stage == Stage::Familiar and difficulty < 2);
		if (revealed)
		{
			addItemId(msg, loot.id);
		}
		else
		{
			msg.add<SpecialCode>(SpecialCode::Zero);
		}
		msg.addByte(difficulty);
		msg.add(CommonCode::Zero); // event loot
		if (revealed)
		{
			msg.addString(Item::items[loot.id].name);
			msg.add(loot.countmax > 1 ? CommonCode::True : CommonCode::False);
		}
	}

	if (stage >= Stage::Familiar)
	{
		msg.add<uint16_t>(entry.charm_points);
		uint8_t attackMode = 0; // melee
		if (not monsterType->info.isHostile)
		{
			attackMode = 2; // does not attack
		}
		else if (monsterType->info.targetDistance > 1)
		{
			attackMode = 1; // ranged
		}
		msg.addByte(attackMode);
		msg.addByte(2); // cast mode, always shown as "casts spells"
		msg.add<uint32_t>(std::max<int32_t>(monsterType->info.healthMax, 0));
		msg.add<uint32_t>(monsterType->info.experience);
		msg.add<uint16_t>(monsterType->info.baseSpeed);
		msg.add<uint16_t>(std::max<int32_t>(monsterType->info.armor, 0));
		msg.addDouble(0.0, 2); // mitigation
	}

	if (stage >= Stage::Known)
	{
		// resistances as the client shows them: 100% is neutral, less is
		// resistant, more is weak
		msg.addByte(CyclopediaElements.size());
		for (const auto& [combatType, element] : CyclopediaElements)
		{
			int32_t percent = 100;
			if (auto it = monsterType->info.elementMap.find(combatType); it != monsterType->info.elementMap.end())
			{
				percent -= it->second;
			}
			msg.add(element);
			msg.add<uint16_t>(std::clamp(percent, 0, std::numeric_limits<uint16_t>::max() + 0));
		}

		msg.add<uint16_t>(1); // location entries
		msg.addString(entry.locations);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendBestiaryCharms()
{
	using BlackTek::Bestiary::Registry;
	using Stage = BlackTek::Bestiary::Registry::Stage;
	const auto& bestiary = Registry::getInstance();
	const auto& self = player;

	NetworkMessage msg;
	msg.add(ServerCode::BestiaryCharms);
	msg.add<uint64_t>(Registry::getResetCost(self));

	const auto charms = bestiary.getCharms();
	msg.addByte(charms.size());
	uint8_t assigned = 0;
	for (const auto& charm : charms)
	{
		const auto& slot = self->getCharmSlot(charm.id);
		msg.addByte(charm.id);
		msg.addByte(slot.tier); // 0: locked
		if (slot.tier != 0 and slot.race_id != 0)
		{
			++assigned;
			msg.add(CommonCode::True);
			msg.add<uint16_t>(slot.race_id);
			msg.add<uint32_t>(Registry::getUnassignCost(self));
		}
		else
		{
			msg.add(CommonCode::False);
		}
	}

	// premium characters carry six runes at once, others two
	const uint8_t totalSlots = self->isPremium() ? 6 : 2;
	msg.addByte(totalSlots > assigned ? totalSlots - assigned : 0);

	// creatures whose entry is complete and still has room for a rune
	std::vector<uint16_t> finished;
	for (const auto& [raceId, kills] : self->getBestiaryKillMap())
	{
		const MonsterType* monsterType = bestiary.getMonster(raceId);
		if (monsterType and Registry::getStage(*monsterType, kills) == Stage::Complete)
		{
			finished.push_back(raceId);
		}
	}
	msg.add<uint16_t>(finished.size());
	for (uint16_t raceId : finished)
	{
		msg.add<uint32_t>(raceId);
	}
	writeToOutputBuffer(msg);

	sendCharmBalance();
}

void ProtocolGame::sendCharmBalance()
{
	sendResourceBalance(ResourceType::CharmPoints, player->getCharmPoints());
	sendResourceBalance(ResourceType::MinorCharmEchoes, 0);
	sendResourceBalance(ResourceType::MaxCharmPoints, std::numeric_limits<uint32_t>::max());
	sendResourceBalance(ResourceType::MaxMinorCharmEchoes, std::numeric_limits<uint32_t>::max());
}

void ProtocolGame::sendBestiaryTracker()
{
	using BlackTek::Bestiary::Registry;
	using Stage = BlackTek::Bestiary::Registry::Stage;
	const auto& bestiary = Registry::getInstance();

	NetworkMessage msg;
	msg.add(ServerCode::BestiaryTracker);
	msg.add(CommonCode::Zero); // creatures, not bosses (13.20+)
	const auto& tracked = player->getBestiaryTracker();
	msg.addByte(std::min<size_t>(tracked.size(), std::numeric_limits<uint8_t>::max()));
	auto known = tracked | std::views::filter([&](uint16_t raceId) { return bestiary.getMonster(raceId) != nullptr; });
	for (const uint16_t raceId : known)
	{
		const MonsterType* monsterType = bestiary.getMonster(raceId);
		const auto& entry = monsterType->info.bestiary;
		const uint32_t kills = player->getBestiaryKills(raceId);
		msg.add<uint16_t>(raceId);
		msg.add<uint32_t>(kills);
		msg.add<uint16_t>(entry.first_unlock);
		msg.add<uint16_t>(entry.second_unlock);
		msg.add<uint16_t>(entry.to_kill);
		msg.add(Registry::getStage(*monsterType, kills) == Stage::Complete ? Stage::Complete : Stage::Unknown);
	}
	writeToOutputBuffer(msg);
}

// the description rows an inspection window lists under an item
void ProtocolGame::addInspectionDescriptions(NetworkMessage& msg, const ItemType& it) const
{
	std::vector<std::pair<std::string, std::string>> rows;
	if (it.armor != 0)
	{
		rows.emplace_back("Armor", std::to_string(it.armor));
	}
	if (it.attack != 0)
	{
		rows.emplace_back("Attack", std::to_string(it.attack));
	}
	if (it.defense != 0)
	{
		rows.emplace_back("Defense", std::to_string(it.defense));
	}
	if (it.weight != 0)
	{
		rows.emplace_back("Weight", fmt::format("{:.2f} oz", it.weight / 100.0));
	}
	if (not it.description.empty())
	{
		rows.emplace_back("Description", it.description);
	}

	msg.addByte(rows.size());
	for (const auto& [key, value] : rows)
	{
		msg.addString(key);
		msg.addString(value);
	}
}

void ProtocolGame::addInspectionItem(NetworkMessage& msg, const ItemPtr& item, const ItemType& it) const
{
	msg.addString(it.name);
	if (item)
	{
		addItem(msg, item);
	}
	else
	{
		addItem(msg, it.getID(), 1);
	}
	msg.add(CommonCode::Zero); // imbuements
	addInspectionDescriptions(msg, it);
}

void ProtocolGame::sendItemInspection(const ItemPtr& item, bool cyclopedia)
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaItemDetail);
	msg.add(InspectionWindow::Item);
	msg.add(cyclopedia ? InspectionType::Cyclopedia : InspectionType::NormalObject);
	msg.add<uint32_t>(player->getID());
	msg.add(CommonCode::True); // one item
	addInspectionItem(msg, item, Item::items[item->getID()]);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendItemTypeInspection(uint16_t itemId, uint8_t inspectionType)
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaItemDetail);
	msg.add(InspectionWindow::Item);
	msg.addByte(inspectionType);
	msg.add<uint32_t>(player->getID());
	msg.add(CommonCode::True); // one item
	addInspectionItem(msg, nullptr, Item::items[itemId]);
	writeToOutputBuffer(msg);
}

void ProtocolGame::addCharacterInspection(NetworkMessage& msg, const PlayerConstPtr& target) const
{
	std::vector<std::pair<uint8_t, ItemPtr>> worn;
	for (uint8_t slot = CONST_SLOT_FIRST; slot <= CONST_SLOT_LAST; ++slot)
	{
		if (const auto& item = target->getInventoryItem(slot))
		{
			worn.emplace_back(slot, item);
		}
	}

	msg.addByte(worn.size());
	for (const auto& [slot, item] : worn)
	{
		msg.addByte(slot);
		addInspectionItem(msg, item, Item::items[item->getID()]);
	}

	msg.addString(target->getName());
	addOutfitLook(msg, target->getDefaultOutfit());

	msg.addByte(2); // character rows
	msg.addString("Level");
	msg.addString(std::to_string(target->getLevel()));
	msg.addString("Vocation");
	msg.addString(target->getVocation()->getVocName());
}

void ProtocolGame::sendCharacterInspection(const PlayerConstPtr& target, bool cyclopedia)
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaItemDetail);
	msg.add(InspectionWindow::Character);
	msg.add(cyclopedia ? InspectionType::Cyclopedia : InspectionType::NormalObject);
	msg.add<uint32_t>(target->getID());
	addCharacterInspection(msg, target);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCyclopediaCharacterTitles()
{
	NetworkMessage msg;
	msg.add(ServerCode::CyclopediaCharacterInfo);
	msg.add(CyclopediaInfoCode::Titles);
	msg.add(CyclopediaErrorCode::None);
	msg.add(CommonCode::Zero); // current title
	msg.add(CommonCode::Zero); // titles
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSaleItemList(const std::list<ShopInfo>& shop)
{
	if (hasFeature(ProtocolFeature::ResourceBalance))
	{
		// the modern trade window reads money from the resource balances
		sendResourceBalance(ResourceType::Bank, player->getBankBalance());
		sendResourceBalance(ResourceType::Inventory, player->getMoney());
	}

	NetworkMessage msg;
	msg.add(ServerCode::SaleItemList);
	if (not usesModernLayout())
	{
		msg.add<uint64_t>(player->getMoney() + player->getBankBalance());
	}

	std::map<uint16_t, uint32_t> saleMap;

	if (shop.size() <= 5)
	{
		// For very small shops it's not worth it to create the complete map
		for (const ShopInfo& shopInfo : shop)
		{
			if (shopInfo.sellPrice == 0)
			{
				continue;
			}

			int8_t subtype = -1;

			const ItemType& itemType = Item::items[shopInfo.itemId];
			if (itemType.hasSubType() and !itemType.stackable)
			{
				subtype = (shopInfo.subType == 0 ? -1 : shopInfo.subType);
			}

			uint32_t count = player->getItemTypeCount(shopInfo.itemId, subtype);
			if (count > 0)
			{
				saleMap[shopInfo.itemId] = count;
			}
		}
	}
	else
	{
		// Large shop, it's better to get a cached map of all item counts and use it
		// We need a temporary map since the finished map should only contain items
		// available in the shop
		gtl::btree_map<uint32_t, uint32_t> tempSaleMap;
		player->getAllItemTypeCount(tempSaleMap);

		// We must still check manually for the special items that require subtype matches
		// (That is, fluids such as potions etc., actually these items are very few since
		// health potions now use their own ID)
		for (const ShopInfo& shopInfo : shop)
		{
			if (shopInfo.sellPrice == 0)
			{
				continue;
			}

			int8_t subtype = -1;

			const ItemType& itemType = Item::items[shopInfo.itemId];
			if (itemType.hasSubType() and !itemType.stackable)
			{
				subtype = (shopInfo.subType == 0 ? -1 : shopInfo.subType);
			}

			if (subtype != -1)
			{
				uint32_t count;
				if (itemType.isFluidContainer() or itemType.isSplash())
				{
					count = player->getItemTypeCount(shopInfo.itemId, subtype); // This shop item requires extra checks
				}
				else
				{
					count = subtype;
				}

				if (count > 0)
				{
					saleMap[shopInfo.itemId] = count;
				}
			}
			else
			{
				gtl::btree_map<uint32_t, uint32_t>::const_iterator findIt = tempSaleMap.find(shopInfo.itemId);
				if (findIt != tempSaleMap.end() and findIt->second > 0)
				{
					saleMap[shopInfo.itemId] = findIt->second;
				}
			}
		}
	}

	if (usesModernLayout())
	{
		// 12.90+ counts and amounts are u16
		uint16_t itemsToSend = std::min<size_t>(saleMap.size(), std::numeric_limits<uint16_t>::max());
		msg.add<uint16_t>(itemsToSend);

		uint16_t i = 0;
		for (std::map<uint16_t, uint32_t>::const_iterator it = saleMap.begin(); i < itemsToSend; ++it, ++i)
		{
			addItemId(msg, it->first);
			msg.add<uint16_t>(std::min<uint32_t>(it->second, std::numeric_limits<uint16_t>::max()));
		}

		writeToOutputBuffer(msg);
		return;
	}

	uint8_t itemsToSend = std::min<size_t>(saleMap.size(), std::numeric_limits<uint8_t>::max());
	msg.addByte(itemsToSend);

	uint8_t i = 0;
	for (std::map<uint16_t, uint32_t>::const_iterator it = saleMap.begin(); i < itemsToSend; ++it, ++i)
	{
		addItemId(msg, it->first);
		msg.addByte(std::min<uint32_t>(it->second, std::numeric_limits<uint8_t>::max()));
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketEnter()
{
	if (hasFeature(ProtocolFeature::ResourceBalance))
	{
		// the modern market window reads the bank balance from the resource
		sendResourceBalance(ResourceType::Bank, player->getBankBalance());
	}

	NetworkMessage msg;
	msg.add(ServerCode::MarketEnter);

	if (not usesModernLayout())
	{
		msg.add<uint64_t>(player->getBankBalance());
	}
	msg.addByte(std::min<uint32_t>(IOMarket::getPlayerOfferCount(player->getGUID()), std::numeric_limits<uint8_t>::max()));

	player->setInMarket(true);

	std::map<uint16_t, uint32_t> depotItems;
	std::forward_list<ContainerPtr> containerList{ player->getInbox() };

	if (player->depotChests)
	{
		for (const auto& chest : *player->depotChests)
		{
			if (not chest.second->empty())
				containerList.push_front(chest.second);
		}
	}

	do
	{
		ContainerPtr container = containerList.front();
		containerList.pop_front();

		if (not container)
		{
			continue;
		}

		for (const auto& item : container->getItemList())
		{
			const auto& c = item->getContainer();
			if (c and not c->empty())
			{
				containerList.push_front(c);
				continue;
			}

			const ItemType& itemType = Item::items[item->getID()];
			if (itemType.wareId == 0)
			{
				continue;
			}

			if (c and (not itemType.isContainer() or c->capacity() != itemType.maxItems))
			{
				continue;
			}

			if (not item->hasMarketAttributes())
			{
				continue;
			}

			depotItems[itemType.wareId] += Item::countByType(item, -1);
		}
	} while (not containerList.empty());

	uint16_t itemsToSend = std::min<size_t>(depotItems.size(), std::numeric_limits<uint16_t>::max());
	msg.add<uint16_t>(itemsToSend);

	uint16_t i = 0;
	for (std::map<uint16_t, uint32_t>::const_iterator it = depotItems.begin(); i < itemsToSend; ++it, ++i)
	{
		addMarketItemId(msg, it->first);
		msg.add<uint16_t>(std::min<uint32_t>(std::numeric_limits<uint16_t>::max(), it->second));
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketLeave()
{
	NetworkMessage msg;
	msg.add(ServerCode::MarketLeave);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseItem(uint16_t itemId, const MarketOfferList& buyOffers, const MarketOfferList& sellOffers)
{
	NetworkMessage msg;
	msg.reset();
	msg.add(ServerCode::MarketAction);
	if (usesModernLayout())
	{
		msg.add(MarketRequestCode::BrowseItem);
	}
	addMarketItemId(msg, itemId);

	msg.add<uint32_t>(buyOffers.size());

	for (const MarketOffer& offer : buyOffers)
	{
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
		msg.addString(offer.playerName);
	}

	msg.add<uint32_t>(sellOffers.size());

	for (const MarketOffer& offer : sellOffers)
	{
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
		msg.addString(offer.playerName);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketAcceptOffer(const MarketOfferEx& offer)
{
	NetworkMessage msg;
	msg.add(ServerCode::MarketAction);
	if (usesModernLayout())
	{
		msg.add(MarketRequestCode::BrowseItem);
	}
	addMarketItemId(msg, offer.itemId);

	if (offer.type == MARKETACTION_BUY)
	{
		msg.add<uint32_t>(1);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
		msg.addString(offer.playerName);
		msg.add<uint32_t>(0);
	}
	else
	{
		msg.add<uint32_t>(0);
		msg.add<uint32_t>(1);
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
		msg.addString(offer.playerName);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnOffers(const MarketOfferList& buyOffers, const MarketOfferList& sellOffers)
{
	NetworkMessage msg;
	msg.add(ServerCode::MarketAction);
	addMarketRequest(msg, MarketRequestCode::OwnOffers, MARKETREQUEST_OWN_OFFERS);

	msg.add<uint32_t>(buyOffers.size());
	for (const MarketOffer& offer : buyOffers)
	{
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		addMarketItemId(msg, offer.itemId);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
	}

	msg.add<uint32_t>(sellOffers.size());
	for (const MarketOffer& offer : sellOffers)
	{
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		addMarketItemId(msg, offer.itemId);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketCancelOffer(const MarketOfferEx& offer)
{
	NetworkMessage msg;
	msg.add(ServerCode::MarketAction);
	addMarketRequest(msg, MarketRequestCode::OwnOffers, MARKETREQUEST_OWN_OFFERS);

	if (offer.type == MARKETACTION_BUY)
	{
		msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::True));
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		addMarketItemId(msg, offer.itemId);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
		msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::Zero));
	}
	else
	{
		msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::Zero));
		msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::True));
		msg.add<uint32_t>(offer.timestamp);
		msg.add<uint16_t>(offer.counter);
		addMarketItemId(msg, offer.itemId);
		msg.add<uint16_t>(offer.amount);
		addMarketPrice(msg, offer.price);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketBrowseOwnHistory(const HistoryMarketOfferList& buyOffers, const HistoryMarketOfferList& sellOffers)
{
	uint32_t i = 0;
	std::map<uint32_t, uint16_t> counterMap;
	uint32_t buyOffersToSend = std::min<uint32_t>(buyOffers.size(), 810 + std::max<int32_t>(0, 810 - sellOffers.size()));
	uint32_t sellOffersToSend = std::min<uint32_t>(sellOffers.size(), 810 + std::max<int32_t>(0, 810 - buyOffers.size()));

	NetworkMessage msg;
	msg.add(ServerCode::MarketAction);
	addMarketRequest(msg, MarketRequestCode::OwnHistory, MARKETREQUEST_OWN_HISTORY);

	msg.add<uint32_t>(buyOffersToSend);
	for (auto it = buyOffers.begin(); i < buyOffersToSend; ++it, ++i)
	{
		msg.add<uint32_t>(it->timestamp);
		msg.add<uint16_t>(counterMap[it->timestamp]++);
		addMarketItemId(msg, it->itemId);
		msg.add<uint16_t>(it->amount);
		addMarketPrice(msg, it->price);
		msg.addByte(it->state);
	}

	counterMap.clear();
	i = 0;

	msg.add<uint32_t>(sellOffersToSend);
	for (auto it = sellOffers.begin(); i < sellOffersToSend; ++it, ++i)
	{
		msg.add<uint32_t>(it->timestamp);
		msg.add<uint16_t>(counterMap[it->timestamp]++);
		addMarketItemId(msg, it->itemId);
		msg.add<uint16_t>(it->amount);
		addMarketPrice(msg, it->price);
		msg.addByte(it->state);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMarketDetail(uint16_t itemId)
{
	NetworkMessage msg;
	msg.add(ServerCode::MarketDetail);
	addMarketItemId(msg, itemId);

	const ItemType& it = Item::items[itemId];
	if (it.armor != 0)
	{
		msg.addString(std::to_string(it.armor));
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (it.attack != 0)
	{
		// TODO: chance to hit, range
		// example:
		// "attack +x, chance to hit +y%, z fields"
		if (it.abilities and it.abilities->elementType != COMBAT_NONE and it.abilities->elementDamage != 0) {
			msg.addString(fmt::format("{:d} physical +{:d} {:s}", it.attack, it.abilities->elementDamage, getCombatName(it.abilities->elementType)));
		}
		else
		{
			msg.addString(std::to_string(it.attack));
		}
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (it.isContainer())
	{
		msg.addString(std::to_string(it.maxItems));
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (it.defense != 0)
	{
		if (it.extraDefense != 0)
		{
			msg.addString(fmt::format("{:d} {:+d}", it.defense, it.extraDefense));
		}
		else
		{
			msg.addString(std::to_string(it.defense));
		}
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (not it.description.empty())
	{
		const std::string& descr = it.description;
		if (descr.back() == '.')
		{
			msg.addString(std::string(descr, 0, descr.length() - 1));
		}
		else
		{
			msg.addString(descr);
		}
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (it.decayTime != 0)
	{
		msg.addString(fmt::format("{:d} seconds", it.decayTime));
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (it.minReqLevel != 0)
	{
		msg.addString(std::to_string(it.minReqLevel));
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (it.minReqMagicLevel != 0)
	{
		msg.addString(std::to_string(it.minReqMagicLevel));
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	msg.addString(it.vocationString);

	msg.addString(it.runeSpellName);

	if (it.abilities)
	{
		std::ostringstream ss;
		bool separator = false;

		for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; i++)
		{
			if (not it.abilities->skills[i])
			{
				continue;
			}

			if (separator)
			{
				ss << ", ";
			} 
			else
			{
				separator = true;
			}

			ss << getSkillName(i) << ' ' << std::showpos << it.abilities->skills[i] << std::noshowpos;
		}

		if (it.abilities->stats[STAT_MAGICPOINTS] != 0)
		{
			if (separator)
			{
				ss << ", ";
			}
			else
			{
				separator = true;
			}

			ss << "magic level " << std::showpos << it.abilities->stats[STAT_MAGICPOINTS] << std::noshowpos;
		}

		if (it.abilities->speed != 0)
		{
			if (separator)
			{
				ss << ", ";
			}

			ss << "speed " << std::showpos << (it.abilities->speed >> 1) << std::noshowpos;
		}

		msg.addString(ss.str());
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (it.charges != 0)
	{
		msg.addString(std::to_string(it.charges));
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	std::string weaponName = getWeaponName(it.weaponType);

	if (it.slotPosition & SLOTP_TWO_HAND)
	{
		if (not weaponName.empty())
		{
			weaponName += ", two-handed";
		}
		else
		{
			weaponName = "two-handed";
		}
	}

	msg.addString(weaponName);

	if (it.weight != 0)
	{
		std::ostringstream ss;
		if (it.weight < 10)
		{
			ss << "0.0" << it.weight;
		} 
		else if (it.weight < 100)
		{
			ss << "0." << it.weight;
		}
		else
		{
			std::string weightString = std::to_string(it.weight);
			weightString.insert(weightString.end() - 2, '.');
			ss << weightString;
		}
		ss << " oz";
		msg.addString(ss.str());
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (usesModernLayout())
	{
		// 12.x-15.x read eleven more description slots after weight; only
		// the upgrade classification has a value on this server
		msg.add<SpecialCode>(SpecialCode::Zero); // augment
		msg.add<SpecialCode>(SpecialCode::Zero); // imbuing slots
		msg.add<SpecialCode>(SpecialCode::Zero); // magic shield capacity
		msg.add<SpecialCode>(SpecialCode::Zero); // cleave
		msg.add<SpecialCode>(SpecialCode::Zero); // damage reflection
		msg.add<SpecialCode>(SpecialCode::Zero); // perfect shot

		const auto* app = BlackTek::Assets::Appearances::getInstance().getObject(Item::items.getModernClientId(itemId));
		if (app and app->classification > 0)
		{
			msg.addString(std::to_string(app->classification));
		}
		else
		{
			msg.add<SpecialCode>(SpecialCode::Zero); // upgrade classification
		}

		msg.add<SpecialCode>(SpecialCode::Zero); // current tier
		msg.add<SpecialCode>(SpecialCode::Zero); // elemental bond
		msg.add<SpecialCode>(SpecialCode::Zero); // mantra
		msg.add<SpecialCode>(SpecialCode::Zero); // imbuement effect
	}

	addMarketStatistics(msg, IOMarket::getInstance().getPurchaseStatistics(itemId));
	addMarketStatistics(msg, IOMarket::getInstance().getSaleStatistics(itemId));

	writeToOutputBuffer(msg);
}

// one day of purchase or sale statistics; 12.81+ prices are u64
void ProtocolGame::addMarketStatistics(NetworkMessage& msg, const MarketStatistics* statistics) const
{
	if (not statistics)
	{
		msg.add(CommonCode::Zero);
		return;
	}

	msg.add(CommonCode::True);
	msg.add<uint32_t>(statistics->numTransactions);
	if (usesModernLayout())
	{
		msg.add<uint64_t>(statistics->totalPrice);
		msg.add<uint64_t>(statistics->highestPrice);
		msg.add<uint64_t>(statistics->lowestPrice);
		return;
	}

	msg.add<uint32_t>(std::min<uint64_t>(std::numeric_limits<uint32_t>::max(), statistics->totalPrice));
	msg.add<uint32_t>(statistics->highestPrice);
	msg.add<uint32_t>(statistics->lowestPrice);
}

void ProtocolGame::addMarketPrice(NetworkMessage& msg, uint32_t price) const
{
	if (usesModernLayout())
	{
		msg.add<uint64_t>(price); // 12.81+
		return;
	}
	msg.add<uint32_t>(price);
}

// legacy clients read the own-offers/history marker as a u16 sentinel,
// modern ones as a request byte
void ProtocolGame::addMarketRequest(NetworkMessage& msg, MarketRequestCode modernRequest, uint16_t legacyRequest) const
{
	if (usesModernLayout())
	{
		msg.add(modernRequest);
		return;
	}
	msg.add<uint16_t>(legacyRequest);
}

void ProtocolGame::sendUnjustifiedStats()
{
	NetworkMessage msg;
	msg.add(ServerCode::UnjustifiedStats);

	int64_t fragTime = g_config.GetNumber(ConfigManager::FRAG_TIME); // returned in seconds
	if (fragTime <= 0)
	{
		fragTime = 24 * 60 * 60; // Default 24 hours
	}

	int64_t skullTicks = player->getSkullTicks();
	uint8_t killsDay = 0;
	uint8_t killsWeek = 0;
	uint8_t killsMonth = 0;
	
	if (skullTicks > 0)
	{
		// Total kills = skullTicks / fragTime (rounded up)
		int64_t totalKills = (skullTicks + fragTime - 1) / fragTime;
		killsDay = static_cast<uint8_t>(std::min<int64_t>(totalKills, 255));
		killsWeek = static_cast<uint8_t>(std::min<int64_t>(totalKills, 255));
		killsMonth = static_cast<uint8_t>(std::min<int64_t>(totalKills, 255));
	}

	uint8_t killsToRed = static_cast<uint8_t>(g_config.GetNumber(ConfigManager::KILLS_TO_RED));
	uint8_t killsToBlack = static_cast<uint8_t>(g_config.GetNumber(ConfigManager::KILLS_TO_BLACK));
	
	// Calculate progress percentages (0-100)
	uint8_t dayProgress = killsDay > 0 ? static_cast<uint8_t>(std::min<int64_t>((killsDay * 100) / killsToRed, 100)) : 0;
	uint8_t weekProgress = killsWeek > 0 ? static_cast<uint8_t>(std::min<int64_t>((killsWeek * 100) / killsToRed, 100)) : 0;
	uint8_t monthProgress = killsMonth > 0 ? static_cast<uint8_t>(std::min<int64_t>((killsMonth * 100) / killsToBlack, 100)) : 0;

	// Calculate remaining kills until red skull
	uint8_t dayRemaining = killsDay < killsToRed ? (killsToRed - killsDay) : 0;
	uint8_t weekRemaining = killsWeek < killsToRed ? (killsToRed - killsWeek) : 0;
	uint8_t monthRemaining = killsMonth < killsToBlack ? (killsToBlack - killsMonth) : 0;

	// Calculate skull time in days
	uint8_t skullTimeDays = 0;
	if (skullTicks > 0)
	{
		skullTimeDays = static_cast<uint8_t>(std::min<int64_t>((skullTicks / (24 * 60 * 60)) + 1, 255));
	}

	msg.addByte(dayProgress);        // Day kills progress %
	msg.addByte(dayRemaining);       // Day kills remaining
	msg.addByte(weekProgress);       // Week kills progress %
	msg.addByte(weekRemaining);      // Week kills remaining
	msg.addByte(monthProgress);      // Month kills progress %
	msg.addByte(monthRemaining);     // Month kills remaining
	msg.addByte(skullTimeDays);      // Skull time in days

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPvpSituations()
{
	NetworkMessage msg;
	msg.add(ServerCode::PvpSituations);  // 0xB8
	
	// Open PvP situations - number of players you've attacked recently
	uint8_t openPvpSituations = static_cast<uint8_t>(std::min<size_t>(player->attackedSet ? player->attackedSet->size() : 0, 255));
	
	msg.addByte(openPvpSituations);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendQuestLog()
{
	NetworkMessage msg;
	msg.add(ServerCode::QuestLog);
	msg.add<uint16_t>(g_game.quests.getQuestsCount(player));

	for (const Quest& quest : g_game.quests.getQuests())
	{
		if (quest.isStarted(player))
		{
			msg.add<uint16_t>(quest.getID());
			msg.addString(quest.getName());
			msg.addByte(quest.isCompleted(player));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendQuestLine(const Quest* quest)
{
	NetworkMessage msg;
	msg.add(ServerCode::QuestLine);
	msg.add<uint16_t>(quest->getID());
	msg.addByte(quest->getMissionsCount(player));

	// missions have no id of their own; their position in the quest is
	// stable, and only the client's quest tracker refers back to it
	uint16_t missionId = 0;
	for (const Mission& mission : quest->getMissions())
	{
		++missionId;
		if (mission.isStarted(player))
		{
			if (usesModernLayout())
			{
				msg.add<uint16_t>(missionId);
			}
			msg.addString(mission.getName(player));
			msg.addString(mission.getDescription(player));
		}
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTradeItemRequest(const std::string& traderName, const ItemPtr& item, bool ack)
{
	if (not item) {
		std::cout << "Error: item is null!" << std::endl;
		return;
	}

	NetworkMessage msg;
	msg.add(ack ? ServerCode::TradeItemRequest : ServerCode::TradeAcknowledged);
	msg.addString(traderName);

	if (auto tradeContainer = item->getContainer())
	{

		std::vector<ContainerPtr> containerStack;
		std::vector<ItemPtr> itemList;

		itemList.push_back(item);

		if (not tradeContainer->getItemList().empty())
		{
			containerStack.push_back(tradeContainer);
		}

		while (not containerStack.empty())
		{
			auto container = containerStack.back();
			containerStack.pop_back();

			if (not container)
			{
				continue;
			}

			for (auto& containerItem : container->getItemList())
			{
				if (not containerItem)
				{
					continue;
				}

				if (auto tmpContainer = containerItem->getContainer())
				{
					containerStack.push_back(tmpContainer);
				}

				itemList.push_back(containerItem);
			}
		}

		msg.addByte(static_cast<uint8_t>(itemList.size()));

		for (const auto& listItem : itemList)
		{
			if (listItem)
			{
				addItem(msg, listItem);
			}
		}
	}
	else
	{
		msg.add(CommonCode::True);
		addItem(msg, item);
	}

	writeToOutputBuffer(msg);
}



void ProtocolGame::sendCloseTrade()
{
	NetworkMessage msg;
	msg.add(ServerCode::CloseTrade);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCloseContainer(uint8_t cid)
{
	NetworkMessage msg;
	msg.add(ServerCode::CloseContainer);
	msg.addByte(cid);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureTurn(const CreatureConstPtr& creature, uint32_t stackPos)
{
	if (not canSee(creature))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::UpdateTileThing);
	if (stackPos >= 10 or usesModernLayout())
	{
		msg.add<SpecialCode>(SpecialCode::End);
		msg.add<uint32_t>(creature->getID());
	}
	else
	{
		msg.addPosition(creature->getPosition());
		msg.addByte(stackPos);
	}

	msg.add<SpecialCode>(SpecialCode::CreatureTurn);
	msg.add<uint32_t>(creature->getID());
	msg.addByte(creature->getDirection());
	msg.add(player->canWalkthroughEx(creature) ? CommonCode::Zero : CommonCode::True);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureSay(const CreatureConstPtr& creature, SpeakClasses type, const std::string& text, const Position* pos/* = nullptr*/)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatureSay);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);

	msg.addString(creature->getName());

	if (usesModernLayout())
	{
		msg.add(CommonCode::Zero); // statement suffix, read when statement id != 0 (12.81+)
	}

	//Add level only for players
	if (const auto& speaker = creature->getPlayer())
	{
		msg.add<uint16_t>(speaker->getLevel());
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	msg.addByte(type);

	if (pos)
	{
		msg.addPosition(*pos);
	}
	else
	{
		msg.addPosition(creature->getPosition());
	}

	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendToChannel(const CreatureConstPtr& creature, SpeakClasses type, const std::string& text, uint16_t channelId)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatureSay);

	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (not creature)
	{
		// empty name + level 0; the u32 trick from the else-branch below
		// can't carry the modern suffix byte, so spell the fields out
		if (usesModernLayout())
		{
			msg.addString("");
			msg.add(CommonCode::Zero); // statement suffix (12.81+)
			msg.add<SpecialCode>(SpecialCode::Zero);
		}
		else
		{
			msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::Zero));
		}
	}
	else
	{
		msg.addString(creature->getName());
		if (usesModernLayout())
		{
			msg.add(CommonCode::Zero); // statement suffix (12.81+)
		}
		//Add level only for players
		if (const auto& speaker = creature->getPlayer())
		{
			msg.add<uint16_t>(speaker->getLevel());
		}
		else
		{
			msg.add<SpecialCode>(SpecialCode::Zero);
		}
	}

	msg.addByte(type);
	msg.add<uint16_t>(channelId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPrivateMessage(const PlayerConstPtr& speaker, SpeakClasses type, const std::string& text)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatureSay);
	static uint32_t statementId = 0;
	msg.add<uint32_t>(++statementId);
	if (speaker)
	{
		msg.addString(speaker->getName());
		if (usesModernLayout())
		{
			msg.add(CommonCode::Zero); // statement suffix (12.81+)
		}
		msg.add<uint16_t>(speaker->getLevel());
	}
	else if (usesModernLayout())
	{
		msg.addString("");
		msg.add(CommonCode::Zero); // statement suffix (12.81+)
		msg.add<SpecialCode>(SpecialCode::Zero);
	}
	else
	{
		msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::Zero));
	}
	msg.addByte(type);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelTarget()
{
	NetworkMessage msg;
	msg.add(ServerCode::CancelTarget);
	msg.add<uint32_t>(static_cast<uint32_t>(CommonCode::Zero)); // interesting, why do we need to send this? What other possibilities are there?
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendChangeSpeed(const CreatureConstPtr& creature, uint32_t speed)
{
	NetworkMessage msg;
	msg.add(ServerCode::CreatureSpeed);
	msg.add<uint32_t>(creature->getID());
	msg.add<uint16_t>(creature->getBaseSpeed() / 2);
	msg.add<uint16_t>(speed / 2);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCancelWalk()
{
	NetworkMessage msg;
	msg.add(ServerCode::CancelWalk);
	msg.addByte(player->getDirection());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSkills()
{
	NetworkMessage msg;
	AddPlayerSkills(msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPing()
{
	NetworkMessage msg;
	msg.add(ServerCode::Ping);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPingBack()
{
	NetworkMessage msg;
	msg.add(ServerCode::PingBack);
	writeToOutputBuffer(msg);
}

bool ProtocolGame::shared_modern_layout = false;

void ProtocolGame::AddDistanceShoot(NetworkMessage& msg, const Position& from, const Position& to, uint8_t type)
{
	AddDistanceShoot(msg, from, to, type, shared_modern_layout);
}

void ProtocolGame::AddDistanceShoot(NetworkMessage& msg, const Position& from, const Position& to, uint8_t type, bool modernLayout)
{
	if (modernLayout)
	{
		// 12.03+ distance effects ride the magic-effect loop: anchored at
		// `from`, with a signed offset to the target
		msg.add(ServerCode::MagicEffect);
		msg.addPosition(from);
		msg.add(EffectLoopCode::CreateDistanceEffect);
		msg.add<uint16_t>(type);
		msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(to.x - from.x)));
		msg.addByte(static_cast<uint8_t>(static_cast<int8_t>(to.y - from.y)));
		msg.add(CommonCode::Zero); // effect source (15.14+)
		msg.add(EffectLoopCode::EndLoop);
		return;
	}

	msg.add(ServerCode::DistanceShoot);
	msg.addPosition(from);
	msg.addPosition(to);
	msg.addByte(type);
}

void ProtocolGame::AddMagicEffect(NetworkMessage& msg, const Position& pos, uint16_t type)
{
	AddMagicEffect(msg, pos, type, shared_modern_layout);
}

void ProtocolGame::AddMagicEffect(NetworkMessage& msg, const Position& pos, uint16_t type, bool modernLayout)
{
	msg.add(ServerCode::MagicEffect);
	msg.addPosition(pos);
	if (modernLayout)
	{
		// 12.03+ effects are a typed loop; effect ids are appearance ids and
		// CipSoft keeps those append-only, so legacy CONST_ME values hold
		msg.add(EffectLoopCode::CreateEffect);
		msg.add<uint16_t>(type);
		msg.add(CommonCode::Zero); // effect source: own (15.14+)
		msg.add(EffectLoopCode::EndLoop);
	}
	else
	{
		// legacy clients read a single byte, so they never see an effect past 255
		msg.addByte(static_cast<uint8_t>(type));
	}
}

void ProtocolGame::AddCreatureHealth(NetworkMessage& msg, const CreatureConstPtr& creature)
{
	msg.add(ServerCode::CreatureHealth);
	msg.add<uint32_t>(creature->getID());

	if (creature->isHealthHidden())
	{
		msg.add(CommonCode::Zero);
	}
	else
	{
		msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
	}
}

void ProtocolGame::sendDistanceShoot(const Position& from, const Position& to, uint8_t type)
{
	NetworkMessage msg;
	AddDistanceShoot(msg, from, to, type, usesModernLayout());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendMagicEffect(const Position& pos, uint16_t type)
{
	if (not canSee(pos)) {
		return;
	}

	NetworkMessage msg;
	AddMagicEffect(msg, pos, type, usesModernLayout());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendCreatureHealth(const CreatureConstPtr& creature)
{
	NetworkMessage msg;
	AddCreatureHealth(msg, creature);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFYIBox(const std::string& message)
{
	NetworkMessage msg;
	msg.add(ServerCode::FyiBox);
	msg.addString(message);
	writeToOutputBuffer(msg);
}

//tile
void ProtocolGame::sendMapDescription(const Position& pos)
{
	NetworkMessage msg;
	msg.add(ServerCode::MapDescription);
	msg.addPosition(player->getPosition());
	GetMapDescription(pos.x - Map::maxClientViewportX, pos.y - Map::maxClientViewportY, pos.z, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, msg);
	writeToOutputBuffer(msg);
}

void ProtocolGame::refreshWorldView()
{
	if (!player) {
		return;
	}

	knownCreatureSet.Clear();
	sendMapDescription(player->getPosition());
}

void ProtocolGame::sendAddTileItem(const Position& pos, uint32_t stackpos, const ItemConstPtr& item)
{
	if (not canSee(pos))
	{
		return;
	}
	NetworkMessage msg;
	msg.add(ServerCode::AddTileThing);
	msg.addPosition(pos);
	msg.addByte(stackpos);
	addItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTileItem(const Position& pos, uint32_t stackpos, const ItemConstPtr& item)
{
	if (not canSee(pos))
	{
		return;
	}
	NetworkMessage msg;
	msg.add(ServerCode::UpdateTileThing);
	msg.addPosition(pos);
	msg.addByte(stackpos);
	addItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveTileThing(const Position& pos, uint32_t stackpos)
{
	if (not canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	RemoveTileThing(msg, pos, stackpos);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTileCreature(const Position& pos, uint32_t stackpos, const CreatureConstPtr& creature)
{
	if (not canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::UpdateTileThing);
	msg.addPosition(pos);
	msg.addByte(stackpos);

	bool known;
	uint32_t removedKnown;
	checkCreatureAsKnown(creature->getID(), known, removedKnown);
	AddCreature(msg, creature, false, removedKnown);

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveTileCreature(const CreatureConstPtr& creature, const Position& pos, uint32_t stackpos)
{
    NetworkMessage msg;

	// modern clients find a creature by its id, which still holds when the two
	// sides disagree about the items stacked beneath it
	if (usesModernLayout() and not canSee(pos))
		return;

	if (stackpos < 10 and not usesModernLayout()) // todo : change all of these 10 magic numbers into their own config constant, with possibly a hard max?
	{
		if (not canSee(pos))
		{
			return;
		}

		RemoveTileThing(msg, pos, stackpos);
		writeToOutputBuffer(msg);
		return;
	}

	msg.add(ServerCode::RemoveTileThing);
	msg.add<SpecialCode>(SpecialCode::End);
	msg.add<uint32_t>(creature->getID());
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateTile(const TileConstPtr& tile, const Position& pos)
{
	if (not canSee(pos))
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::UpdateTile);
	msg.addPosition(pos);

	if (tile)
	{
		GetTileDescription(tile, msg);
		msg.add(CommonCode::Zero);
		msg.add(CommonCode::End);
	}
	else
	{
		msg.add(CommonCode::True);
		msg.add(CommonCode::End);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendPendingStateEntered()
{
	NetworkMessage msg;
	msg.add(ServerCode::PendingStateEntered);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendEnterWorld()
{
	NetworkMessage msg;
	msg.add(ServerCode::EnterWorld);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendFightModes()
{
	NetworkMessage msg;
	msg.add(ServerCode::FightMode);
	msg.addByte(player->fightMode);
	msg.addByte(player->chaseMode);
	msg.addByte(player->secureMode);
	msg.addByte(PVP_MODE_DOVE);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddCreature(const CreatureConstPtr& creature, const Position& pos, int32_t stackpos, MagicEffectClasses magicEffect/*= CONST_ME_NONE*/)
{
	if (not canSee(pos))
	{
		return;
	}

	if (creature != player)
	{
		// stack pos is always real index now, so it can exceed the limit
		// if stack pos exceeds the limit, we need to refresh the tile instead
		// 1. this is a rare case, and is only triggered by forcing summon in a position
		// 2. since no stackpos will be send to the client about that creature, removing
		//    it must be done with its id if its stackpos remains >= 10. this is done to
		//    add creatures to battle list instead of rendering on screen
		if (stackpos >= 10)
		{
			// @todo: should we avoid this check?
			if (const auto& tile = creature->getTile())
			{
				sendUpdateTile(tile, pos);
			}
		}
		else
		{
			// if stackpos is -1, the client will automatically detect it
			NetworkMessage msg;
			msg.add(ServerCode::AddTileThing);
			msg.addPosition(pos);
			msg.addByte(stackpos);

			bool known;
			uint32_t removedKnown;
			checkCreatureAsKnown(creature->getID(), known, removedKnown);
			AddCreature(msg, creature, known, removedKnown);
			writeToOutputBuffer(msg);
		}

		if (magicEffect != CONST_ME_NONE)
		{
			sendMagicEffect(pos, magicEffect);
		}
		return;
	}

	// For sure a player at this point

	NetworkMessage msg;
	msg.add(ServerCode::LoginSuccess);

	msg.add<uint32_t>(player->getID());
	msg.add<uint16_t>(50); // beat duration.. why does client need this? I suspect we can manipulate this for our own benefits

	msg.addDouble(Creature::speedA, 3);
	msg.addDouble(Creature::speedB, 3);
	msg.addDouble(Creature::speedC, 3);

	const bool modernLogin = usesModernLayout();

	// can report bugs? 13.20+ clients dropped this byte from the login
	// block (GameDynamicBugReporter) - it moved to its own packet
	if (not modernLogin)
	{
		if (player->getAccountType() >= ACCOUNT_TYPE_TUTOR)
		{
			msg.add(CommonCode::True);
		}
		else
		{
			msg.add(CommonCode::False);
		}
	}

	msg.add(CommonCode::Zero); // can change pvp framing option
	msg.add(CommonCode::Zero); // expert mode button enabled

	msg.addString(g_config.GetString(ConfigManager::STORE_IMAGES_URL));
	msg.add<uint16_t>(static_cast<uint16_t>(g_config.GetNumber(ConfigManager::STORE_COIN_PACKAGE_SIZE)));

	if (modernLogin)
	{
		msg.add(CommonCode::Zero); // exiva button enabled (12.81+)
		// no tournament byte - GameTournamentPackets is off since 13.14
	}

	writeToOutputBuffer(msg);

	sendPendingStateEntered();
	sendEnterWorld();
	sendMapDescription(pos);

	if (magicEffect != CONST_ME_NONE)
	{
		sendMagicEffect(pos, magicEffect);
	}

	for (int i = CONST_SLOT_FIRST; i <= CONST_SLOT_LAST; ++i)
	{
		sendInventoryItem(static_cast<slots_t>(i), player->getInventoryItem(static_cast<slots_t>(i)));
	}

	sendInventoryItem(CONST_SLOT_STORE_INBOX, player->getStoreInbox()->getOwner());

	const bool open = g_config.GetBoolean(ConfigManager::AUTO_OPEN_CONTAINERS);
    if (open)
		player->autoOpenContainers();

	sendStats();
	sendSkills();
	sendUnjustifiedStats();
	sendPvpSituations();

	//gameworld light-settings
	sendWorldLight(g_game.getWorldLightInfo());

	//player light level
	sendCreatureLight(creature);

	sendVIPEntries();

	sendBasicData();
	player->sendIcons();

	if (hasFeature(ProtocolFeature::BlessingsDialog))
	{
		sendBlessStatus();
	}

	if (hasFeature(ProtocolFeature::PreySystem))
	{
		sendPreySlots();
	}

	if (hasFeature(ProtocolFeature::Forge))
	{
		sendForgeItemClasses();
		sendForgeBalances();
	}
}

void ProtocolGame::sendMoveCreature(const CreatureConstPtr& creature, const Position& newPos, int32_t newStackPos, const Position& oldPos, int32_t oldStackPos, bool teleport)
{
	if (creature == player)
	{
		if (teleport)
		{
			sendRemoveTileCreature(creature, oldPos, oldStackPos);
			sendMapDescription(newPos);
		}
		else
		{
			NetworkMessage msg;
			if (oldPos.z == 7 and newPos.z >= 8)
			{
				RemoveTileCreature(msg, creature, oldPos, oldStackPos);
			}
			else
			{
				msg.add(ServerCode::MoveCreature);
				if (oldStackPos < 10)
				{
					msg.addPosition(oldPos);
					msg.addByte(oldStackPos);
				}
				else
				{
					msg.add<SpecialCode>(SpecialCode::End);
					msg.add<uint32_t>(creature->getID());
				}
				msg.addPosition(newPos);
			}

			if (newPos.z > oldPos.z)
			{
				MoveDownCreature(msg, creature, newPos, oldPos);
			}
			else if (newPos.z < oldPos.z)
			{
				MoveUpCreature(msg, creature, newPos, oldPos);
			}

			if (oldPos.y > newPos.y)
			{ // north, for old x
				msg.add(ServerCode::MoveNorth);
				GetMapDescription(oldPos.x - Map::maxClientViewportX, newPos.y - Map::maxClientViewportY, newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
			}
			else if (oldPos.y < newPos.y)
			{ // south, for old x
				msg.add(ServerCode::MoveSouth);
				GetMapDescription(oldPos.x - Map::maxClientViewportX, newPos.y + (Map::maxClientViewportY + 1), newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
			}

			if (oldPos.x < newPos.x)
			{ // east, [with new y]
				msg.add(ServerCode::MoveEast);
				GetMapDescription(newPos.x + (Map::maxClientViewportX + 1), newPos.y - Map::maxClientViewportY, newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);
			}
			else if (oldPos.x > newPos.x)
			{ // west, [with new y]
				msg.add(ServerCode::MoveWest);
				GetMapDescription(newPos.x - Map::maxClientViewportX, newPos.y - Map::maxClientViewportY, newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);
			}
			writeToOutputBuffer(msg);
		}
	}
	else if (canSee(oldPos) and canSee(creature->getPosition()))
	{
		if (teleport or (oldPos.z == 7 and newPos.z >= 8))
		{
			sendRemoveTileCreature(creature, oldPos, oldStackPos);
			sendAddCreature(creature, newPos, newStackPos);
		}
		else
		{
			NetworkMessage msg;
			msg.add(ServerCode::MoveCreature);
			if (oldStackPos < 10 and not usesModernLayout())
			{
				msg.addPosition(oldPos);
				msg.addByte(oldStackPos);
			}
			else
			{
				msg.add<SpecialCode>(SpecialCode::End);
				msg.add<uint32_t>(creature->getID());
			}
			msg.addPosition(creature->getPosition());
			writeToOutputBuffer(msg);
		}
	}
	else if (canSee(oldPos))
	{
		sendRemoveTileCreature(creature, oldPos, oldStackPos);
	}
	else if (canSee(creature->getPosition()))
	{
		sendAddCreature(creature, newPos, newStackPos);
	}
}

void ProtocolGame::sendInventoryItem(slots_t slot, const ItemConstPtr& item)
{
	NetworkMessage msg;
	if (item)
	{
		msg.add(ServerCode::InventoryItem);
		msg.addByte(slot);
		addItem(msg, item);
	}
	else
	{
		msg.add(ServerCode::EmptyInventory);
		msg.addByte(slot);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendItems()
{
	const bool modern = usesModernLayout();
	// 15.00+ clients read the per-entry amount as a packed varint
	// (readPackedCount1500); 13.40/14.12 still read a plain u16
	const bool packedCount = modern and version >= 1500;

	// writes the action-bar inventory count the way the target client reads it
	const auto addInventoryCount = [&](NetworkMessage& out, uint32_t amount)
	{
		if (not packedCount)
		{
			out.add<uint16_t>(static_cast<uint16_t>(amount));
			return;
		}
		if (amount < 0x40)
		{
			out.addByte(static_cast<uint8_t>(amount));
		}
		else if (amount < 0x4000)
		{
			out.addByte(static_cast<uint8_t>(0x40 + (amount >> 8)));
			out.addByte(static_cast<uint8_t>(amount & 0xFF));
		}
		else
		{
			out.addByte(static_cast<uint8_t>(0x80 | (amount >> 24)));
			out.addByte(static_cast<uint8_t>((amount >> 16) & 0xFF));
			out.addByte(static_cast<uint8_t>((amount >> 8) & 0xFF));
			out.addByte(static_cast<uint8_t>(amount & 0xFF));
		}
	};

	NetworkMessage msg;
	msg.add(ServerCode::SendItems);

	const std::vector<uint16_t>& inventory = Item::items.getInventory();
	msg.add<uint16_t>(inventory.size() + 11);
	// todo figure out what the above magic number means and give it a constant
	// and investigate if this is the same loop twice or whats going on here...
	for (uint16_t i = 1; i <= 11; i++)
	{
		msg.add<uint16_t>(i);
		msg.add(CommonCode::Zero); //always 0
		addInventoryCount(msg, 1);
	}

	for (auto itemTypeID : inventory)
	{
		addItemId(msg, itemTypeID); // modern clients need client ids here
		msg.add(CommonCode::Zero); //always 0
		addInventoryCount(msg, 1);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAddContainerItem(uint8_t cid, uint16_t slot, const ItemConstPtr& item)
{
	NetworkMessage msg;
	msg.add(ServerCode::AddContainerItem);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	addItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdateContainerItem(uint8_t cid, uint16_t slot, const ItemConstPtr& item)
{
	NetworkMessage msg;
	msg.add(ServerCode::UpdateContainerItem);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	addItem(msg, item);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendRemoveContainerItem(uint8_t cid, uint16_t slot, const ItemConstPtr& lastItem)
{
	NetworkMessage msg;
	msg.add(ServerCode::RemoveContainerItem);
	msg.addByte(cid);
	msg.add<uint16_t>(slot);
	if (lastItem)
	{
		addItem(msg, lastItem);
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, const ItemPtr& item, uint16_t maxlen, bool canWrite)
{
	NetworkMessage msg;
	msg.add(ServerCode::TextWindow);
	msg.add<uint32_t>(windowTextId);
	addItem(msg, item);

	if (canWrite)
	{
		msg.add<uint16_t>(maxlen);
		msg.addString(item->getText());
	}
	else
	{
		const std::string& text = item->getText();
		msg.add<uint16_t>(text.size());
		msg.addString(text);
	}

	const std::string& writer = item->getWriter();
	if (not writer.empty())
	{
		msg.addString(writer);
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	if (usesModernLayout())
	{
		msg.add(CommonCode::Zero); // writer name suffix (12.81+)
	}

	time_t writtenDate = item->getDate();
	if (writtenDate != 0)
	{
		msg.addString(formatDateShort(writtenDate));
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendTextWindow(uint32_t windowTextId, uint32_t itemId, const std::string& text)
{
	NetworkMessage msg;
	msg.add(ServerCode::TextWindow);
	msg.add<uint32_t>(windowTextId);
	addItem(msg, itemId, 1);
	msg.add<uint16_t>(text.size());
	msg.addString(text);
	msg.add<SpecialCode>(SpecialCode::Zero); // writer
	if (usesModernLayout())
	{
		msg.add(CommonCode::Zero); // writer name suffix (12.81+)
	}
	msg.add<SpecialCode>(SpecialCode::Zero); // date
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendHouseWindow(uint32_t windowTextId, const std::string& text)
{
	NetworkMessage msg;
	msg.add(ServerCode::HouseWindow);
	msg.add(CommonCode::Zero);
	msg.add<uint32_t>(windowTextId);
	msg.addString(text);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendAccountManagerTextBox(uint32_t windowTextId, const std::string& text)
{
	NetworkMessage msg;
	msg.add(ServerCode::TextWindow);
	msg.add<uint32_t>(windowTextId);
	addItem(msg, ITEM_LETTER, 1);
	msg.add<uint16_t>(18); // max string length aka max chars
	msg.addString(text);
	msg.add<SpecialCode>(SpecialCode::Zero);
	msg.add<SpecialCode>(SpecialCode::Zero);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendOutfitWindow()
{
	const auto& outfits = Outfits::getInstance().getOutfits(player->getSex());
	if (outfits.size() == 0)
	{
		return;
	}

	NetworkMessage msg;
	msg.add(ServerCode::OutfitWindow);

	Outfit_t currentOutfit = player->getDefaultOutfit();
	if (currentOutfit.lookType == 0)
	{
		Outfit_t newOutfit;
		newOutfit.lookType = outfits.front().lookType;
		currentOutfit = newOutfit;
	}

	Mount* currentMount = g_game.mounts.getMountByID(player->getCurrentMount());
	if (currentMount)
	{
		currentOutfit.lookMount = currentMount->clientId;
	}

	AddOutfit(msg, currentOutfit);

	std::vector<ProtocolOutfit> protocolOutfits;
	if (player->isAccessPlayer())
	{
		protocolOutfits.emplace_back("Gamemaster", 75, 0);
	}

	// 12.81+ lists are u16 counted and every entry carries an availability
	// byte; the u8 lists below stay the legacy 10.98 limit
	const size_t outfitLimit = usesModernLayout() ? std::numeric_limits<uint16_t>::max() : std::numeric_limits<uint8_t>::max();
	for (const Outfit& outfit : outfits)
	{
		uint8_t addons;
		if (not player->getOutfitAddons(outfit, addons))
		{
			continue;
		}

		protocolOutfits.emplace_back(outfit.name, outfit.lookType, addons);
		if (protocolOutfits.size() == outfitLimit)
		{
			break;
		}
	}

	std::vector<const Mount*> mounts;
	for (const Mount& mount : g_game.mounts.getMounts())
	{
		if (player->hasMount(&mount))
		{
			mounts.push_back(&mount);
		}
	}

	if (usesModernLayout())
	{
		if (currentOutfit.lookMount == 0)
		{
			// mount colors are expected here even without a mount
			msg.add(CommonCode::Zero); // mount head
			msg.add(CommonCode::Zero); // mount body
			msg.add(CommonCode::Zero); // mount legs
			msg.add(CommonCode::Zero); // mount feet
		}
		msg.add<SpecialCode>(SpecialCode::Zero); // current familiar look type

		msg.add<uint16_t>(protocolOutfits.size());
		for (const ProtocolOutfit& outfit : protocolOutfits)
		{
			msg.add<uint16_t>(outfit.lookType);
			msg.addString(outfit.name);
			msg.addByte(outfit.addons);
			msg.add(CommonCode::Zero); // available (0x01 store offer, 0x02 golden outfit)
		}

		msg.add<uint16_t>(mounts.size());
		for (const Mount* mount : mounts)
		{
			msg.add<uint16_t>(mount->clientId);
			msg.addString(mount->name);
			msg.add(CommonCode::Zero); // available
		}

		msg.add<SpecialCode>(SpecialCode::Zero); // familiars; BlackTek has none
		msg.add(CommonCode::False); // try outfit mode
		msg.add(player->isMounted() ? CommonCode::True : CommonCode::False);
		msg.add(CommonCode::False); // random mount (12.81+)
		writeToOutputBuffer(msg);
		return;
	}

	msg.addByte(protocolOutfits.size());
	for (const ProtocolOutfit& outfit : protocolOutfits)
	{
		msg.add<uint16_t>(outfit.lookType);
		msg.addString(outfit.name);
		msg.addByte(outfit.addons);
	}

	msg.addByte(mounts.size());
	for (const Mount* mount : mounts)
	{
		msg.add<uint16_t>(mount->clientId);
		msg.addString(mount->name);
	}

	writeToOutputBuffer(msg);
}

void ProtocolGame::sendUpdatedVIPStatus(uint32_t guid, VipStatus_t newStatus)
{
	NetworkMessage msg;
	msg.add(ServerCode::VipStatus);
	msg.add<uint32_t>(guid);
	msg.addByte(newStatus);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIP(uint32_t guid, const std::string& name, const std::string& description, uint32_t icon, bool notify, VipStatus_t status)
{
	NetworkMessage msg;
	msg.add(ServerCode::VipEntry);
	msg.add<uint32_t>(guid);
	msg.addString(name);
	msg.addString(description);
	msg.add<uint32_t>(std::min<uint32_t>(10, icon));
	msg.add(notify ? CommonCode::True : CommonCode::False);
	msg.addByte(status);
	if (usesModernLayout())
	{
		msg.add(CommonCode::Zero); // vip group count (GameVipGroups, 12.00+)
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendVIPEntries()
{
	const std::forward_list<VIPEntry>& vipEntries = IOLoginData::getVIPEntries(player->getAccount());

	for (const VIPEntry& entry : vipEntries)
	{
		VipStatus_t vipStatus = VIPSTATUS_ONLINE;

		const auto& vipPlayer = g_game.getPlayerByGUID(entry.guid);

		if (not vipPlayer or not player->canSeeCreature(vipPlayer))
		{
			vipStatus = VIPSTATUS_OFFLINE;
		}

		sendVIP(entry.guid, entry.name, entry.description, entry.icon, entry.notify, vipStatus);
	}
}

void ProtocolGame::sendSpellCooldown(uint8_t spellId, uint32_t time)
{
	NetworkMessage msg;
	msg.add(ServerCode::SpellCooldown);
	if (usesModernLayout())
	{
		msg.add<uint16_t>(spellId); // 13.00+
	}
	else
	{
		msg.addByte(spellId);
	}
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendSpellGroupCooldown(SpellGroup_t groupId, uint32_t time)
{
	NetworkMessage msg;
	msg.add(ServerCode::SpellGroupCooldown);
	msg.addByte(groupId);
	msg.add<uint32_t>(time);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendModalWindow(const ModalWindow& modalWindow)
{
	NetworkMessage msg;
	msg.add(ServerCode::ModalWindow);

	msg.add<uint32_t>(modalWindow.id);
	msg.addString(modalWindow.title);
	msg.addString(modalWindow.message);

	msg.addByte(modalWindow.buttons.size());
	for (const auto& it : modalWindow.buttons)
	{
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.choices.size());
	for (const auto& it : modalWindow.choices)
	{
		msg.addString(it.first);
		msg.addByte(it.second);
	}

	msg.addByte(modalWindow.defaultEscapeButton);
	msg.addByte(modalWindow.defaultEnterButton);
	msg.add(modalWindow.priority ? CommonCode::True : CommonCode::False);

	writeToOutputBuffer(msg);
}

////////////// Add CommonCode messages
namespace
{
	// mapped id for a modern client, with a visible placeholder when the
	// server id has no surviving appearance - a wrong-looking item beats a
	// client-side parse exception on id 0
	// 12.x+ clients read a fluid by its own list, not the 10.98 colour index
	uint8_t ModernFluidId(uint8_t fluidType) noexcept
	{
		switch (fluidType)
		{
			case FLUID_WATER: return 1;
			case FLUID_MANA: return 2;
			case FLUID_BEER: return 3;
			case FLUID_OIL: return 4;
			case FLUID_BLOOD: return 5;
			case FLUID_SLIME: return 6;
			case FLUID_MUD: return 7;
			case FLUID_LEMONADE: return 8;
			case FLUID_MILK: return 9;
			case FLUID_WINE: return 10;
			case FLUID_LIFE: return 11;
			case FLUID_URINE: return 12;
			case FLUID_RUM: return 13;
			case FLUID_FRUITJUICE: return 14;
			case FLUID_COCONUTMILK: return 15;
			case FLUID_TEA: return 16;
			case FLUID_MEAD: return 17;
			case FLUID_INK: return 18;
			case FLUID_CANDY: return 19;
			case FLUID_CHOCOLATE: return 20;
			default: return 0;
		}
	}

	uint16_t ModernItemId(uint16_t serverId)
	{
		constexpr uint16_t FALLBACK_GOLD_COIN = 3031;
		const uint32_t mapped = Item::items.getModernClientId(serverId);
		if (mapped == 0 or mapped > std::numeric_limits<uint16_t>::max())
		{
			return FALLBACK_GOLD_COIN;
		}
		return static_cast<uint16_t>(mapped);
	}

	// extras the 15.25 client reads after the id, driven by what IT believes
	// about the appearance (mehah getItem with the 15.25 feature set). The
	// count/subtype byte is the caller's; everything else is neutral filler
	// until the underlying systems (tiers, charges, podiums) get ported.
	void AddModernItemExtras(NetworkMessage& msg, const BlackTek::Assets::AppearanceInfo* app,
	                         uint8_t countOrSubType, uint32_t durationSeconds, uint16_t charges, uint8_t tier)
	{
		if (not app)
		{
			return;
		}

		if (app->stackable or app->liquidContainer or app->liquidPool)
		{
			msg.addByte(countOrSubType);
		}

		if (app->container)
		{
			msg.add(CommonCode::Zero); // container type: plain
		}

		if (app->podium)
		{
			msg.add<uint16_t>(0); // looktype
			msg.add<uint16_t>(0); // looktype-ex (13.90+ reads it when looktype is 0)
			msg.add<uint16_t>(0); // mount looktype
			msg.addByte(DIRECTION_SOUTH); // direction
			msg.add(CommonCode::True); // visible
		}

		if (app->classification > 0)
		{
			msg.addByte(tier);
		}

		if (app->clockExpire or app->expire or app->expireStop)
		{
			msg.add<uint32_t>(durationSeconds);
			msg.add(CommonCode::Zero); // is brand-new
		}

		if (app->wearOut)
		{
			msg.add<uint32_t>(charges);
			msg.add(CommonCode::Zero); // is brand-new
		}

		if (app->wrapKit)
		{
			msg.add<uint16_t>(0); // wrapped item id
		}
	}
}

void ProtocolGame::addItem(NetworkMessage& msg, uint16_t id, uint8_t count) const
{
	if (not usesModernLayout())
	{
		msg.addItem(id, count);
		return;
	}

	const uint16_t clientId = ModernItemId(id);
	msg.add<uint16_t>(clientId);
	AddModernItemExtras(msg, BlackTek::Assets::Appearances::getInstance().getObject(clientId), count, 0, 0, 0);
}

void ProtocolGame::addItem(NetworkMessage& msg, const ItemConstPtr& item) const
{
	if (not usesModernLayout())
	{
		msg.addItem(item);
		return;
	}

	const uint16_t clientId = ModernItemId(item->getID());
	msg.add<uint16_t>(clientId);

	// the count/fluid decision keys off what the CLIENT believes about the
	// appearance, not ItemType - generated 15.25 items are stackable
	// client-side without any server stackable flag
	const auto* app = BlackTek::Assets::Appearances::getInstance().getObject(clientId);
	uint8_t countOrSubType;
	if (app and (app->liquidContainer or app->liquidPool))
	{
		countOrSubType = ModernFluidId(item->getFluidType());
	}
	else
	{
		countOrSubType = static_cast<uint8_t>(std::min<uint16_t>(0xFF, std::max<uint16_t>(1, item->getItemCount())));
	}

	AddModernItemExtras(msg, app, countOrSubType, item->getDuration() / 1000, item->getCharges(), item->getForgeTier());
}

void ProtocolGame::addItemId(NetworkMessage& msg, uint16_t itemId) const
{
	if (not usesModernLayout())
	{
		msg.addItemId(itemId);
		return;
	}
	msg.add<uint16_t>(ModernItemId(itemId));
}

// item ids the client sends back to us; modern clients speak in appearance
// ids, so those come back through the reverse table (0 when unmapped, which
// the game layer rejects the same way it rejects any id that does not match)
uint16_t ProtocolGame::getItemId(NetworkMessage& msg) const
{
	const uint16_t wireId = msg.get<uint16_t>();
	if (not usesModernLayout())
	{
		return wireId;
	}
	return Item::items.getItemIdByModernClientId(wireId);
}

// market entries: 12.81+ clients read a tier byte after any item whose
// appearance carries an upgrade classification; BlackTek has no tiers yet
void ProtocolGame::addMarketItemId(NetworkMessage& msg, uint16_t itemId) const
{
	addItemId(msg, itemId);
	if (not usesModernLayout())
	{
		return;
	}

	const auto* app = BlackTek::Assets::Appearances::getInstance().getObject(ModernItemId(itemId));
	if (app and app->classification > 0)
	{
		msg.add(CommonCode::Zero); // tier
	}
}

// the mirror of addMarketItemId for ids the client sends us; 0 when the
// appearance has no item on this server
uint16_t ProtocolGame::getMarketItemId(NetworkMessage& msg) const
{
	const uint16_t wireId = msg.get<uint16_t>();
	if (not usesModernLayout())
	{
		return wireId;
	}

	const auto* app = BlackTek::Assets::Appearances::getInstance().getObject(wireId);
	if (app and app->classification > 0)
	{
		msg.skipBytes(1); // tier
	}
	return Item::items.getItemIdByModernClientId(wireId);
}

void ProtocolGame::AddCreature(NetworkMessage& msg, const CreatureConstPtr& creature, bool known, uint32_t remove)
{
	if (protocol_profile and protocol_profile->generation == TransportGeneration::Modern)
	{
		// Layout ground truth: mehah getCreature at 1525. Deltas from 10.98:
		// summon-own master ids, a per-creature icon list, a vocation byte
		// for players, an inspection byte, no speech bubble and no helpers,
		// unscaled speed, and mount color bytes inside the outfit.
		CreatureType_t modernType = ModernCreatureType(creature->getType());
		if (modernType == CREATURETYPE_MONSTER)
		{
			if (const auto& master = creature->getMaster())
			{
				if (const auto& masterPlayer = master->getPlayer())
				{
					modernType = (masterPlayer == player) ? CREATURETYPE_SUMMON_OWN : CREATURETYPE_MONSTER;
				}
			}
		}

		const auto& modernOtherPlayer = creature->getPlayer();

		if (known)
		{
			msg.add<SpecialCode>(SpecialCode::AddKnownCreature);
			msg.add<uint32_t>(creature->getID());
		}
		else
		{
			msg.add<SpecialCode>(SpecialCode::AddCreature);
			msg.add<uint32_t>(remove);
			msg.add<uint32_t>(creature->getID());
			msg.addByte(modernType);
			if (modernType == CREATURETYPE_SUMMON_OWN)
			{
				msg.add<uint32_t>(creature->getMaster()->getID());
			}
			msg.addString(creature->getName());
		}

		if (creature->isHealthHidden())
		{
			msg.add(CommonCode::Zero);
		}
		else
		{
			msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
		}

		msg.addByte(creature->getDirection());

		if (not creature->isInGhostMode() and not creature->isInvisible())
		{
			AddOutfit(msg, creature->getCurrentOutfit());
		}
		else
		{
			static Outfit_t invisibleOutfit;
			AddOutfit(msg, invisibleOutfit);
		}

		LightInfo modernLight = creature->getCreatureLight();
		msg.addByte(player->isAccessPlayer() ? 255 : modernLight.level);
		msg.addByte(modernLight.color);

		// same half-scale as legacy: the speed-formula constants sent in the
		// login block are calibrated for it, and sendChangeSpeed halves too
		msg.add<uint16_t>(creature->getStepSpeed() / 2);

		msg.add(CommonCode::Zero); // creature icon list: count

		msg.addByte(player->getSkullClient(creature));
		msg.addByte(player->getPartyShield(modernOtherPlayer));

		if (not known)
		{
			msg.addByte(player->getGuildEmblem(modernOtherPlayer));
		}

		msg.addByte(modernType);
		if (modernType == CREATURETYPE_SUMMON_OWN)
		{
			msg.add<uint32_t>(creature->getMaster()->getID());
		}
		else if (modernType == CREATURETYPE_PLAYER and modernOtherPlayer)
		{
			msg.addByte(modernOtherPlayer->getVocation()->getClientId());
		}

		msg.add(CommonCode::Zero); // creature icon (GameCreatureIcons, 12.x)

		msg.add(CommonCode::End); // mark: 0xFF = unmarked
		msg.add(CommonCode::Zero); // inspection type

		msg.add(player->canWalkthroughEx(creature) ? CommonCode::False : CommonCode::True);
		return;
	}

	CreatureType_t creatureType = creature->getType();

	const auto& otherPlayer = creature->getPlayer();

	if (known)
	{
		msg.add<SpecialCode>(SpecialCode::AddKnownCreature);
		msg.add<uint32_t>(creature->getID());
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::AddCreature);
		msg.add<uint32_t>(remove);
		msg.add<uint32_t>(creature->getID());
		msg.addByte(creatureType);
		msg.addString(creature->getName());
	}

	if (creature->isHealthHidden())
	{
		msg.add(CommonCode::Zero);
	}
	else
	{
		// I'm a bit confused how we are sending current healh as a uint8_t. I need to come back and investigate this
		// I suspect this must just account for a "percent", hence the use of the double below, but it could just be for precision.
		msg.addByte(std::ceil((static_cast<double>(creature->getHealth()) / std::max<int32_t>(creature->getMaxHealth(), 1)) * 100));
	}

	msg.addByte(creature->getDirection());

	if (not creature->isInGhostMode() and not creature->isInvisible())
	{
		AddOutfit(msg, creature->getCurrentOutfit());
	}
	else
	{
		static Outfit_t outfit;
		AddOutfit(msg, outfit);
	}

	LightInfo lightInfo = creature->getCreatureLight();
	auto maxLight = static_cast<uint8_t>(255);
	msg.addByte(player->isAccessPlayer() ? maxLight : lightInfo.level);
	msg.addByte(lightInfo.color);

	msg.add<uint16_t>(creature->getStepSpeed() / 2);

	msg.addByte(player->getSkullClient(creature));
	msg.addByte(player->getPartyShield(otherPlayer));

	if (not known)
	{
		msg.addByte(player->getGuildEmblem(otherPlayer));
	}

	if (creatureType == CREATURETYPE_MONSTER)
	{
		if (const auto& master = creature->getMaster())
		{
			if (const auto& masterPlayer = master->getPlayer())
			{
				if (masterPlayer == player)
				{
					creatureType = CREATURETYPE_SUMMON_OWN;
				}
				else
				{
					creatureType = CREATURETYPE_SUMMON_HOSTILE;
				}
			}
		}
	}

	msg.addByte(creatureType); // Type (for summons)
	msg.addByte(creature->getSpeechBubble());
	msg.add(CommonCode::End); // MARK_UNMARKED

	if (otherPlayer)
	{
		msg.add<uint16_t>(otherPlayer->getHelpers());
	}
	else
	{
		msg.add<SpecialCode>(SpecialCode::Zero);
	}

	msg.add(player->canWalkthroughEx(creature) ? CommonCode::False : CommonCode::True);
}

void ProtocolGame::AddPlayerStats(NetworkMessage& msg) const
{
	const bool modern = usesModernLayout();

	msg.add(ServerCode::PlayerStats);

	if (modern)
	{
		// Layout ground truth: mehah parsePlayerStats at >= 1281 with the
		// 15.25 feature set (features.lua), cross-checked against canary.
		msg.add<uint32_t>(std::max<int32_t>(player->getHealth(), 0));
		msg.add<uint32_t>(std::max<int32_t>(player->getMaxHealth(), 0));

		msg.add<uint32_t>(player->getFreeCapacity());
		// no total capacity for >= 1281

		msg.add<uint64_t>(player->getExperience());

		msg.add<uint16_t>(player->getLevel());
		if (protocol_profile->hasFeature(ProtocolFeature::PlayerLevelPercentU16))
		{
			msg.add<uint16_t>(std::min<uint16_t>(static_cast<uint16_t>(player->getLevelPercent()) * 100, 10000));
		}
		else
		{
			msg.addByte(player->getLevelPercent());
		}

		msg.add<uint16_t>(100); // base xp gain rate
		// no xp voucher field for >= 1281
		msg.add<uint16_t>(0);   // low level bonus
		msg.add<uint16_t>(0);   // store xp boost
		msg.add<uint16_t>(100); // stamina multiplier (100 = x1.0)

		msg.add<uint32_t>(std::max<int32_t>(player->getMana(), 0));
		msg.add<uint32_t>(std::max<int32_t>(player->getMaxMana(), 0));
		// no magic level here for >= 1281 - it moved into 0xA1

		msg.addByte(player->getSoul());
		msg.add<uint16_t>(player->getStaminaMinutes());
		msg.add<uint16_t>(player->getBaseSpeed() / 2); // same half-scale as legacy

		Condition* regenCondition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
		msg.add<uint16_t>(regenCondition ? regenCondition->getTicks() / 1000 : 0);

		msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);

		msg.add<SpecialCode>(SpecialCode::Zero); // xp boost time (seconds)
		msg.add(CommonCode::Zero); // enables exp boost in the store

		msg.add<uint32_t>(0); // remaining mana shield
		msg.add<uint32_t>(0); // total mana shield
		return;
	}

	msg.add<uint16_t>(std::min<int32_t>(player->getHealth(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<int32_t>(player->getMaxHealth(), std::numeric_limits<uint16_t>::max()));

	msg.add<uint32_t>(player->getFreeCapacity());
	msg.add<uint32_t>(player->getCapacity());

	msg.add<uint64_t>(player->getExperience());

	msg.add<uint16_t>(player->getLevel());
	msg.addByte(player->getLevelPercent());

	// todo : convert these to ServerSpecial Codes
	msg.add<uint16_t>(100); // base xp gain rate
	msg.add<uint16_t>(0); // xp voucher
	msg.add<uint16_t>(0); // low level bonus
	msg.add<uint16_t>(0); // xp boost
	msg.add<uint16_t>(100); // stamina multiplier (100 = x1.0)

	msg.add<uint16_t>(std::min<int32_t>(player->getMana(), std::numeric_limits<uint16_t>::max()));
	msg.add<uint16_t>(std::min<int32_t>(player->getMaxMana(), std::numeric_limits<uint16_t>::max()));

	msg.addByte(std::min<uint32_t>(player->getMagicLevel(), std::numeric_limits<uint8_t>::max()));
	msg.addByte(std::min<uint32_t>(player->getBaseMagicLevel(), std::numeric_limits<uint8_t>::max()));
	msg.addByte(player->getMagicLevelPercent());

	msg.addByte(player->getSoul());

	msg.add<uint16_t>(player->getStaminaMinutes());

	msg.add<uint16_t>(player->getBaseSpeed() / 2);

	Condition* condition = player->getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT);
	msg.add<uint16_t>(condition ? condition->getTicks() / 1000 : 0);

	msg.add<uint16_t>(player->getOfflineTrainingTime() / 60 / 1000);

	msg.add<SpecialCode>(SpecialCode::Zero); // xp boost time (seconds)
	msg.add(CommonCode::Zero); // enables exp boost in the store
}

void ProtocolGame::AddPlayerSkills(NetworkMessage& msg) const
{
	const bool modern = usesModernLayout();

	msg.add(ServerCode::PlayerSkills);

	if (modern)
	{
		// Layout ground truth: mehah parsePlayerSkills at >= 1281 with the
		// 15.25 feature set. Magic level moved here from 0xA0, every skill
		// is a quad of u16s, and 14.10+ replaced the additional/forge skill
		// lists with the big character-skill-stats tail block.
		msg.add<uint16_t>(std::min<uint32_t>(player->getMagicLevel(), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(std::min<uint32_t>(player->getBaseMagicLevel(), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(std::min<uint32_t>(player->getBaseMagicLevel(), std::numeric_limits<uint16_t>::max())); // base + loyalty
		msg.add<uint16_t>(static_cast<uint16_t>(player->getMagicLevelPercent()) * 100);

		for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; ++i)
		{
			msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
			msg.add<uint16_t>(player->getBaseSkill(i));
			msg.add<uint16_t>(player->getBaseSkill(i)); // base + loyalty
			msg.add<uint16_t>(static_cast<uint16_t>(player->getSkillPercent(i)) * 100);
		}

		// 13.40 would need the pre-14.10 additional-skills and forge lists
		// here instead of the block below; that band stays unported until a
		// 13.40 client is testable.
		if (protocol_profile->hasFeature(ProtocolFeature::ConcoctionsByte))
		{
			msg.add(CommonCode::Zero); // active concoctions count
		}

		if (protocol_profile->hasFeature(ProtocolFeature::CharacterSkillStats))
		{
			msg.add<uint32_t>(player->getCapacity()); // base + bonus capacity
			msg.add<uint32_t>(player->getCapacity()); // base capacity

			msg.add<uint16_t>(0); // flat damage/healing bonus

			msg.add<uint16_t>(0); // weapon attack value
			msg.add(CommonCode::Zero); // weapon attack element

			msg.addDouble(0.0, 2); // converted damage
			msg.add(CommonCode::Zero); // converted element

			msg.addDouble(0.0, 2); // life leech
			msg.addDouble(0.0, 2); // mana leech
			msg.addDouble(0.0, 2); // crit chance
			msg.addDouble(0.0, 2); // crit damage
			msg.addDouble(0.0, 2); // onslaught

			msg.add<uint16_t>(std::max<int32_t>(player->getDefense(), 0));
			msg.add<uint16_t>(static_cast<uint16_t>(player->getArmor()));
			if (protocol_profile->hasFeature(ProtocolFeature::MonkMantra))
			{
				msg.add<uint16_t>(0); // mantra
			}
			msg.addDouble(0.0, 2); // mitigation
			msg.addDouble(0.0, 2); // dodge
			msg.add<uint16_t>(0);  // damage reflection

			msg.add(CommonCode::Zero); // combat absorb entry count

			msg.addDouble(0.0, 2); // forge momentum
			msg.addDouble(0.0, 2); // forge transcendence
			msg.addDouble(0.0, 2); // forge amplification
		}
		return;
	}

	for (uint8_t i = SKILL_FIRST; i <= SKILL_LAST; ++i)
	{
		msg.add<uint16_t>(std::min<int32_t>(player->getSkillLevel(i), std::numeric_limits<uint16_t>::max()));
		msg.add<uint16_t>(player->getBaseSkill(i));
		msg.addByte(player->getSkillPercent(i));
	}

	using AT = BlackTek::DamageModifier::AttackType;
	const auto& during = player->getMainAttackModSums();
	const auto& post   = player->getMainAttackModPostSums();

	const auto critIdx = std::to_underlying(AT::Critical);
	const auto lifeIdx = std::to_underlying(AT::Lifesteal);
	const auto manaIdx = std::to_underlying(AT::Manasteal);

	const std::array<uint32_t, SPECIALSKILL_LAST + 1> cache_bonus = {
		during[critIdx].percent,  // SPECIALSKILL_CRITICALHITCHANCE
		during[critIdx].flat,     // SPECIALSKILL_CRITICALHITAMOUNT
		post[lifeIdx].percent,    // SPECIALSKILL_LIFELEECHCHANCE
		post[lifeIdx].flat,       // SPECIALSKILL_LIFELEECHAMOUNT
		post[manaIdx].percent,    // SPECIALSKILL_MANALEECHCHANCE
		post[manaIdx].flat,       // SPECIALSKILL_MANALEECHAMOUNT
	};

	for (uint8_t i = SPECIALSKILL_FIRST; i <= SPECIALSKILL_LAST; ++i)
	{
		const uint32_t total = static_cast<uint32_t>(std::max<int32_t>(0, player->varSpecialSkills[i])) + cache_bonus[i];
		msg.add<uint16_t>(static_cast<uint16_t>(std::min<uint32_t>(total, 100u)));
		msg.add<SpecialCode>(SpecialCode::Zero);
	}
}

// the look without its mount: a few 12.x+ windows read only this part
void ProtocolGame::addOutfitLook(NetworkMessage& msg, const Outfit_t& outfit) const
{
	msg.add<uint16_t>(outfit.lookType);

	if (outfit.lookType != 0)
	{
		msg.addByte(outfit.lookHead);
		msg.addByte(outfit.lookBody);
		msg.addByte(outfit.lookLegs);
		msg.addByte(outfit.lookFeet);
		msg.addByte(outfit.lookAddons);
	}
	else
	{
		addItemId(msg, outfit.lookTypeEx);
	}
}

void ProtocolGame::AddOutfit(NetworkMessage& msg, const Outfit_t& outfit)
{
	addOutfitLook(msg, outfit);

	msg.add<uint16_t>(outfit.lookMount);
	if (usesModernLayout() and outfit.lookMount != 0)
	{
		// 12.81+ mounts are colorable; BlackTek has no mount colors yet
		msg.add(CommonCode::Zero); // mount head
		msg.add(CommonCode::Zero); // mount body
		msg.add(CommonCode::Zero); // mount legs
		msg.add(CommonCode::Zero); // mount feet
	}
}

void ProtocolGame::AddWorldLight(NetworkMessage& msg, LightInfo lightInfo) const
{
	msg.add(ServerCode::WorldLight);
	auto maxLight = static_cast<uint8_t>(255);
	msg.addByte((player->isAccessPlayer() ? maxLight : lightInfo.level));
	msg.addByte(lightInfo.color);
}

void ProtocolGame::AddCreatureLight(NetworkMessage& msg, const CreatureConstPtr& creature) const
{
	LightInfo lightInfo = creature->getCreatureLight();

	msg.add(ServerCode::CreatureLight);
	msg.add<uint32_t>(creature->getID());
	auto maxLight = static_cast<uint8_t>(255);
	msg.addByte((player->isAccessPlayer() ? maxLight : lightInfo.level));
	msg.addByte(lightInfo.color);
}

//tile
void ProtocolGame::RemoveTileThing(NetworkMessage& msg, const Position& pos, uint32_t stackpos)
{
	if (stackpos >= 10)
	{
		return;
	}

	msg.add(ServerCode::RemoveTileThing);
	msg.addPosition(pos);
	msg.addByte(stackpos);
}

void ProtocolGame::RemoveTileCreature(NetworkMessage& msg, const CreatureConstPtr& creature, const Position& pos, uint32_t stackpos)
{
	if (stackpos < 10)
	{
		RemoveTileThing(msg, pos, stackpos);
	}
	
	msg.add(ServerCode::RemoveTileThing);
	msg.add<SpecialCode>(SpecialCode::End);
	msg.add<uint32_t>(creature->getID());
}

// Todo : The following two methods use far too many magic numbers, eliminate the magic numbers
// and possibly extract the math into it's own function/method with more clarity
void ProtocolGame::MoveUpCreature(NetworkMessage& msg, const CreatureConstPtr& creature, const Position& newPos, const Position& oldPos)
{
	if (creature != player)
	{
		return;
	}

	// floor change up
	msg.add(ServerCode::FloorChangeUp);

	// going to surface
	if (newPos.z == 7)
	{
		int32_t skip = -1;

		// floor 7 and 6 already set
		for (int i = 5; i >= 0; --i)
		{
			GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, i, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, 8 - i, skip);
		}
		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.add(CommonCode::End);
		}
	}
	// underground, going one floor up (still underground)
	else if (newPos.z > 7)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, oldPos.getZ() - 3, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, 3, skip);

		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.add(CommonCode::End);
		}
	}

	// moving up a floor up makes us out of sync
	// west
	msg.add(ServerCode::MoveWest);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y - (Map::maxClientViewportY - 1), newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);

	// north
	msg.add(ServerCode::MoveNorth);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
}

void ProtocolGame::MoveDownCreature(NetworkMessage& msg, const CreatureConstPtr& creature, const Position& newPos, const Position& oldPos)
{
	if (creature != player)
	{
		return;
	}

	// floor change down
	msg.add(ServerCode::FloorChangeDown);

	// going from surface to underground
	if (newPos.z == 8)
	{
		int32_t skip = -1;

		for (int i = 0; i < 3; ++i)
		{
			GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z + i, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, -i - 1, skip);
		}
		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.add(CommonCode::Zero);
		}
	}
	// going further down
	else if (newPos.z > oldPos.z and newPos.z > 8 and newPos.z < 14)
	{
		int32_t skip = -1;
		GetFloorDescription(msg, oldPos.x - Map::maxClientViewportX, oldPos.y - Map::maxClientViewportY, newPos.z + 2, (Map::maxClientViewportX * 2) + 2, (Map::maxClientViewportY * 2) + 2, -3, skip);

		if (skip >= 0)
		{
			msg.addByte(skip);
			msg.add(CommonCode::Zero);
		}
	}

	// moving down a floor makes us out of sync
	// east
	msg.add(ServerCode::MoveEast);
	GetMapDescription(oldPos.x + (Map::maxClientViewportX + 1), oldPos.y - (Map::maxClientViewportY + 1), newPos.z, 1, (Map::maxClientViewportY * 2) + 2, msg);

	// south
	msg.add(ServerCode::MoveSouth);
	GetMapDescription(oldPos.x - Map::maxClientViewportX, oldPos.y + (Map::maxClientViewportY + 1), newPos.z, (Map::maxClientViewportX * 2) + 2, 1, msg);
}

void ProtocolGame::AddShopItem(NetworkMessage& msg, const ShopInfo& item)
{
	const ItemType& it = Item::items[item.itemId];
	addItemId(msg, it.getID());

	if (it.isSplash() or it.isFluidContainer())
	{
		msg.addByte(serverFluidToClient(item.subType));
	}
	else
	{
		msg.add(CommonCode::Zero);
	}

	msg.addString(item.realName);
	msg.add<uint32_t>(it.weight);
	msg.add<uint32_t>(item.buyPrice);
	msg.add<uint32_t>(item.sellPrice);
}

void ProtocolGame::parseExtendedOpcode(NetworkMessage& msg)
{
	uint8_t opcode = msg.getByte();
	auto buffer = msg.getString();

	// process additional opcodes via lua script event
	addGameTask([=, playerID = player->getID(), buffer = std::string{ buffer }]() { g_game.parsePlayerExtendedOpcode(playerID, opcode, buffer); });
}

// the shelves: every category with its icon and parent
void ProtocolGame::sendStoreCategories(const BlackTek::StoreWindow& window)
{
	const auto& categories = window.getCategories();
	NetworkMessage msg;
	msg.add(ServerCode::StoreCategories);
	msg.add<uint16_t>(static_cast<uint16_t>(categories.size()));
	for (const auto& category : categories)
	{
		msg.addString(category->name);
		msg.addByte(std::to_underlying(category->state));
		msg.addByte(static_cast<uint8_t>(std::min<size_t>(category->icons.size(), 255)));
		for (const auto& icon : category->icons | std::views::take(255))
		{
			msg.addString(icon);
		}
		if (category->parent_name.empty())
		{
			msg.add<uint16_t>(0);
		}
		else
		{
			msg.addString(category->parent_name);
		}
	}
	writeToOutputBuffer(msg);
}

// the coin balance: the client waits for the "updating" flag to drop
void ProtocolGame::sendStoreBalances()
{
	NetworkMessage msg;
	msg.add(ServerCode::CoinBalanceUpdating);
	msg.addByte(0x00);
	writeToOutputBuffer(msg);

	NetworkMessage balance;
	balance.add(ServerCode::CoinBalanceUpdating);
	balance.addByte(0x01);
	balance.add(ServerCode::CoinBalance);
	balance.addByte(0x01);
	balance.add<uint32_t>(player->getCoins() + player->getTransferableCoins());
	balance.add<uint32_t>(player->getTransferableCoins());
	balance.add<uint32_t>(0); // reserved for a character auction
	writeToOutputBuffer(balance);
}

// one offer as the 12.x+ client lists it: a single sub-offer, then how it
// is drawn (the client renders items, outfits and mounts itself)
void ProtocolGame::addStoreOffer(NetworkMessage& msg, const BlackTek::StoreProduct& product, const std::vector<std::string>& reasons, const std::string& reason)
{
	using Kind = BlackTek::StoreProduct::Kind;
	msg.addString(product.name);
	msg.addByte(1);
	msg.add<uint32_t>(product.id);
	msg.add<uint16_t>(product.count);
	msg.add<uint32_t>(product.price);
	msg.addByte(std::to_underlying(product.coins));
	const bool disabled = not reason.empty();
	msg.addByte(disabled ? 1 : 0);
	if (disabled)
	{
		const auto it = std::ranges::find(reasons, reason);
		msg.addByte(0x01);
		msg.add<uint16_t>(static_cast<uint16_t>(it != reasons.end() ? std::distance(reasons.begin(), it) : 0));
	}
	msg.addByte(std::to_underlying(product.state));

	msg.addByte(std::to_underlying(product.kind));
	uint8_t tryOn = 0;
	switch (product.kind)
	{
		case Kind::Other:
			msg.addString(product.icons.empty() ? std::string{} : product.icons.front());
			break;
		case Kind::Mount:
		{
			const auto* mount = g_game.mounts.getMountByID(product.mount_id);
			msg.add<uint16_t>(mount ? mount->clientId : 0);
			tryOn = 1;
			break;
		}
		case Kind::Outfit:
		{
			msg.add<uint16_t>(player->getSex() == PLAYERSEX_FEMALE ? product.looktype_female : product.looktype_male);
			const auto& outfit = player->getCurrentOutfit();
			msg.addByte(outfit.lookHead);
			msg.addByte(outfit.lookBody);
			msg.addByte(outfit.lookLegs);
			msg.addByte(outfit.lookFeet);
			tryOn = 1;
			break;
		}
		case Kind::Item:
			msg.add<uint16_t>(static_cast<uint16_t>(Item::items.getModernClientId(product.item_id)));
			break;
	}
	msg.addByte(tryOn);
	msg.add<uint16_t>(0); // collection
	msg.add<uint16_t>(0); // popularity
	msg.add<uint32_t>(0); // new until
	msg.addByte(0); // needs configuring
	msg.add<uint16_t>(0); // products capacity
}

void ProtocolGame::sendStoreOffers(const std::string& name, const std::vector<const BlackTek::StoreProduct*>& products, uint32_t redirectId, bool search)
{
	const auto& store = BlackTek::Store::System::getInstance();
	const auto* window = store.getWindow(player);
	if (not window)
	{
		return;
	}

	// the client asks for the descriptions separately, but seeds them from these
	for (const auto* product : products)
	{
		sendStoreOfferDescription(product->id, product->description);
	}

	std::vector<std::string> reasons;
	std::vector<std::string> reasonOf;
	for (const auto* product : products)
	{
		const auto* category = window->getCategoryByProduct(product->id);
		std::string reason = category ? store.disabledReason(player, *category, *product) : std::string{};
		if (not reason.empty() and std::ranges::find(reasons, reason) == reasons.end())
		{
			reasons.push_back(reason);
		}
		reasonOf.push_back(std::move(reason));
	}

	NetworkMessage msg;
	msg.add(ServerCode::StoreOffers);
	msg.addString(name);
	msg.add<uint32_t>(redirectId);
	msg.addByte(0); // window type
	msg.addByte(0); // collections
	msg.add<uint16_t>(0); // collection name
	msg.add<uint16_t>(static_cast<uint16_t>(reasons.size()));
	for (const auto& reason : reasons)
	{
		msg.addString(reason);
	}
	msg.add<uint16_t>(static_cast<uint16_t>(products.size()));
	for (size_t index = 0; index < products.size(); ++index)
	{
		addStoreOffer(msg, *products[index], reasons, reasonOf[index]);
	}
	if (search)
	{
		msg.addByte(0); // not too many results
	}
	writeToOutputBuffer(msg);
}

// the front page: the offers flagged for it, then the banners
void ProtocolGame::sendStoreHome(const std::vector<const BlackTek::StoreProduct*>& products)
{
	const auto& store = BlackTek::Store::System::getInstance();
	const auto* window = store.getWindow(player);
	if (not window)
	{
		return;
	}

	std::vector<std::string> reasons;
	std::vector<std::string> reasonOf;
	for (const auto* product : products)
	{
		const auto* category = window->getCategoryByProduct(product->id);
		std::string reason = category ? store.disabledReason(player, *category, *product) : std::string{};
		if (not reason.empty() and std::ranges::find(reasons, reason) == reasons.end())
		{
			reasons.push_back(reason);
		}
		reasonOf.push_back(std::move(reason));
	}

	const auto& config = store.getConfig();
	NetworkMessage msg;
	msg.add(ServerCode::StoreOffers);
	msg.addString("Home");
	msg.add<uint32_t>(0);
	msg.addByte(0);
	msg.addByte(0);
	msg.add<uint16_t>(0);
	msg.add<uint16_t>(static_cast<uint16_t>(reasons.size()));
	for (const auto& reason : reasons)
	{
		msg.addString(reason);
	}
	msg.add<uint16_t>(static_cast<uint16_t>(products.size()));
	for (size_t index = 0; index < products.size(); ++index)
	{
		addStoreOffer(msg, *products[index], reasons, reasonOf[index]);
	}
	msg.addByte(static_cast<uint8_t>(config.banners.size()));
	for (const auto& banner : config.banners)
	{
		msg.addString(banner);
		msg.addByte(0x04); // opens a category
		msg.add<uint32_t>(0);
		msg.addByte(0);
		msg.addByte(0);
	}
	msg.addByte(config.banner_delay);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreHistory(uint32_t page, uint32_t pages, const std::vector<BlackTek::Store::HistoryEntry>& entries)
{
	NetworkMessage msg;
	msg.add(ServerCode::StoreHistory);
	msg.add<uint32_t>(page);
	msg.add<uint32_t>(pages);
	msg.addByte(static_cast<uint8_t>(std::min<size_t>(entries.size(), 255)));
	for (const auto& entry : entries | std::views::take(255))
	{
		msg.add<uint32_t>(0); // entry id
		msg.add<uint32_t>(static_cast<uint32_t>(entry.created_at));
		msg.addByte(std::to_underlying(entry.mode));
		msg.add<int32_t>(entry.amount);
		msg.addByte(std::to_underlying(entry.coins));
		msg.addString(entry.description);
		msg.addByte(0); // details
	}
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStorePurchaseResult(const std::string& message)
{
	NetworkMessage msg;
	// 12.x+ reads the balance from the balance packets that follow, not from here
	msg.add(ServerCode::StorePurchaseResult);
	msg.addByte(0x00);
	msg.addString(message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreError(BlackTek::Store::System::Error error, const std::string& message)
{
	NetworkMessage msg;
	msg.add(ServerCode::StoreError);
	msg.addByte(std::to_underlying(error));
	msg.addString(message);
	writeToOutputBuffer(msg);
}

void ProtocolGame::sendStoreOfferDescription(uint32_t offerId, const std::string& description)
{
	NetworkMessage msg;
	msg.add(ServerCode::StoreOfferDescription);
	msg.add<uint32_t>(offerId);
	msg.addString(description);
	writeToOutputBuffer(msg);
}

