// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "store.h"
#include "console.h"
#include "database.h"
#include "game.h"
#include "iologindata.h"
#include "item.h"
#include "itemcontainer.h"
#include "items.h"
#include "player.h"
#include "tools.h"

#include <algorithm>
#include <ranges>
#include <toml++/toml.hpp>

extern Game g_game;

namespace BlackTek::Store
{
	namespace
	{
		using Coins = StoreProduct::Coins;
		using Kind = StoreProduct::Kind;
		using Mode = HistoryEntry::Mode;

		constexpr std::string_view HomeName = "Home";
		constexpr std::string_view SearchName = "Search";
		constexpr std::string_view PremiumName = "Premium Time";
		constexpr std::string_view BoostsName = "Boosts";
		constexpr std::string_view BlessingsName = "Blessings";
		constexpr std::string_view UsefulName = "Useful Things";
		constexpr uint8_t FirstBlessingSubAction = 3;
		constexpr uint8_t LastBlessingSubAction = 12;

		[[nodiscard]] std::string LowerCased(std::string_view text)
		{
			std::string lowered(text);
			std::ranges::transform(lowered, lowered.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
			return lowered;
		}

		[[nodiscard]] uint32_t BalanceFor(const PlayerPtr& player, Coins coins) noexcept
		{
			return coins == Coins::Transferable ? player->getTransferableCoins() : player->getCoins() + player->getTransferableCoins();
		}
	}

	bool System::loadConfig()
	{
		config = Config{};
		try
		{
			auto table = toml::parse_file("config/store.toml");
			const auto store = table["store"];
			config.enabled = store["enabled"].value_or(config.enabled);
			config.images_url = store["images_url"].value_or(config.images_url);
			config.coin_package_size = store["coin_package_size"].value_or(config.coin_package_size);
			config.banner_delay = store["banner_delay"].value_or(config.banner_delay);
			config.history_page_size = store["history_page_size"].value_or(config.history_page_size);
			if (const auto* banners = store["banners"].as_array())
			{
				for (const auto& banner : *banners)
				{
					if (const auto image = banner.value<std::string>())
					{
						config.banners.push_back(*image);
					}
				}
			}
		}
		catch (const toml::parse_error& err)
		{
			Console::Error("Store::System::loadConfig: failed to parse config/store.toml: {:s}", err.description());
			return false;
		}

		Console::Info("Store::System::loadConfig: the store is {:s}; images from {:s}", config.enabled ? "enabled" : "disabled", config.images_url);
		return true;
	}

	const StoreWindow* System::getWindow(const PlayerPtr& player) const noexcept
	{
		if (not config.enabled or not player)
		{
			return nullptr;
		}
		return g_storeManager.getWindowForAccountType(player->getAccountType());
	}

	// the shelves, the balance and the front page
	void System::open(const PlayerPtr& player) const
	{
		const auto* window = getWindow(player);
		if (not window)
		{
			player->sendStoreError(Error::Network, "The store is closed right now.");
			return;
		}

		window->executeOnOpen(player);
		player->sendStoreCategories(*window);
		player->sendStoreBalances();
		browse(player, Action::Home, "", 0, 0);
	}

