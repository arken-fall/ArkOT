// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "presence.h"
#include "console.h"
#include "database.h"
#include "databasetasks.h"
#include "game.h"
#include "scheduler.h"
#include "tools.h"

#include <algorithm>
#include <fmt/format.h>
#include <iterator>
#include <optional>
#include <ranges>
#include <utility>
#include <vector>

extern Game g_game;

namespace BlackTek::World
{
	namespace
	{
		// INSERT IGNORE, holder lookup, then one act on Classify: a takeover that
		// loses to another world, or a holder that releases in between, costs an
		// attempt. Three bounds the dispatcher's time on one login.
		constexpr int ClaimAttempts = 3;

		constexpr int32_t BeatIntervalMs = static_cast<int32_t>(std::chrono::milliseconds(Presence::BeatInterval).count());

		// IsHeld() means token != 0, so zero must never be handed out. Two 32-bit
		// draws fill the word; the loop only repeats on an all-zero pair.
		[[nodiscard]] uint64_t NewToken() noexcept
		{
			auto& generator = getRandomGenerator();

			uint64_t token = 0;
			while (token == 0)
			{
				const auto high = static_cast<uint32_t>(generator());
				const auto low = static_cast<uint32_t>(generator());
				token = (static_cast<uint64_t>(high) << 32) | low;
			}

			return token;
		}

		// Every query names the auth schema directly: the presence tables have no
		// per-world views. Start() refuses a name containing '`', so wrapping it in
		// backticks here cannot break out of the identifier.
		[[nodiscard]] std::string ReleaseQuery(std::string_view authSchema, uint32_t accountId, uint64_t token)
		{
			return fmt::format("DELETE FROM `{:s}`.`account_presence` WHERE `account_id` = {:d} AND `claim_token` = {:d}", authSchema, accountId, token);
		}

		[[nodiscard]] std::string BeatQuery(std::string_view authSchema, Id self)
		{
			return fmt::format("INSERT INTO `{:s}`.`world_presence` (`world_id`, `beat_at`) VALUES ({:d}, UNIX_TIMESTAMP()) ON DUPLICATE KEY UPDATE `beat_at` = UNIX_TIMESTAMP()", authSchema, self);
		}

		// How long ago this world's last heartbeat landed, on the database's clock.
		// beat_at is a signed bigint and UNIX_TIMESTAMP() is cast to signed as well, so
		// the subtraction stays signed even if the clock stepped back below beat_at;
		// world_id is unsigned and takes part in no arithmetic.
		[[nodiscard]] std::string BeatAgeQuery(std::string_view authSchema, Id self)
		{
			return fmt::format("SELECT CAST(UNIX_TIMESTAMP() AS SIGNED) - `beat_at` AS `age` FROM `{:s}`.`world_presence` WHERE `world_id` = {:d}", authSchema, self);
		}
	}

	// ---------------------------------------------------------------------------
	// PresenceClaim
	// ---------------------------------------------------------------------------

	PresenceClaim::PresenceClaim(std::string releaseQuery, uint64_t claimToken) noexcept
		: release_query(std::move(releaseQuery))
		, token(claimToken)
	{
	}

	PresenceClaim::~PresenceClaim()
	{
		// g_config is already gone when a Player in g_game dies at static
		// destruction, so only the prebuilt query is touched. g_databaseTasks
		// outlives g_game (otserv.cpp:47, 52) and drops tasks once stopped.
		QueueRelease();
	}

	PresenceClaim::PresenceClaim(PresenceClaim&& other) noexcept
		: release_query(std::move(other.release_query))
		, token(std::exchange(other.token, 0))
	{
		other.release_query.clear();
	}

	PresenceClaim& PresenceClaim::operator=(PresenceClaim&& other) noexcept
	{
		if (this != &other)
		{
			QueueRelease();

			release_query = std::move(other.release_query);
			other.release_query.clear();
			token = std::exchange(other.token, 0);
		}

		return *this;
	}

