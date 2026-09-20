// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "wheel.h"
#include "augments.h"
#include "console.h"
#include "damagemodifier.h"
#include "game.h"
#include "item.h"
#include "items.h"
#include "player.h"
#include "tools.h"
#include "vocation.h"

#include <algorithm>
#include <cmath>
#include <ranges>
#include <toml++/toml.hpp>

extern Game g_game;

namespace BlackTek::Wheel
{
	namespace
	{
		using Slot = System::Slot;
		using Quadrant = System::Quadrant;
		using Vocation = System::Vocation;
		using PointStat = System::PointStat;
		using Reward = System::Reward;
		using Instant = Bonuses::Instant;
		using Perk = Bonuses::Perk;
		using Basic = Gem::BasicModifier;
		using Supreme = Gem::SupremeModifier;

		// what one point buys, by wire vocation minus one (knight, paladin, sorcerer, druid, monk)
		constexpr std::array<int32_t, VocationCount> HealthPerPoint { 3, 2, 1, 1, 2 };
		constexpr std::array<int32_t, VocationCount> ManaPerPoint { 1, 3, 6, 6, 2 };
		constexpr std::array<int32_t, VocationCount> CapacityPerPoint { 5, 4, 2, 2, 5 };
		constexpr int32_t MitigationPerPoint = 3; // hundredths of a percent
		constexpr int32_t LifeLeechPerReward = 75; // hundredths of a percent
		constexpr int32_t ManaLeechPerReward = 25;
		constexpr std::array<uint16_t, 3> StageThresholds { 250, 500, 1000 };
		constexpr std::array<int32_t, 3> RevelationDamage { 4, 9, 20 }; // percent, damage and healing alike
		constexpr std::array<Quadrant, QuadrantCount> QuadrantOrder { Quadrant::Green, Quadrant::Red, Quadrant::Blue, Quadrant::Purple };

		constexpr std::string_view FocusSpell = "Any Focus Spell";
		constexpr std::array<std::string_view, 4> FocusSpells { "Eternal Winter", "Hell's Core", "Rage of the Skies", "Wrath of Nature" };

		// the wheel's geometry: quadrant, size, the points a character
		// needs before the slot opens, and the slots a full one may grow from
		constexpr std::array<System::Place, SlotCount + 1> Places { {
			{},
			{ Quadrant::Green, 200, 375, { Slot::GreenTop150, Slot::GreenBottom150 } },
			{ Quadrant::Green, 150, 225, { Slot::GreenTop100, Slot::GreenMiddle100, Slot::GreenBottom150 } },
			{ Quadrant::Green, 100, 125, { Slot::RedTop100, Slot::GreenTop75, Slot::GreenMiddle100 } },
			{ Quadrant::Red, 100, 125, { Slot::RedTop75, Slot::GreenTop100, Slot::RedMiddle100, Slot::RedTop150 } },
			{ Quadrant::Red, 150, 225, { Slot::RedTop100, Slot::RedMiddle100, Slot::RedBottom150 } },
			{ Quadrant::Red, 200, 375, { Slot::RedTop150, Slot::RedBottom150 } },
			{ Quadrant::Green, 150, 225, { Slot::GreenMiddle100, Slot::GreenBottom100, Slot::GreenTop150 } },
			{ Quadrant::Green, 100, 125, { Slot::GreenTop100, Slot::GreenTop75, Slot::GreenBottom75, Slot::GreenBottom100 } },
			{ Quadrant::Green, 75, 50, { Slot::Green50, Slot::RedTop75, Slot::GreenBottom75, Slot::GreenMiddle100, Slot::GreenTop100 } },
			{ Quadrant::Red, 75, 50, { Slot::Red50, Slot::GreenTop75, Slot::RedTop100, Slot::RedMiddle100, Slot::RedBottom75 } },
			{ Quadrant::Red, 100, 125, { Slot::RedTop75, Slot::RedBottom75, Slot::RedBottom100, Slot::RedTop100 } },
			{ Quadrant::Red, 150, 225, { Slot::RedMiddle100, Slot::RedBottom100, Slot::RedTop150 } },
			{ Quadrant::Green, 100, 125, { Slot::GreenMiddle100, Slot::GreenBottom75, Slot::BlueTop100, Slot::GreenBottom150 } },
			{ Quadrant::Green, 75, 50, { Slot::Green50, Slot::BlueTop75, Slot::GreenMiddle100, Slot::GreenBottom100, Slot::GreenTop75 } },
			{ Quadrant::Green, 50, 0, {} },
			{ Quadrant::Red, 50, 0, {} },
			{ Quadrant::Red, 75, 50, { Slot::Red50, Slot::PurpleTop75, Slot::RedBottom100, Slot::RedMiddle100, Slot::RedTop75 } },
			{ Quadrant::Red, 100, 125, { Slot::RedBottom75, Slot::PurpleTop100, Slot::RedMiddle100, Slot::RedBottom150 } },
			{ Quadrant::Blue, 100, 125, { Slot::BlueTop75, Slot::GreenBottom100, Slot::BlueMiddle100, Slot::BlueTop150 } },
			{ Quadrant::Blue, 75, 50, { Slot::Blue50, Slot::GreenBottom75, Slot::BlueBottom75, Slot::BlueMiddle100, Slot::BlueTop100 } },
			{ Quadrant::Blue, 50, 0, {} },
			{ Quadrant::Purple, 50, 0, {} },
			{ Quadrant::Purple, 75, 50, { Slot::Purple50, Slot::RedBottom75, Slot::PurpleBottom75, Slot::PurpleMiddle100, Slot::PurpleTop100 } },
			{ Quadrant::Purple, 100, 125, { Slot::PurpleTop75, Slot::RedBottom100, Slot::PurpleMiddle100, Slot::PurpleTop150 } },
			{ Quadrant::Blue, 150, 225, { Slot::BlueMiddle100, Slot::BlueTop100, Slot::BlueBottom150 } },
			{ Quadrant::Blue, 100, 125, { Slot::BlueTop75, Slot::BlueBottom75, Slot::BlueBottom100, Slot::BlueTop100 } },
			{ Quadrant::Blue, 75, 50, { Slot::Blue50, Slot::PurpleBottom75, Slot::BlueTop75, Slot::BlueMiddle100, Slot::BlueBottom100 } },
			{ Quadrant::Purple, 75, 50, { Slot::Purple50, Slot::BlueBottom75, Slot::PurpleTop75, Slot::PurpleMiddle100, Slot::PurpleBottom100 } },
			{ Quadrant::Purple, 100, 125, { Slot::PurpleTop75, Slot::PurpleBottom75, Slot::PurpleBottom100, Slot::PurpleTop100 } },
			{ Quadrant::Purple, 150, 225, { Slot::PurpleMiddle100, Slot::PurpleTop100, Slot::PurpleBottom150 } },
			{ Quadrant::Blue, 200, 375, { Slot::BlueTop150, Slot::BlueBottom150 } },
			{ Quadrant::Blue, 150, 225, { Slot::BlueMiddle100, Slot::BlueBottom100, Slot::BlueTop150 } },
			{ Quadrant::Blue, 100, 125, { Slot::BlueBottom75, Slot::PurpleBottom100, Slot::BlueMiddle100, Slot::BlueBottom150 } },
			{ Quadrant::Purple, 100, 125, { Slot::PurpleBottom75, Slot::BlueBottom100, Slot::PurpleMiddle100, Slot::PurpleBottom150 } },
			{ Quadrant::Purple, 150, 225, { Slot::PurpleMiddle100, Slot::PurpleBottom100, Slot::PurpleTop150 } },
			{ Quadrant::Purple, 200, 375, { Slot::PurpleTop150, Slot::PurpleBottom150 } },
		} };

		// the spells the vocations share a slot for, by wire vocation minus one
		constexpr std::array<std::string_view, VocationCount> SpellsA { "Front Sweep", "Sharpshooter", FocusSpell, "Strong Ice Wave", "Sweeping Takedown" };
		constexpr std::array<std::string_view, VocationCount> SpellsB { "Groundshaker", "Strong Ethereal Spear", "Magic Shield", "Mass Healing", "Mass Spirit Mend" };
		constexpr std::array<std::string_view, VocationCount> SpellsC { "Chivalrous Challenge", "Divine Dazzle", "Sap Strength", "Nature's Embrace", "Mystic Repulse" };
		constexpr std::array<std::string_view, VocationCount> SpellsD { "Intense Wound Cleansing", "Swift Foot", "Energy Wave", "Terra Wave", "Chained Penance" };
		constexpr std::array<std::string_view, VocationCount> SpellsE { "Fierce Berserk", "Divine Caldera", "Great Fire Wave", "Heal Friend", "Flurry of Blows" };
		constexpr std::array<Instant, VocationCount> InstantsGreen { Instant::BattleInstinct, Instant::PositionalTactics, Instant::RunicMastery, Instant::HealingLink, Instant::GuidingPresence };
		constexpr std::array<Instant, VocationCount> InstantsPurple { Instant::BattleHealing, Instant::BallisticMastery, Instant::FocusMastery, Instant::RunicMastery, Instant::Sanctuary };