	void System::browse(const PlayerPtr& player, Action action, const std::string& text, uint8_t subAction, uint32_t offerId) const
	{
		const auto* window = getWindow(player);
		if (not window)
		{
			return;
		}

		auto showCategory = [&](std::string_view name, uint32_t redirect)
		{
			if (const auto* category = window->getCategoryByName(name))
			{
				std::vector<const StoreProduct*> products;
				for (const auto& product : category->products)
				{
					products.push_back(&product);
				}
				player->sendStoreOffers(category->name, products, redirect, false);
			}
			else
			{
				player->sendStoreError(Error::Information, fmt::format("There is no {:s} section in this store.", name));
			}
		};

		switch (action)
		{
			case Action::Home:
			{
				std::vector<const StoreProduct*> products;
				for (const auto& category : window->getCategories())
				{
					for (const auto& product : category->products)
					{
						if (product.home)
						{
							products.push_back(&product);
						}
					}
				}
				player->sendStoreHome(products);
				break;
			}
			case Action::Category:
				showCategory(text, 0);
				break;
			case Action::PremiumBoost:
				showCategory(subAction == 0 ? PremiumName : BoostsName, 0);
				break;
			case Action::UsefulThings:
				showCategory(subAction >= FirstBlessingSubAction and subAction <= LastBlessingSubAction ? BlessingsName : UsefulName, subAction);
				break;
			case Action::Offer:
				if (const auto* category = window->getCategoryByProduct(offerId))
				{
					showCategory(category->name, offerId);
				}
				break;
			case Action::Search:
			{
				const auto products = search(*window, text);
				if (products.empty())
				{
					player->sendStoreError(Error::Information, fmt::format("No results found for \"{:s}\".", text));
				}
				else
				{
					player->sendStoreOffers(std::string(SearchName), products, 0, true);
				}
				break;
			}
		}
	}

	std::vector<const StoreProduct*> System::search(const StoreWindow& window, std::string_view text) const
	{
		std::vector<const StoreProduct*> found;
		const std::string needle = LowerCased(text);
		if (needle.empty())
		{
			return found;
		}
		for (const auto& category : window.getCategories())
		{
			auto matches = category->products | std::views::filter([&](const StoreProduct& product) { return LowerCased(product.name).find(needle) != std::string::npos; });
			for (const auto& product : matches)
			{
				found.push_back(&product);
			}
		}
		return found;
	}

	std::string System::disabledReason(const PlayerPtr& player, const StoreCategory& category, const StoreProduct& product) const
	{
		if (not product.enabled)
		{
			return "This offer is not available right now.";
		}
		switch (product.kind)
		{
			case Kind::Outfit:
			{
				const uint16_t looktype = player->getSex() == PLAYERSEX_FEMALE ? product.looktype_female : product.looktype_male;
				if (looktype != 0 and player->hasOutfit(looktype, product.addons))
				{
					return "You already own this outfit.";
				}
				break;
			}
			case Kind::Mount:
				if (const auto* mount = g_game.mounts.getMountByID(product.mount_id); mount and player->hasMount(mount))
				{
					return "You already own this mount.";
				}
				break;
			case Kind::Item:
			case Kind::Other:
				break;
		}
		std::string reason;
		if (not category.executeCanPurchase(player, product.id, reason))
		{
			return reason.empty() ? "You cannot buy this right now." : reason;
		}
		return {};
	}

	void System::purchase(const PlayerPtr& player, uint32_t offerId, uint8_t productType, const std::string& param) const
	{
		const auto* window = getWindow(player);
		if (not window)
		{
			player->sendStoreError(Error::Network, "The store is closed right now.");
			return;
		}

		const auto* category = window->getCategoryByProduct(offerId);
		const auto* product = category ? category->getProductById(offerId) : nullptr;
		if (not product)
		{
			player->sendStoreError(Error::Purchase, "This offer is unavailable.");
			return;
		}

		if (const auto reason = disabledReason(player, *category, *product); not reason.empty())
		{
			player->sendStoreError(Error::Purchase, reason);
			return;
		}

		if (BalanceFor(player, product->coins) < product->price)
		{
			player->sendStoreError(Error::Purchase, "You do not have enough coins. Your purchase has been cancelled.");
			return;
		}

		if (not deliver(player, *category, *product, productType, param))
		{
			player->sendStoreError(Error::Purchase, "Your purchase could not be completed.");
			return;
		}

		removeCoins(player, product->price, product->coins, product->name);
		player->sendStorePurchaseResult(fmt::format("You have purchased {:s}.", product->name));
		player->sendStoreBalances();
	}

