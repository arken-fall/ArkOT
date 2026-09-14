// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include "augment.h"
#include "const.h"

#include <array>
#include <span>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

class MonsterType;
class Player;
using PlayerPtr = std::shared_ptr<Player>;

namespace BlackTek::Bestiary
{
	// One modifier a charm grants against its assigned creature, in the
	// vocabulary of the augment system; the chance is per charm tier
	struct CharmModifier
	{
		uint8_t		stance = 0;
		uint8_t		mod_type = 0;
		uint16_t	value = 0;
		uint8_t		factor = 0;
		uint16_t	damage_type = COMBAT_NONE;
		uint8_t		origin = 0;
		std::array<uint8_t, 3> chance {};
	};

	// A charm rune as defined in config/charms.toml
	class Charm
	{
		public:
			enum class Category : uint8_t
			{
				Major = 1,
				Minor = 2,
			};

			enum class Effect : uint8_t
			{
				Offensive = 1,
				Defensive = 2,
				Passive = 3,
			};

			static constexpr uint8_t Tiers = 3;

			uint8_t		id = 0;
			std::string	name;
			std::string	description;
			Category	category = Category::Major;
			Effect		effect = Effect::Offensive;
			uint16_t	damage_type = COMBAT_NONE;
			double		percent = 0.0;
			std::array<double, Tiers> chance {};
			std::array<uint16_t, Tiers> points {};
			std::vector<CharmModifier> modifiers;

			// the augment a charm becomes once it is assigned to a creature
			[[nodiscard]] std::string augmentName() const;
			[[nodiscard]] std::shared_ptr<Augment> makeAugment(uint8_t tier, const MonsterType& target) const;
	};

	// Everything the bestiary knows that is not per player: which creature
	// owns which race id, and the charm table
	class Registry
	{
		public:
			// The bestiary groups every creature under one of these races; the
			// values are what the client reads, so they never change order.
			enum class Race : uint8_t
			{
				None = 0,
				Amphibic = 1,
				Aquatic = 2,
				Bird = 3,
				Construct = 4,
				Demon = 5,
				Dragon = 6,
				Elemental = 7,
				Fey = 8,
				Giant = 9,
				Human = 10,
				Humanoid = 11,
				Lycanthrope = 12,
				Magical = 13,
				Mammal = 14,
				Plant = 15,
				Reptile = 16,
				Slime = 17,
				Undead = 18,
				Vermin = 19,
				ExtraDimensional = 20,
				Inkborn = 21,

				First = Amphibic,
				Last = Inkborn,
			};

			// How far a character has come with one creature; the client shows
			// more of the entry at every stage
			enum class Stage : uint8_t
			{
				Unknown = 0,
				Seen = 1,
				Familiar = 2,
				Known = 3,
				Complete = 4,
			};

			static constexpr uint8_t MaxCharms = 32;

			// non-copyable
			Registry(const Registry&) = delete;
			Registry& operator=(const Registry&) = delete;

			static Registry& getInstance() {
				static Registry instance;
				return instance;
			}

			bool loadCharms();

			void registerMonster(MonsterType& monsterType);
			[[nodiscard]] const MonsterType* getMonster(uint16_t raceId) const;
			[[nodiscard]] const std::vector<const MonsterType*>& getRaceMembers(Race race) const;
			[[nodiscard]] std::vector<const MonsterType*> findByName(std::string_view text) const;
			[[nodiscard]] size_t monsterCount() const noexcept { return monsters_by_race_id.size(); }

			[[nodiscard]] std::span<const Charm> getCharms() const noexcept { return charms; }
			[[nodiscard]] const Charm* getCharm(uint8_t charmId) const;

			[[nodiscard]] static Stage getStage(const MonsterType& monsterType, uint32_t kills) noexcept;
			[[nodiscard]] static uint8_t getLootDifficulty(uint32_t chance) noexcept;

			// kill and charm bookkeeping; these are the entry points the game
			// layer and the protocol call
			void addKill(const PlayerPtr& player, const MonsterType& monsterType);
			bool buyCharm(const PlayerPtr& player, uint8_t charmId);
			bool assignCharm(const PlayerPtr& player, uint8_t charmId, uint16_t raceId);
			bool unassignCharm(const PlayerPtr& player, uint8_t charmId);
			void applyCharmAugments(const PlayerPtr& player) const;

			[[nodiscard]] static uint32_t getUnassignCost(const PlayerPtr& player) noexcept;
			[[nodiscard]] static uint64_t getResetCost(const PlayerPtr& player) noexcept;

		private:
			Registry() = default;

			std::unordered_map<uint16_t, const MonsterType*> monsters_by_race_id;
			std::array<std::vector<const MonsterType*>, static_cast<size_t>(Race::Last) + 1> monsters_by_race;
			std::vector<Charm> charms;
	};

	[[nodiscard]] Registry::Race ParseRace(std::string_view name) noexcept;
	[[nodiscard]] std::string_view RaceName(Registry::Race race) noexcept;
}