		constexpr std::array<System::SlotBonus, SlotCount + 1> SlotBonuses { {
			{},
			{ PointStat::Health, PointStat::Mana, Reward::Instant, {}, InstantsGreen },
			{ PointStat::Mitigation, PointStat::None, Reward::ManaLeech },
			{ PointStat::Health, PointStat::None, Reward::Vessel },
			{ PointStat::Mana, PointStat::None, Reward::Skill },
			{ PointStat::Health, PointStat::None, Reward::Vessel },
			{ PointStat::Health, PointStat::Mana, Reward::Spell, SpellsA },
			{ PointStat::Mitigation, PointStat::None, Reward::Vessel },
			{ PointStat::Health, PointStat::None, Reward::Spell, SpellsB },
			{ PointStat::Mana, PointStat::None, Reward::LifeLeech },
			{ PointStat::Capacity, PointStat::None, Reward::Vessel },
			{ PointStat::Mana, PointStat::None, Reward::Spell, SpellsC },
			{ PointStat::Health, PointStat::None, Reward::ManaLeech },
			{ PointStat::Health, PointStat::None, Reward::Spell, SpellsD },
			{ PointStat::Mana, PointStat::None, Reward::Skill },
			{ PointStat::Capacity, PointStat::None, Reward::Vessel },
			{ PointStat::Mitigation, PointStat::None, Reward::Spell, SpellsE },
			{ PointStat::Capacity, PointStat::None, Reward::LifeLeech },
			{ PointStat::Mana, PointStat::None, Reward::Vessel },
			{ PointStat::Mitigation, PointStat::None, Reward::Vessel },
			{ PointStat::Health, PointStat::None, Reward::ManaLeech },
			{ PointStat::Mana, PointStat::None, Reward::Spell, SpellsA },
			{ PointStat::Health, PointStat::None, Reward::Vessel },
			{ PointStat::Mitigation, PointStat::None, Reward::Skill },
			{ PointStat::Capacity, PointStat::None, Reward::Spell, SpellsB },
			{ PointStat::Capacity, PointStat::None, Reward::LifeLeech },
			{ PointStat::Mitigation, PointStat::None, Reward::Spell, SpellsC },
			{ PointStat::Health, PointStat::None, Reward::Vessel },
			{ PointStat::Mitigation, PointStat::None, Reward::ManaLeech },
			{ PointStat::Capacity, PointStat::None, Reward::Spell, SpellsD },
			{ PointStat::Mana, PointStat::None, Reward::Vessel },
			{ PointStat::Health, PointStat::Mana, Reward::Spell, SpellsE },
			{ PointStat::Capacity, PointStat::None, Reward::Vessel },
			{ PointStat::Mitigation, PointStat::None, Reward::Skill },
			{ PointStat::Capacity, PointStat::None, Reward::Vessel },
			{ PointStat::Mana, PointStat::None, Reward::LifeLeech },
			{ PointStat::Health, PointStat::Mana, Reward::Instant, {}, InstantsPurple },
		} };

		constexpr std::array<std::string_view, std::to_underlying(Instant::Count)> InstantNames {
			"Battle Instinct", "Battle Healing", "Positional Tactics", "Ballistic Mastery", "Healing Link",
			"Runic Mastery", "Focus Mastery", "Sanctuary", "Guiding Presence",
		};

		constexpr std::array<std::string_view, std::to_underlying(Perk::Count)> PerkNames {
			"Gift of Life", "Combat Mastery", "Blessing of the Grove", "Drain Body", "Beam Mastery",
			"Divine Empowerment", "Twin Burst", "Executioner's Throw", "Avatar of Light", "Avatar of Nature",
			"Avatar of Steel", "Avatar of Storm", "Avatar of Balance", "Divine Grenade", "Spiritual Outburst", "Ascetic",
		};

		// what a vocation's revelations are, by quadrant then wire vocation minus one; green is Gift of Life for everyone
		constexpr std::array<Perk, VocationCount> RedPerks { Perk::ExecutionersThrow, Perk::DivineGrenade, Perk::BeamMastery, Perk::BlessingOfTheGrove, Perk::SpiritualOutburst };
		constexpr std::array<Perk, VocationCount> BluePerks { Perk::CombatMastery, Perk::DivineEmpowerment, Perk::DrainBody, Perk::TwinBurst, Perk::Ascetic };
		constexpr std::array<Perk, VocationCount> PurplePerks { Perk::AvatarOfSteel, Perk::AvatarOfLight, Perk::AvatarOfStorm, Perk::AvatarOfNature, Perk::AvatarOfBalance };

		// what a slot upgrade does to a spell, by vocation: the first grade
		// comes with the first slot that names the spell, the second with the next
		struct SpellGrade
		{
			Vocation			vocation;
			std::string_view	name;
			SpellBonus			first;
			SpellBonus			second;
		};

		constexpr SpellBonus Damage(int32_t percent) { SpellBonus bonus; bonus.damage = percent; return bonus; }
		constexpr SpellBonus Heal(int32_t percent) { SpellBonus bonus; bonus.heal = percent; return bonus; }
		constexpr SpellBonus Cooldown(int32_t seconds) { SpellBonus bonus; bonus.cooldown = seconds * 1000; return bonus; }
		constexpr SpellBonus GroupCooldown(int32_t seconds) { SpellBonus bonus; bonus.group_cooldown = seconds * 1000; return bonus; }
		constexpr SpellBonus ManaCost(int32_t percent) { SpellBonus bonus; bonus.mana_cost = percent; return bonus; }
		constexpr SpellBonus LifeLeech(int32_t percent) { SpellBonus bonus; bonus.life_leech = percent; return bonus; }
		constexpr SpellBonus ManaLeech(int32_t percent) { SpellBonus bonus; bonus.mana_leech = percent; return bonus; }
		constexpr SpellBonus Targets(int32_t count) { SpellBonus bonus; bonus.additional_targets = count; return bonus; }
		constexpr SpellBonus Area() { SpellBonus bonus; bonus.area = true; return bonus; }
		constexpr SpellBonus Critical(int32_t damage, int32_t chance) { SpellBonus bonus; bonus.critical_damage = damage; bonus.critical_chance = chance; return bonus; }
		constexpr SpellBonus Reduction(int32_t amount) { SpellBonus bonus; bonus.damage_reduction = amount; return bonus; }
		constexpr SpellBonus DurationAndCooldown(int32_t seconds, int32_t cooldown) { SpellBonus bonus; bonus.duration = seconds; bonus.cooldown = cooldown * 1000; return bonus; }
		constexpr SpellBonus CooldownBoth(int32_t seconds) { SpellBonus bonus; bonus.cooldown = seconds * 1000; bonus.group_cooldown = seconds * 1000; return bonus; }

		constexpr std::array<SpellGrade, 25> SpellGrades { {
			{ Vocation::Druid, "Strong Ice Wave", ManaLeech(3), Damage(10) },
			{ Vocation::Druid, "Mass Healing", Heal(4), Area() },
			{ Vocation::Druid, "Nature's Embrace", Heal(11), Cooldown(10) },
			{ Vocation::Druid, "Terra Wave", Damage(7), LifeLeech(5) },
			{ Vocation::Druid, "Heal Friend", ManaCost(10), Heal(6) },
			{ Vocation::Knight, "Front Sweep", LifeLeech(5), Damage(14) },
			{ Vocation::Knight, "Groundshaker", Damage(13), Cooldown(2) },
			{ Vocation::Knight, "Chivalrous Challenge", ManaCost(20), Targets(1) },
			{ Vocation::Knight, "Intense Wound Cleansing", Heal(125), Cooldown(300) },
			{ Vocation::Knight, "Fierce Berserk", ManaCost(30), Damage(10) },
			{ Vocation::Paladin, "Sharpshooter", GroupCooldown(8), Cooldown(6) },
			{ Vocation::Paladin, "Strong Ethereal Spear", Cooldown(2), Damage(380) },
			{ Vocation::Paladin, "Divine Dazzle", Targets(1), DurationAndCooldown(4, 4) },
			{ Vocation::Paladin, "Swift Foot", GroupCooldown(8), Cooldown(6) },
			{ Vocation::Paladin, "Divine Caldera", ManaCost(20), Damage(9) },
			{ Vocation::Sorcerer, "Magic Shield", {}, Cooldown(6) },
			{ Vocation::Sorcerer, "Sap Strength", Area(), Reduction(1) },
			{ Vocation::Sorcerer, "Energy Wave", Damage(5), Area() },
			{ Vocation::Sorcerer, "Great Fire Wave", Critical(15, 10), Damage(5) },
			{ Vocation::Sorcerer, FocusSpell, Damage(5), CooldownBoth(4) },
			{ Vocation::Monk, "Mass Spirit Mend", Heal(8), Area() },
			{ Vocation::Monk, "Mystic Repulse", Cooldown(4), Damage(40) },
			{ Vocation::Monk, "Chained Penance", Targets(1), Targets(2) },
			{ Vocation::Monk, "Flurry of Blows", LifeLeech(5), Damage(12) },
			{ Vocation::Monk, "Sweeping Takedown", ManaLeech(3), Critical(25, 10) },
		} };