	// items land in the store inbox, outfits and mounts on the character; the
	// datapack's onPurchase takes over for everything else, or for anything
	// the category chose to script itself
	bool System::deliver(const PlayerPtr& player, const StoreCategory& category, const StoreProduct& product, uint8_t productType, const std::string& param) const
	{
		if (category.on_purchase_script_id != -1)
		{
			return category.executePurchase(player, product.id, productType, param);
		}

		switch (product.kind)
		{
			case Kind::Item:
			{
				if (product.item_id == 0)
				{
					return false;
				}
				const auto& inbox = player->getStoreInbox();
				uint16_t remaining = std::max<uint16_t>(1, product.count);
				const bool stackable = Item::items[product.item_id].stackable;
				while (remaining > 0)
				{
					const uint16_t batch = stackable ? std::min<uint16_t>(remaining, 100) : 1;
					auto item = Item::CreateItem(product.item_id, stackable ? batch : product.count);
					if (not item)
					{
						return false;
					}
					// a store item may only rest in the store inbox, a depot or a house
					if (not product.movable)
						item->setStoreItem(true);

					const auto target = inbox ? BlackTek::ItemLocation{ .containerItem = inbox->getOwner() } : BlackTek::ItemLocation{ .player = player };
					if (g_game.internalAddItem(target, item, INDEX_ANYWHERE, FLAG_NOLIMIT) != RETURNVALUE_NOERROR)
					{
						return false;
					}
					remaining -= stackable ? batch : 1;
				}
				return true;
			}
			case Kind::Outfit:
				if (product.looktype_male != 0)
				{
					player->addOutfit(product.looktype_male, product.addons);
				}
				if (product.looktype_female != 0)
				{
					player->addOutfit(product.looktype_female, product.addons);
				}
				return product.looktype_male != 0 or product.looktype_female != 0;
			case Kind::Mount:
				return product.mount_id != 0 and player->tameMount(product.mount_id);
			case Kind::Other:
				return false;
		}
		return false;
	}

	// transferable coins may be handed to a character of another account
	void System::transfer(const PlayerPtr& player, const std::string& recipientName, uint32_t amount) const
	{
		if (amount == 0 or amount > player->getTransferableCoins())
		{
			player->sendStoreError(Error::Transfer, "You do not have that many transferable coins.");
			return;
		}

		const uint32_t recipientAccount = IOLoginData::getAccountIdByPlayerName(recipientName);
		if (recipientAccount == 0)
		{
			player->sendStoreError(Error::Transfer, "We could not find that character.");
			return;
		}
		if (recipientAccount == player->getAccount())
		{
			player->sendStoreError(Error::Transfer, "You cannot transfer coins to your own account.");
			return;
		}

		if (not removeCoins(player, amount, Coins::Transferable, fmt::format("You transferred coins to {:s}.", recipientName)))
		{
			player->sendStoreError(Error::Transfer, "The transfer failed.");
			return;
		}

		Database& db = Database::getInstance();
		db.executeQuery(fmt::format("UPDATE `accounts` SET `coins_transferable` = `coins_transferable` + {:d} WHERE `id` = {:d}", amount, recipientAccount));
		record(recipientAccount, Mode::Gift, static_cast<int32_t>(amount), Coins::Transferable, fmt::format("{:s} transferred coins to you.", player->getName()));
		if (const auto& recipient = g_game.getPlayerByName(recipientName); recipient and recipient->getAccount() == recipientAccount)
		{
			recipient->setCoins(recipient->getCoins(), recipient->getTransferableCoins() + amount);
			recipient->sendStoreBalances();
		}

		player->sendStorePurchaseResult(fmt::format("You have transferred {:d} coins to {:s}.", amount, recipientName));
		player->sendStoreBalances();
	}

	void System::sendHistory(const PlayerPtr& player, uint32_t page, uint8_t perPage) const
	{
		uint32_t pages = 0;
		const auto entries = getHistory(player->getAccount(), page, perPage == 0 ? config.history_page_size : perPage, pages);
		if (entries.empty())
		{
			player->sendStoreError(Error::History, "You do not have any entries yet.");
			return;
		}
		player->sendStoreHistory(page, pages, entries);
	}

