// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include <array>
#include <cstdint>
#include <map>
#include <memory>
#include <string>
#include <vector>

class Item;
class Player;
class NetworkMessage;
using ItemPtr = std::shared_ptr<Item>;
using PlayerPtr = std::shared_ptr<Player>;

namespace BlackTek::Forge
{
	// the client's forge requests
	enum class Action : uint8_t
	{
		Fusion = 0x00,
		Transfer = 0x01,
		DustToSlivers = 0x02,
		SliversToCores = 0x03,
		IncreaseDustLimit = 0x04,
	};

	// what a successful fusion may hand back; the client names them
	enum class Bonus : uint8_t
	{
		None = 0x00,
		DustKept = 0x01,
		CoresKept = 0x02,
		GoldKept = 0x03,
		SecondItemKept = 0x04,
	};

	constexpr uint8_t ClassificationCount = 4;
	constexpr uint8_t MaxTier = 10;

	// the price of reaching one tier inside a classification
	struct TierPrice
	{
		uint8_t cores = 1;
		uint64_t regular = 0;
		uint64_t convergence_fusion = 0;
		uint64_t convergence_transfer = 0;
	};

	// config/forge.toml
	struct Config
	{
		uint8_t max_tier = MaxTier;
		uint16_t dust_per_sliver_batch = 20; // dust spent for one batch of slivers
		uint8_t slivers_per_batch = 3;
		uint16_t slivers_per_core = 50;
		uint16_t dust_level_start = 100;
		uint16_t dust_level_max = 225;
		uint16_t dust_level_step_cost = 75; // the level minus this is the dust the next step costs
		uint8_t fusion_dust_cost = 100;
		uint8_t convergence_fusion_dust_cost = 130;
		uint8_t transfer_dust_cost = 100;
		uint8_t convergence_transfer_dust_cost = 160;
		uint8_t fusion_base_success = 50; // percent
		uint8_t fusion_improved_success = 15; // added when a core is spent
		uint8_t fusion_tier_loss_reduction = 50; // percent chance to keep the tier on failure, when a core is spent
		uint8_t dust_chance_per_kill = 10; // percent
		uint8_t dust_min_per_kill = 1;
		uint8_t dust_max_per_kill = 3;
		std::array<std::map<uint8_t, TierPrice>, ClassificationCount + 1> prices; // by classification, then tier
	};

	// one line of a character's forge history
	struct HistoryEntry
	{
		int64_t created_at = 0;
		Action action = Action::Fusion;
		std::string description;
		bool success = false;
		Bonus bonus = Bonus::None;
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

			// the sliver and core items, found by their appearance once items are loaded
			[[nodiscard]] uint16_t getSliverId() const noexcept { return sliver_id; }
			[[nodiscard]] uint16_t getCoreId() const noexcept { return core_id; }
			[[nodiscard]] const TierPrice* getPrice(uint8_t classification, uint8_t tier) const;

			void fuse(const PlayerPtr& player, uint16_t itemId, uint8_t tier, uint16_t secondItemId, bool convergence, bool improveChance, bool reduceTierLoss) const;
			void transfer(const PlayerPtr& player, uint16_t donorItemId, uint8_t tier, uint16_t receiverItemId, bool convergence) const;
			void convert(const PlayerPtr& player, Action action) const;
			void onKill(const PlayerPtr& player) const;

			[[nodiscard]] std::vector<HistoryEntry> getHistory(const PlayerPtr& player, uint16_t page, uint16_t perPage, uint16_t& pages) const;

		private:
			System() = default;

			void record(const PlayerPtr& player, const HistoryEntry& entry) const;
			[[nodiscard]] ItemPtr findItem(const PlayerPtr& player, uint16_t itemId, uint8_t tier, const ItemPtr& exclude) const;
			[[nodiscard]] uint32_t countCores(const PlayerPtr& player) const;
			bool removeCores(const PlayerPtr& player, uint32_t amount) const;

			Config config;
			uint16_t sliver_id = 0;
			uint16_t core_id = 0;
	};
}
