// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "forge.h"
#include "appearances.h"
#include "console.h"
#include "database.h"
#include "game.h"
#include "item.h"
#include "itemcontainer.h"
#include "items.h"
#include "player.h"
#include "tools.h"

#include <ranges>
#include <toml++/toml.hpp>

extern Game g_game;

namespace BlackTek::Forge
{
	namespace
	{
		// the sliver and exalted core as CipSoft's asset catalog knows them
		constexpr uint32_t SliverAppearance = 37109;
		constexpr uint32_t CoreAppearance = 37110;

		uint8_t ClassificationOf(uint16_t itemId) noexcept
		{
			const auto* app = BlackTek::Assets::Appearances::getInstance().getObject(Item::items.getModernClientId(itemId));
			return app ? static_cast<uint8_t>(std::min<uint32_t>(app->classification, ClassificationCount)) : 0;
		}

		// every item the character carries, containers included
		template<typename Visitor>
		void ForEachCarriedItem(const PlayerPtr& player, Visitor&& visit)
		{
			auto carried = std::views::iota(static_cast<int32_t>(CONST_SLOT_FIRST), static_cast<int32_t>(CONST_SLOT_LAST) + 1)
				| std::views::transform([&](int32_t slot) { return player->getInventoryItem(static_cast<slots_t>(slot)); })
				| std::views::filter([](const ItemPtr& item) { return item != nullptr; });
			for (const auto& item : carried)
			{
				visit(item);
				if (const auto& container = item->getContainer())
				{
					for (ContainerIterator it = container->iterator(); it.hasNext(); it.advance())
					{
						visit(*it);
					}
				}
			}
		}

		System::Bonus RollBonus() noexcept
		{
			const int32_t roll = uniform_random(0, 10000);
			if (roll <= 8000)
			{
				return System::Bonus::None;
			}

			if (roll <= 8500)
			{
				return System::Bonus::DustKept;
			}

			if (roll <= 9000)
			{
				return System::Bonus::CoresKept;
			}

			if (roll <= 9500)
			{
				return System::Bonus::GoldKept;
			}
			return System::Bonus::SecondItemKept;
		}
	}

	bool System::loadConfig()
	{
		try
		{
			auto table = toml::parse_file("config/forge.toml");
			config.max_tier = table["max_tier"].value_or(config.max_tier);
			config.dust_per_sliver_batch = table["dust_per_sliver_batch"].value_or(config.dust_per_sliver_batch);
			config.slivers_per_batch = table["slivers_per_batch"].value_or(config.slivers_per_batch);
			config.slivers_per_core = table["slivers_per_core"].value_or(config.slivers_per_core);
			config.dust_level_start = table["dust_level_start"].value_or(config.dust_level_start);
			config.dust_level_max = table["dust_level_max"].value_or(config.dust_level_max);
			config.dust_level_step_cost = table["dust_level_step_cost"].value_or(config.dust_level_step_cost);
			config.fusion_dust_cost = table["fusion_dust_cost"].value_or(config.fusion_dust_cost);
			config.convergence_fusion_dust_cost = table["convergence_fusion_dust_cost"].value_or(config.convergence_fusion_dust_cost);
			config.transfer_dust_cost = table["transfer_dust_cost"].value_or(config.transfer_dust_cost);
			config.convergence_transfer_dust_cost = table["convergence_transfer_dust_cost"].value_or(config.convergence_transfer_dust_cost);
			config.fusion_base_success = table["fusion_base_success"].value_or(config.fusion_base_success);
			config.fusion_improved_success = table["fusion_improved_success"].value_or(config.fusion_improved_success);
			config.fusion_tier_loss_reduction = table["fusion_tier_loss_reduction"].value_or(config.fusion_tier_loss_reduction);
			config.dust_chance_per_kill = table["dust_chance_per_kill"].value_or(config.dust_chance_per_kill);
			config.dust_min_per_kill = table["dust_min_per_kill"].value_or(config.dust_min_per_kill);
			config.dust_max_per_kill = table["dust_max_per_kill"].value_or(config.dust_max_per_kill);

			// [[classifications]] id = N, tiers = [{ tier, cores, regular, convergence_fusion, convergence_transfer }]
			if (const auto* classes = table["classifications"].as_array())
			{
				for (const auto& entry : *classes | std::views::filter(&toml::node::is_table))
				{
					const auto& classTable = *entry.as_table();
					const auto classification = static_cast<uint8_t>(classTable["id"].value_or(int64_t{ 0 }));
					const bool known = classification != 0 and classification <= ClassificationCount;
					const auto* tiers = known ? classTable["tiers"].as_array() : nullptr;
					if (tiers)
					{
						for (const auto& tierEntry : *tiers | std::views::filter(&toml::node::is_table))
						{
							// the top tiers cost more than an int holds, so read them as int64
							const auto& tierTable = *tierEntry.as_table();
							TierPrice price;
							price.cores = static_cast<uint8_t>(tierTable["cores"].value_or(int64_t{ 1 }));
							price.regular = static_cast<uint64_t>(tierTable["regular"].value_or(int64_t{ 0 }));
							price.convergence_fusion = static_cast<uint64_t>(tierTable["convergence_fusion"].value_or(int64_t{ 0 }));
							price.convergence_transfer = static_cast<uint64_t>(tierTable["convergence_transfer"].value_or(int64_t{ 0 }));
							config.prices[classification][static_cast<uint8_t>(tierTable["tier"].value_or(int64_t{ 0 }))] = price;
						}
					}
				}
			}
		}
		catch (const toml::parse_error& err)
		{
			Console::Error("Forge::System::loadConfig: failed to parse config/forge.toml: {:s}", err.description());
			return false;
		}

		sliver_id = Item::items.getItemIdByModernClientId(SliverAppearance);
		core_id = Item::items.getItemIdByModernClientId(CoreAppearance);
		if (sliver_id == 0 or core_id == 0)
		{
			Console::Warn("Forge::System::loadConfig: the sliver or exalted core appearance has no item; conversions are disabled");
		}
		return true;
	}