		// the basic modifiers the client lists a grade for, in its order
		constexpr std::array<Basic, BasicPositionCount> BasicPositions {
			Basic::GeneralPhysicalResistance, Basic::GeneralHolyResistance, Basic::GeneralDeathResistance, Basic::GeneralFireResistance,
			Basic::GeneralEarthResistance, Basic::GeneralIceResistance, Basic::GeneralEnergyResistance, Basic::GeneralHolyResistanceDeathWeakness,
			Basic::GeneralDeathResistanceHolyWeakness, Basic::GeneralFireResistanceEarthResistance, Basic::GeneralFireResistanceIceResistance,
			Basic::GeneralFireResistanceEnergyResistance, Basic::GeneralEarthResistanceIceResistance, Basic::GeneralEarthResistanceEnergyResistance,
			Basic::GeneralIceResistanceEnergyResistance, Basic::GeneralFireResistanceEarthWeakness, Basic::GeneralFireResistanceIceWeakness,
			Basic::GeneralFireResistanceEnergyWeakness, Basic::GeneralEarthResistanceFireWeakness, Basic::GeneralEarthResistanceIceWeakness,
			Basic::GeneralEarthResistanceEnergyWeakness, Basic::GeneralIceResistanceEarthWeakness, Basic::GeneralIceResistanceFireWeakness,
			Basic::GeneralIceResistanceEnergyWeakness, Basic::GeneralEnergyResistanceEarthWeakness, Basic::GeneralEnergyResistanceIceWeakness,
			Basic::GeneralEnergyResistanceFireWeakness, Basic::GeneralManaDrainResistance, Basic::GeneralLifeDrainResistance,
			Basic::GeneralManaDrainResistanceLifeDrainResistance, Basic::GeneralMitigationMultiplier, Basic::VocationHealth,
			Basic::VocationManaFireResistance, Basic::VocationManaEnergyResistance, Basic::VocationManaEarthResistance, Basic::VocationManaIceResistance,
			Basic::VocationMana, Basic::VocationHealthFireResistance, Basic::VocationHealthEnergyResistance, Basic::VocationHealthEarthResistance,
			Basic::VocationHealthIceResistance, Basic::VocationCapacityFireResistance, Basic::VocationCapacityEnergyResistance,
			Basic::VocationCapacityEarthResistance, Basic::VocationCapacityIceResistance, Basic::VocationCapacity,
		};

		// what the atelier may reveal in a gem's first and second facet
		constexpr std::array<Basic, 20> FirstFacet {
			Basic::GeneralFireResistance, Basic::GeneralIceResistance, Basic::GeneralEnergyResistance, Basic::GeneralEarthResistance,
			Basic::GeneralMitigationMultiplier, Basic::VocationHealth, Basic::VocationMana, Basic::VocationCapacity,
			Basic::VocationHealthFireResistance, Basic::VocationHealthIceResistance, Basic::VocationHealthEnergyResistance, Basic::VocationHealthEarthResistance,
			Basic::VocationManaFireResistance, Basic::VocationManaEnergyResistance, Basic::VocationManaEarthResistance, Basic::VocationManaIceResistance,
			Basic::VocationCapacityFireResistance, Basic::VocationCapacityEnergyResistance, Basic::VocationCapacityEarthResistance, Basic::VocationCapacityIceResistance,
		};

		constexpr std::array<Basic, 30> SecondFacet {
			Basic::GeneralFireResistance, Basic::GeneralIceResistance, Basic::GeneralEnergyResistance, Basic::GeneralEarthResistance,
			Basic::GeneralPhysicalResistance, Basic::GeneralHolyResistance, Basic::GeneralHolyResistanceDeathWeakness, Basic::GeneralDeathResistanceHolyWeakness,
			Basic::GeneralFireResistanceEarthResistance, Basic::GeneralFireResistanceIceResistance, Basic::GeneralFireResistanceEnergyResistance,
			Basic::GeneralEarthResistanceIceResistance, Basic::GeneralEarthResistanceEnergyResistance, Basic::GeneralIceResistanceEnergyResistance,
			Basic::GeneralFireResistanceEarthWeakness, Basic::GeneralFireResistanceIceWeakness, Basic::GeneralFireResistanceEnergyWeakness,
			Basic::GeneralEarthResistanceFireWeakness, Basic::GeneralEarthResistanceIceWeakness, Basic::GeneralEarthResistanceEnergyWeakness,
			Basic::GeneralIceResistanceEarthWeakness, Basic::GeneralIceResistanceFireWeakness, Basic::GeneralIceResistanceEnergyWeakness,
			Basic::GeneralEnergyResistanceEarthWeakness, Basic::GeneralEnergyResistanceIceWeakness, Basic::GeneralEnergyResistanceFireWeakness,
			Basic::GeneralManaDrainResistance, Basic::GeneralLifeDrainResistance, Basic::GeneralManaDrainResistanceLifeDrainResistance,
			Basic::GeneralMitigationMultiplier,
		};

		// a supreme modifier: who may roll it, and what it does
		struct SupremeEffect
		{
			enum class Kind : uint8_t
			{
				Dodge,
				CriticalDamage,
				LifeLeech,
				ManaLeech,
				Revelation,
				SpellDamage,
				SpellCritical,
				SpellHeal,
				SpellCooldown,
			};

			enum class Who : uint8_t
			{
				Everyone,
				Mages,
				Knight,
				Paladin,
				Sorcerer,
				Druid,
				Monk,
			};

			Who					who;
			Kind				kind;
			int32_t				value; // hundredths of a percent, percent, points or seconds by kind
			std::string_view	spell = {};
			Quadrant			quadrant = Quadrant::Green;
		};

		using Kind = SupremeEffect::Kind;
		using Who = SupremeEffect::Who;

		constexpr std::array<SupremeEffect, SupremeModifierCount> SupremeEffects { {
			{ Who::Everyone, Kind::Dodge, 28 },
			{ Who::Everyone, Kind::CriticalDamage, 200 },
			{ Who::Everyone, Kind::LifeLeech, 200 },
			{ Who::Everyone, Kind::ManaLeech, 80 },
			{ Who::Mages, Kind::SpellHeal, 5, "Ultimate Healing" },
			{ Who::Everyone, Kind::Revelation, 150, {}, Quadrant::Green },
			{ Who::Knight, Kind::SpellCooldown, 900, "Avatar of Steel" },
			{ Who::Knight, Kind::SpellCooldown, 2, "Executioner's Throw" },
			{ Who::Knight, Kind::SpellDamage, 6, "Executioner's Throw" },
			{ Who::Knight, Kind::SpellCritical, 12, "Executioner's Throw" },
			{ Who::Knight, Kind::SpellDamage, 5, "Fierce Berserk" },
			{ Who::Knight, Kind::SpellCritical, 8, "Fierce Berserk" },
			{ Who::Knight, Kind::SpellDamage, 5, "Berserk" },
			{ Who::Knight, Kind::SpellCritical, 12, "Berserk" },
			{ Who::Knight, Kind::SpellCritical, 12, "Front Sweep" },
			{ Who::Knight, Kind::SpellDamage, 8, "Front Sweep" },
			{ Who::Knight, Kind::SpellDamage, 7, "Groundshaker" },
			{ Who::Knight, Kind::SpellCritical, 12, "Groundshaker" },
			{ Who::Knight, Kind::SpellCritical, 15, "Annihilation" },
			{ Who::Knight, Kind::SpellDamage, 12, "Annihilation" },
			{ Who::Knight, Kind::SpellHeal, 10, "Fair Wound Cleansing" },
			{ Who::Knight, Kind::Revelation, 150, {}, Quadrant::Purple },
			{ Who::Knight, Kind::Revelation, 150, {}, Quadrant::Red },
			{ Who::Knight, Kind::Revelation, 150, {}, Quadrant::Blue },
			{ Who::Paladin, Kind::SpellCooldown, 900, "Avatar of Light" },
			{ Who::Paladin, Kind::SpellCooldown, 4, "Divine Dazzle" },
			{ Who::Paladin, Kind::SpellDamage, 6, "Divine Grenade" },
			{ Who::Paladin, Kind::SpellCritical, 12, "Divine Grenade" },
			{ Who::Paladin, Kind::SpellDamage, 5, "Divine Caldera" },
			{ Who::Paladin, Kind::SpellCritical, 12, "Divine Caldera" },
			{ Who::Paladin, Kind::SpellDamage, 8, "Divine Missile" },
			{ Who::Paladin, Kind::SpellCritical, 12, "Divine Missile" },
			{ Who::Paladin, Kind::SpellDamage, 10, "Ethereal Spear" },
			{ Who::Paladin, Kind::SpellCritical, 15, "Ethereal Spear" },
			{ Who::Paladin, Kind::SpellDamage, 8, "Strong Ethereal Spear" },
			{ Who::Paladin, Kind::SpellCritical, 12, "Strong Ethereal Spear" },
			{ Who::Paladin, Kind::SpellCooldown, 6, "Divine Empowerment" },
			{ Who::Paladin, Kind::SpellCooldown, 2, "Divine Grenade" },
			{ Who::Paladin, Kind::SpellHeal, 6, "Salvation" },
			{ Who::Paladin, Kind::Revelation, 150, {}, Quadrant::Purple },
			{ Who::Paladin, Kind::Revelation, 150, {}, Quadrant::Red },
			{ Who::Paladin, Kind::Revelation, 150, {}, Quadrant::Blue },
			{ Who::Sorcerer, Kind::SpellCooldown, 900, "Avatar of Storm" },
			{ Who::Sorcerer, Kind::SpellCooldown, 1, "Energy Wave" },
			{ Who::Sorcerer, Kind::SpellDamage, 10, "Great Death Beam" },
			{ Who::Sorcerer, Kind::SpellCritical, 15, "Great Death Beam" },
			{ Who::Sorcerer, Kind::SpellDamage, 8, "Hell's Core" },
			{ Who::Sorcerer, Kind::SpellCritical, 12, "Hell's Core" },
			{ Who::Sorcerer, Kind::SpellDamage, 5, "Energy Wave" },
			{ Who::Sorcerer, Kind::SpellCritical, 12, "Energy Wave" },
			{ Who::Sorcerer, Kind::SpellDamage, 5, "Great Fire Wave" },
			{ Who::Sorcerer, Kind::SpellCritical, 8, "Great Fire Wave" },
			{ Who::Sorcerer, Kind::SpellDamage, 8, "Rage of the Skies" },
			{ Who::Sorcerer, Kind::SpellCritical, 12, "Rage of the Skies" },
			{ Who::Sorcerer, Kind::SpellDamage, 10, "Great Energy Beam" },
			{ Who::Sorcerer, Kind::SpellCritical, 15, "Great Energy Beam" },
			{ Who::Sorcerer, Kind::Revelation, 150, {}, Quadrant::Purple },
			{ Who::Sorcerer, Kind::Revelation, 150, {}, Quadrant::Red },
			{ Who::Sorcerer, Kind::Revelation, 150, {}, Quadrant::Blue },
			{ Who::Druid, Kind::SpellCooldown, 900, "Avatar of Nature" },
			{ Who::Druid, Kind::SpellCooldown, 5, "Nature's Embrace" },
			{ Who::Druid, Kind::SpellDamage, 7, "Terra Burst" },
			{ Who::Druid, Kind::SpellCritical, 12, "Terra Burst" },
			{ Who::Druid, Kind::SpellDamage, 7, "Ice Burst" },
			{ Who::Druid, Kind::SpellCritical, 12, "Ice Burst" },
			{ Who::Druid, Kind::SpellCritical, 12, "Eternal Winter" },
			{ Who::Druid, Kind::SpellDamage, 8, "Eternal Winter" },
			{ Who::Druid, Kind::SpellDamage, 5, "Terra Wave" },
			{ Who::Druid, Kind::SpellCritical, 12, "Terra Wave" },
			{ Who::Druid, Kind::SpellDamage, 8, "Strong Ice Wave" },
			{ Who::Druid, Kind::SpellCritical, 15, "Strong Ice Wave" },
			{ Who::Druid, Kind::SpellHeal, 5, "Heal Friend" },
			{ Who::Druid, Kind::SpellHeal, 5, "Mass Healing" },
			{ Who::Druid, Kind::Revelation, 150, {}, Quadrant::Purple },
			{ Who::Druid, Kind::Revelation, 150, {}, Quadrant::Red },
			{ Who::Druid, Kind::Revelation, 150, {}, Quadrant::Blue },
			{ Who::Monk, Kind::SpellCooldown, 900, "Avatar of Balance" },
			{ Who::Monk, Kind::SpellHeal, 6, "Spirit Mend" },
			{ Who::Monk, Kind::SpellDamage, 5, "Spiritual Outburst" },
			{ Who::Monk, Kind::SpellCritical, 8, "Spiritual Outburst" },
			{ Who::Monk, Kind::SpellDamage, 10, "Forceful Uppercut" },
			{ Who::Monk, Kind::SpellCritical, 8, "Forceful Uppercut" },
			{ Who::Monk, Kind::SpellDamage, 7, "Flurry of Blows" },
			{ Who::Monk, Kind::SpellCritical, 8, "Flurry of Blows" },
			{ Who::Monk, Kind::SpellDamage, 5, "Greater Flurry of Blows" },
			{ Who::Monk, Kind::SpellCritical, 8, "Greater Flurry of Blows" },
			{ Who::Monk, Kind::SpellDamage, 5, "Sweeping Takedown" },
			{ Who::Monk, Kind::SpellCritical, 8, "Sweeping Takedown" },
			{ Who::Monk, Kind::SpellCooldown, 300, "Focus Serenity" },
			{ Who::Monk, Kind::SpellCooldown, 30, "Focus Harmony" },
			{ Who::Monk, Kind::SpellHeal, 5, "Mass Spirit Mend" },
			{ Who::Monk, Kind::Revelation, 150, {}, Quadrant::Purple },
			{ Who::Monk, Kind::Revelation, 150, {}, Quadrant::Red },
			{ Who::Monk, Kind::Revelation, 150, {}, Quadrant::Blue },
		} };

