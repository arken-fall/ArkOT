// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "world.h"

#include "testregistry.h"

#include <fmt/format.h>

#include <atomic>
#include <expected>
#include <fstream>
#include <optional>
#include <string>
#include <string_view>

// The registry is what stops a world from advertising, or answering to, another
// world's identity, so every refusal it can report has to be the *right* refusal:
// a boot failure that names the wrong cause sends an operator hunting the wrong
// file. These assert the specific Error, never merely "it failed". The absent-file
// case is the load-bearing one: it is what keeps an existing single-world install
// booting with no config/worlds.toml at all.

using namespace BlackTek::Tests;

namespace
{
	using BlackTek::World::Entry;
	using BlackTek::World::Id;
	using BlackTek::World::Registry;

	using LoadResult = std::expected<void, Registry::Error>;

	// What the fixture's [[world]] id 0 declares, and what localIdentity() claims
	// to be. A case that wants a mismatch varies exactly one of these.
	constexpr std::string_view LocalName		= "Arkenfall";
	constexpr std::string_view LocalAddress		= "127.0.0.1";
	constexpr std::string_view LocalSchema		= "arkot_world_0";
	constexpr uint16_t LocalPort				= 7183;

	constexpr std::string_view ForeignName		= "Arkenfall-Hardcore";

	constexpr std::string_view TwoWorlds = R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"

[[world]]
id      = 1
name    = "Arkenfall-Hardcore"
address = "127.0.0.2"
port    = 7283
schema  = "arkot_world_1"
)";

	[[nodiscard]] std::filesystem::path uniquePath()
	{
		static std::atomic<uint32_t> sequence{ 0 };

		const auto stamp = static_cast<uint64_t>(std::chrono::steady_clock::now().time_since_epoch().count());
		const auto ordinal = sequence.fetch_add(1, std::memory_order_relaxed);

		return std::filesystem::temp_directory_path() / fmt::format("blacktek-world-registry-{:x}-{:x}", stamp, ordinal);
	}

	// Registry::Load reads the relative path config/worlds.toml, and the registry
	// it fills is a process-wide singleton, so a case's fixture is a real directory
	// the process stands in for the duration of that case. The destructor restores
	// the previous working directory and removes the tree on every exit path,
	// including the throw of a failed BT_CHECK, so one failing case cannot cascade
	// into the next one (or into the item-table cases, which read data/ relatively).
	class WorldsDirectory
	{
		public:
			// contents == nullopt writes no file at all: that is the absent-file path
			explicit WorldsDirectory(std::optional<std::string_view> contents)
				: previous_directory(std::filesystem::current_path())
				, directory(uniquePath())
			{
				std::error_code failure;
				if (not std::filesystem::create_directories(directory / "config", failure))
				{
					throw TestFailure{ fmt::format("could not create the fixture directory {}: {}", directory.string(), failure.message()) };
				}

				if (contents)
				{
					const auto file = directory / "config" / "worlds.toml";

					std::ofstream out(file, std::ios::binary | std::ios::trunc);
					out << *contents;
					out.close();

					if (not out)
					{
						std::error_code ignored;
						std::filesystem::remove_all(directory, ignored);
						throw TestFailure{ fmt::format("could not write the fixture file {}", file.string()) };
					}
				}

				std::filesystem::current_path(directory);
			}

			WorldsDirectory(const WorldsDirectory&) = delete;
			WorldsDirectory& operator=(const WorldsDirectory&) = delete;

			~WorldsDirectory()
			{
				// a destructor may not throw, so both steps take the error_code overload
				std::error_code ignored;
				std::filesystem::current_path(previous_directory, ignored);
				std::filesystem::remove_all(directory, ignored);
			}

		private:
			std::filesystem::path	previous_directory;
			std::filesystem::path	directory;
	};

	[[nodiscard]] Registry::Identity localIdentity()
	{
		return Registry::Identity{
			.name		= std::string(LocalName),
			.address	= std::string(LocalAddress),
			.schema		= std::string(LocalSchema),
			.port		= LocalPort,
			.id			= Id{ 0 } };
	}

	// Every case calls Load itself and asserts on that call's result: GetInstance()
	// is shared, so state left by an earlier case is never a premise here.
	[[nodiscard]] LoadResult loadWorlds(const Registry::Identity& self)
	{
		return Registry::GetInstance().Load(self);
	}

	void expectLoaded(const LoadResult& result, std::string_view what)
	{
		if (not result)
		{
			throw TestFailure{ fmt::format("{}: Load failed with '{}'", what, Registry::Describe(result.error())) };
		}
	}

	void expectError(const LoadResult& result, Registry::Error expected, std::string_view what)
	{
		if (result)
		{
			throw TestFailure{ fmt::format("{}: Load succeeded, expected the refusal '{}'", what, Registry::Describe(expected)) };
		}

		if (result.error() != expected)
		{
			throw TestFailure{ fmt::format("{}: Load refused with '{}', expected '{}'", what, Registry::Describe(result.error()), Registry::Describe(expected)) };
		}

		// a refusal must leave nothing half-built behind for the next reader
		if (not Registry::GetInstance().All().empty())
		{
			throw TestFailure{ fmt::format("{}: the registry kept entries after refusing with '{}'", what, Registry::Describe(expected)) };
		}
	}
}