	const TierPrice* System::getPrice(uint8_t classification, uint8_t tier) const noexcept
	{
		if (classification == 0 or classification > ClassificationCount)
		{
			return nullptr;
		}

		const auto& tiers = config.prices[classification];
		auto it = tiers.find(tier);
		return it != tiers.end() ? &it->second : nullptr;
	}

	ItemPtr System::findItem(const PlayerPtr& player, uint16_t itemId, uint8_t tier, const ItemPtr& exclude) const
	{
		ItemPtr found;
		ForEachCarriedItem(player, [&](const ItemPtr& item)
		{
			if (not found and item != exclude and item->getID() == itemId and item->getForgeTier() == tier)
			{
				found = item;
			}
		});
		return found;
	}

	uint32_t System::countCores(const PlayerPtr& player) const noexcept
	{
		return core_id != 0 ? player->getItemTypeCount(core_id) : 0;
	}

	bool System::removeCores(const PlayerPtr& player, uint32_t amount) const
	{
		return amount == 0 or (core_id != 0 and player->removeItemOfType(core_id, amount, -1));
	}

	void System::record(const PlayerPtr& player, const HistoryEntry& entry) const
	{
		Database& db = Database::getInstance();
		db.executeQuery(fmt::format("INSERT INTO `forge_history` (`player_id`, `action`, `description`, `success`, `bonus`, `created`) VALUES ({:d}, {:d}, {:s}, {:d}, {:d}, {:d})",
			player->getGUID(), std::to_underlying(entry.action), db.escapeString(entry.description), entry.success ? 1 : 0, std::to_underlying(entry.bonus), entry.created_at));
	}

	std::vector<System::HistoryEntry> System::getHistory(const PlayerPtr& player, uint16_t page, uint16_t perPage, uint16_t& pages) const
	{
		std::vector<HistoryEntry> entries;
		pages = 0;
		if (not player or perPage == 0)
		{
			return entries;
		}

		Database& db = Database::getInstance();
		if (DBResult_ptr count = db.storeQuery(fmt::format("SELECT COUNT(*) AS `total` FROM `forge_history` WHERE `player_id` = {:d}", player->getGUID())))
		{
			pages = static_cast<uint16_t>((count->getNumber<uint32_t>("total") + perPage - 1) / perPage);
		}

		const uint32_t offset = static_cast<uint32_t>(page) * perPage;
		DBResult_ptr result = db.storeQuery(fmt::format("SELECT `action`, `description`, `success`, `bonus`, `created` FROM `forge_history` WHERE `player_id` = {:d} ORDER BY `created` DESC LIMIT {:d} OFFSET {:d}", player->getGUID(), perPage, offset));
		if (result)
		{
			do
			{
				HistoryEntry entry;
				entry.action = static_cast<Action>(result->getNumber<uint8_t>("action"));
				entry.description = std::string(result->getString("description"));
				entry.success = result->getNumber<uint8_t>("success") != 0;
				entry.bonus = static_cast<Bonus>(result->getNumber<uint8_t>("bonus"));
				entry.created_at = result->getNumber<int64_t>("created");
				entries.push_back(std::move(entry));
			} while (result->next());
		}
		return entries;
	}

