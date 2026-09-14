// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "prey.h"
#include "bestiary.h"
#include "console.h"
#include "game.h"
#include "monsters.h"
#include "player.h"
#include "tools.h"

#include <ranges>
#include <toml++/toml.hpp>

extern Game g_game;

namespace BlackTek::Prey
{
	namespace
	{
		// how many creatures of each star band a list holds, by level band
		struct ListShape
		{
			uint8_t one = 0;
			uint8_t two = 0;
			uint8_t three = 0;
			uint8_t four = 0;
		};

		ListShape ShapeForLevel(uint32_t level) noexcept
		{
			if (level < 100)
			{
				return { 3, 3, 2, 1 };
			}

			if (level < 300)
			{
				return { 1, 3, 3, 2 };
			}

			if (level < 500)
			{
				return { 1, 2, 3, 3 };
			}
			return { 1, 1, 3, 4 };
		}

		bool IsPreyable(const MonsterType& monsterType) noexcept
		{
			return monsterType.info.bestiary.race_id != 0 and monsterType.info.experience != 0 and not monsterType.info.isBoss;
		}
	}

	bool System::loadConfig()
	{
		try
		{
			auto table = toml::parse_file("config/prey.toml");
			config.enabled = table["enabled"].value_or(config.enabled);
			config.free_third_slot = table["free_third_slot"].value_or(config.free_third_slot);
			config.reroll_price_per_level = table["reroll_price_per_level"].value_or(config.reroll_price_per_level);
			config.selection_list_price = table["selection_list_price"].value_or(config.selection_list_price);
			config.bonus_reroll_price = table["bonus_reroll_price"].value_or(config.bonus_reroll_price);
			config.bonus_time = table["bonus_time"].value_or(config.bonus_time);
			config.free_reroll_time = table["free_reroll_time"].value_or(config.free_reroll_time);
		}
		catch (const toml::parse_error& err)
		{
			Console::Error("Prey::System::loadConfig: failed to parse config/prey.toml: {:s}", err.description());
			return false;
		}
		return true;
	}

	void System::initializeSlots(const PlayerPtr& player) const
	{
		for (uint8_t slotId = 0; slotId < SlotCount; ++slotId)
		{
			Slot& slot = player->getPreySlot(slotId);
			slot.id = slotId;
			// two slots come with the character, the third with the store (or the config)
			if (slot.state == Slot::State::Locked and (slotId < 2 or config.free_third_slot))
			{
				slot.state = Slot::State::Selection;
				rollMonsterList(slot, player);
			}
		}
	}

	uint32_t System::getRerollPrice(const PlayerPtr& player) const noexcept
	{
		return player ? player->getLevel() * config.reroll_price_per_level : 0;
	}

	// nine creatures from the bestiary, spread over the star bands the
	// character's level calls for, and never one another slot already shows
	void System::rollMonsterList(Slot& slot, const PlayerPtr& player) const
	{
		slot.race_list.clear();
		if (not config.enabled or not player)
		{
			return;
		}

		const auto& bestiary = Bestiary::Registry::getInstance();
		std::vector<const MonsterType*> pool;
		for (auto race = static_cast<uint8_t>(Bestiary::Registry::Race::First); race <= static_cast<uint8_t>(Bestiary::Registry::Race::Last); ++race)
		{
			for (const MonsterType* monsterType : bestiary.getRaceMembers(static_cast<Bestiary::Registry::Race>(race)))
			{
				if (IsPreyable(*monsterType))
				{
					pool.push_back(monsterType);
				}
			}
		}

		if (pool.size() < ListSize)
		{
			Console::Warn("Prey::System::rollMonsterList: only {:d} creatures carry a bestiary entry; a prey list needs {:d}", pool.size(), ListSize);
			return;
		}

		std::vector<uint16_t> taken = player->getPreyRaceIds();
		ListShape shape = ShapeForLevel(player->getLevel());
		uint16_t tries = 0;
		while (slot.race_list.size() < ListSize and tries < 500)
		{
			++tries;
			const MonsterType* candidate = pool[uniform_random(0, static_cast<int32_t>(pool.size()) - 1)];
			const uint16_t raceId = candidate->info.bestiary.race_id;
			if (std::ranges::find(taken, raceId) == taken.end())
			{
				const uint8_t stars = candidate->info.bestiary.stars;
				uint8_t* band = nullptr;
				if (stars <= 1)
				{
					band = &shape.one;
				}
				else if (stars == 2)
				{
					band = &shape.two;
				}
				else if (stars == 3)
				{
					band = &shape.three;
				}
				else
				{
					band = &shape.four;
				}

				// after enough misses the band quota stops mattering
				if (*band > 0 or tries >= 60)
				{
					if (*band > 0)
					{
						--(*band);
					}
					taken.push_back(raceId);
					slot.race_list.push_back(raceId);
				}
			}
		}
	}

