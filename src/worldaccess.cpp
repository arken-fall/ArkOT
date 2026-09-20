// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "worldaccess.h"
#include "console.h"
#include "database.h"

#include <fmt/format.h>

namespace BlackTek::World
{
	namespace
	{
		constexpr std::string_view GrantTable = "account_roles";

		// The grant table has no per-world view, so it is named in the auth schema
		// directly, exactly as BlackTek::World::Presence names its own tables. An
		// identifier cannot go through escapeString, which is why Start() refuses a
		// schema name containing a backtick before anything is ever built from it.
		//
		// EXISTS() yields exactly one row whatever the catalogue holds, so an absent
		// table is not mistaken for a failed query by the row count - though both
		// arrive as a nullptr result, and both must refuse.
		[[nodiscard]] std::string GrantTableProbe(Database& db, std::string_view authSchema)
		{
			return fmt::format("SELECT EXISTS(SELECT 1 FROM `information_schema`.`TABLES` WHERE `TABLE_SCHEMA` = {:s} AND `TABLE_TYPE` = 'BASE TABLE' AND `TABLE_NAME` = {:s}) AS `present`", db.escapeString(authSchema), db.escapeString(GrantTable));
		}

		// One round trip answers both halves of the question from one snapshot: what
		// the account's type is, and whether it holds the role this world requires.
		//
		// `accounts` stays unqualified so it resolves through this world's view into
		// the auth schema, the way every other account query in this process does
		// (src/iologindata.cpp:92). `account_roles` has no such view and is named in
		// the auth schema directly.
		//
		// The role is escaped even though Registry::Load already restricted it to
		// lowercase a-z, digits and underscore: that alphabet is the guarantee, this
		// is the second layer that survives someone widening it. EXISTS() keeps the
		// row present whether or not the grant is there, so an empty result can only
		// mean the account row is gone or the query failed.
		[[nodiscard]] std::string AdmissionQuery(Database& db, std::string_view authSchema, std::string_view requiredRole, uint32_t accountId)
		{
			return fmt::format("SELECT `a`.`type` AS `type`, EXISTS(SELECT 1 FROM `{:s}`.`account_roles` AS `r` WHERE `r`.`account_id` = `a`.`id` AND `r`.`role` = {:s}) AS `granted` FROM `accounts` AS `a` WHERE `a`.`id` = {:d}", authSchema, db.escapeString(requiredRole), accountId);
		}
	}

	std::expected<void, std::string> Access::Start(std::string_view authSchema)
	{
		// identifiers cannot go through escapeString, so an unquotable name is never stored
		const bool quotable = authSchema.find('`') == std::string_view::npos;

		if (quotable)
			auth_schema = authSchema;

		// Local() on an unloaded registry is a blank entry, whose empty required_role
		// would read as "public" - an admission this subsystem cannot prove. Refuse
		// rather than guess, as Presence::Start does for the same reason.
		if (Registry::GetInstance().All().empty())
			return std::unexpected(std::string{ "World::Access::Start: the world registry is not loaded." });

		const Entry& self = Local();

		// The whole point of the design: a public world asks nothing of an account, so
		// it needs no auth schema, no grant table, and no query on any login path.
		if (self.required_role.empty())
			return {};

		if (authSchema.empty())
		{
			return std::unexpected(fmt::format("World access: world '{:s}' (id {:d}) requires the role '{:s}', but no shared auth schema is configured. Roles are granted in the shared auth schema, so set [mysql].auth_database in config/database.toml to it, or remove `access` from this world's row in config/worlds.toml.", self.name, self.id, self.required_role));
		}

		if (not quotable)
		{
			return std::unexpected(fmt::format("World access: the auth schema name '{:s}' contains a backtick, so world '{:s}' (id {:d}) cannot read the role it requires. Rename the schema in [mysql].auth_database in config/database.toml.", authSchema, self.name, self.id));
		}

		Database& db = Database::getInstance();

		const auto probe = db.storeQuery(GrantTableProbe(db, authSchema));

		// storeQuery returns nullptr for a failed query as readily as for an empty
		// result (src/database.cpp:148-150), so an unreadable catalogue and an absent
		// table land in the same branch - and both must refuse. A world that boots
		// without being able to read its own grant table would refuse every login it
		// was provisioned to admit.
		if (not probe or probe->getNumber<uint32_t>("present") == 0)
		{
			return std::unexpected(fmt::format("World access: world '{:s}' (id {:d}) requires the role '{:s}', but `{:s}`.`{:s}` could not be read as a base table. Create it in auth schema '{:s}' and grant this MySQL user SELECT on it, then start the server again.", self.name, self.id, self.required_role, authSchema, GrantTable, authSchema));
		}

		Console::Security::Info("World::Access::Start: world '{:s}' (id {:d}) is private; entry requires the role '{:s}', granted in `{:s}`.`{:s}`.", self.name, self.id, self.required_role, auth_schema, GrantTable);
		return {};
	}

	Access::Admission Access::Admit(uint32_t accountId, Id world) const
	{
		const Entry* entry = Registry::GetInstance().Find(world);

		// A world the registry does not declare cannot be proven public, so it is
		// refused instead of waved through.
		if (not entry)
		{
			Console::Security::Warn("World::Access::Admit: account {:d} was checked against world id {:d}, which the registry does not declare; the login was refused.", accountId, world);
			return std::unexpected(Refusal::Unavailable);
		}

		// The zero-cost path, and the one the live public worlds take: no role, no
		// query, no round trip added to a login that used to have none.
		if (entry->required_role.empty())
			return {};

		// Start() refuses the boot for exactly this, so reaching here means the world
		// went private after boot - which it cannot. Fail closed anyway; a guard that
		// only runs when something impossible happened costs one predictable branch.
		if (auth_schema.empty())
		{
			Console::Database::Error("World::Access::Admit: world '{:s}' (id {:d}) requires the role '{:s}' but no auth schema is known; account {:d} was refused.", entry->name, entry->id, entry->required_role, accountId);
			return std::unexpected(Refusal::Unavailable);
		}

		Database& db = Database::getInstance();

		const auto result = db.storeQuery(AdmissionQuery(db, auth_schema, entry->required_role, accountId));

		if (not result)
		{
			Console::Database::Error("World::Access::Admit: could not read account {:d}'s entry to world '{:s}' (id {:d}); the login was refused.", accountId, entry->name, entry->id);
			return std::unexpected(Refusal::Unavailable);
		}

		// Staff hold every key: the same accounts the deployment-wide session rule
		// already exempts, and the ones who have to reach a world to fix it.
		if (IsStaffAccount(static_cast<AccountType_t>(result->getNumber<uint16_t>("type"))))
			return {};

		if (result->getNumber<uint32_t>("granted") != 0)
			return {};

		Console::Security::Warn("World::Access::Admit: account {:d} holds no '{:s}' role and was refused entry to world '{:s}' (id {:d}).", accountId, entry->required_role, entry->name, entry->id);
		return std::unexpected(Refusal::NotInvited);
	}
}
