// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include "const.h"
#include "enums.h"

#include <array>
#include <cstdint>
#include <map>
#include <memory>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

class Player;
using PlayerPtr = std::shared_ptr<Player>;

namespace BlackTek::Wheel
{
	constexpr uint8_t SlotCount = 36;
	constexpr uint8_t QuadrantCount = 4;
	constexpr uint8_t VocationCount = 5;
	constexpr uint8_t MaxGrade = 3;
	constexpr uint8_t ScrollCount = 5;
	constexpr uint8_t BasicModifierCount = 49; // the highest basic modifier value plus one
	constexpr uint8_t BasicPositionCount = 46; // the modifiers the client lists a grade for
	constexpr uint8_t SupremeModifierCount = 94;
	constexpr uint8_t SupremePositionCount = 23; // per vocation
	constexpr uint8_t NoVessel = 0xFF;

	// a gem as the atelier revealed it; every value here is one the
	// client names, so the numbers never change
	struct Gem
	{
		enum class Quality : uint8_t
		{
			Lesser = 0,
			Regular = 1,
			Greater = 2,
		};

		enum class Domain : uint8_t
		{
			Green = 0,
			Red = 1,
			Blue = 2,
			Purple = 3,
		};

		enum class BasicModifier : uint8_t
		{
			GeneralPhysicalResistance = 0,
			GeneralHolyResistance = 1,
			GeneralDeathResistance = 2,
			GeneralFireResistance = 3,
			GeneralEarthResistance = 4,
			GeneralIceResistance = 5,
			GeneralEnergyResistance = 6,
			GeneralHolyResistanceDeathWeakness = 7,
			GeneralDeathResistanceHolyWeakness = 8,
			GeneralFireResistanceEarthResistance = 9,
			GeneralFireResistanceIceResistance = 10,
			GeneralFireResistanceEnergyResistance = 11,
			GeneralEarthResistanceIceResistance = 12,
			GeneralEarthResistanceEnergyResistance = 13,
			GeneralIceResistanceEnergyResistance = 14,
			GeneralFireResistanceEarthWeakness = 15,
			GeneralFireResistanceIceWeakness = 16,
			GeneralFireResistanceEnergyWeakness = 17,
			GeneralEarthResistanceFireWeakness = 18,
			GeneralEarthResistanceIceWeakness = 19,
			GeneralEarthResistanceEnergyWeakness = 20,
			GeneralIceResistanceEarthWeakness = 21,
			GeneralIceResistanceFireWeakness = 22,
			GeneralIceResistanceEnergyWeakness = 23,
			GeneralEnergyResistanceEarthWeakness = 24,
			GeneralEnergyResistanceIceWeakness = 25,
			GeneralEnergyResistanceFireWeakness = 26,
			GeneralManaDrainResistance = 27,
			GeneralLifeDrainResistance = 28,
			GeneralManaDrainResistanceLifeDrainResistance = 29,
			GeneralMitigationMultiplier = 30,
			VocationHealth = 31,
			VocationManaCapacity = 32, // never rolled; kept so the numbers line up
			VocationManaFireResistance = 33,
			VocationManaEnergyResistance = 34,
			VocationManaEarthResistance = 35,
			VocationManaIceResistance = 36,
			VocationMana = 37,
			VocationHealthFireResistance = 38,
			VocationHealthEnergyResistance = 39,
			VocationHealthEarthResistance = 40,
			VocationHealthIceResistance = 41,
			VocationMixed = 42,
			VocationMixed2 = 43,
			VocationCapacityFireResistance = 44,
			VocationCapacityEnergyResistance = 45,
			VocationCapacityEarthResistance = 46,
			VocationCapacityIceResistance = 47,
			VocationCapacity = 48,
		};