	void System::rollBonusType(Slot& slot) const
	{
		// a top-rarity slot never rolls the same bonus twice in a row
		Slot::Bonus rolled = slot.bonus;
		while (rolled == slot.bonus)
		{
			rolled = static_cast<Slot::Bonus>(uniform_random(static_cast<int32_t>(Slot::Bonus::First), static_cast<int32_t>(Slot::Bonus::Last)));
			if (slot.rarity < MaxRarity)
			{
				break;
			}
		}
		slot.bonus = rolled;
	}

	// every roll raises the rarity; the percentage follows the bonus type
	void System::rollBonusValue(Slot& slot) const
	{
		if (slot.rarity >= MaxRarity - 1)
		{
			slot.rarity = MaxRarity;
		}
		else
		{
			slot.rarity = static_cast<uint8_t>(uniform_random(slot.rarity + 1, MaxRarity));
		}

		switch (slot.bonus)
		{
			case Slot::Bonus::DamageBoost: slot.percentage = 2 * slot.rarity + 5; break;
			case Slot::Bonus::DamageReduction: slot.percentage = 2 * slot.rarity + 10; break;
			default: slot.percentage = 3 * slot.rarity + 10; break;
		}
	}

	void System::select(const PlayerPtr& player, Slot& slot, uint16_t raceId) const
	{
		slot.selected_race = raceId;
		slot.state = Slot::State::Active;
		if (slot.bonus == Slot::Bonus::None)
		{
			rollBonusType(slot);
			rollBonusValue(slot);
		}
		slot.time_left = static_cast<uint16_t>(std::min<uint32_t>(config.bonus_time, std::numeric_limits<uint16_t>::max()));
		slot.race_list.clear();
		applyAugments(player);
	}

	void System::expire(const PlayerPtr& player, Slot& slot) const
	{
		slot.selected_race = 0;
		slot.time_left = 0;
		slot.bonus = Slot::Bonus::None;
		slot.rarity = 1;
		slot.percentage = 0;
		slot.state = Slot::State::Selection;
		rollMonsterList(slot, player);
		applyAugments(player);
	}

	void System::action(const PlayerPtr& player, uint8_t slotId, Action action, uint8_t index, uint16_t raceId, Slot::Option option) const
	{
		if (not player or not config.enabled or slotId >= SlotCount)
		{
			return;
		}

		Slot& slot = player->getPreySlot(slotId);
		if (slot.state == Slot::State::Locked)
		{
			return;
		}

		switch (action)
		{
			case Action::ListReroll:
			{
				const bool freeReroll = slot.free_reroll_at <= OTSYS_TIME();
				if (not freeReroll)
				{
					const uint32_t price = getRerollPrice(player);
					if (player->getMoney() + player->getBankBalance() < price)
					{
						player->sendFYIBox("You do not have enough gold to reroll this prey list.");
						break;
					}
					g_game.removeMoney({ .player = player }, price);
				}
				else
				{
					slot.free_reroll_at = OTSYS_TIME() + static_cast<int64_t>(config.free_reroll_time) * 1000;
				}

				slot.selected_race = 0;
				slot.time_left = 0;
				slot.state = slot.bonus == Slot::Bonus::None ? Slot::State::Selection : Slot::State::SelectionChangeMonster;
				rollMonsterList(slot, player);
				applyAugments(player);
				break;
			}
			case Action::BonusReroll:
			{
				if (not slot.isOccupied())
				{
					break;
				}

				if (not player->removePreyWildcards(config.bonus_reroll_price))
				{
					player->sendFYIBox("You do not have enough prey wildcards to reroll this bonus.");
					break;
				}

				rollBonusType(slot);
				rollBonusValue(slot);
				slot.time_left = static_cast<uint16_t>(std::min<uint32_t>(config.bonus_time, std::numeric_limits<uint16_t>::max()));
				applyAugments(player);
				break;
			}
			case Action::MonsterSelection:
			{
				if (slot.isOccupied() or not slot.canSelect() or index >= slot.race_list.size())
				{
					break;
				}

				select(player, slot, slot.race_list[index]);
				break;
			}
			case Action::ListAllMonsters:
			{
				if (slot.isOccupied())
				{
					break;
				}

				if (not player->removePreyWildcards(config.selection_list_price))
				{
					player->sendFYIBox("You do not have enough prey wildcards to pick a creature freely.");
					break;
				}

				slot.time_left = 0;
				slot.state = slot.bonus == Slot::Bonus::None ? Slot::State::ListSelection : Slot::State::WildcardSelection;
				break;
			}
			case Action::ChangeFromAll:
			{
				const MonsterType* target = Bestiary::Registry::getInstance().getMonster(raceId);
				if (slot.isOccupied() or (slot.state != Slot::State::ListSelection and slot.state != Slot::State::WildcardSelection) or not target or not IsPreyable(*target))
				{
					break;
				}

				if (player->getPreyWithMonster(raceId))
				{
					player->sendFYIBox("This creature is already the prey of another slot.");
					break;
				}

				select(player, slot, raceId);
				break;
			}
			case Action::Option:
			{
				if (option == Slot::Option::AutomaticReroll and player->getPreyWildcards() < config.bonus_reroll_price)
				{
					player->sendFYIBox("You do not have enough prey wildcards to enable the automatic reroll.");
					break;
				}

				if (option == Slot::Option::Locked and player->getPreyWildcards() < config.selection_list_price)
				{
					player->sendFYIBox("You do not have enough prey wildcards to lock this prey.");
					break;
				}

				slot.option = option;
				break;
			}
			default:
				Console::Player::Warn("Prey::System::action: {:s} sent an unknown prey action {:d}", player->getName(), std::to_underlying(action));
				break;
		}

		player->sendPreySlot(slotId);
	}