	// two identical items of the same tier become one item a tier higher -
	// or, on failure, the second item is lost and the first may drop a tier
	void System::fuse(const PlayerPtr& player, uint16_t itemId, uint8_t tier, uint16_t secondItemId, bool convergence, bool improveChance, bool reduceTierLoss) const
	{
		if (not player)
		{
			return;
		}

		const uint8_t classification = ClassificationOf(itemId);
		if (classification == 0 or tier >= config.max_tier or (not convergence and itemId != secondItemId))
		{
			player->sendForgeError("These items can not be fused.");
			return;
		}

		const ItemPtr first = findItem(player, itemId, tier, nullptr);
		const ItemPtr second = findItem(player, secondItemId, tier, first);
		const TierPrice* price = getPrice(classification, tier + 1);
		if (not first or not second or not price)
		{
			player->sendForgeError("You need two matching items of that tier to fuse.");
			return;
		}

		const uint16_t dustCost = convergence ? config.convergence_fusion_dust_cost : config.fusion_dust_cost;
		const uint64_t goldCost = convergence ? price->convergence_fusion : price->regular;
		const uint32_t coreCost = (improveChance ? 1 : 0) + (reduceTierLoss ? 1 : 0);
		if (player->getForgeDust() < dustCost)
		{
			player->sendForgeError("You do not have enough dust.");
			return;
		}

		if (countCores(player) < coreCost)
		{
			player->sendForgeError("You do not have enough exalted cores.");
			return;
		}

		if (player->getMoney() + player->getBankBalance() < goldCost)
		{
			player->sendForgeError("You do not have enough gold.");
			return;
		}

		// convergence always succeeds; a normal fusion rolls against the base
		// chance, improved when a core is spent
		uint8_t successChance = config.fusion_base_success + (improveChance ? config.fusion_improved_success : 0);
		const bool success = convergence or uniform_random(1, 100) <= successChance;
		const Bonus bonus = success and not convergence ? RollBonus() : Bonus::None;

		if (bonus != Bonus::DustKept)
		{
			player->removeForgeDust(dustCost);
		}
		if (bonus != Bonus::CoresKept)
		{
			removeCores(player, coreCost);
		}
		if (bonus != Bonus::GoldKept)
		{
			g_game.removeMoney({ .player = player }, goldCost);
		}

		HistoryEntry entry;
		entry.action = Action::Fusion;
		entry.success = success;
		entry.bonus = bonus;
		entry.created_at = time(nullptr);

		uint16_t leftItemId = itemId;
		uint8_t leftTier = tier;
		uint16_t rightItemId = secondItemId;
		uint8_t rightTier = tier;
		if (success)
		{
			first->setForgeTier(tier + 1);
			leftTier = tier + 1;
			if (bonus != Bonus::SecondItemKept)
			{
				g_game.internalRemoveItem(second, 1);
				rightItemId = 0;
				rightTier = 0;
			}
			entry.description = fmt::format("Fused two {:s} into tier {:d}.", first->getName(), leftTier);
		}
		else
		{
			g_game.internalRemoveItem(second, 1);
			rightItemId = 0;
			rightTier = 0;
			const bool tierKept = reduceTierLoss and uniform_random(1, 100) <= config.fusion_tier_loss_reduction;
			if (not tierKept and tier > 0)
			{
				first->setForgeTier(tier - 1);
				leftTier = tier - 1;
			}
			entry.description = fmt::format("Failed to fuse two {:s} at tier {:d}.", first->getName(), tier);
		}

		record(player, entry);
		player->sendForgeResult(Action::Fusion, convergence, success, leftItemId, leftTier, rightItemId, rightTier, bonus, coreCost);
		player->sendForgeBalances();
	}

