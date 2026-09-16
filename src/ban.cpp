// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "ban.h"
#include "console.h"
#include "database.h"
#include "databasetasks.h"
#include "tools.h"

#include <fmt/format.h>
#include <string>
#include <vector>

bool Ban::acceptConnection(uint32_t clientIP)
{
	std::lock_guard<std::recursive_mutex> lockClass(lock);

	uint64_t currentTime = OTSYS_TIME();

	auto it = ipConnectMap.find(clientIP);
	if (it == ipConnectMap.end()) {
		ipConnectMap.emplace(clientIP, ConnectBlock(currentTime, 0, 1));
		return true;
	}

	ConnectBlock& connectBlock = it->second;
	if (connectBlock.blockTime > currentTime) {
		connectBlock.blockTime += 250;
		return false;
	}

	int64_t timeDiff = currentTime - connectBlock.lastAttempt;
	connectBlock.lastAttempt = currentTime;
	if (timeDiff <= 5000) {
		if (++connectBlock.count > 5) {
			connectBlock.count = 0;
			if (timeDiff <= 500) {
				connectBlock.blockTime = currentTime + 3000;
				return false;
			}
		}
	} else {
		connectBlock.count = 1;
	}
	return true;
}

namespace
{
	struct ExpiredBan
	{
		std::string	reason;
		std::string	banned_by_name;
		int64_t		banned_at = 0;
		int64_t		expires_at = 0;
		uint32_t	account_id = 0;
		uint32_t	banned_by = 0;
	};

	// copies the row out, so the ban outlives the result it was read from
	ExpiredBan ReadBan(const DBResult& row, uint32_t accountId)
	{
		return ExpiredBan
		{
			.reason			= std::string(row.getString("reason")),
			.banned_by_name	= std::string(row.getString("banned_by_name")),
			.banned_at		= row.getNumber<int64_t>("banned_at"),
			.expires_at		= row.getNumber<int64_t>("expires_at"),
			.account_id		= accountId,
			.banned_by		= row.getNumber<uint32_t>("banned_by")
		};
	}

	// the guarded DELETE decides who moves the ban: only the caller whose DELETE
	// removed the row writes history, however many worlds notice the expiry at once.
	// It runs synchronously on the main connection because the affected-row count
	// must come from the connection that ran the DELETE, which g_databaseTasks'
	// callback cannot hand back. No DBTransaction: see the phase 2 plan, section 6.
	void RetireExpiredBan(const ExpiredBan& ban)
	{
		Database& db = Database::getInstance();

		// banned_at and expires_at pin the exact ban, so a newer ban issued for the
		// same account after this one was read is never removed by mistake
		if (not db.executeQuery(fmt::format(
			"DELETE FROM `account_bans` WHERE `account_id` = {:d} AND `banned_at` = {:d} AND `expires_at` = {:d}",
			ban.account_id, ban.banned_at, ban.expires_at)))
		{
			BlackTek::Console::Database::Error("IOBan::RetireExpiredBan: removing the expired ban of account {:d} failed", ban.account_id);
			return;
		}

		// 0 means another world, or an earlier resend, already moved this ban
		if (db.getAffectedRows() != 1)
			return;

		// a failed history write is logged, never undone: the ban has expired either way
		if (not db.executeQuery(fmt::format(
			"INSERT INTO `account_ban_history` (`account_id`, `reason`, `banned_at`, `expired_at`, `banned_by`, `banned_by_name`) VALUES ({:d}, {:s}, {:d}, {:d}, {:d}, {:s})",
			ban.account_id, db.escapeString(ban.reason), ban.banned_at, ban.expires_at, ban.banned_by, db.escapeString(ban.banned_by_name))))
		{
			BlackTek::Console::Database::Error("IOBan::RetireExpiredBan: the history row for the expired ban of account {:d} could not be written", ban.account_id);
		}
	}
}

bool IOBan::isAccountBanned(uint32_t accountId, BanInfo& banInfo)
{
	Database& db = Database::getInstance();

	// the issuer's name is read from the ban itself: `banned_by` is a character id
	// on whichever world issued the ban, so looking it up in this world's `players`
	// would name the wrong character or none
	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `reason`, `expires_at`, `banned_at`, `banned_by`, `banned_by_name` FROM `account_bans` WHERE `account_id` = {:d}", accountId));
	if (not result)
		return false;

	const int64_t expiresAt = result->getNumber<int64_t>("expires_at");
	if (expiresAt != 0 and time(nullptr) > expiresAt)
	{
		const ExpiredBan ban = ReadBan(*result, accountId);
		result.reset();
		RetireExpiredBan(ban);
		return false;
	}

	banInfo.expiresAt = expiresAt;
	banInfo.reason = result->getString("reason");
	banInfo.bannedBy = result->getString("banned_by_name");
	return true;
}

void IOBan::sweepExpiredAccountBans()
{
	Database& db = Database::getInstance();

	std::vector<ExpiredBan> expiredBans;
	if (DBResult_ptr result = db.storeQuery(fmt::format("SELECT `account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`, `banned_by_name` FROM `account_bans` WHERE `expires_at` != 0 AND `expires_at` <= {:d}", static_cast<int64_t>(time(nullptr)))))
	{
		// read every row before issuing a single DELETE, so no write runs while the result is being walked
		do
		{
			expiredBans.push_back(ReadBan(*result, result->getNumber<uint32_t>("account_id")));
		}
		while (result->next());
	}

	for (const ExpiredBan& ban : expiredBans)
		RetireExpiredBan(ban);
}

bool IOBan::isIpBanned(uint32_t clientIP, BanInfo& banInfo)
{
	if (clientIP == 0) {
		return false;
	}

	Database& db = Database::getInstance();

	DBResult_ptr result = db.storeQuery(fmt::format("SELECT `reason`, `expires_at`, (SELECT `name` FROM `players` WHERE `id` = `banned_by`) AS `name` FROM `ip_bans` WHERE `ip` = {:d}", clientIP));
	if (!result) {
		return false;
	}

	int64_t expiresAt = result->getNumber<int64_t>("expires_at");
	if (expiresAt != 0 && time(nullptr) > expiresAt) {
		g_databaseTasks.addTask(fmt::format("DELETE FROM `ip_bans` WHERE `ip` = {:d}", clientIP));
		return false;
	}

	banInfo.expiresAt = expiresAt;
	banInfo.reason = result->getString("reason");
	banInfo.bannedBy = result->getString("name");
	return true;
}

bool IOBan::isPlayerNamelocked(uint32_t playerId)
{
	return Database::getInstance().storeQuery(fmt::format("SELECT 1 FROM `player_namelocks` WHERE `player_id` = {:d}", playerId)).get() != nullptr;
}