		enum class SupremeModifier : uint8_t
		{
			GeneralDodge = 0,
			GeneralCriticalDamage = 1,
			GeneralLifeLeech = 2,
			GeneralManaLeech = 3,
			SorcererDruidUltimateHealing = 4,
			GeneralRevelationMasteryGiftOfLife = 5,
			KnightAvatarOfSteelCooldown = 6,
			KnightExecutionersThrowCooldown = 7,
			KnightExecutionersThrowDamage = 8,
			KnightExecutionersThrowCritical = 9,
			KnightFierceBerserkDamage = 10,
			KnightFierceBerserkCritical = 11,
			KnightBerserkDamage = 12,
			KnightBerserkCritical = 13,
			KnightFrontSweepCritical = 14,
			KnightFrontSweepDamage = 15,
			KnightGroundshakerDamage = 16,
			KnightGroundshakerCritical = 17,
			KnightAnnihilationCritical = 18,
			KnightAnnihilationDamage = 19,
			KnightFairWoundCleansingHealing = 20,
			KnightRevelationMasteryAvatarOfSteel = 21,
			KnightRevelationMasteryExecutionersThrow = 22,
			KnightRevelationMasteryCombatMastery = 23,
			PaladinAvatarOfLightCooldown = 24,
			PaladinDivineDazzleCooldown = 25,
			PaladinDivineGrenadeDamage = 26,
			PaladinDivineGrenadeCritical = 27,
			PaladinDivineCalderaDamage = 28,
			PaladinDivineCalderaCritical = 29,
			PaladinDivineMissileDamage = 30,
			PaladinDivineMissileCritical = 31,
			PaladinEtherealSpearDamage = 32,
			PaladinEtherealSpearCritical = 33,
			PaladinStrongEtherealSpearDamage = 34,
			PaladinStrongEtherealSpearCritical = 35,
			PaladinDivineEmpowermentCooldown = 36,
			PaladinDivineGrenadeCooldown = 37,
			PaladinSalvationHealing = 38,
			PaladinRevelationMasteryAvatarOfLight = 39,
			PaladinRevelationMasteryDivineGrenade = 40,
			PaladinRevelationMasteryDivineEmpowerment = 41,
			SorcererAvatarOfStormCooldown = 42,
			SorcererEnergyWaveCooldown = 43,
			SorcererGreatDeathBeamDamage = 44,
			SorcererGreatDeathBeamCritical = 45,
			SorcererHellsCoreDamage = 46,
			SorcererHellsCoreCritical = 47,
			SorcererEnergyWaveDamage = 48,
			SorcererEnergyWaveCritical = 49,
			SorcererGreatFireWaveDamage = 50,
			SorcererGreatFireWaveCritical = 51,
			SorcererRageOfTheSkiesDamage = 52,
			SorcererRageOfTheSkiesCritical = 53,
			SorcererGreatEnergyBeamDamage = 54,
			SorcererGreatEnergyBeamCritical = 55,
			SorcererRevelationMasteryAvatarOfStorm = 56,
			SorcererRevelationMasteryBeamMastery = 57,
			SorcererRevelationMasteryDrainBody = 58,
			DruidAvatarOfNatureCooldown = 59,
			DruidNaturesEmbraceCooldown = 60,
			DruidTerraBurstDamage = 61,
			DruidTerraBurstCritical = 62,
			DruidIceBurstDamage = 63,
			DruidIceBurstCritical = 64,
			DruidEternalWinterCritical = 65,
			DruidEternalWinterDamage = 66,
			DruidTerraWaveDamage = 67,
			DruidTerraWaveCritical = 68,
			DruidStrongIceWaveDamage = 69,
			DruidStrongIceWaveCritical = 70,
			DruidHealFriendHealing = 71,
			DruidMassHealingHealing = 72,
			DruidRevelationMasteryAvatarOfNature = 73,
			DruidRevelationMasteryBlessingOfTheGrove = 74,
			DruidRevelationMasteryTwinBursts = 75,
			MonkAvatarOfBalanceCooldown = 76,
			MonkSpiritMendHealing = 77,
			MonkSpiritualOutburstDamage = 78,
			MonkSpiritualOutburstCritical = 79,
			MonkForcefulUppercutDamage = 80,
			MonkForcefulUppercutCritical = 81,
			MonkFlurryOfBlowsDamage = 82,
			MonkFlurryOfBlowsCritical = 83,
			MonkGreaterFlurryOfBlowsDamage = 84,
			MonkGreaterFlurryOfBlowsCritical = 85,
			MonkSweepingTakedownDamage = 86,
			MonkSweepingTakedownCritical = 87,
			MonkFocusSerenityCooldown = 88,
			MonkFocusHarmonyCooldown = 89,
			MonkMassSpiritMendHealing = 90,
			MonkRevelationMasteryAvatarOfBalance = 91,
			MonkRevelationMasterySpiritualBurst = 92,
			MonkRevelationMasteryAscetic = 93,
		};

		uint32_t		id = 0; // database row; the client addresses gems by their position in the id-sorted list
		bool			locked = false;
		Domain			domain = Domain::Green;
		Quality			quality = Quality::Lesser;
		BasicModifier	first_modifier = BasicModifier::GeneralFireResistance;
		BasicModifier	second_modifier = BasicModifier::GeneralFireResistance; // regular and greater gems
		SupremeModifier	supreme_modifier = SupremeModifier::GeneralDodge; // greater gems
		uint8_t			vessel = NoVessel; // the domain it sits in, or NoVessel while it rests in the atelier
	};