	// the donor's tier moves to a fresh receiver of the same class, one step
	// lower; the donor is spent
	void System::transfer(const PlayerPtr& player, uint16_t donorItemId, uint8_t tier, uint16_t receiverItemId, bool convergence) const
	{
		if (not player)
		{
			return;
		}

		const uint8_t classification = ClassificationOf(donorItemId);
		if (classification == 0 or tier == 0 or classification != ClassificationOf(receiverItemId))
		{
			player->sendForgeError("A tier can only move between items of the same class.");
			return;
		}

		const ItemPtr donor = findItem(player, donorItemId, tier, nullptr);
		const ItemPtr receiver = findItem(player, receiverItemId, 0, donor);
		const uint8_t toTier = convergence ? tier : tier - 1;
		const TierPrice* price = getPrice(classification, std::max<uint8_t>(toTier, 1));
		if (not donor or not receiver or not price or toTier == 0)
		{
			player->sendForgeError("You need a tiered item and an untiered item of the same class.");
			return;
		}

		const uint16_t dustCost = convergence ? config.convergence_transfer_dust_cost : config.transfer_dust_cost;
		const uint64_t goldCost = convergence ? price->convergence_transfer : price->regular;
		if (player->getForgeDust() < dustCost)
		{
			player->sendForgeError("You do not have enough dust.");
			return;
		}

		if (countCores(player) < price->cores)
		{
			player->sendForgeError("You do not have enough exalted cores.");
			return;
		}

		if (player->getMoney() + player->getBankBalance() < goldCost)
		{
			player->sendForgeError("You do not have enough gold.");
			return;
		}

		player->removeForgeDust(dustCost);
		removeCores(player, price->cores);
		g_game.removeMoney({ .player = player }, goldCost);
		g_game.internalRemoveItem(donor, 1);
		receiver->setForgeTier(toTier);

		HistoryEntry entry;
		entry.action = Action::Transfer;
		entry.success = true;
		entry.created_at = time(nullptr);
		entry.description = fmt::format("Transferred tier {:d} to {:s} (tier {:d}).", tier, receiver->getName(), toTier);
		record(player, entry);

		player->sendForgeResult(Action::Transfer, convergence, true, donorItemId, 0, receiverItemId, toTier, Bonus::None, 0);
		player->sendForgeBalances();
	}

	void System::convert(const PlayerPtr& player, Action action) const
	{
		if (not player)
		{
			return;
		}

		HistoryEntry entry;
		entry.action = action;
		entry.success = true;
		entry.created_at = time(nullptr);

		switch (action)
		{
			case Action::DustToSlivers:
			{
				if (sliver_id == 0 or player->getForgeDust() < config.dust_per_sliver_batch)
				{
					player->sendForgeError("You do not have enough dust.");
					return;
				}

				const auto& slivers = Item::CreateItem(sliver_id, config.slivers_per_batch);
				if (not slivers or g_game.internalPlayerAddItem(player, slivers) != RETURNVALUE_NOERROR)
				{
					player->sendForgeError("You have no room for the slivers.");
					return;
				}

				player->removeForgeDust(config.dust_per_sliver_batch);
				entry.description = fmt::format("Turned {:d} dust into {:d} slivers.", config.dust_per_sliver_batch, config.slivers_per_batch);
				break;
			}
			case Action::SliversToCores:
			{
				if (core_id == 0 or sliver_id == 0 or player->getItemTypeCount(sliver_id) < config.slivers_per_core)
				{
					player->sendForgeError("You do not have enough slivers.");
					return;
				}

				const auto& core = Item::CreateItem(core_id, 1);
				if (not core or g_game.internalPlayerAddItem(player, core) != RETURNVALUE_NOERROR)
				{
					player->sendForgeError("You have no room for the core.");
					return;
				}

				player->removeItemOfType(sliver_id, config.slivers_per_core, -1);
				entry.description = fmt::format("Turned {:d} slivers into an exalted core.", config.slivers_per_core);
				break;
			}
			case Action::IncreaseDustLimit:
			{
				const uint16_t level = player->getForgeDustLevel();
				if (level >= config.dust_level_max)
				{
					player->sendForgeError("Your dust limit can not go any higher.");
					return;
				}

				const uint16_t cost = level > config.dust_level_step_cost ? level - config.dust_level_step_cost : 0;
				if (player->getForgeDust() < cost)
				{
					player->sendForgeError("You do not have enough dust.");
					return;
				}

				player->removeForgeDust(cost);
				player->setForgeDustLevel(level + 1);
				entry.description = fmt::format("Raised the dust limit to {:d}.", level + 1);
				break;
			}
			default:
				return;
		}

		record(player, entry);
		player->sendForgeBalances();
		player->sendForgeWindow();
	}

	// creatures leave a little dust behind for the character that finished them
	void System::onKill(const PlayerPtr& player) const
	{
		if (not player or config.dust_chance_per_kill == 0 or uniform_random(1, 100) > config.dust_chance_per_kill)
		{
			return;
		}

		const uint32_t gained = uniform_random(config.dust_min_per_kill, config.dust_max_per_kill);
		const uint32_t before = player->getForgeDust();
		player->addForgeDust(gained);
		if (player->getForgeDust() != before)
		{
			player->sendTextMessage(MESSAGE_STATUS_DEFAULT, fmt::format("You gathered {:d} dust.", player->getForgeDust() - before));
			player->sendForgeBalances();
		}
	}
}