	void PresenceClaim::QueueRelease() noexcept
	{
		if (not IsHeld())
			return;

		token = 0;
		g_databaseTasks.addTask(std::exchange(release_query, std::string{}));
	}

	void PresenceClaim::Discard() noexcept
	{
		token = 0;
		release_query.clear();
	}

	void PresenceClaim::Release() noexcept
	{
		if (not IsHeld())
			return;

		// Shutdown deletes every claim of this world with one statement
		// (Presence::Retire), so the per-player DELETE here is pure cost. Discard
		// rather than return: a claim left held would be queued by ~PresenceClaim
		// and run by saveGameState's g_databaseTasks.flush(), which is the same
		// round trip on a different thread.
		if (Presence::GetInstance().IsRetiring())
		{
			Discard();
			return;
		}

		// executeQuery already waits out a lost connection, so a failure here is a
		// real error. Handing the same query to the background connection is the
		// only other chance: a claim leaked on a live world never goes stale.
		if (Database::getInstance().executeQuery(release_query))
		{
			token = 0;
			release_query.clear();
			return;
		}

		Console::Database::Error("World::PresenceClaim::Release: the release of claim {:d} failed; retrying it in the background.", token);
		QueueRelease();
	}

	// ---------------------------------------------------------------------------
	// Presence
	// ---------------------------------------------------------------------------

	std::expected<void, std::string> Presence::Start(std::string_view authSchema)
	{
		if (authSchema.empty())
			return {};

		if (not auth_schema.empty() or retired)
			return std::unexpected(std::string{ "World::Presence::Start: presence was already started." });

		// identifiers cannot go through escapeString, so an unquotable name is refused outright
		if (authSchema.find('`') != std::string_view::npos)
			return std::unexpected(fmt::format("World::Presence::Start: the auth schema name '{:s}' contains a backtick.", authSchema));

		// Local() on an unloaded registry is a blank entry with id 0, which would
		// clear world 0's rows; refuse rather than guess.
		if (Registry::GetInstance().All().empty())
			return std::unexpected(std::string{ "World::Presence::Start: the world registry is not loaded." });

		const Id self = Local().id;
		Database& db = Database::getInstance();

		// A successful listener bind proves no other process is this world on this
		// host (plan section 2, fact 3), so every claim naming this world is leftover.
		if (not db.executeQuery(fmt::format("DELETE FROM `{:s}`.`account_presence` WHERE `world_id` = {:d}", authSchema, self)))
			return std::unexpected(fmt::format("World::Presence::Start: could not clear world {:d}'s leftover claims in `{:s}`.`account_presence`.", self, authSchema));

		if (not db.executeQuery(BeatQuery(authSchema, self)))
			return std::unexpected(fmt::format("World::Presence::Start: could not write world {:d}'s heartbeat to `{:s}`.`world_presence`.", self, authSchema));

		auth_schema = authSchema;

		const auto now = std::chrono::steady_clock::now();
		last_beat = now;
		next_beat = now;

		g_scheduler.addEvent(createSchedulerTask(NextResyncDelay(next_beat, BeatIntervalMs), [this]() { Beat(); }));

		Console::Database::Info("World::Presence::Start: world {:d} is sharing logins through `{:s}`.", self, auth_schema);
		return {};
	}

	void Presence::Retire() noexcept
	{
		// a Retire() with no prior BeginRetire() still ends the claim-by-claim path
		retiring = true;

		if (auth_schema.empty() or retired)
		{
			retired = true;
			return;
		}

		const Id self = Local().id;
		Database& db = Database::getInstance();

		if (not db.executeQuery(fmt::format("DELETE FROM `{:s}`.`account_presence` WHERE `world_id` = {:d}", auth_schema, self)))
			Console::Database::Error("World::Presence::Retire: could not free world {:d}'s claims; they expire {:d} s after the last heartbeat.", self, Lease.count());

		if (not db.executeQuery(fmt::format("DELETE FROM `{:s}`.`world_presence` WHERE `world_id` = {:d}", auth_schema, self)))
			Console::Database::Error("World::Presence::Retire: could not remove world {:d}'s heartbeat row.", self);

		retired = true;
	}