	// bonus time only runs while the character is online
	void System::tick(const PlayerPtr& player, uint16_t seconds) const
	{
		if (not player or not config.enabled)
		{
			return;
		}

		auto occupied = std::views::iota(uint8_t{ 0 }, SlotCount) | std::views::filter([&](uint8_t slotId) { return player->getPreySlot(slotId).isOccupied(); });
		for (const uint8_t slotId : occupied)
		{
			Slot& slot = player->getPreySlot(slotId);
			if (slot.time_left > seconds)
			{
				slot.time_left -= seconds;
				player->sendPreyTimeLeft(slotId);
			}
			// the bonus ran out; the slot's option decides what happens next
			else if (slot.option == Slot::Option::AutomaticReroll and player->removePreyWildcards(config.bonus_reroll_price))
			{
				rollBonusType(slot);
				rollBonusValue(slot);
				slot.time_left = static_cast<uint16_t>(std::min<uint32_t>(config.bonus_time, std::numeric_limits<uint16_t>::max()));
				player->sendTextMessage(MESSAGE_STATUS_DEFAULT, "Your prey bonus has been rerolled automatically.");
				applyAugments(player);
				player->sendPreySlot(slotId);
			}
			else if (slot.option == Slot::Option::Locked and player->removePreyWildcards(config.selection_list_price))
			{
				slot.time_left = static_cast<uint16_t>(std::min<uint32_t>(config.bonus_time, std::numeric_limits<uint16_t>::max()));
				player->sendTextMessage(MESSAGE_STATUS_DEFAULT, "Your prey bonus time has been renewed.");
				player->sendPreySlot(slotId);
			}
			else
			{
				player->sendTextMessage(MESSAGE_STATUS_DEFAULT, "Your prey bonus has expired.");
				expire(player, slot);
				player->sendPreySlot(slotId);
			}
		}
	}

	// damage boost and damage reduction ride the augment system, filtered by
	// the creature's name; experience and loot are read where they apply
	void System::applyAugments(const PlayerPtr& player) const
	{
		if (not player)
		{
			return;
		}

		const auto& bestiary = Bestiary::Registry::getInstance();
		for (uint8_t slotId = 0; slotId < SlotCount; ++slotId)
		{
			player->removeAugment(player->getPreySlot(slotId).augmentName());
		}

		// only an active damage bonus against a known creature becomes an augment
		auto boosted = std::views::iota(uint8_t{ 0 }, SlotCount) | std::views::filter([&](uint8_t slotId)
		{
			const Slot& slot = player->getPreySlot(slotId);
			return slot.isOccupied() and (slot.bonus == Slot::Bonus::DamageBoost or slot.bonus == Slot::Bonus::DamageReduction) and bestiary.getMonster(slot.selected_race) != nullptr;
		});
		for (const uint8_t slotId : boosted)
		{
			const Slot& slot = player->getPreySlot(slotId);
			const MonsterType* target = bestiary.getMonster(slot.selected_race);
			auto augment = Augment::MakeAugment(slot.augmentName(), "prey bonus against " + target->name);
			if (slot.bonus == Slot::Bonus::DamageBoost)
			{
				augment->addModifier(DamageModifier(std::to_underlying(DamageModifier::Stance::Attack), std::to_underlying(DamageModifier::AttackType::Critical), slot.percentage, std::to_underlying(DamageModifier::Factor::Percent), 100, COMBAT_NONE, 0, CREATURETYPE_ATTACKABLE, RACE_NONE, target->name));
			}
			else
			{
				augment->addModifier(DamageModifier(std::to_underlying(DamageModifier::Stance::Defense), std::to_underlying(DamageModifier::DefenseType::Resist), slot.percentage, std::to_underlying(DamageModifier::Factor::Percent), 100, COMBAT_NONE, 0, CREATURETYPE_ATTACKABLE, RACE_NONE, target->name));
			}
			player->addAugment(augment);
		}
	}
}
