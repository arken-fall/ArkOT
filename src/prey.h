// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include "augment.h"

#include <array>
#include <cstdint>
#include <memory>
#include <string>
#include <vector>

class MonsterType;
class Player;
using PlayerPtr = std::shared_ptr<Player>;

namespace BlackTek::Prey
{
	// slot states as the 12.x+ client reads them
	enum class SlotState : uint8_t
	{
		Locked = 0x00,
		Inactive = 0x01,
		Active = 0x02,
		Selection = 0x03,
		SelectionChangeMonster = 0x04,
		ListSelection = 0x05,
		WildcardSelection = 0x06,
	};

	// what an active slot grants against its creature
	enum class Bonus : uint8_t
	{
		DamageBoost = 0x00,
		DamageReduction = 0x01,
		Experience = 0x02,
		Loot = 0x03,
		None = 0x04,

		First = DamageBoost,
		Last = Loot,
	};

	// what happens when the bonus time runs out
	enum class Option : uint8_t
	{
		None = 0x00,
		AutomaticReroll = 0x01,
		Locked = 0x02,
	};

	// the client's PreyAction requests
	enum class Action : uint8_t
	{
		ListReroll = 0x00,
		BonusReroll = 0x01,
		MonsterSelection = 0x02,
		ListAllMonsters = 0x03,
		ChangeFromAll = 0x04,
		Option = 0x05,
	};

	constexpr uint8_t SlotCount = 3;
	constexpr uint8_t ListSize = 9;
	constexpr uint8_t MaxRarity = 10;

	// one prey slot as the character holds it
	struct Slot
	{
		uint8_t id = 0;
		SlotState state = SlotState::Locked;
		Bonus bonus = Bonus::None;
		Option option = Option::None;
		uint8_t rarity = 1;
		uint16_t percentage = 0;
		uint16_t time_left = 0; // seconds of bonus left
		uint16_t selected_race = 0;
		int64_t free_reroll_at = 0; // OTSYS_TIME the next free list is due
		std::vector<uint16_t> race_list;

		[[nodiscard]] bool isOccupied() const noexcept { return state == SlotState::Active and selected_race != 0; }
		[[nodiscard]] bool canSelect() const noexcept { return state == SlotState::Selection or state == SlotState::SelectionChangeMonster or state == SlotState::ListSelection or state == SlotState::WildcardSelection; }
		[[nodiscard]] std::string augmentName() const { return "Prey: slot " + std::to_string(id + 1); }
	};

	// config/prey.toml
	struct Config
	{
		bool enabled = true;
		bool free_third_slot = false;
		uint32_t reroll_price_per_level = 200;
		uint16_t selection_list_price = 5; // wildcards
		uint16_t bonus_reroll_price = 1; // wildcards
		uint32_t bonus_time = 2 * 60 * 60; // seconds
		uint32_t free_reroll_time = 20 * 60 * 60; // seconds
	};

	class System
	{
		public:
			// non-copyable
			System(const System&) = delete;
			System& operator=(const System&) = delete;

			static System& getInstance() {
				static System instance;
				return instance;
			}

			bool loadConfig();
			[[nodiscard]] const Config& getConfig() const noexcept { return config; }

			// a fresh character's slots, and what a level is charged for a list
			void initializeSlots(const PlayerPtr& player) const;
			[[nodiscard]] uint32_t getRerollPrice(const PlayerPtr& player) const noexcept;

			void rollMonsterList(Slot& slot, const PlayerPtr& player) const;
			void rollBonusType(Slot& slot) const;
			void rollBonusValue(Slot& slot) const;

			void action(const PlayerPtr& player, uint8_t slotId, Action action, uint8_t index, uint16_t raceId, Option option) const;
			void tick(const PlayerPtr& player, uint16_t seconds) const;
			void applyAugments(const PlayerPtr& player) const;

		private:
			System() = default;

			void select(const PlayerPtr& player, Slot& slot, uint16_t raceId) const;
			void expire(const PlayerPtr& player, Slot& slot) const;

			Config config;
	};
}
