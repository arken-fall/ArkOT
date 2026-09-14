// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "bestiary.h"
#include "augments.h"
#include "console.h"
#include "game.h"
#include "monsters.h"
#include "player.h"
#include "tools.h"

#include <ranges>
#include <toml++/toml.hpp>

extern Game g_game;

namespace BlackTek::Bestiary
{
	namespace
	{
		constexpr std::array<std::string_view, static_cast<size_t>(Registry::Race::Last) + 1> RaceNames {
			"",
			"Amphibic",
			"Aquatic",
			"Bird",
			"Construct",
			"Demon",
			"Dragon",
			"Elemental",
			"Fey",
			"Giant",
			"Human",
			"Humanoid",
			"Lycanthrope",
			"Magical",
			"Mammal",
			"Plant",
			"Reptile",
			"Slime",
			"Undead",
			"Vermin",
			"Extra Dimensional",
			"Inkborn",
		};

		template<typename T, size_t N>
		std::array<T, N> ReadTierValues(const toml::node_view<const toml::node>& node, T fallback)
		{
			std::array<T, N> values;
			values.fill(fallback);
			if (const auto* array = node.as_array())
			{
				size_t index = 0;
				for (const auto& element : *array)
				{
					if (index >= N)
					{
						break;
					}
					values[index++] = static_cast<T>(element.value_or(static_cast<double>(fallback)));
				}
			}
			else if (const auto single = node.value<double>())
			{
				values.fill(static_cast<T>(*single));
			}
			return values;
		}
	}

	Registry::Race ParseRace(std::string_view name) noexcept
	{
		for (size_t index = static_cast<size_t>(Registry::Race::First); index <= static_cast<size_t>(Registry::Race::Last); ++index)
		{
			if (caseInsensitiveEqual(RaceNames[index], name))
			{
				return static_cast<Registry::Race>(index);
			}
		}
		return Registry::Race::None;
	}

	std::string_view RaceName(Registry::Race race) noexcept
	{
		const auto index = static_cast<size_t>(race);
		return index < RaceNames.size() ? RaceNames[index] : std::string_view{};
	}

	std::string Charm::augmentName() const
	{
		return "Charm: " + name;
	}

	std::shared_ptr<Augment> Charm::makeAugment(uint8_t tier, const MonsterType& target) const
	{
		auto augment = Augment::MakeAugment(augmentName(), description);
		const size_t tierIndex = std::clamp<size_t>(tier, 1, Tiers) - 1;
		for (const auto& recipe : modifiers)
		{
			DamageModifier modifier(recipe.stance, recipe.mod_type, recipe.value, recipe.factor, recipe.chance[tierIndex], recipe.damage_type, recipe.origin, CREATURETYPE_ATTACKABLE, RACE_NONE, target.name);
			augment->addModifier(std::move(modifier));
		}
		return augment;
	}

	bool Registry::loadCharms()
	{
		charms.clear();
		try
		{
			auto config = toml::parse_file("config/charms.toml");
			auto runes = config | std::views::filter([](const auto& entry) { return entry.second.is_table(); });
			for (const auto& [key, value] : runes)
			{
				const auto* table = value.as_table();

				Charm charm;
				charm.id = (*table)["id"].value_or(0);
				charm.name = (*table)["name"].value_or(std::string(key.str()));
				charm.description = (*table)["description"].value_or("");
				charm.category = caseInsensitiveEqual((*table)["category"].value_or("major"), "minor") ? Charm::Category::Minor : Charm::Category::Major;

				const std::string_view effect = (*table)["effect"].value_or("offensive");
				if (caseInsensitiveEqual(effect, "defensive"))
				{
					charm.effect = Charm::Effect::Defensive;
				}
				else if (caseInsensitiveEqual(effect, "passive"))
				{
					charm.effect = Charm::Effect::Passive;
				}

				charm.damage_type = Augments::ParseDamage((*table)["damage"].value_or("none"));
				charm.percent = (*table)["percent"].value_or(0.0);
				charm.chance = ReadTierValues<double, Charm::Tiers>((*table)["chance"], 0.0);
				charm.points = ReadTierValues<uint16_t, Charm::Tiers>((*table)["points"], 0);

				if (const auto* modifiers = (*table)["modifiers"].as_array())
				{
					for (const auto& entry : *modifiers | std::views::filter(&toml::node::is_table))
					{
						const auto* modifierTable = entry.as_table();
						const std::string_view modType = (*modifierTable)["mod"].value_or("none");
						CharmModifier recipe;
						recipe.stance = Augments::ParseStance(modType);
						recipe.mod_type = recipe.stance == std::to_underlying(DamageModifier::Stance::Attack) ? Augments::ParseAttackModifier(modType) : Augments::ParseDefenseModifier(modType);
						recipe.value = (*modifierTable)["value"].value_or(0);
						recipe.factor = Augments::ParseFactor((*modifierTable)["factor"].value_or("percent"));
						recipe.damage_type = Augments::ParseDamage((*modifierTable)["damage"].value_or("none"));
						recipe.origin = Augments::ParseOrigin((*modifierTable)["origin"].value_or("none"));
						recipe.chance = ReadTierValues<uint8_t, Charm::Tiers>((*modifierTable)["chance"], 100);
						charm.modifiers.push_back(std::move(recipe));
					}
				}

				if (charm.id < MaxCharms)
				{
					charms.push_back(std::move(charm));
				}
				else
				{
					Console::Warn("Bestiary::Registry::loadCharms: charm '{:s}' has id {:d}, the limit is {:d}", charm.name, charm.id, MaxCharms - 1);
				}
			}
		}
		catch (const toml::parse_error& err)
		{
			Console::Error("Bestiary::Registry::loadCharms: failed to parse config/charms.toml: {:s}", err.description());
			return false;
		}

		std::ranges::sort(charms, {}, &Charm::id);
		return true;
	}