		[[nodiscard]] bool AppliesTo(Who who, Vocation vocation) noexcept
		{
			switch (who)
			{
				case Who::Everyone: return true;
				case Who::Mages: return vocation == Vocation::Sorcerer or vocation == Vocation::Druid;
				case Who::Knight: return vocation == Vocation::Knight;
				case Who::Paladin: return vocation == Vocation::Paladin;
				case Who::Sorcerer: return vocation == Vocation::Sorcerer;
				case Who::Druid: return vocation == Vocation::Druid;
				case Who::Monk: return vocation == Vocation::Monk;
			}
			return false;
		}

		// grade one is the gem as revealed; each fragment grade adds a tenth
		[[nodiscard]] double GradeMultiplier(uint8_t grade) noexcept
		{
			return 1.0 + 0.1 * std::min<uint8_t>(grade > 0 ? grade - 1 : 0, MaxGrade - 1);
		}

		[[nodiscard]] int32_t Graded(int32_t value, uint8_t grade) noexcept
		{
			return static_cast<int32_t>(std::lround(value * GradeMultiplier(grade)));
		}

		[[nodiscard]] size_t VocationIndex(Vocation vocation) noexcept
		{
			return vocation == Vocation::None ? 0 : std::to_underlying(vocation) - 1;
		}

		// health, mana and capacity a gem facet grants, by vocation; the
		// facets that pair a stat with a resistance grant half
		constexpr std::array<int32_t, VocationCount> GemHealth { 300, 200, 100, 100, 200 };
		constexpr std::array<int32_t, VocationCount> GemMana { 100, 300, 600, 600, 200 };
		constexpr std::array<int32_t, VocationCount> GemCapacity { 500, 400, 200, 200, 500 };

		void AddResistance(Bonuses& bonuses, CombatType_t type, int32_t hundredths) noexcept
		{
			const size_t index = combatTypeToIndex(type);
			if (index < bonuses.resistance.size())
			{
				bonuses.resistance[index] += hundredths;
			}
		}

		void AddSpellBonus(Bonuses& bonuses, std::string_view spell, const SpellBonus& bonus)
		{
			if (spell == FocusSpell)
			{
				for (const auto& name : FocusSpells)
				{
					bonuses.spell_bonuses[std::string(name)] += bonus;
				}
				return;
			}
			bonuses.spell_bonuses[std::string(spell)] += bonus;
		}

		[[nodiscard]] uint16_t QuadrantPoints(const State& state, Quadrant quadrant) noexcept
		{
			uint16_t total = 0;
			for (uint8_t slot = std::to_underlying(Slot::First); slot <= std::to_underlying(Slot::Last); ++slot)
			{
				if (Places[slot].quadrant == quadrant)
				{
					total += state.points[slot];
				}
			}
			return total;
		}

		[[nodiscard]] uint8_t StageOf(uint32_t points) noexcept
		{
			uint8_t stage = 0;
			for (const auto threshold : StageThresholds)
			{
				if (points >= threshold)
				{
					++stage;
				}
			}
			return stage;
		}

		// the slots in the order they are settled: the small inner ones first,
		// so a full slot is known before the slots that grow from it are checked
		[[nodiscard]] std::vector<Slot> SettleOrder()
		{
			std::vector<Slot> order;
			for (const uint8_t size : { 50, 75, 100, 150, 200 })
			{
				for (uint8_t slot = std::to_underlying(Slot::First); slot <= std::to_underlying(Slot::Last); ++slot)
				{
					if (Places[slot].max_points == size)
					{
						order.push_back(static_cast<Slot>(slot));
					}
				}
			}
			return order;
		}

		[[nodiscard]] uint16_t GemIndexOf(const State& state, uint32_t gemId) noexcept
		{
			for (uint16_t index = 0; index < state.gems.size(); ++index)
			{
				if (state.gems[index].id == gemId)
				{
					return index;
				}
			}
			return 0xFFFF;
		}

		[[nodiscard]] bool PayGold(const PlayerPtr& player, uint64_t cost)
		{
			if (cost == 0)
			{
				return true;
			}
			if (not player->payGold(cost))
			{
				player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have enough gold.");
				return false;
			}
			return true;
		}

		[[nodiscard]] uint16_t PercentOf(int32_t hundredths) noexcept
		{
			return static_cast<uint16_t>(std::max<int32_t>(0, (std::abs(hundredths) + 50) / 100));
		}
	}

	SpellBonus& SpellBonus::operator+=(const SpellBonus& other) noexcept
	{
		damage += other.damage;
		heal += other.heal;
		critical_damage += other.critical_damage;
		critical_chance += other.critical_chance;
		cooldown += other.cooldown;
		group_cooldown += other.group_cooldown;
		mana_cost += other.mana_cost;
		additional_targets += other.additional_targets;
		duration += other.duration;
		damage_reduction += other.damage_reduction;
		life_leech += other.life_leech;
		mana_leech += other.mana_leech;
		area = area or other.area;
		return *this;
	}

