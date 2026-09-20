// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#pragma once

#include "enums.h"
#include "world.h"

#include <cstdint>
#include <expected>
#include <string>
#include <string_view>

namespace BlackTek::World
{
	// One spelling of "this account is staff". Account type is account-level, so it
	// is shared across worlds through the `accounts` view, and staff are the accounts
	// every deployment-wide rule has always exempted.
	[[nodiscard]] constexpr bool IsStaffAccount(AccountType_t accountType) noexcept
	{
		return accountType >= ACCOUNT_TYPE_GAMEMASTER;
	}

	// The private-world gate. A world's row in config/worlds.toml either names the
	// role an account must hold to log in here, or it does not; a row that names no
	// role is public and this subsystem costs it nothing at all - not one query on
	// the login path, which is what the live public worlds need.
	//
	// Dispatcher only. Start() writes the schema name once at boot, before any
	// listener accepts; every later call only reads it, so no synchronisation is
	// needed and none is introduced.
	class Access
	{
		public:
			enum class Refusal : uint8_t
			{
				NotInvited,		// the account holds no grant for this world's role
				Unavailable,	// the answer could not be established; fails closed
			};

			using Admission = std::expected<void, Refusal>;

			// non-copyable
			Access(const Access&) = delete;
			Access& operator=(const Access&) = delete;

			static Access& GetInstance() noexcept
			{
				static Access instance;
				return instance;
			}

			// mainLoader, once, after the world registry is loaded and the database is
			// connected. A public world stores the schema and requires nothing further.
			// A world whose row names a role must prove, here, that it can read the
			// grant table; it refuses the boot otherwise, because a world that cannot
			// check its own key would refuse every login it was meant to admit.
			std::expected<void, std::string> Start(std::string_view authSchema);

			// Total over any world id, including one no registry row declares. Public
			// worlds return success without touching the database.
			[[nodiscard]] Admission Admit(uint32_t accountId, Id world) const;

		private:
			Access() = default;

			std::string	auth_schema;	// empty means no shared auth schema; the only state this subsystem holds
	};
}
