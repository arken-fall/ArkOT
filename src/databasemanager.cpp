// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "configmanager.h"
#include "console.h"
#include "databasemanager.h"
#include "luascript.h"

#include <fmt/format.h>

extern ConfigManager g_config;

namespace
{
	// A Lua error value is usually a string, but a script is free to raise
	// anything, and lua_tostring returns nullptr for a value it cannot convert.
	// The message a refused boot carries must never be built from that.
	[[nodiscard]] std::string LuaErrorText(lua_State* state)
	{
		const char* text = lua_tostring(state, -1);
		return text ? std::string{ text } : std::string{ "the script raised a non-textual error" };
	}
}

bool DatabaseManager::optimizeTables()
{
	Database& db = Database::getInstance();

	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `TABLE_NAME` FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = {:s} AND `DATA_FREE` > 0", db.escapeString(g_config.GetString(ConfigManager::MYSQL_DB))));
	if (not result)
	{
		return false;
	}

	do
	{
		const auto tableName = result->getString("TABLE_NAME");
		std::cout << "> Optimizing table " << tableName << "..." << std::flush;

		if (db.executeQuery(fmt::format("OPTIMIZE TABLE `{:s}`", tableName)))
			std::cout << " [success]" << std::endl;
		else
			std::cout << " [failed]" << std::endl;

	} while (result->next());
	return true;
}

bool DatabaseManager::tableExists(const std::string& tableName)
{
	Database& db = Database::getInstance();
	return db.storeQuery(fmt::format("SELECT `TABLE_NAME` FROM `information_schema`.`tables` WHERE `TABLE_SCHEMA` = {:s} AND `TABLE_NAME` = {:s} LIMIT 1", db.escapeString(g_config.GetString(ConfigManager::MYSQL_DB)), db.escapeString(tableName))).get() != nullptr;
}

bool DatabaseManager::isDatabaseSetup()
{
	Database& db = Database::getInstance();
	return db.storeQuery(fmt::format("SELECT `TABLE_NAME` FROM `information_schema`.`tables` WHERE `TABLE_SCHEMA` = {:s}", db.escapeString(g_config.GetString(ConfigManager::MYSQL_DB)))).get() != nullptr;
}

int32_t DatabaseManager::getDatabaseVersion()
{
	Database& db = Database::getInstance();
	if (not tableExists("server_config"))
	{
		db.executeQuery("CREATE TABLE `server_config` (`config` VARCHAR(50) NOT NULL, `value` VARCHAR(256) NOT NULL DEFAULT '', UNIQUE(`config`)) ENGINE = InnoDB");
	}

	int32_t version = 0;
	if (getDatabaseConfig("db_version", version))
	{
		return version;
	}
	else
	{
		db.executeQuery("INSERT INTO `server_config` VALUES ('db_version', 0)");
		return 0;
	}
}

std::expected<int32_t, std::string> DatabaseManager::UpdateDatabase()
{
	lua_State* L = luaL_newstate();
	if (not L)
	{
		return std::unexpected<std::string>("Database migrations: a Lua state could not be created, so no migration could be run.");
	}

	// every exit below carries a message out of this function, so the state is
	// closed by scope rather than by a close call on each of those paths
	const auto closeState = [](lua_State* state) noexcept { lua_close(state); };
	const std::unique_ptr<lua_State, decltype(closeState)> stateGuard{ L, closeState };

	luaL_openlibs(L);

	//db table
	luaL_register(L, "db", LuaScriptInterface::luaDatabaseTable);

	//result table
	luaL_register(L, "result", LuaScriptInterface::luaResultTable);

	int32_t version = getDatabaseVersion();
	do
	{
		const std::string migration = fmt::format("data/migrations/{:d}.lua", version);

		// A schema at the head of the chain has no next file, which is what a fully
		// migrated database looks like, not a failure. Only a file that is there and
		// will not load is one. exists() is asked with an error_code so that a
		// directory this process cannot read is reported rather than mistaken for
		// the end of the chain.
		std::error_code probe;
		const bool present = std::filesystem::exists(migration, probe);
		if (probe)
		{
			return std::unexpected(fmt::format("Database migration {:d}: '{:s}' could not be read: {:s}.", version, migration, probe.message()));
		}

		if (not present)
		{
			break;
		}

		if (luaL_dofile(L, migration.c_str()) != 0)
		{
			return std::unexpected(fmt::format("Database migration {:d} ('{:s}') failed to load: {:s}.", version, migration, LuaErrorText(L)));
		}

		if (not LuaScriptInterface::reserveScriptEnv())
		{
			return std::unexpected(fmt::format("Database migration {:d} ('{:s}') could not reserve a script environment.", version, migration));
		}

		lua_getglobal(L, "onUpdateDatabase");
		if (lua_pcall(L, 0, 1, 0) != 0)
		{
			// read before the reset, which is free to disturb the Lua stack
			const std::string error = LuaErrorText(L);
			LuaScriptInterface::resetScriptEnv();
			return std::unexpected(fmt::format("Database migration {:d} ('{:s}') failed: {:s}.", version, migration, error));
		}

		// a script that returns false has decided there is nothing left to migrate:
		// the chain ending, not the chain breaking
		if (not LuaScriptInterface::getBoolean(L, -1, false))
		{
			LuaScriptInterface::resetScriptEnv();
			break;
		}

		version++;
		BlackTek::Console::Print("> Database has been updated to version {:d}.", version);
		registerDatabaseConfig("db_version", version);

		LuaScriptInterface::resetScriptEnv();
	} while (true);

	return version;
}

bool DatabaseManager::getDatabaseConfig(const std::string& config, int32_t& value)
{
	Database& db = Database::getInstance();

	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `value` FROM `server_config` WHERE `config` = {:s}", db.escapeString(config)));
	if (not result)
	{
		return false;
	}

	value = result->getNumber<int32_t>("value");
	return true;
}

void DatabaseManager::registerDatabaseConfig(const std::string& config, int32_t value)
{
	Database& db = Database::getInstance();

	int32_t tmp;

	if (not getDatabaseConfig(config, tmp))
	{
		db.executeQuery(fmt::format("INSERT INTO `server_config` VALUES ({:s}, '{:d}')", db.escapeString(config), value));
	}
	else
	{
		db.executeQuery(fmt::format("UPDATE `server_config` SET `value` = '{:d}' WHERE `config` = {:s}", value, db.escapeString(config)));
	}
}