	bool System::loadConfig()
	{
		config = Config{};
		try
		{
			auto table = toml::parse_file("config/wheel.toml");
			config.enabled = table["enabled"].value_or(config.enabled);
			config.require_premium = table["require_premium"].value_or(config.require_premium);
			config.require_promotion = table["require_promotion"].value_or(config.require_promotion);
			config.points_per_level = table["points_per_level"].value_or(config.points_per_level);
			config.temple_range = table["temple_range"].value_or(config.temple_range);

			auto readCosts = [&](std::string_view key, std::array<uint64_t, 3>& costs)
			{
				if (const auto* array = table[key].as_array())
				{
					for (size_t index = 0; index < costs.size() and index < array->size(); ++index)
					{
						costs[index] = (*array)[index].value_or(costs[index]);
					}
				}
			};
			readCosts("reveal_cost", config.reveal_cost);
			readCosts("rotate_cost", config.rotate_cost);

			auto readGradeCosts = [&](std::string_view key, std::array<std::pair<uint64_t, uint8_t>, MaxGrade>& costs)
			{
				if (const auto* array = table[key].as_array())
				{
					for (size_t index = 0; index < costs.size() and index < array->size(); ++index)
					{
						if (const auto* row = (*array)[index].as_table())
						{
							costs[index].first = (*row)["gold"].value_or(costs[index].first);
							costs[index].second = (*row)["fragments"].value_or(costs[index].second);
						}
					}
				}
			};
			readGradeCosts("lesser_grade_cost", config.lesser_grade_cost);
			readGradeCosts("greater_grade_cost", config.greater_grade_cost);

			if (const auto* array = table["scroll_points"].as_array())
			{
				for (size_t index = 0; index < ScrollCount and index < array->size(); ++index)
				{
					config.scroll_points[index] = (*array)[index].value_or(config.scroll_points[index]);
				}
			}
		}
		catch (const toml::parse_error& err)
		{
			Console::Error("Wheel::System::loadConfig: failed to parse config/wheel.toml: {:s}", err.description());
			return false;
		}

		for (size_t vocation = 0; vocation < VocationCount; ++vocation)
		{
			for (size_t quality = 0; quality < 3; ++quality)
			{
				gem_items[vocation][quality] = Item::items.getItemIdByModernClientId(config.gem_appearances[vocation][quality]);
			}
		}
		fragment_items[std::to_underlying(FragmentType::Greater)] = Item::items.getItemIdByModernClientId(config.greater_fragment_appearance);
		fragment_items[std::to_underlying(FragmentType::Lesser)] = Item::items.getItemIdByModernClientId(config.lesser_fragment_appearance);
		for (size_t index = 0; index < ScrollCount; ++index)
		{
			scroll_items[index] = Item::items.getItemIdByModernClientId(config.scroll_appearances[index]);
		}

		if (gem_items[0][0] == 0 or fragment_items[0] == 0)
		{
			Console::Warn("Wheel::System::loadConfig: the gem or fragment appearances have no items; the atelier is disabled");
		}
		Console::Info("Wheel::System::loadConfig: the wheel of destiny is {:s}", config.enabled ? "enabled" : "disabled");
		return true;
	}

	const System::Place& System::getPlace(Slot slot) noexcept
	{
		const auto index = std::to_underlying(slot);
		return Places[index <= std::to_underlying(Slot::Last) ? index : 0];
	}

	const System::SlotBonus& System::getSlotBonus(Slot slot) noexcept
	{
		const auto index = std::to_underlying(slot);
		return SlotBonuses[index <= std::to_underlying(Slot::Last) ? index : 0];
	}

	System::Vocation System::getVocation(const PlayerPtr& player) noexcept
	{
		if (not player or not player->getVocation())
		{
			return Vocation::None;
		}
		const auto* vocation = player->getVocation();
		const uint32_t baseId = vocation->getFromVocation() != VOCATION_NONE ? vocation->getFromVocation() : vocation->getId();
		switch (baseId)
		{
			case 1: return Vocation::Sorcerer;
			case 2: return Vocation::Druid;
			case 3: return Vocation::Paladin;
			case 4: return Vocation::Knight;
			// the monk sits at 9 because 5 through 8 were already the promotions
			// when it arrived; the wheel's own Monk and its bonuses were waiting
			case 9: return Vocation::Monk;
			default: return Vocation::None;
		}
	}

	std::string_view System::instantName(Bonuses::Instant instant) noexcept
	{
		return InstantNames[std::min<size_t>(std::to_underlying(instant), InstantNames.size() - 1)];
	}

	std::string_view System::perkName(Bonuses::Perk perk) noexcept
	{
		return PerkNames[std::min<size_t>(std::to_underlying(perk), PerkNames.size() - 1)];
	}

	std::optional<Bonuses::Instant> System::instantByName(std::string_view name) noexcept
	{
		for (size_t index = 0; index < InstantNames.size(); ++index)
		{
			if (strcasecmp(InstantNames[index].data(), name.data()) == 0 and InstantNames[index].size() == name.size())
			{
				return static_cast<Instant>(index);
			}
		}
		return std::nullopt;
	}

	std::optional<Bonuses::Perk> System::perkByName(std::string_view name) noexcept
	{
		for (size_t index = 0; index < PerkNames.size(); ++index)
		{
			if (strcasecmp(PerkNames[index].data(), name.data()) == 0 and PerkNames[index].size() == name.size())
			{
				return static_cast<Perk>(index);
			}
		}
		return std::nullopt;
	}

	std::span<const Gem::BasicModifier> System::basicPositions() noexcept
	{
		return BasicPositions;
	}

	std::vector<Gem::SupremeModifier> System::supremePositions(Vocation vocation)
	{
		std::vector<Supreme> positions;
		for (size_t index = 0; index < SupremeEffects.size(); ++index)
		{
			if (AppliesTo(SupremeEffects[index].who, vocation))
			{
				positions.push_back(static_cast<Supreme>(index));
			}
		}
		return positions;
	}

	uint16_t System::getPoints(const PlayerPtr& player) const noexcept
	{
		if (not player or player->getLevel() < config.min_level)
		{
			return 0;
		}
		return static_cast<uint16_t>((player->getLevel() - (config.min_level - 1)) * config.points_per_level);
	}

	// promotion scrolls; the client adds its own point per fully graded modifier
	uint16_t System::getExtraPoints(const PlayerPtr& player) const noexcept
	{
		if (not player or player->getLevel() < config.min_level)
		{
			return 0;
		}
		uint16_t extra = 0;
		for (const auto itemId : player->getWheelState().scrolls)
		{
			extra += getScrollPoints(itemId);
		}
		return extra;
	}

	uint16_t System::getUsedPoints(const PlayerPtr& player) const noexcept
	{
		const auto& state = player->getWheelState();
		uint32_t used = 0;
		for (uint8_t slot = std::to_underlying(Slot::First); slot <= std::to_underlying(Slot::Last); ++slot)
		{
			used += state.points[slot];
		}
		return static_cast<uint16_t>(std::min<uint32_t>(used, 0xFFFF));
	}

	bool System::canOpen(const PlayerPtr& player) const noexcept
	{
		if (not config.enabled or not player or getVocation(player) == Vocation::None)
		{
			return false;
		}
		if (player->getLevel() < config.min_level)
		{
			return false;
		}
		if (config.require_premium and not player->isPremium())
		{
			return false;
		}
		if (config.require_promotion and not player->isPromoted())
		{
			return false;
		}
		return true;
	}

	// points come back only in a temple; elsewhere they may only be added
	System::Options System::getOptions(const PlayerPtr& player, uint32_t ownerId) const
	{
		if (player->getID() != ownerId)
		{
			return Options::Locked;
		}
		if (player->getZone() == ZONE_PROTECTION)
		{
			const auto& position = player->getPosition();
			for (const auto& [townId, town] : g_game.map.towns.getTowns())
			{
				const auto& temple = town->getTemplePosition();
				if (temple.z == position.z and Position::areInRange(temple, position, config.temple_range, config.temple_range))
				{
					return Options::Free;
				}
			}
		}
		return Options::AddOnly;
	}

	uint16_t System::getGemItemId(Vocation vocation, Gem::Quality quality) const noexcept
	{
		if (vocation == Vocation::None)
		{
			return 0;
		}
		return gem_items[VocationIndex(vocation)][std::min<size_t>(std::to_underlying(quality), 2)];
	}

	uint16_t System::getFragmentItemId(FragmentType type) const noexcept
	{
		return fragment_items[std::min<size_t>(std::to_underlying(type), 1)];
	}

	uint16_t System::getScrollItemId(uint8_t index) const noexcept
	{
		return index < ScrollCount ? scroll_items[index] : 0;
	}

	uint8_t System::getScrollPoints(uint16_t itemId) const noexcept
	{
		for (size_t index = 0; index < ScrollCount; ++index)
		{
			if (scroll_items[index] != 0 and scroll_items[index] == itemId)
			{
				return config.scroll_points[index];
			}
		}
		return 0;
	}

	// a slot holds points once the character has enough of them and, for
	// every slot but the four innermost, one of the slots it grows from is full
	bool System::canHoldPoints(const State& state, Slot slot, uint16_t budget) const noexcept
	{
		const auto& place = getPlace(slot);
		if (budget < place.points_required)
		{
			return false;
		}
		if (place.neighbours[0] == Slot::None)
		{
			return true;
		}
		for (const auto neighbour : place.neighbours)
		{
			if (neighbour == Slot::None)
			{
				break;
			}
			if (state.points[std::to_underlying(neighbour)] == getPlace(neighbour).max_points)
			{
				return true;
			}
		}
		return false;
	}