	void Registry::registerMonster(MonsterType& monsterType)
	{
		const auto& entry = monsterType.info.bestiary;
		if (entry.race_id == 0)
		{
			return;
		}

		if (auto it = monsters_by_race_id.find(entry.race_id); it != monsters_by_race_id.end() and it->second != &monsterType)
		{
			Console::Warn("Bestiary::Registry::registerMonster: race id {:d} is used by both '{:s}' and '{:s}'", entry.race_id, it->second->name, monsterType.name);
			return;
		}

		monsters_by_race_id[entry.race_id] = &monsterType;
		auto& members = monsters_by_race[static_cast<size_t>(entry.race)];
		if (std::ranges::find(members, &monsterType) == members.end())
		{
			members.push_back(&monsterType);
		}
	}

	const MonsterType* Registry::getMonster(uint16_t raceId) const
	{
		auto it = monsters_by_race_id.find(raceId);
		return it != monsters_by_race_id.end() ? it->second : nullptr;
	}

	const std::vector<const MonsterType*>& Registry::getRaceMembers(Race race) const
	{
		return monsters_by_race[static_cast<size_t>(race)];
	}

	std::vector<const MonsterType*> Registry::findByName(std::string_view text) const
	{
		std::vector<const MonsterType*> found;
		const std::string needle = asLowerCaseString(std::string(text));
		for (const auto& [raceId, monsterType] : monsters_by_race_id)
		{
			if (asLowerCaseString(monsterType->name).find(needle) != std::string::npos)
			{
				found.push_back(monsterType);
			}
		}
		return found;
	}

	const Charm* Registry::getCharm(uint8_t charmId) const
	{
		for (const auto& charm : charms)
		{
			if (charm.id == charmId)
			{
				return &charm;
			}
		}
		return nullptr;
	}

	Registry::Stage Registry::getStage(const MonsterType& monsterType, uint32_t kills) noexcept
	{
		const auto& entry = monsterType.info.bestiary;
		if (kills == 0)
		{
			return Stage::Unknown;
		}

		if (kills < entry.first_unlock)
		{
			return Stage::Seen;
		}

		if (kills < entry.second_unlock)
		{
			return Stage::Familiar;
		}

		if (kills < entry.to_kill)
		{
			return Stage::Known;
		}
		return Stage::Complete;
	}

	// loot chance is per hundred thousand; the client groups drops into four
	// rarity bands and reveals the rarer ones later
	uint8_t Registry::getLootDifficulty(uint32_t chance) noexcept
	{
		const double percent = chance / 1000.0;
		if (percent < 0.2)
		{
			return 4;
		}

		if (percent < 1.0)
		{
			return 3;
		}

		if (percent < 5.0)
		{
			return 2;
		}

		if (percent < 25.0)
		{
			return 1;
		}
		return 0;
	}

