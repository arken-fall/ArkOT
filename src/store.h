// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include "storewindow.h"

#include <cstdint>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

class Player;
using PlayerPtr = std::shared_ptr<Player>;

namespace BlackTek::Store
{
	// config/store.toml
	struct Config
	{
		bool		enabled = true;
		std::string	images_url = "http://127.0.0.1/images/store/"; // where the client fetches icons and banners
		uint16_t	coin_package_size = 25;
		uint8_t		banner_delay = 10; // seconds between the front page's banners
		uint8_t		history_page_size = 26;
		std::vector<std::string> banners; // image names under images_url
	};

	// one line of an account's coin history
	struct HistoryEntry
	{
		enum class Mode : uint8_t
		{
			Normal = 0,
			Gift = 1,
			Refund = 2,
		};

		int64_t		created_at = 0;
		Mode		mode = Mode::Normal;
		int32_t		amount = 0; // negative when spent
		StoreProduct::Coins	coins = StoreProduct::Coins::Regular;
		std::string	description;
	};

	class System
	{
		public:
			// what the client asks to browse
			enum class Action : uint8_t
			{
				Home = 0,
				PremiumBoost = 1,
				Category = 2,
				UsefulThings = 3,
				Offer = 4,
				Search = 5,
			};

			// the kinds of failure the client shows
			enum class Error : uint8_t
			{
				Purchase = 0,
				Network = 1,
				History = 2,
				Transfer = 3,
				Information = 4,
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

			[[nodiscard]] const StoreWindow* getWindow(const PlayerPtr& player) const noexcept;

			// the client's requests
			void open(const PlayerPtr& player) const;
			void browse(const PlayerPtr& player, Action action, const std::string& text, uint8_t subAction, uint32_t offerId) const;
			void purchase(const PlayerPtr& player, uint32_t offerId, uint8_t productType, const std::string& param) const;
			void transfer(const PlayerPtr& player, const std::string& recipientName, uint32_t amount) const;
			void sendHistory(const PlayerPtr& player, uint32_t page, uint8_t perPage) const;
			void sendDescription(const PlayerPtr& player, uint32_t offerId) const;

			// the account's coins; every change is written through and recorded
			bool addCoins(const PlayerPtr& player, uint32_t amount, StoreProduct::Coins coins, const std::string& description, HistoryEntry::Mode mode = HistoryEntry::Mode::Normal) const;
			bool removeCoins(const PlayerPtr& player, uint32_t amount, StoreProduct::Coins coins, const std::string& description) const;
			[[nodiscard]] std::vector<HistoryEntry> getHistory(uint32_t accountId, uint32_t page, uint8_t perPage, uint32_t& pages) const;

			// why a product is greyed out for this character, or empty
			[[nodiscard]] std::string disabledReason(const PlayerPtr& player, const StoreCategory& category, const StoreProduct& product) const;

		private:
			System() = default;

			bool deliver(const PlayerPtr& player, const StoreCategory& category, const StoreProduct& product, uint8_t productType, const std::string& param) const;
			void record(uint32_t accountId, HistoryEntry::Mode mode, int32_t amount, StoreProduct::Coins coins, const std::string& description) const;
			void saveCoins(const PlayerPtr& player) const;
			[[nodiscard]] std::vector<const StoreProduct*> search(const StoreWindow& window, std::string_view text) const;

			Config config;
	};
}