	bool System::save(const PlayerPtr& player, const std::array<uint16_t, SlotCount + 1>& points, const std::array<uint16_t, QuadrantCount>& vessels) const
	{
		if (not canOpen(player))
		{
			return false;
		}

		auto& state = player->getWheelState();
		const auto options = getOptions(player, player->getID());
		if (options == Options::Locked)
		{
			return false;
		}

		uint32_t gradedModifiers = 0;
		for (const auto grade : state.basic_grades)
		{
			gradedModifiers += grade == MaxGrade ? 1 : 0;
		}
		for (const auto grade : state.supreme_grades)
		{
			gradedModifiers += grade == MaxGrade ? 1 : 0;
		}
		const uint16_t budget = static_cast<uint16_t>(std::min<uint32_t>(getPoints(player) + getExtraPoints(player) + gradedModifiers, 0xFFFF));

		// settle the small slots first; a slot that cannot be settled yet
		// waits for a later pass, since its neighbour may fill in this one
		State working = state;
		working.points.fill(0);
		uint32_t spent = 0;
		std::vector<Slot> pending = SettleOrder();
		for (uint8_t pass = 0; pass < 6 and not pending.empty(); ++pass)
		{
			std::vector<Slot> retry;
			auto wanting = pending | std::views::filter([&](Slot slot) { return points[std::to_underlying(slot)] != 0; });
			for (const auto slot : wanting)
			{
				const auto index = std::to_underlying(slot);
				const uint16_t wanted = points[index];
				if (wanted > getPlace(slot).max_points or spent + wanted > budget or (options == Options::AddOnly and wanted < state.points[index]))
				{
					Console::Warn("Wheel::System::save: {:s} sent {:d} points for slot {:d}; the wheel was not saved", player->getName(), wanted, index);
					player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something went wrong with your wheel; please open it again.");
					return false;
				}
				if (canHoldPoints(working, slot, budget))
				{
					working.points[index] = wanted;
					spent += wanted;
				}
				else
				{
					retry.push_back(slot);
				}
			}
			pending = std::move(retry);
		}

		if (not pending.empty())
		{
			Console::Warn("Wheel::System::save: {:s} sent points for slots that are not open; the wheel was not saved", player->getName());
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "Something went wrong with your wheel; please open it again.");
			return false;
		}

		state.points = working.points;

		// the vessels: one gem of the matching domain each, or none
		for (auto& gem : state.gems)
		{
			gem.vessel = NoVessel;
		}
		for (uint8_t domain = 0; domain < QuadrantCount; ++domain)
		{
			const uint16_t index = vessels[domain];
			if (index < state.gems.size() and std::to_underlying(state.gems[index].domain) == domain)
			{
				state.gems[index].vessel = domain;
			}
		}