	// what one spell gains from the wheel: slot upgrades, gems and stages
	struct SpellBonus
	{
		int32_t	damage = 0; // percent
		int32_t	heal = 0; // percent
		int32_t	critical_damage = 0; // percent
		int32_t	critical_chance = 0; // percent
		int32_t	cooldown = 0; // milliseconds off
		int32_t	group_cooldown = 0; // milliseconds off the secondary group
		int32_t	mana_cost = 0; // percent off
		int32_t	additional_targets = 0;
		int32_t	duration = 0; // seconds
		int32_t	damage_reduction = 0;
		int32_t	life_leech = 0; // percent
		int32_t	mana_leech = 0; // percent
		bool	area = false;

		SpellBonus& operator+=(const SpellBonus& other) noexcept;
	};

	// everything the wheel grants a character, rebuilt whenever the wheel changes
	struct Bonuses
	{
		enum class Instant : uint8_t
		{
			BattleInstinct = 0,
			BattleHealing = 1,
			PositionalTactics = 2,
			BallisticMastery = 3,
			HealingLink = 4,
			RunicMastery = 5,
			FocusMastery = 6,
			Sanctuary = 7,
			GuidingPresence = 8,

			Count = 9,
		};

		enum class Perk : uint8_t
		{
			GiftOfLife = 0,
			CombatMastery = 1,
			BlessingOfTheGrove = 2,
			DrainBody = 3,
			BeamMastery = 4,
			DivineEmpowerment = 5,
			TwinBurst = 6,
			ExecutionersThrow = 7,
			AvatarOfLight = 8,
			AvatarOfNature = 9,
			AvatarOfSteel = 10,
			AvatarOfStorm = 11,
			AvatarOfBalance = 12,
			DivineGrenade = 13,
			SpiritualOutburst = 14,
			Ascetic = 15,

			Count = 16,
		};

		int32_t		health = 0;
		int32_t		mana = 0;
		int32_t		capacity = 0; // ounces
		int32_t		mitigation = 0; // hundredths of a percent
		int32_t		damage = 0; // percent
		int32_t		healing = 0; // percent
		int32_t		melee = 0;
		int32_t		distance = 0;
		int32_t		magic = 0;
		int32_t		fist = 0;
		int32_t		life_leech = 0; // hundredths of a percent
		int32_t		mana_leech = 0; // hundredths of a percent
		int32_t		dodge = 0; // hundredths of a percent
		int32_t		critical_damage = 0; // hundredths of a percent
		std::array<int32_t, COMBAT_COUNT> resistance {}; // hundredths of a percent, by combat index
		std::array<uint8_t, QuadrantCount> vessel_resonance {};
		std::array<uint16_t, QuadrantCount> revelation_points {};
		std::array<uint8_t, QuadrantCount> stages {};
		std::array<bool, std::to_underlying(Instant::Count)> instants {};
		std::array<uint8_t, std::to_underlying(Perk::Count)> perks {};
		std::map<std::string, uint8_t> spell_grades;
		std::map<std::string, SpellBonus> spell_bonuses;
	};

	// what one character has done with the wheel; lives on the Player
	// and in the player_wheel_* tables
	struct State
	{
		std::array<uint16_t, SlotCount + 1> points {}; // by slot number, index 0 unused
		std::vector<Gem> gems; // sorted by id
		std::array<uint8_t, BasicModifierCount> basic_grades {}; // by basic modifier
		std::array<uint8_t, SupremeModifierCount> supreme_grades {}; // by supreme modifier
		std::vector<uint16_t> scrolls; // item ids of the promotion scrolls read
		Bonuses bonuses; // what the wheel currently grants
		Bonuses applied; // what was written onto the character, so it can be taken back
		uint32_t next_gem_id = 1; // ids for gems revealed since the last save
		bool applied_any = false;
	};