	Presence::ClaimResult Presence::Claim(uint32_t accountId, uint32_t playerId, std::string_view characterName)
	{
		// fails closed: a caller that skipped IsEnabled() must not be let through
		if (not IsEnabled()) [[unlikely]]
		{
			Console::Database::Error("World::Presence::Claim: presence is not enabled; refusing account {:d}.", accountId);
			return std::unexpected(Refused{ .reason = Refusal::Unavailable });
		}

		Database& db = Database::getInstance();
		const Id self = Local().id;
		const uint64_t token = NewToken();
		const std::string escapedName = db.escapeString(characterName);

		// One token for every attempt: if executeQuery resends a write that had
		// already landed, the lookup finds this token and Classify answers Ours.
		const std::string insertQuery = fmt::format(
			"INSERT IGNORE INTO `{:s}`.`account_presence` (`account_id`, `world_id`, `player_id`, `character_name`, `claim_token`, `claimed_at`) VALUES ({:d}, {:d}, {:d}, {:s}, {:d}, UNIX_TIMESTAMP())",
			auth_schema, accountId, self, playerId, escapedName, token);

		// staleness is judged on the database's clock, shared by every world (fact 1)
		const std::string lookupQuery = fmt::format(
			"SELECT `p`.`world_id`, `p`.`claim_token`, `p`.`character_name`, (COALESCE(`w`.`beat_at`, 0) < UNIX_TIMESTAMP() - {:d}) AS `expired` FROM `{:s}`.`account_presence` `p` LEFT JOIN `{:s}`.`world_presence` `w` ON `w`.`world_id` = `p`.`world_id` WHERE `p`.`account_id` = {:d}",
			Lease.count(), auth_schema, auth_schema, accountId);

		const auto granted = [&]()
		{
			return PresenceClaim{ ReleaseQuery(auth_schema, accountId, token), token };
		};

		const auto unavailable = []()
		{
			return std::unexpected(Refused{ .reason = Refusal::Unavailable });
		};

		for (int attempt = 0; attempt < ClaimAttempts; ++attempt)
		{
			// the connection counts rows changed, and a fresh insert always changes one
			if (not db.executeQuery(insertQuery))
			{
				Console::Database::Error("World::Presence::Claim: the claim insert for account {:d} failed; refusing the login.", accountId);
				return unavailable();
			}

			if (db.getAffectedRows() == 1)
				return granted();

			// nullptr is both "no row" (the holder released in between) and a failed
			// query; either way the next attempt re-reads, and running out refuses
			if (const auto holder = db.storeQuery(lookupQuery))
			{
				const auto holderWorld = holder->getNumber<Id>("world_id");
				const auto holderToken = holder->getNumber<uint64_t>("claim_token");
				const bool holderExpired = holder->getNumber<int32_t>("expired") != 0;

				switch (Classify(holderToken, holderWorld, holderExpired, token, self))
				{
					case Holder::Ours:
						return granted();

					case Holder::Live:
						return std::unexpected(Refused{
							.character_name	= std::string{ holder->getString("character_name") },
							.reason			= Refusal::AlreadyOnline,
							.world			= holderWorld });

					case Holder::Abandoned:
					{
						// Classify put Ours first, so holderToken != token: a matching row
						// really changes claim_token, and rows-changed reports 1 exactly
						// when this world won the takeover.
						//
						// The lookup's verdict is stale by the time this runs (executeQuery
						// may resend it for as long as the connection is lost), so the WHERE
						// re-applies Classify's Abandoned rule at execution: the row is this
						// world's, or its world has no heartbeat row or one older than Lease.
						// NOT EXISTS over a fresh heartbeat is the lookup's
						// COALESCE(beat_at, 0) < UNIX_TIMESTAMP() - Lease negated row by row:
						// world_id is world_presence's primary key and beat_at is NOT NULL,
						// so a missing row needs no case of its own. A token names one claim
						// for its whole life (a takeover replaces both), so the row's world_id
						// is still the holder world the lookup read. If the holder world
						// recovered first, nothing matches and the next attempt reads it Live.
						const std::string takeoverQuery = fmt::format(
							"UPDATE `{:s}`.`account_presence` `p` SET `world_id` = {:d}, `player_id` = {:d}, `character_name` = {:s}, `claim_token` = {:d}, `claimed_at` = UNIX_TIMESTAMP() WHERE `p`.`account_id` = {:d} AND `p`.`claim_token` = {:d} AND (`p`.`world_id` = {:d} OR NOT EXISTS (SELECT 1 FROM `{:s}`.`world_presence` `w` WHERE `w`.`world_id` = `p`.`world_id` AND `w`.`beat_at` >= UNIX_TIMESTAMP() - {:d}))",
							auth_schema, self, playerId, escapedName, token, accountId, holderToken, self, auth_schema, Lease.count());

						if (not db.executeQuery(takeoverQuery))
						{
							Console::Database::Error("World::Presence::Claim: the takeover of account {:d}'s abandoned claim failed; refusing the login.", accountId);
							return unavailable();
						}

						if (db.getAffectedRows() == 1)
							return granted();

						// another world took it first, or the holder world beat again since
						// the lookup: the next attempt sees the new holder, or reads it Live
						break;
					}
				}
			}
		}

		Console::Database::Warn("World::Presence::Claim: account {:d} could not be claimed in {:d} attempts; refusing the login.", accountId, ClaimAttempts);
		return unavailable();
	}