BT_TEST(worldRegistrySynthesisesTheLocalWorldWithoutAFile)
{
	const WorldsDirectory fixture{ std::nullopt };

	const auto self = localIdentity();
	expectLoaded(loadWorlds(self), "absent worlds.toml");

	const auto& worlds = Registry::GetInstance();
	BT_CHECK(worlds.All().size() == 1);

	const auto& only = worlds.All().front();
	BT_CHECK(only.id == self.id);
	BT_CHECK(only.name == self.name);
	BT_CHECK(only.address == self.address);
	BT_CHECK(only.port == self.port);
	BT_CHECK(only.schema == self.schema);

	BT_CHECK(&worlds.Self() == &only);
	BT_CHECK(worlds.Find(self.id) == &only);
	BT_CHECK(worlds.Find(LocalName) == &only);
	BT_CHECK(worlds.IsSelf(LocalName));
}

BT_TEST(worldRegistryResolvesAValidTwoWorldFile)
{
	const WorldsDirectory fixture{ TwoWorlds };

	expectLoaded(loadWorlds(localIdentity()), "valid two-world file");

	const auto& worlds = Registry::GetInstance();
	BT_CHECK(worlds.All().size() == 2);

	const Entry* local = worlds.Find(Id{ 0 });
	BT_CHECK(local != nullptr);
	BT_CHECK(local->name == LocalName);
	BT_CHECK(local->address == LocalAddress);
	BT_CHECK(local->port == LocalPort);
	BT_CHECK(local->schema == LocalSchema);

	const Entry* foreign = worlds.Find(Id{ 1 });
	BT_CHECK(foreign != nullptr);
	BT_CHECK(foreign->name == ForeignName);
	BT_CHECK(foreign->address == "127.0.0.2");
	BT_CHECK(foreign->port == 7283);
	BT_CHECK(foreign->schema == "arkot_world_1");

	BT_CHECK(worlds.Find(LocalName) == local);
	BT_CHECK(worlds.Find(ForeignName) == foreign);
	BT_CHECK(worlds.Find(Id{ 9 }) == nullptr);
	BT_CHECK(worlds.Find(std::string_view("Norsefall")) == nullptr);

	// Self() is the row matching the identity that was handed in, not simply the
	// first row, and it is a reference into the registry's own storage.
	BT_CHECK(&worlds.Self() == local);
}

BT_TEST(worldRegistryMatchesItsOwnNameLoosely)
{
	const WorldsDirectory fixture{ TwoWorlds };

	expectLoaded(loadWorlds(localIdentity()), "valid two-world file");

	const auto& worlds = Registry::GetInstance();

	// The wire name reaches us through the login webservice's SERVER_NAME and a
	// client's CRLF, so case drift and a trailing '\r' must not read as a foreign
	// world: a false rejection here is a total outage.
	BT_CHECK(worlds.IsSelf(LocalName));
	BT_CHECK(worlds.IsSelf("arkenfall"));
	BT_CHECK(worlds.IsSelf("ARKENFALL"));
	BT_CHECK(worlds.IsSelf("Arkenfall\r"));
	BT_CHECK(worlds.IsSelf("arkenfall\r"));

	// a genuinely different world is still refused
	BT_CHECK(not worlds.IsSelf(ForeignName));
	BT_CHECK(not worlds.IsSelf("Norsefall"));

	// the case-insensitive match is the lookup's too, not just IsSelf's
	BT_CHECK(worlds.Find(std::string_view("arkenfall-HARDCORE")) == worlds.Find(Id{ 1 }));
}

BT_TEST(worldRegistryRefusesUnparseableToml)
{
	// unterminated string: toml++ reports a parse error rather than a shape error
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::ParseFailed, "unterminated string");
}

BT_TEST(worldRegistryRefusesAWorldArrayThatIsNotTables)
{
	// valid TOML, wrong shape: `world` is an array of integers, not of tables
	const WorldsDirectory fixture{ "world = [ 0, 1 ]\n" };

	expectError(loadWorlds(localIdentity()), Registry::Error::ParseFailed, "[[world]] elements that are not tables");
}

BT_TEST(worldRegistryRefusesAFileDeclaringNoWorlds)
{
	const WorldsDirectory fixture{ "# every world was commented out\n" };

	expectError(loadWorlds(localIdentity()), Registry::Error::NoWorlds, "no [[world]] entries");
}

BT_TEST(worldRegistryRefusesAnEmptyRequiredField)
{
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = ""
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::EmptyField, "empty name");
}

BT_TEST(worldRegistryRefusesADuplicateId)
{
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"

[[world]]
id      = 0
name    = "Arkenfall-Hardcore"
address = "127.0.0.2"
port    = 7283
schema  = "arkot_world_1"
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::DuplicateId, "two worlds sharing id 0");
}