	// config/wheel.toml
	struct Config
	{
		bool		enabled = true;
		bool		require_premium = true;
		bool		require_promotion = true;
		uint8_t		min_level = 51; // the client hard-codes this
		uint8_t		points_per_level = 1; // above level 50
		uint8_t		temple_range = 10; // sqm around a temple where points may be taken back
		std::array<uint64_t, 3> reveal_cost { 125000, 1000000, 6000000 }; // by gem quality
		std::array<uint64_t, 3> rotate_cost { 125000, 250000, 500000 };
		std::array<std::pair<uint64_t, uint8_t>, MaxGrade> lesser_grade_cost { { { 2000000, 5 }, { 5000000, 15 }, { 30000000, 30 } } }; // gold, fragments
		std::array<std::pair<uint64_t, uint8_t>, MaxGrade> greater_grade_cost { { { 5000000, 5 }, { 12000000, 15 }, { 75000000, 30 } } };
		std::array<uint8_t, ScrollCount> scroll_points { 3, 5, 9, 13, 20 };
		std::array<uint32_t, ScrollCount> scroll_appearances { 43946, 43947, 43948, 43949, 43950 };
		std::array<std::array<uint32_t, 3>, VocationCount> gem_appearances { { // by wire vocation minus one, then quality
			{ 44602, 44603, 44604 }, // knight: guardian gems
			{ 44605, 44606, 44607 }, // paladin: marksman gems
			{ 44608, 44609, 44610 }, // sorcerer: sage gems
			{ 44611, 44612, 44613 }, // druid: mystic gems
			{ 49371, 49372, 49373 }, // monk: spiritualist gems
		} };
		uint32_t	lesser_fragment_appearance = 46625;
		uint32_t	greater_fragment_appearance = 46626;
	};

	class System
	{
		public:
			// the wheel's slots in the order the client sends and reads them
			enum class Slot : uint8_t
			{
				None = 0,
				Green200 = 1,
				GreenTop150 = 2,
				GreenTop100 = 3,
				RedTop100 = 4,
				RedTop150 = 5,
				Red200 = 6,
				GreenBottom150 = 7,
				GreenMiddle100 = 8,
				GreenTop75 = 9,
				RedTop75 = 10,
				RedMiddle100 = 11,
				RedBottom150 = 12,
				GreenBottom100 = 13,
				GreenBottom75 = 14,
				Green50 = 15,
				Red50 = 16,
				RedBottom75 = 17,
				RedBottom100 = 18,
				BlueTop100 = 19,
				BlueTop75 = 20,
				Blue50 = 21,
				Purple50 = 22,
				PurpleTop75 = 23,
				PurpleTop100 = 24,
				BlueTop150 = 25,
				BlueMiddle100 = 26,
				BlueBottom75 = 27,
				PurpleBottom75 = 28,
				PurpleMiddle100 = 29,
				PurpleTop150 = 30,
				Blue200 = 31,
				BlueBottom150 = 32,
				BlueBottom100 = 33,
				PurpleBottom100 = 34,
				PurpleBottom150 = 35,
				Purple200 = 36,

				First = Green200,
				Last = Purple200,
			};

			enum class Quadrant : uint8_t
			{
				Green = 0,
				Red = 1,
				Blue = 2,
				Purple = 3,
			};

			// the client's vocation ids
			enum class Vocation : uint8_t
			{
				None = 0,
				Knight = 1,
				Paladin = 2,
				Sorcerer = 3,
				Druid = 4,
				Monk = 5,
			};

			// the client's gem atelier requests
			enum class GemAction : uint8_t
			{
				Destroy = 0,
				Reveal = 1,
				SwitchDomain = 2,
				ToggleLock = 3,
				ImproveGrade = 4,
			};

			enum class FragmentType : uint8_t
			{
				Greater = 0,
				Lesser = 1,
			};

			// what one slot gives per point, and what it unlocks once full
			enum class PointStat : uint8_t
			{
				None,
				Health,
				Mana,
				Capacity,
				Mitigation,
			};

			enum class Reward : uint8_t
			{
				None,
				Skill,
				LifeLeech,
				ManaLeech,
				Vessel,
				Spell,
				Instant,
			};

			// the options byte of the wheel window
			enum class Options : uint8_t
			{
				Locked = 0,
				Free = 1, // points may be added and taken back
				AddOnly = 2,
			};

			// where one slot sits: its quadrant, its size, the points a
			// character needs before it opens, and the slots it grows from
			struct Place
			{
				Quadrant	quadrant = Quadrant::Green;
				uint8_t		max_points = 0;
				uint16_t	points_required = 0;
				std::array<Slot, 5> neighbours {}; // Slot::None ends the list; none at all means the slot is always open
			};

			// the bonus one slot grants, by vocation where they differ
			struct SlotBonus
			{
				PointStat	first = PointStat::None;
				PointStat	second = PointStat::None;
				Reward		reward = Reward::None;
				std::array<std::string_view, VocationCount> spells {}; // by wire vocation minus one
				std::array<Bonuses::Instant, VocationCount> instants {};
			};