		apply(player);
		player->sendWheelWindow(player->getID());
		return true;
	}

	void System::rollGem(Vocation vocation, Gem& gem) const
	{
		gem.first_modifier = FirstFacet[uniform_random(0, static_cast<int32_t>(FirstFacet.size()) - 1)];
		gem.second_modifier = gem.first_modifier;
		if (gem.quality >= Gem::Quality::Regular)
		{
			while (gem.second_modifier == gem.first_modifier)
			{
				gem.second_modifier = SecondFacet[uniform_random(0, static_cast<int32_t>(SecondFacet.size()) - 1)];
			}
		}
		if (gem.quality >= Gem::Quality::Greater)
		{
			const auto positions = supremePositions(vocation);
			if (not positions.empty())
			{
				gem.supreme_modifier = positions[uniform_random(0, static_cast<int32_t>(positions.size()) - 1)];
			}
		}
	}

	// a first visit finds a lesser and a regular gem of every domain waiting
	void System::grantInitialGems(const PlayerPtr& player) const
	{
		auto& state = player->getWheelState();
		if (not state.gems.empty())
		{
			return;
		}
		const auto vocation = getVocation(player);
		for (uint8_t domain = 0; domain < QuadrantCount; ++domain)
		{
			for (const auto quality : { Gem::Quality::Lesser, Gem::Quality::Regular })
			{
				Gem gem;
				gem.id = state.next_gem_id++;
				gem.domain = static_cast<Gem::Domain>(domain);
				gem.quality = quality;
				rollGem(vocation, gem);
				state.gems.push_back(gem);
			}
		}
	}

	void System::revealGem(const PlayerPtr& player, Gem::Quality quality) const
	{
		if (not canOpen(player))
		{
			return;
		}
		const auto vocation = getVocation(player);
		const uint16_t gemItemId = getGemItemId(vocation, quality);
		if (gemItemId == 0 or player->getItemTypeCount(gemItemId) == 0)
		{
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need a gem of that quality to reveal.");
			return;
		}
		if (not PayGold(player, config.reveal_cost[std::min<size_t>(std::to_underlying(quality), 2)]))
		{
			return;
		}
		player->removeItemOfType(gemItemId, 1, -1);

		auto& state = player->getWheelState();
		Gem gem;
		gem.id = state.next_gem_id++;
		gem.domain = static_cast<Gem::Domain>(uniform_random(0, QuadrantCount - 1));
		gem.quality = quality;
		rollGem(vocation, gem);
		state.gems.push_back(gem);

		player->sendWheelGemRevealed(GemIndexOf(state, gem.id));
		sendResourceBalances(player);
		player->sendWheelWindow(player->getID());
	}

	// a broken gem leaves fragments behind, unless it was locked
	void System::destroyGem(const PlayerPtr& player, uint16_t index) const
	{
		auto& state = player->getWheelState();
		if (index >= state.gems.size() or state.gems[index].locked)
		{
			return;
		}

		const auto quality = state.gems[index].quality;
		uint16_t fragmentId = 0;
		uint16_t count = 0;
		switch (quality)
		{
			case Gem::Quality::Lesser:
				fragmentId = getFragmentItemId(FragmentType::Lesser);
				count = static_cast<uint16_t>(normal_random(1, 5));
				break;
			case Gem::Quality::Regular:
				fragmentId = getFragmentItemId(FragmentType::Lesser);
				count = static_cast<uint16_t>(normal_random(2, 10));
				break;
			case Gem::Quality::Greater:
				fragmentId = getFragmentItemId(FragmentType::Greater);
				count = static_cast<uint16_t>(normal_random(1, 5));
				break;
		}

		if (fragmentId != 0 and count > 0)
		{
			if (g_game.internalPlayerAddItem(player, Item::CreateItem(fragmentId, count), false) != RETURNVALUE_NOERROR)
			{
				player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no room for the fragments.");
				return;
			}
		}

		state.gems.erase(state.gems.begin() + index);
		apply(player);
		sendResourceBalances(player);
		player->sendWheelWindow(player->getID());
	}

	// the domain turns green, red, blue, purple and round again
	void System::switchGemDomain(const PlayerPtr& player, uint16_t index) const
	{
		auto& state = player->getWheelState();
		if (index >= state.gems.size() or state.gems[index].locked)
		{
			return;
		}
		auto& gem = state.gems[index];
		if (not PayGold(player, config.rotate_cost[std::min<size_t>(std::to_underlying(gem.quality), 2)]))
		{
			return;
		}
		gem.domain = static_cast<Gem::Domain>((std::to_underlying(gem.domain) + 1) % QuadrantCount);
		gem.vessel = NoVessel;
		apply(player);
		sendResourceBalances(player);
		player->sendWheelWindow(player->getID());
	}

	void System::toggleGemLock(const PlayerPtr& player, uint16_t index) const
	{
		auto& state = player->getWheelState();
		if (index >= state.gems.size())
		{
			return;
		}
		state.gems[index].locked = not state.gems[index].locked;
		player->sendWheelWindow(player->getID());
	}

	// fragments and gold raise a modifier's grade for every gem that carries it
	void System::improveGemGrade(const PlayerPtr& player, FragmentType type, uint8_t position) const
	{
		if (not canOpen(player))
		{
			return;
		}
		auto& state = player->getWheelState();
		std::span<uint8_t> grades = type == FragmentType::Lesser ? std::span<uint8_t>(state.basic_grades) : std::span<uint8_t>(state.supreme_grades);
		if (position >= grades.size() or grades[position] >= MaxGrade)
		{
			return;
		}

		const auto& costs = type == FragmentType::Lesser ? config.lesser_grade_cost : config.greater_grade_cost;
		const auto& [gold, fragments] = costs[grades[position]];
		const uint16_t fragmentId = getFragmentItemId(type);
		if (fragmentId == 0 or player->getItemTypeCount(fragmentId) < fragments)
		{
			player->sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have enough fragments.");
			return;
		}
		if (not PayGold(player, gold))
		{
			return;
		}
		player->removeItemOfType(fragmentId, fragments, -1);
		++grades[position];
		apply(player);
		sendResourceBalances(player);
		player->sendWheelWindow(player->getID());
	}

	bool System::unlockScroll(const PlayerPtr& player, uint16_t itemId) const
	{
		if (getScrollPoints(itemId) == 0)
		{
			return false;
		}
		auto& scrolls = player->getWheelState().scrolls;
		if (std::ranges::find(scrolls, itemId) != scrolls.end())
		{
			return false;
		}
		scrolls.push_back(itemId);
		return true;
	}

	// what one slot's points grant; a full slot also hands out its reward
	void System::applySlot(const PlayerPtr& player, Slot slot, Bonuses& bonuses) const
	{
		const auto& state = player->getWheelState();
		const uint16_t points = state.points[std::to_underlying(slot)];
		if (points == 0)
		{
			return;
		}

		const auto vocation = getVocation(player);
		const size_t vocationIndex = VocationIndex(vocation);
		const auto& bonus = getSlotBonus(slot);
		auto grant = [&](PointStat stat)
		{
			switch (stat)
			{
				case PointStat::Health: bonuses.health += HealthPerPoint[vocationIndex] * points; break;
				case PointStat::Mana: bonuses.mana += ManaPerPoint[vocationIndex] * points; break;
				case PointStat::Capacity: bonuses.capacity += CapacityPerPoint[vocationIndex] * points * 100; break;
				case PointStat::Mitigation: bonuses.mitigation += MitigationPerPoint * points; break;
				case PointStat::None: break;
			}
		};
		grant(bonus.first);
		grant(bonus.second);

		if (points < getPlace(slot).max_points)
		{
			return;
		}

		switch (bonus.reward)
		{
			case Reward::Skill:
				switch (vocation)
				{
					case Vocation::Knight: ++bonuses.melee; break;
					case Vocation::Paladin: ++bonuses.distance; break;
					case Vocation::Sorcerer:
					case Vocation::Druid: ++bonuses.magic; break;
					case Vocation::Monk: ++bonuses.fist; break;
					case Vocation::None: break;
				}
				break;
			case Reward::LifeLeech: bonuses.life_leech += LifeLeechPerReward; break;
			case Reward::ManaLeech: bonuses.mana_leech += ManaLeechPerReward; break;
			case Reward::Vessel: ++bonuses.vessel_resonance[std::to_underlying(getPlace(slot).quadrant)]; break;
			case Reward::Spell:
				if (const auto name = bonus.spells[vocationIndex]; not name.empty())
				{
					auto& grade = bonuses.spell_grades[std::string(name)];
					grade = std::min<uint8_t>(grade + 1, 2);
				}
				break;
			case Reward::Instant: bonuses.instants[std::to_underlying(bonus.instants[vocationIndex])] = true; break;
			case Reward::None: break;
		}
	}

	void System::applyBasicModifier(Vocation vocation, Gem::BasicModifier modifier, uint8_t grade, Bonuses& bonuses) const
	{
		const size_t vocationIndex = VocationIndex(vocation);
		auto resist = [&](CombatType_t type, int32_t hundredths) { AddResistance(bonuses, type, Graded(hundredths, grade)); };
		auto weaken = [&](CombatType_t type, int32_t hundredths) { AddResistance(bonuses, type, -hundredths); };
		auto health = [&](bool half) { bonuses.health += Graded(GemHealth[vocationIndex] / (half ? 2 : 1), grade); };
		auto mana = [&](bool half) { bonuses.mana += Graded(GemMana[vocationIndex] / (half ? 2 : 1), grade); };
		auto capacity = [&](bool half) { bonuses.capacity += Graded(GemCapacity[vocationIndex] / (half ? 2 : 1), grade) * 100; };

		switch (modifier)
		{
			case Basic::GeneralPhysicalResistance: resist(COMBAT_PHYSICALDAMAGE, 100); break;
			case Basic::GeneralHolyResistance: resist(COMBAT_HOLYDAMAGE, 100); break;
			case Basic::GeneralDeathResistance: resist(COMBAT_DEATHDAMAGE, 100); break;
			case Basic::GeneralFireResistance: resist(COMBAT_FIREDAMAGE, 200); break;
			case Basic::GeneralEarthResistance: resist(COMBAT_EARTHDAMAGE, 200); break;
			case Basic::GeneralIceResistance: resist(COMBAT_ICEDAMAGE, 200); break;
			case Basic::GeneralEnergyResistance: resist(COMBAT_ENERGYDAMAGE, 200); break;
			case Basic::GeneralHolyResistanceDeathWeakness: resist(COMBAT_HOLYDAMAGE, 150); weaken(COMBAT_DEATHDAMAGE, 100); break;
			case Basic::GeneralDeathResistanceHolyWeakness: resist(COMBAT_DEATHDAMAGE, 150); weaken(COMBAT_HOLYDAMAGE, 100); break;
			case Basic::GeneralFireResistanceEarthResistance: resist(COMBAT_FIREDAMAGE, 100); resist(COMBAT_EARTHDAMAGE, 100); break;
			case Basic::GeneralFireResistanceIceResistance: resist(COMBAT_FIREDAMAGE, 100); resist(COMBAT_ICEDAMAGE, 100); break;
			case Basic::GeneralFireResistanceEnergyResistance: resist(COMBAT_FIREDAMAGE, 100); resist(COMBAT_ENERGYDAMAGE, 100); break;
			case Basic::GeneralEarthResistanceIceResistance: resist(COMBAT_EARTHDAMAGE, 100); resist(COMBAT_ICEDAMAGE, 100); break;
			case Basic::GeneralEarthResistanceEnergyResistance: resist(COMBAT_EARTHDAMAGE, 100); resist(COMBAT_ENERGYDAMAGE, 100); break;
			case Basic::GeneralIceResistanceEnergyResistance: resist(COMBAT_ICEDAMAGE, 100); resist(COMBAT_ENERGYDAMAGE, 100); break;
			case Basic::GeneralFireResistanceEarthWeakness: resist(COMBAT_FIREDAMAGE, 300); weaken(COMBAT_EARTHDAMAGE, 200); break;
			case Basic::GeneralFireResistanceIceWeakness: resist(COMBAT_FIREDAMAGE, 300); weaken(COMBAT_ICEDAMAGE, 200); break;
			case Basic::GeneralFireResistanceEnergyWeakness: resist(COMBAT_FIREDAMAGE, 300); weaken(COMBAT_ENERGYDAMAGE, 200); break;
			case Basic::GeneralEarthResistanceFireWeakness: resist(COMBAT_EARTHDAMAGE, 300); weaken(COMBAT_FIREDAMAGE, 200); break;
			case Basic::GeneralEarthResistanceIceWeakness: resist(COMBAT_EARTHDAMAGE, 300); weaken(COMBAT_ICEDAMAGE, 200); break;
			case Basic::GeneralEarthResistanceEnergyWeakness: resist(COMBAT_EARTHDAMAGE, 300); weaken(COMBAT_ENERGYDAMAGE, 200); break;
			case Basic::GeneralIceResistanceEarthWeakness: resist(COMBAT_ICEDAMAGE, 300); weaken(COMBAT_EARTHDAMAGE, 200); break;
			case Basic::GeneralIceResistanceFireWeakness: resist(COMBAT_ICEDAMAGE, 300); weaken(COMBAT_FIREDAMAGE, 200); break;
			case Basic::GeneralIceResistanceEnergyWeakness: resist(COMBAT_ICEDAMAGE, 300); weaken(COMBAT_ENERGYDAMAGE, 200); break;
			case Basic::GeneralEnergyResistanceEarthWeakness: resist(COMBAT_ENERGYDAMAGE, 300); weaken(COMBAT_EARTHDAMAGE, 200); break;
			case Basic::GeneralEnergyResistanceIceWeakness: resist(COMBAT_ENERGYDAMAGE, 300); weaken(COMBAT_ICEDAMAGE, 200); break;
			case Basic::GeneralEnergyResistanceFireWeakness: resist(COMBAT_ENERGYDAMAGE, 300); weaken(COMBAT_FIREDAMAGE, 200); break;
			case Basic::GeneralManaDrainResistance: resist(COMBAT_MANADRAIN, 300); break;
			case Basic::GeneralLifeDrainResistance: resist(COMBAT_LIFEDRAIN, 300); break;
			case Basic::GeneralManaDrainResistanceLifeDrainResistance: resist(COMBAT_MANADRAIN, 150); resist(COMBAT_LIFEDRAIN, 150); break;
			case Basic::GeneralMitigationMultiplier: bonuses.mitigation += Graded(500, grade); break;
			case Basic::VocationHealth: health(false); break;
			case Basic::VocationManaCapacity: mana(true); capacity(true); break;
			case Basic::VocationManaFireResistance: mana(true); resist(COMBAT_FIREDAMAGE, 100); break;
			case Basic::VocationManaEnergyResistance: mana(true); resist(COMBAT_ENERGYDAMAGE, 100); break;
			case Basic::VocationManaEarthResistance: mana(true); resist(COMBAT_EARTHDAMAGE, 100); break;
			case Basic::VocationManaIceResistance: mana(true); resist(COMBAT_ICEDAMAGE, 100); break;
			case Basic::VocationMana: mana(false); break;
			case Basic::VocationHealthFireResistance: health(true); resist(COMBAT_FIREDAMAGE, 100); break;
			case Basic::VocationHealthEnergyResistance: health(true); resist(COMBAT_ENERGYDAMAGE, 100); break;
			case Basic::VocationHealthEarthResistance: health(true); resist(COMBAT_EARTHDAMAGE, 100); break;
			case Basic::VocationHealthIceResistance: health(true); resist(COMBAT_ICEDAMAGE, 100); break;
			case Basic::VocationMixed: health(true); mana(true); capacity(true); break;
			case Basic::VocationMixed2: health(true); mana(true); capacity(true); break;
			case Basic::VocationCapacityFireResistance: capacity(true); resist(COMBAT_FIREDAMAGE, 100); break;
			case Basic::VocationCapacityEnergyResistance: capacity(true); resist(COMBAT_ENERGYDAMAGE, 100); break;
			case Basic::VocationCapacityEarthResistance: capacity(true); resist(COMBAT_EARTHDAMAGE, 100); break;
			case Basic::VocationCapacityIceResistance: capacity(true); resist(COMBAT_ICEDAMAGE, 100); break;
			case Basic::VocationCapacity: capacity(false); break;
		}
	}

	void System::applySupremeModifier(Gem::SupremeModifier modifier, uint8_t grade, Bonuses& bonuses) const
	{
		const auto index = std::to_underlying(modifier);
		if (index >= SupremeEffects.size())
		{
			return;
		}
		const auto& effect = SupremeEffects[index];
		switch (effect.kind)
		{
			case Kind::Dodge: bonuses.dodge += Graded(effect.value, grade); break;
			case Kind::CriticalDamage: bonuses.critical_damage += Graded(effect.value, grade); break;
			case Kind::LifeLeech: bonuses.life_leech += Graded(effect.value, grade); break;
			case Kind::ManaLeech: bonuses.mana_leech += Graded(effect.value, grade); break;
			case Kind::Revelation: bonuses.revelation_points[std::to_underlying(effect.quadrant)] += static_cast<uint16_t>(Graded(effect.value, grade)); break;
			case Kind::SpellDamage: AddSpellBonus(bonuses, effect.spell, Damage(Graded(effect.value, grade))); break;
			case Kind::SpellCritical: AddSpellBonus(bonuses, effect.spell, Critical(Graded(effect.value, grade), 0)); break;
			case Kind::SpellHeal: AddSpellBonus(bonuses, effect.spell, Heal(Graded(effect.value, grade))); break;
			case Kind::SpellCooldown: AddSpellBonus(bonuses, effect.spell, Cooldown(effect.value)); break;
		}
	}

	// a gem in its vessel awakens one facet per resonating slot of its domain
	void System::applyGems(const PlayerPtr& player, Bonuses& bonuses) const
	{
		const auto& state = player->getWheelState();
		const auto vocation = getVocation(player);
		auto placed = state.gems | std::views::filter([](const Gem& gem) { return gem.vessel != NoVessel and gem.vessel < QuadrantCount; });
		for (const auto& gem : placed)
		{
			const uint8_t resonance = bonuses.vessel_resonance[gem.vessel];
			if (resonance >= 1)
			{
				applyBasicModifier(vocation, gem.first_modifier, state.basic_grades[std::to_underlying(gem.first_modifier)], bonuses);
			}
			if (resonance >= 2 and gem.quality >= Gem::Quality::Regular)
			{
				applyBasicModifier(vocation, gem.second_modifier, state.basic_grades[std::to_underlying(gem.second_modifier)], bonuses);
			}
			if (resonance >= 3 and gem.quality >= Gem::Quality::Greater)
			{
				applySupremeModifier(gem.supreme_modifier, state.supreme_grades[std::to_underlying(gem.supreme_modifier)], bonuses);
			}
		}
	}

	// every quadrant reveals its perk in three stages as points gather in it
	void System::applyStages(const PlayerPtr& player, Bonuses& bonuses) const
	{
		const auto& state = player->getWheelState();
		const size_t vocationIndex = VocationIndex(getVocation(player));
		for (const auto quadrant : QuadrantOrder)
		{
			const auto index = std::to_underlying(quadrant);
			const uint8_t stage = StageOf(QuadrantPoints(state, quadrant) + bonuses.revelation_points[index]);
			bonuses.stages[index] = stage;
			if (stage != 0)
			{
				bonuses.damage += RevelationDamage[stage - 1];
				bonuses.healing += RevelationDamage[stage - 1];
				switch (quadrant)
				{
					case Quadrant::Green: bonuses.perks[std::to_underlying(Perk::GiftOfLife)] = stage; break;
					case Quadrant::Red: bonuses.perks[std::to_underlying(RedPerks[vocationIndex])] = stage; break;
					case Quadrant::Blue: bonuses.perks[std::to_underlying(BluePerks[vocationIndex])] = stage; break;
					case Quadrant::Purple: bonuses.perks[std::to_underlying(PurplePerks[vocationIndex])] = stage; break;
				}
			}
		}
	}

	void System::applySpellGrades(Vocation vocation, Bonuses& bonuses) const
	{
		for (const auto& [name, grade] : bonuses.spell_grades)
		{
			auto matches = SpellGrades | std::views::filter([&](const SpellGrade& entry) { return entry.vocation == vocation and entry.name == name; });
			for (const auto& entry : matches)
			{
				AddSpellBonus(bonuses, entry.name, entry.first);
				if (grade >= 2)
				{
					AddSpellBonus(bonuses, entry.name, entry.second);
				}
			}
		}
	}

	Bonuses System::compute(const PlayerPtr& player) const
	{
		Bonuses bonuses;
		if (not canOpen(player))
		{
			return bonuses;
		}
		for (uint8_t slot = std::to_underlying(Slot::First); slot <= std::to_underlying(Slot::Last); ++slot)
		{
			applySlot(player, static_cast<Slot>(slot), bonuses);
		}
		applyGems(player, bonuses);
		applyStages(player, bonuses);
		applySpellGrades(getVocation(player), bonuses);
		return bonuses;
	}

	// take back what the wheel last wrote onto the character
	void System::clear(const PlayerPtr& player) const
	{
		auto& state = player->getWheelState();
		if (not state.applied_any)
		{
			return;
		}
		const auto& applied = state.applied;
		player->setVarStats(STAT_MAXHITPOINTS, -applied.health);
		player->setVarStats(STAT_MAXMANAPOINTS, -applied.mana);
		player->setVarStats(STAT_MAGICPOINTS, -applied.magic);
		player->setVarSkill(SKILL_CLUB, -applied.melee);
		player->setVarSkill(SKILL_SWORD, -applied.melee);
		player->setVarSkill(SKILL_AXE, -applied.melee);
		player->setVarSkill(SKILL_DISTANCE, -applied.distance);
		player->setVarSkill(SKILL_FIST, -applied.fist);
		player->wheel_capacity = 0;
		player->removeAugment(augmentName());
		state.applied = Bonuses{};
		state.applied_any = false;
	}

	// rebuild the bonuses and write them onto the character: stats and skills
	// directly, resistances and leeches as one augment named after the wheel
	void System::apply(const PlayerPtr& player) const
	{
		clear(player);
		auto& state = player->getWheelState();
		state.bonuses = compute(player);
		const auto& bonuses = state.bonuses;

		player->setVarStats(STAT_MAXHITPOINTS, bonuses.health);
		player->setVarStats(STAT_MAXMANAPOINTS, bonuses.mana);
		player->setVarStats(STAT_MAGICPOINTS, bonuses.magic);
		player->setVarSkill(SKILL_CLUB, bonuses.melee);
		player->setVarSkill(SKILL_SWORD, bonuses.melee);
		player->setVarSkill(SKILL_AXE, bonuses.melee);
		player->setVarSkill(SKILL_DISTANCE, bonuses.distance);
		player->setVarSkill(SKILL_FIST, bonuses.fist);
		player->wheel_capacity = static_cast<uint32_t>(std::max<int32_t>(0, bonuses.capacity));

		using Stance = DamageModifier::Stance;
		using Attack = DamageModifier::AttackType;
		using Defense = DamageModifier::DefenseType;
		using Factor = DamageModifier::Factor;
		auto augment = Augment::MakeAugment(augmentName(), "The wheel of destiny");
		bool anyModifier = false;
		auto addModifier = [&](Stance stance, uint8_t type, int32_t hundredths, CombatType_t combatType)
		{
			const uint16_t percent = PercentOf(hundredths);
			if (percent == 0)
			{
				return;
			}
			augment->addModifier(DamageModifier(std::to_underlying(stance), type, percent, std::to_underlying(Factor::Percent), 100, combatType));
			anyModifier = true;
		};

		for (size_t index = 0; index < bonuses.resistance.size(); ++index)
		{
			const int32_t value = bonuses.resistance[index];
			if (value > 0)
			{
				addModifier(Stance::Defense, std::to_underlying(Defense::Resist), value, indexToCombatType(index));
			}
			else if (value < 0)
			{
				addModifier(Stance::Defense, std::to_underlying(Defense::Weakness), -value, indexToCombatType(index));
			}
		}
		addModifier(Stance::Defense, std::to_underlying(Defense::Resist), bonuses.mitigation, COMBAT_NONE);
		addModifier(Stance::Attack, std::to_underlying(Attack::Lifesteal), bonuses.life_leech, COMBAT_NONE);
		addModifier(Stance::Attack, std::to_underlying(Attack::Manasteal), bonuses.mana_leech, COMBAT_NONE);
		addModifier(Stance::Attack, std::to_underlying(Attack::Regeneration), bonuses.healing * 100, COMBAT_NONE);
		if (anyModifier)
		{
			player->addAugment(augment);
		}

		state.applied = bonuses;
		state.applied_any = true;
		player->sendStats();
		player->sendSkills();
	}

	const SpellBonus* System::getSpellBonus(const Player& player, std::string_view spellName) const noexcept
	{
		const auto& bonuses = player.getWheelState().bonuses.spell_bonuses;
		const auto it = bonuses.find(std::string(spellName));
		return it != bonuses.end() ? &it->second : nullptr;
	}

	// the atelier shows gold, gems and fragments; the client reads them off the balances
	void System::sendResourceBalances(const PlayerPtr& player) const
	{
		using Resource = BlackTek::Network::ResourceType;
		const auto vocation = getVocation(player);
		player->sendResourceBalance(Resource::Bank, player->getBankBalance());
		player->sendResourceBalance(Resource::Inventory, player->getMoney());
		auto count = [&](uint16_t itemId) -> uint64_t { return itemId != 0 ? player->getItemTypeCount(itemId) : 0; };
		player->sendResourceBalance(Resource::LesserGems, count(getGemItemId(vocation, Gem::Quality::Lesser)));
		player->sendResourceBalance(Resource::RegularGems, count(getGemItemId(vocation, Gem::Quality::Regular)));
		player->sendResourceBalance(Resource::GreaterGems, count(getGemItemId(vocation, Gem::Quality::Greater)));
		player->sendResourceBalance(Resource::LesserFragments, count(getFragmentItemId(FragmentType::Lesser)));
		player->sendResourceBalance(Resource::GreaterFragments, count(getFragmentItemId(FragmentType::Greater)));
	}
}