BT_TEST(worldRegistryRefusesADuplicateName)
{
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"

[[world]]
id      = 1
name    = "Arkenfall"
address = "127.0.0.2"
port    = 7283
schema  = "arkot_world_1"
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::DuplicateName, "two worlds sharing a name");
}

BT_TEST(worldRegistryRefusesAnIdentityNoEntryDeclares)
{
	const WorldsDirectory fixture{ TwoWorlds };

	auto self = localIdentity();
	self.id = Id{ 7 };

	expectError(loadWorlds(self), Registry::Error::SelfMissing, "[world].id absent from worlds.toml");
}

BT_TEST(worldRegistryRefusesAnAddressMismatch)
{
	const WorldsDirectory fixture{ TwoWorlds };

	auto self = localIdentity();
	self.address = "10.0.0.5";

	expectError(loadWorlds(self), Registry::Error::SelfAddressMismatch, "address disagreeing with worlds.toml");
}

BT_TEST(worldRegistryRefusesAPortMismatch)
{
	const WorldsDirectory fixture{ TwoWorlds };

	// address still agrees, so only the port can be the reported cause
	auto self = localIdentity();
	self.port = 7283;

	expectError(loadWorlds(self), Registry::Error::SelfPortMismatch, "port disagreeing with worlds.toml");
}

BT_TEST(worldRegistryRefusesASchemaMismatch)
{
	const WorldsDirectory fixture{ TwoWorlds };

	// address and port still agree, so only the schema can be the reported cause
	auto self = localIdentity();
	self.schema = "arkot_world_1";

	expectError(loadWorlds(self), Registry::Error::SelfSchemaMismatch, "schema disagreeing with worlds.toml");
}

// `access` is a security key, so the cases that matter are the ones where a
// misreading would open a private world rather than close a public one: an absent
// key and the explicit "public" must both mean public, and anything the registry
// cannot read as a role name must refuse the boot rather than default to "off".

BT_TEST(worldRegistryTreatsAnAbsentAccessAsPublic)
{
	// TwoWorlds declares no `access` at all - which is exactly what the live public
	// worlds deploy, and what must keep meaning "anyone may log in here".
	const WorldsDirectory fixture{ TwoWorlds };

	expectLoaded(loadWorlds(localIdentity()), "worlds declaring no access");

	const auto& worlds = Registry::GetInstance();

	const Entry* local = worlds.Find(Id{ 0 });
	BT_CHECK(local != nullptr);
	BT_CHECK(local->required_role.empty());

	const Entry* foreign = worlds.Find(Id{ 1 });
	BT_CHECK(foreign != nullptr);
	BT_CHECK(foreign->required_role.empty());
}

BT_TEST(worldRegistryNormalisesPublicAccessToNoRole)
{
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"
access  = "public"
)" };

	expectLoaded(loadWorlds(localIdentity()), "access = public");

	const Entry* local = Registry::GetInstance().Find(Id{ 0 });
	BT_CHECK(local != nullptr);

	// "public" is a spelling of the default, not a role named "public": the access
	// gate keys entirely off required_role being empty.
	BT_CHECK(local->required_role.empty());
}

BT_TEST(worldRegistryKeepsANamedAccessRole)
{
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"

[[world]]
id      = 1
name    = "Arkenfall-Hardcore"
address = "127.0.0.2"
port    = 7283
schema  = "arkot_world_1"
access  = "tester"
)" };

	expectLoaded(loadWorlds(localIdentity()), "access = tester");

	const auto& worlds = Registry::GetInstance();

	// the row that named a role carries it; the row that did not stays public
	const Entry* foreign = worlds.Find(Id{ 1 });
	BT_CHECK(foreign != nullptr);
	BT_CHECK(foreign->required_role == "tester");

	const Entry* local = worlds.Find(Id{ 0 });
	BT_CHECK(local != nullptr);
	BT_CHECK(local->required_role.empty());
}

BT_TEST(worldRegistryRefusesANonStringAccess)
{
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"
access  = true
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::InvalidAccess, "access that is not a string");
}

BT_TEST(worldRegistryRefusesAnOverLongAccessRole)
{
	// 33 characters: one past the varchar(32) the `account_roles`.`role` column
	// declares, so it could never match a granted row
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"
access  = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::InvalidAccess, "access role longer than the role column");
}

BT_TEST(worldRegistryRefusesAnUpperCaseAccessRole)
{
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"
access  = "Tester"
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::InvalidAccess, "access role that is not lowercase");
}

BT_TEST(worldRegistryRefusesAnAccessRoleOutsideTheAlphabet)
{
	// a quote would otherwise reach a query built with fmt rather than escaped,
	// which is precisely why the accepted alphabet is narrower than the column
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"
access  = "tes'ter"
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::InvalidAccess, "access role outside the accepted alphabet");
}

BT_TEST(worldRegistryRefusesAnEmptyAccessRole)
{
	// an empty string is not "public": it is an operator who meant to write a role
	// and wrote nothing, and guessing which they meant is what this refuses to do
	const WorldsDirectory fixture{ R"(
[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"
access  = ""
)" };

	expectError(loadWorlds(localIdentity()), Registry::Error::InvalidAccess, "empty access role");
}
