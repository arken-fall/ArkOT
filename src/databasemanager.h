// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_DATABASEMANAGER_H
#define FS_DATABASEMANAGER_H
#include "database.h"

#include <expected>
#include <string>

class DatabaseManager
{
	public:
		static bool tableExists(const std::string& tableName);

		static int32_t getDatabaseVersion();
		static bool isDatabaseSetup();

		static bool optimizeTables();

		// The version the schema reached, or why a migration stopped. A migration
		// that fails leaves a half-migrated schema, which the caller has to refuse
		// to run on rather than discover later through a query that silently reads
		// the wrong thing.
		[[nodiscard]] static std::expected<int32_t, std::string> UpdateDatabase();

		static bool getDatabaseConfig(const std::string& config, int32_t& value);
		static void registerDatabaseConfig(const std::string& config, int32_t value);
};
#endif