	Presence::Holder Presence::Classify(uint64_t holderToken, Id holderWorld, bool holderExpired, uint64_t ourToken, Id ourWorld) noexcept
	{
		if (holderToken == ourToken)
			return Holder::Ours;

		// fact 2: the local one-session check ran in this same task, so a row naming
		// this world for an account not online here is provably leftover
		if (holderWorld == ourWorld)
			return Holder::Abandoned;

		if (holderExpired)
			return Holder::Abandoned;

		return Holder::Live;
	}

	void Presence::Beat()
	{
		// Retire() is terminal; a retired world stops re-arming instead of ticking idly
		if (retired)
			return;

		// re-arm first, like Game::checkLight, so a failed beat never stops the heartbeat
		g_scheduler.addEvent(createSchedulerTask(NextResyncDelay(next_beat, BeatIntervalMs), [this]() { Beat(); }));

		const Id self = Local().id;
		Database& db = Database::getInstance();

		// The age is read before the upsert, so it measures the heartbeat other
		// worlds have been judging, and readAt is taken before the read so the
		// span to the upsert's reply over-covers the database time in between.
		// storeQuery answers nullptr both for a failed query and for no row; either
		// way no live heartbeat is proven, and IsStall counts nullopt as a stall.
		const auto readAt = std::chrono::steady_clock::now();

		std::optional<std::chrono::seconds> databaseAge;
		if (const auto ageResult = db.storeQuery(BeatAgeQuery(auth_schema, self)))
			databaseAge = std::chrono::seconds{ ageResult->getNumber<int64_t>("age") };

		else
			Console::Database::Warn("World::Presence::Beat: could not read world {:d}'s heartbeat age, or its heartbeat row is missing; treating this beat as a stall.", self);

		// The upsert reports 0 rows changed when beat_at already holds this second,
		// so only the query's success is read, never its affected rows.
		const bool landed = db.executeQuery(BeatQuery(auth_schema, self));
		if (not landed)
			Console::Database::Warn("World::Presence::Beat: world {:d}'s heartbeat failed; its claims expire {:d} s after the last one that landed.", self, Lease.count());

		const auto now = std::chrono::steady_clock::now();
		const auto sinceLastBeat = last_beat == std::chrono::steady_clock::time_point{} ? std::chrono::steady_clock::duration::zero() : now - last_beat;
		const bool stalled = IsStall(databaseAge, now - readAt, sinceLastBeat);

		// A failed beat goes through the plan too, so it provably keeps a pending
		// follow-up and carries its stall. Reconcile runs only after this beat's
		// upsert returned, so its read sees every takeover that committed before the
		// fresh heartbeat, and the takeover guard refuses every one after it.
		const ReconcilePlan plan = PlanReconcile(landed, stalled, follow_up_reconcile, stall_pending);

		bool readFailed = false;
		if (plan.reconcile)
		{
			if (not stalled and not stall_pending)
				Console::Database::Warn("World::Presence::Beat: world {:d} is checking its claims again after a stall, for takeovers that were already under way when it recovered.", self);

			readFailed = not Reconcile();
		}

		follow_up_reconcile = FollowUpAfter(plan, readFailed);
		stall_pending = plan.stall_pending;

		if (landed)
			last_beat = now;
	}