			// non-copyable
			System(const System&) = delete;
			System& operator=(const System&) = delete;

			static System& getInstance() {
				static System instance;
				return instance;
			}

			bool loadConfig();
			[[nodiscard]] const Config& getConfig() const noexcept { return config; }

			[[nodiscard]] static const Place& getPlace(Slot slot) noexcept;
			[[nodiscard]] static const SlotBonus& getSlotBonus(Slot slot) noexcept;
			[[nodiscard]] static Vocation getVocation(const PlayerPtr& player) noexcept;
			[[nodiscard]] static std::string_view instantName(Bonuses::Instant instant) noexcept;
			[[nodiscard]] static std::string_view perkName(Bonuses::Perk perk) noexcept;
			[[nodiscard]] static std::optional<Bonuses::Instant> instantByName(std::string_view name) noexcept;
			[[nodiscard]] static std::optional<Bonuses::Perk> perkByName(std::string_view name) noexcept;
			[[nodiscard]] static std::span<const Gem::BasicModifier> basicPositions() noexcept;
			[[nodiscard]] static std::vector<Gem::SupremeModifier> supremePositions(Vocation vocation);

			// the character's point budget and whether the wheel opens for them
			[[nodiscard]] uint16_t getPoints(const PlayerPtr& player) const noexcept;
			[[nodiscard]] uint16_t getExtraPoints(const PlayerPtr& player) const noexcept;
			[[nodiscard]] uint16_t getUsedPoints(const PlayerPtr& player) const noexcept;
			[[nodiscard]] bool canOpen(const PlayerPtr& player) const noexcept;
			[[nodiscard]] Options getOptions(const PlayerPtr& player, uint32_t ownerId) const;

			// the gem and fragment items, found by their appearances once items are loaded
			[[nodiscard]] uint16_t getGemItemId(Vocation vocation, Gem::Quality quality) const noexcept;
			[[nodiscard]] uint16_t getFragmentItemId(FragmentType type) const noexcept;
			[[nodiscard]] uint16_t getScrollItemId(uint8_t index) const noexcept;
			[[nodiscard]] uint8_t getScrollPoints(uint16_t itemId) const noexcept;

			// the client's save button: every slot's points and the four vessels
			bool save(const PlayerPtr& player, const std::array<uint16_t, SlotCount + 1>& points, const std::array<uint16_t, QuadrantCount>& vessels) const;

			// the gem atelier
			void revealGem(const PlayerPtr& player, Gem::Quality quality) const;
			void destroyGem(const PlayerPtr& player, uint16_t index) const;
			void switchGemDomain(const PlayerPtr& player, uint16_t index) const;
			void toggleGemLock(const PlayerPtr& player, uint16_t index) const;
			void improveGemGrade(const PlayerPtr& player, FragmentType type, uint8_t position) const;
			bool unlockScroll(const PlayerPtr& player, uint16_t itemId) const;

			// the starting gems a character receives on the first visit
			void grantInitialGems(const PlayerPtr& player) const;

			// the bonuses the current wheel grants, and their application to the character
			[[nodiscard]] Bonuses compute(const PlayerPtr& player) const;
			void apply(const PlayerPtr& player) const;
			void clear(const PlayerPtr& player) const;
			[[nodiscard]] const SpellBonus* getSpellBonus(const Player& player, std::string_view spellName) const noexcept;

			void sendResourceBalances(const PlayerPtr& player) const;

			[[nodiscard]] static std::string_view augmentName() noexcept { return "Wheel of Destiny"; }

		private:
			System() = default;

			[[nodiscard]] bool canHoldPoints(const State& state, Slot slot, uint16_t budget) const noexcept;
			void applySlot(const PlayerPtr& player, Slot slot, Bonuses& bonuses) const;
			void applyGems(const PlayerPtr& player, Bonuses& bonuses) const;
			void applyBasicModifier(Vocation vocation, Gem::BasicModifier modifier, uint8_t grade, Bonuses& bonuses) const;
			void applySupremeModifier(Gem::SupremeModifier modifier, uint8_t grade, Bonuses& bonuses) const;
			void applyStages(const PlayerPtr& player, Bonuses& bonuses) const;
			void applySpellGrades(Vocation vocation, Bonuses& bonuses) const;
			void rollGem(Vocation vocation, Gem& gem) const;

			Config config;
			std::array<std::array<uint16_t, 3>, VocationCount> gem_items {}; // by vocation minus one, then quality
			std::array<uint16_t, 2> fragment_items {}; // by FragmentType
			std::array<uint16_t, ScrollCount> scroll_items {};
	};
}
