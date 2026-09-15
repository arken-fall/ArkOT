// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "storewindow.h"
#include "console.h"
#include "luascript.h"

#include <algorithm>
#include <ranges>

namespace BlackTek
{
	StoreProduct& StoreCategory::addProduct(uint32_t id, const std::string& name, uint32_t price, const std::string& icon, const std::string& description)
	{
		StoreProduct product;
		product.id = id;
		product.name = name;
		product.price = price;
		product.description = description;
		if (not icon.empty())
		{
			product.icons.push_back(icon);
		}
		products.push_back(std::move(product));
		return products.back();
	}

	const StoreProduct* StoreCategory::getProductById(uint32_t id) const noexcept
	{
		const auto it = std::ranges::find(products, id, &StoreProduct::id);
		return it != products.end() ? &*it : nullptr;
	}

	StoreProduct* StoreCategory::getProductById(uint32_t id) noexcept
	{
		const auto it = std::ranges::find(products, id, &StoreProduct::id);
		return it != products.end() ? &*it : nullptr;
	}

	bool StoreCategory::executePurchase(const PlayerPtr& player, uint32_t productId, uint8_t offerType, const std::string& param) const
	{
		if (on_purchase_script_id == -1 or not script_interface)
		{
			return false;
		}
		if (not script_interface->reserveScriptEnv())
		{
			Console::Error("StoreCategory::executePurchase: call stack overflow");
			return false;
		}

		ScriptEnvironment* env = script_interface->getScriptEnv();
		env->setScriptId(on_purchase_script_id, script_interface);
		lua_State* L = script_interface->getLuaState();
		script_interface->pushFunction(on_purchase_script_id);
		LuaScriptInterface::pushSharedPtr(L, player);
		LuaScriptInterface::setMetatable(L, -1, "Player");
		lua_pushinteger(L, static_cast<lua_Integer>(productId));
		lua_pushinteger(L, static_cast<lua_Integer>(offerType));
		LuaScriptInterface::pushString(L, param);
		return script_interface->callFunction(4);
	}

	bool StoreCategory::executeCanPurchase(const PlayerPtr& player, uint32_t productId, std::string& outReason) const
	{
		if (can_purchase_script_id == -1 or not script_interface)
		{
			return true;
		}
		if (not script_interface->reserveScriptEnv())
		{
			Console::Error("StoreCategory::executeCanPurchase: call stack overflow");
			return true;
		}

		ScriptEnvironment* env = script_interface->getScriptEnv();
		env->setScriptId(can_purchase_script_id, script_interface);
		lua_State* L = script_interface->getLuaState();
		script_interface->pushFunction(can_purchase_script_id);
		LuaScriptInterface::pushSharedPtr(L, player);
		LuaScriptInterface::setMetatable(L, -1, "Player");
		lua_pushinteger(L, static_cast<lua_Integer>(productId));
		if (LuaScriptInterface::protectedCall(L, 2, 2) != 0)
		{
			LuaScriptInterface::reportError(nullptr, LuaScriptInterface::getString(L, -1));
			lua_pop(L, 1);
			script_interface->resetScriptEnv();
			return true;
		}

		const bool allowed = LuaScriptInterface::getBoolean(L, -2, true);
		if (not allowed)
		{
			outReason = LuaScriptInterface::getString(L, -1);
		}
		lua_pop(L, 2);
		script_interface->resetScriptEnv();
		return allowed;
	}

	StoreWindow::StoreWindow(std::string title) : title(std::move(title))
	{
	}

	StoreCategory* StoreWindow::addCategory(const std::string& name, const std::string& icon)
	{
		auto category = std::make_unique<StoreCategory>();
		category->name = name;
		if (not icon.empty())
		{
			category->icons.push_back(icon);
		}
		auto* pointer = category.get();
		categories.push_back(std::move(category));
		return pointer;
	}

	StoreCategory* StoreWindow::getCategoryByName(std::string_view name) noexcept
	{
		const auto it = std::ranges::find_if(categories, [name](const auto& category) { return strcasecmp(category->name.c_str(), std::string(name).c_str()) == 0; });
		return it != categories.end() ? it->get() : nullptr;
	}

	const StoreCategory* StoreWindow::getCategoryByName(std::string_view name) const noexcept
	{
		const auto it = std::ranges::find_if(categories, [name](const auto& category) { return strcasecmp(category->name.c_str(), std::string(name).c_str()) == 0; });
		return it != categories.end() ? it->get() : nullptr;
	}

	const StoreCategory* StoreWindow::getCategoryByProduct(uint32_t productId) const noexcept
	{
		const auto it = std::ranges::find_if(categories, [productId](const auto& category) { return category->getProductById(productId) != nullptr; });
		return it != categories.end() ? it->get() : nullptr;
	}

	const StoreProduct* StoreWindow::getProductById(uint32_t productId) const noexcept
	{
		const auto* category = getCategoryByProduct(productId);
		return category ? category->getProductById(productId) : nullptr;
	}

	void StoreWindow::executeOnOpen(const PlayerPtr& player) const
	{
		if (on_open_script_id == -1 or not script_interface)
		{
			return;
		}
		if (not script_interface->reserveScriptEnv())
		{
			Console::Error("StoreWindow::executeOnOpen: call stack overflow");
			return;
		}

		ScriptEnvironment* env = script_interface->getScriptEnv();
		env->setScriptId(on_open_script_id, script_interface);
		lua_State* L = script_interface->getLuaState();
		script_interface->pushFunction(on_open_script_id);
		LuaScriptInterface::pushSharedPtr(L, player);
		LuaScriptInterface::setMetatable(L, -1, "Player");
		script_interface->callVoidFunction(1);
	}

	StoreManager& StoreManager::getInstance()
	{
		static StoreManager instance;
		return instance;
	}

	bool StoreManager::registerWindow(StoreWindow* window)
	{
		if (not window)
		{
			return false;
		}
		windows[static_cast<uint8_t>(window->getRequiredAccountType())] = window;
		return true;
	}

	// the window for the highest account type at or below the asked one
	StoreWindow* StoreManager::getWindowForAccountType(AccountType_t type) const noexcept
	{
		for (int candidate = static_cast<int>(type); candidate >= 0; --candidate)
		{
			if (const auto it = windows.find(static_cast<uint8_t>(candidate)); it != windows.end())
			{
				return it->second;
			}
		}
		return nullptr;
	}

	void StoreManager::clear()
	{
		for (auto& [type, window] : windows)
		{
			if (window and window->from_lua)
			{
				delete window;
			}
		}
		windows.clear();
	}
}