	bool Presence::Reconcile()
	{
		const Id self = Local().id;

		// storeQuery answers nullptr both for "no rows" and for a failed query, and an
		// empty token list read from a failed query would kick every claimed player.
		// The constant first row makes a successful read never empty: nullptr now
		// only ever means failure. Zero is never a token (NewToken), and it is found
		// below as proof the rows came from this query.
		const std::string tokensQuery = fmt::format(
			"SELECT CAST(0 AS UNSIGNED) AS `claim_token` UNION ALL SELECT `claim_token` FROM `{:s}`.`account_presence` WHERE `world_id` = {:d}",
			auth_schema, self);

		const auto result = Database::getInstance().storeQuery(tokensQuery);
		if (not result)
		{
			Console::Database::Error("World::Presence::Reconcile: could not read world {:d}'s claims after a stall; kicking nobody, the next landed beat reads them again.", self);
			return false;
		}

		std::vector<uint64_t> tokens;
		do
		{
			tokens.push_back(result->getNumber<uint64_t>("claim_token"));
		}
		while (result->next());

		std::ranges::sort(tokens);

		if (not std::ranges::binary_search(tokens, uint64_t{ 0 }))
		{
			Console::Database::Error("World::Presence::Reconcile: world {:d}'s claim read is missing its marker row; kicking nobody, the next landed beat reads them again.", self);
			return false;
		}

		// Token 0 holds no claim (a Gamemaster-or-above account, a clone, the Account
		// Manager, presence off), so it is excluded before the lookup, never matched
		// against the marker. Tokens are compared for equality only.
		const auto lostClaim = [&tokens](const PlayerPtr& player)
		{
			const uint64_t token = player->getPresenceToken();
			return token != 0 and not std::ranges::binary_search(tokens, token);
		};

		// Kicking erases from the player map, so the victims are copied out first,
		// as Game's shutdown kick loop does. Each kicked player's own release is
		// guarded on its old token, which the row another world now holds no longer
		// carries, so it deletes nothing.
		std::vector<PlayerPtr> victims;
		std::ranges::copy(g_game.getPlayers() | std::views::values | std::views::filter(lostClaim), std::back_inserter(victims));

		for (const auto& player : victims)
		{
			player->sendTextMessage(MESSAGE_STATUS_WARNING, "Your account logged in on another world while this world was unreachable.");
			player->kickPlayer(true);
		}

		// every stall is logged, so a zero count still shows the reconcile ran
		Console::Database::Warn("World::Presence::Reconcile: world {:d} stalled past its lease; kicked {:d} player(s) whose claims were taken over.", self, victims.size());
		return true;
	}
}