	void Registry::addKill(const PlayerPtr& player, const MonsterType& monsterType)
	{
		const auto& entry = monsterType.info.bestiary;
		if (not player or entry.race_id == 0)
		{
			return;
		}

		const uint32_t before = player->getBestiaryKills(entry.race_id);
		player->addBestiaryKills(entry.race_id, 1);
		const uint32_t after = before + 1;

		if (getStage(monsterType, before) != getStage(monsterType, after))
		{
			player->sendTextMessage(MESSAGE_STATUS_DEFAULT, fmt::format("You unlocked details for the creature '{:s}'.", monsterType.name));
			if (getStage(monsterType, after) == Stage::Complete)
			{
				player->addCharmPoints(entry.charm_points);
				player->sendBestiaryCharms();
			}
		}

		if (player->isTrackingBestiary(entry.race_id))
		{
			player->sendBestiaryTracker();
		}
	}

	bool Registry::buyCharm(const PlayerPtr& player, uint8_t charmId)
	{
		const Charm* charm = getCharm(charmId);
		if (not player or not charm)
		{
			return false;
		}

		auto& slot = player->getCharmSlot(charmId);
		if (slot.tier >= Charm::Tiers)
		{
			return false;
		}

		// the next tier's price sits at the current tier's index
		const uint16_t price = charm->points[slot.tier];
		if (player->getCharmPoints() < price)
		{
			player->sendFYIBox("You do not have enough charm points to unlock this rune.");
			return false;
		}

		player->removeCharmPoints(price);
		++slot.tier;
		if (slot.race_id != 0)
		{
			applyCharmAugments(player);
		}
		return true;
	}

	bool Registry::assignCharm(const PlayerPtr& player, uint8_t charmId, uint16_t raceId)
	{
		const Charm* charm = getCharm(charmId);
		const MonsterType* target = getMonster(raceId);
		if (not player or not charm or not target)
		{
			return false;
		}

		auto& slot = player->getCharmSlot(charmId);
		if (slot.tier == 0 or slot.race_id != 0)
		{
			return false;
		}

		if (getStage(*target, player->getBestiaryKills(raceId)) != Stage::Complete)
		{
			player->sendFYIBox("You need to complete this creature's bestiary entry first.");
			return false;
		}

		// one major and one minor charm per creature
		for (const auto& other : charms)
		{
			if (other.id != charm->id and other.category == charm->category and player->getCharmSlot(other.id).race_id == raceId)
			{
				player->sendFYIBox("This creature already carries a charm of that kind.");
				return false;
			}
		}

		slot.race_id = raceId;
		applyCharmAugments(player);
		return true;
	}

	bool Registry::unassignCharm(const PlayerPtr& player, uint8_t charmId)
	{
		const Charm* charm = getCharm(charmId);
		if (not player or not charm)
		{
			return false;
		}

		auto& slot = player->getCharmSlot(charmId);
		if (slot.race_id == 0)
		{
			return false;
		}

		const uint32_t cost = getUnassignCost(player);
		if (player->getMoney() + player->getBankBalance() < cost)
		{
			player->sendFYIBox("You do not have enough gold to remove this charm.");
			return false;
		}

		g_game.removeMoney({ .player = player }, cost);
		slot.race_id = 0;
		player->removeAugment(charm->augmentName());
		return true;
	}

	// the assigned charms live as augments named after them; rebuilding them
	// from the charm slots keeps a login, a tier change and a reassignment on
	// one path
	void Registry::applyCharmAugments(const PlayerPtr& player) const
	{
		if (not player)
		{
			return;
		}

		for (const auto& charm : charms)
		{
			player->removeAugment(charm.augmentName());
		}

		// only assigned runes with a known creature and something to grant become augments
		auto assigned = charms | std::views::filter([&](const Charm& charm)
		{
			const auto& slot = player->getCharmSlot(charm.id);
			return slot.tier != 0 and not charm.modifiers.empty() and getMonster(slot.race_id) != nullptr;
		});
		for (const auto& charm : assigned)
		{
			const auto& slot = player->getCharmSlot(charm.id);
			player->addAugment(charm.makeAugment(slot.tier, *getMonster(slot.race_id)));
		}
	}

	uint32_t Registry::getUnassignCost(const PlayerPtr& player) noexcept
	{
		return player ? player->getLevel() * 100 : 0;
	}

	uint64_t Registry::getResetCost(const PlayerPtr& player) noexcept
	{
		if (not player)
		{
			return 0;
		}

		const uint64_t level = player->getLevel();
		return 100000 + (level > 100 ? level * 11000 : 0);
	}
}