	void System::sendDescription(const PlayerPtr& player, uint32_t offerId) const
	{
		const auto* window = getWindow(player);
		const auto* product = window ? window->getProductById(offerId) : nullptr;
		if (product)
		{
			player->sendStoreOfferDescription(product->id, product->description);
		}
	}

	bool System::addCoins(const PlayerPtr& player, uint32_t amount, Coins coins, const std::string& description, Mode mode) const
	{
		if (not player or amount == 0)
		{
			return false;
		}
		if (coins == Coins::Transferable)
		{
			player->setCoins(player->getCoins(), player->getTransferableCoins() + amount);
		}
		else
		{
			player->setCoins(player->getCoins() + amount, player->getTransferableCoins());
		}
		saveCoins(player);
		record(player->getAccount(), mode, static_cast<int32_t>(amount), coins, description);
		player->sendStoreBalances();
		return true;
	}

	// a regular price is paid from the regular coins first, then from the transferable ones
	bool System::removeCoins(const PlayerPtr& player, uint32_t amount, Coins coins, const std::string& description) const
	{
		if (not player or amount == 0 or BalanceFor(player, coins) < amount)
		{
			return false;
		}
		uint32_t regular = player->getCoins();
		uint32_t transferable = player->getTransferableCoins();
		if (coins == Coins::Transferable)
		{
			transferable -= amount;
		}
		else
		{
			const uint32_t fromRegular = std::min(regular, amount);
			regular -= fromRegular;
			transferable -= amount - fromRegular;
		}
		player->setCoins(regular, transferable);
		saveCoins(player);
		record(player->getAccount(), Mode::Normal, -static_cast<int32_t>(amount), coins, description);
		return true;
	}

	void System::saveCoins(const PlayerPtr& player) const
	{
		Database& db = Database::getInstance();
		db.executeQuery(fmt::format("UPDATE `accounts` SET `coins` = {:d}, `coins_transferable` = {:d} WHERE `id` = {:d}", player->getCoins(), player->getTransferableCoins(), player->getAccount()));
	}

	void System::record(uint32_t accountId, Mode mode, int32_t amount, Coins coins, const std::string& description) const
	{
		Database& db = Database::getInstance();
		db.executeQuery(fmt::format("INSERT INTO `store_history` (`account_id`, `mode`, `amount`, `coin_type`, `description`, `created`) VALUES ({:d}, {:d}, {:d}, {:d}, {:s}, {:d})",
			accountId, std::to_underlying(mode), amount, std::to_underlying(coins), db.escapeString(description), static_cast<int64_t>(time(nullptr))));
	}

	std::vector<HistoryEntry> System::getHistory(uint32_t accountId, uint32_t page, uint8_t perPage, uint32_t& pages) const
	{
		std::vector<HistoryEntry> entries;
		Database& db = Database::getInstance();
		const uint32_t size = std::max<uint8_t>(1, perPage);

		uint32_t total = 0;
		if (const auto count = db.storeQuery(fmt::format("SELECT COUNT(*) AS `total` FROM `store_history` WHERE `account_id` = {:d}", accountId)))
		{
			total = count->getNumber<uint32_t>("total");
		}
		pages = (total + size - 1) / size;
		if (page >= pages)
		{
			return entries;
		}

		auto result = db.storeQuery(fmt::format("SELECT `mode`, `amount`, `coin_type`, `description`, `created` FROM `store_history` WHERE `account_id` = {:d} ORDER BY `created` DESC, `id` DESC LIMIT {:d} OFFSET {:d}",
			accountId, size, page * size));
		if (not result)
		{
			return entries;
		}
		do
		{
			HistoryEntry entry;
			entry.mode = static_cast<Mode>(result->getNumber<uint8_t>("mode"));
			entry.amount = result->getNumber<int32_t>("amount");
			entry.coins = static_cast<Coins>(result->getNumber<uint8_t>("coin_type"));
			entry.description = result->getString("description");
			entry.created_at = result->getNumber<int64_t>("created");
			entries.push_back(std::move(entry));
		} while (result->next());
		return entries;
	}
}
