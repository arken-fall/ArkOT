// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include "declarations.h"
#include "enums.h"

#include <cstdint>
#include <memory>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

class LuaScriptInterface;

namespace BlackTek
{
	// one offer on the store's shelves; the client draws items, outfits and
	// mounts itself and fetches an icon by name for everything else
	struct StoreProduct
	{
		enum class Kind : uint8_t
		{
			Other = 0,
			Mount = 1,
			Outfit = 2,
			Item = 3,
		};

		enum class State : uint8_t
		{
			None = 0,
			New = 1,
			Sale = 2,
			Timed = 3,
		};

		enum class Coins : uint8_t
		{
			Regular = 0,
			Transferable = 1,
		};

		uint32_t	id = 0;
		uint32_t	price = 0;
		State		state = State::None;
		Coins		coins = Coins::Regular;
		Kind		kind = Kind::Other;
		bool		enabled = true;
		bool		home = false; // shown on the front page
		bool		movable = false; // delivered without the store item mark, so it can leave the inbox
		uint16_t	item_id = 0; // server item id for Kind::Item
		uint16_t	count = 1; // items handed over, or charges
		uint16_t	looktype_male = 0; // Kind::Outfit
		uint16_t	looktype_female = 0;
		uint8_t		addons = 0;
		uint8_t		mount_id = 0; // Kind::Mount
		std::string	name;
		std::string	description;
		std::vector<std::string> icons;
	};

	class StoreCategory
	{
		public:
			StoreProduct& addProduct(uint32_t id, const std::string& name, uint32_t price, const std::string& icon, const std::string& description = "");
			[[nodiscard]] const StoreProduct* getProductById(uint32_t id) const noexcept;
			[[nodiscard]] StoreProduct* getProductById(uint32_t id) noexcept;

			// the datapack's say on a purchase, when it registered one
			bool executePurchase(const PlayerPtr& player, uint32_t productId, uint8_t offerType, const std::string& param) const;
			bool executeCanPurchase(const PlayerPtr& player, uint32_t productId, std::string& outReason) const;

			std::string	name;
			std::string	parent_name;
			StoreProduct::State	state = StoreProduct::State::None;
			std::vector<std::string> icons;
			std::vector<StoreProduct> products;
			int32_t		on_purchase_script_id = -1;
			int32_t		can_purchase_script_id = -1;
			LuaScriptInterface*	script_interface = nullptr;
	};

	class StoreWindow
	{
		public:
			explicit StoreWindow(std::string title);
			~StoreWindow() = default;

			void setAccountType(AccountType_t type) noexcept								{ account_type = type; }
			StoreCategory* addCategory(const std::string& name, const std::string& icon);
			[[nodiscard]] StoreCategory* getCategoryByName(std::string_view name) noexcept;
			[[nodiscard]] const StoreCategory* getCategoryByName(std::string_view name) const noexcept;
			[[nodiscard]] const StoreCategory* getCategoryByProduct(uint32_t productId) const noexcept;
			[[nodiscard]] const StoreProduct* getProductById(uint32_t productId) const noexcept;

			[[nodiscard]] const std::string& getTitle() const noexcept						{ return title; }
			[[nodiscard]] AccountType_t getRequiredAccountType() const noexcept				{ return account_type; }
			[[nodiscard]] const std::vector<std::unique_ptr<StoreCategory>>& getCategories() const noexcept { return categories; }

			void executeOnOpen(const PlayerPtr& player) const;

			bool		from_lua = false;
			int32_t		on_open_script_id = -1;
			LuaScriptInterface*	script_interface = nullptr;

		private:
			std::string	title;
			AccountType_t	account_type = ACCOUNT_TYPE_NORMAL;
			std::vector<std::unique_ptr<StoreCategory>> categories;
	};

	class StoreManager
	{
		public:
			static StoreManager& getInstance();

			bool registerWindow(StoreWindow* window);
			[[nodiscard]] StoreWindow* getWindowForAccountType(AccountType_t type) const noexcept;
			void clear();

		private:
			StoreManager() = default;

			std::unordered_map<uint8_t, StoreWindow*> windows;
	};
}

#define g_storeManager (BlackTek::StoreManager::getInstance())
