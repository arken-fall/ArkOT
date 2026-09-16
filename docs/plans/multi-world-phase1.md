# Phase 1 Plan — World Identity and Login Routing

## 1. Current state

### 1.1 There is no world concept, but the wire already carries one

- `src/connection.cpp:161-181` sniffs a plaintext preamble on the *modern* game connection: if the first two header bytes are printable ASCII, the bytes up to `\n` are accumulated into `Connection::modernWorldLine` (`src/connection.h:113-116`) and skipped one byte at a time by `Connection::skipWorldNameByte` (`src/connection.cpp:224-271`).
- On the terminating `\n`, `src/connection.cpp:256` prints the line with `std::cout` and `:257` calls `accept()` — the value is discarded. `src/connection.cpp:268` is a second `std::cout`. Both violate `CONTRIBUTING.md:201-234`.
- `Connection::modernWorldLine` is private (`src/connection.h:116`) with no accessor; `Protocol` declares `friend class Connection` (`src/protocol.h:98`), not the reverse, so no protocol can read it today.
- The preamble path only runs when `protocol` is already non-null (`src/connection.cpp:161`), which is true only for `server_sends_first` services — `ServicePort::onAccept` constructs the protocol up front only in that case (`src/server.cpp:103-107`).
- `STATUS.md:223-227` records the ground truth: clients >= 1200 send `"<worldName>\n"` before any framed traffic. `harness/modern_client.py:121` mirrors it with the literal `b"BlackTek\n"`.
- **The name on the wire is not `[identity].name`.** `config/server.toml:4` is `"Black Tek"` (with a space); the webservice is configured `SERVER_NAME=BlackTek` (`docker-compose.yaml:51`) and that is what the harness echoes (`harness/modern_client.py:121`). The world name the client sends comes from its login source, not from this server's identity string.

### 1.2 The in-binary login path is dead code

- `config/server.toml:35` sets `login_port = 0`, so `services->add<ProtocolLogin>` (`src/otserv.cpp:567-570`) and `services->add<ProtocolOld>` (`src/otserv.cpp:593-596`) never run.
- `src/protocollogin.cpp:88-120` is the only in-binary world list: `addByte(1)` world count at `:103`, world id `0` at `:104`, name from `SERVER_NAME`, address from `IP`, port from `GAME_PORT` at `:105-107`. `GAME_PORT` is `0` on this fork (`config/server.toml:36`), so the advertised port would be 0.
- `ONLINE_OFFLINE_CHARLIST` squats on the world-id byte: `src/protocollogin.cpp:92-101` emits two fake worlds named "Offline"/"Online" at the same address, and `:114-119` writes the per-character world-id byte as an online flag. Config key at `src/configmanager.h:49`, loaded at `src/configmanager.cpp:168`, exposed to Lua at `src/luascript.cpp:2223`, shipped `false` at `config/server.toml:54`. A whole-repo grep finds no other reader.
- `ProtocolLogin` refuses any client outside 1097..1098 (`src/protocollogin.cpp:177-180`) using `CLIENT_VERSION_MIN/MAX` (`src/definitions.h:16-18`), whose own comment says those constants exist only for "the status protocol and the legacy login protocol's version gate" (`src/definitions.h:13-15`).
- `ProtocolLogin::server_sends_first = false` (`src/protocollogin.h:16`), so on a login port `protocol` is null at the first header read and `src/connection.cpp:161` is skipped entirely — a modern client's `"Name\n"` preamble would be consumed as a length header at `src/connection.cpp:183`.
- `ProtocolLogin` and `ProtocolOld` share `protocol_identifier = 0x01` (`src/protocollogin.h:17`, `src/protocolold.h:16`) and are disambiguated by checksum state in `ServicePort::make_protocol` (`src/server.cpp:122-135`).

### 1.3 How a modern client actually gets in today

- The world address/port comes from the external webservice: `playdata.worlds[].externaladdressunprotected/externalportunprotected` (`harness/modern_client.py:88-91`), configured with a single `SERVER_NAME`/`SERVER_IP`/`SERVER_PORT` (`docker-compose.yaml:51-53`).
- The game connection lands on `game_port_modern` (`config/server.toml:40`, `src/otserv.cpp:573-575`). `ProtocolGameModern` fixes the generation by port (`src/protocolgame.h:560-573`), and the first packet resolves a profile at `src/protocolgame.cpp:466-472`.
- The credential is one opaque session-key string (`src/protocolgame.cpp:555-561`), character name at `:612`, then `authenticateAndLogin` (`:639-702`) calls `IOLoginData::sessionKeyAuthentication` (`src/iologindata.cpp:152-177`), which joins `account_sessions` to `players` by `account_id` and `p.name`. **No world parameter is read anywhere on this path.**
- `README.md:40` states the supported client is a mehah OTClient build with **HTTP login** pointed at a login webservice; `STATUS.md:217-234` records the end-to-end validation against that client.

### 1.4 Database

- `Database::getInstance()` is a function-local static holding one `MYSQL*` and one `std::recursive_mutex` (`src/database.h:30-34, 120-121`). `DBTransaction` and `DBInsert` are hardwired to it (`src/database.h:190, 200, 209`).
- `Database::connect()` reads `MYSQL_HOST/USER/PASS/DB/SOCK/SQL_PORT` from `g_config` (`src/database.cpp:40`). `config/database.toml:3-10` holds one `[mysql]` block.
- `g_databaseTasks` owns the only second connection (`src/databasetasks.cpp:13`), also to `MYSQL_DB`.
- **Cross-schema access on a single connection is already in use in this tree.** `src/databasemanager.cpp:18, 41, 47` query `information_schema`.`TABLES`/`COLUMNS` while the connection's default schema is `MYSQL_DB`; `data/migrations/1.lua:7-14` and `data/migrations/6.lua:4` do the same from Lua. Schema qualification per statement is an existing, exercised capability of this one connection.
- `MYSQL_DB` is the de-facto world identity in migrations (`src/databasemanager.cpp:18, 41, 47`), and `updateDatabase()` runs at every boot with no lock (`src/otserv.cpp:402`, `src/databasemanager.cpp:70-120`).
- Seven FKs reference `accounts(id)`: `store_history` (`schema.sql:598`), `account_sessions` (`:702`), `account_bans` (`:1092`), `account_ban_history` (`:1099`), `account_storage` (`:1106`), `account_viplist` (`:1112`), `players` (`:1176`). Three of those tables *also* FK to per-world `players(id)`: `account_bans`.`banned_by` (`:1093`), `account_ban_history`.`banned_by` (`:1100`), `account_viplist`.`player_id` (`:1113`).
- Account-table SQL in C++ is 28 sites across five files: `src/iologindata.cpp:27, 46, 91, 124, 161, 488, 497, 507, 545, 1126, 1979, 1997, 2003, 2008, 2013`; `src/store.cpp:367, 449, 455, 466, 476`; `src/ban.cpp:51, 59, 60`; `src/game.cpp:5735, 5881, 6043, 6803, 6819, 6828`. In Lua, only `data/scripts/talkactions/remove_tutor.lua:6, 22` touches `accounts`; `ban.lua:22, 29`, `unban.lua:11` and `startup.lua:12-17` touch `account_bans` only.
- `accounts.coins` is written as an **absolute** value (`src/store.cpp:449`) from a login-time cache (`src/iologindata.cpp:25-31`), while transfers use a delta (`src/store.cpp:367`). `Database` exposes `getLastInsertId()` (`src/database.h:91-93`) but no affected-row count.
- `account_storage` is read whole at boot (`src/game.cpp:6803`) and saved as unfiltered `DELETE FROM account_storage` plus bulk reinsert inside one transaction (`src/game.cpp:6810-6841`).

### 1.5 Config, boot, threading

- Nine hardcoded `config/*.toml` paths at `src/configmanager.cpp:84-92`; the load-once block at `:99-149` covers ports, MySQL credentials and `map_name`. `ConfigManager` stores flat arrays keyed by enums (`src/configmanager.h:215-218`).
- Subsystems with table-shaped config parse their own TOML directly: `BlackTek::Store::System::loadConfig` parses `config/store.toml` with toml++ and logs through `Console` (`src/store.cpp:53-84`).
- The whole CLI is `--ip`, `--login-port`, `--game-port` (`src/otserv.cpp:648-675`); `game_port_modern` and `status_port` have no override.
- `mainLoader` runs as one dispatcher task (`src/otserv.cpp:267`); `main` waits on `g_loaderSignal` and only then calls `serviceManager.run()` (`src/otserv.cpp:269-275`). Acceptors are opened inside `mainLoader` but **no accept handler can run before `io_context.run()`**, so anything loaded in `mainLoader` is safely visible to connection-strand code afterwards.
- The startup refusal for dual listeners is at `src/otserv.cpp:576-587`, followed by `ProtocolGame::setSharedModernLayout(true)` at `:586`.
- `premake5.lua:43` globs `src/**.cpp`, so new translation units need no build-file edit (premake must be re-run). `tests/` builds every `src/**.cpp` except `otserv.cpp` (`premake5.lua:201-203`).

---

## 2. Constraints and invariants

**Settled by the owner (not reopened):** a character belongs to one world forever; coins are account-wide; unlocks are per-character; one account may hold characters on several worlds. D11 = N processes, one world each — no de-globalisation of `g_game`, `Zones::ZoneManager`, the `src/map.cpp:22-23` cache, or any singleton. D2 = per-world databases plus one shared auth schema. D1 = revive in-binary `ProtocolLogin`.

**Load-bearing and must keep working:**

- `MYSQL_DB` stays the world identity; the ~100 character-scoped inline SQL strings stay unqualified and untouched (`src/databasemanager.cpp:18, 41, 47`).
- 15.25-only: no `game_port` revival, no second generation, the refusal at `src/otserv.cpp:576-587` is not weakened, `ProtocolGame::shared_modern_layout` (`src/protocolgame.h:551-553`) stays a correctness requirement.
- `Zones`, `Components`, `ObjectPools`, `OTB`, `IOGuild`, `Titan`, `xtea` keep their top-level namespaces (`CONTRIBUTING.md:40-46`). New work nests as `BlackTek::World` (`CONTRIBUTING.md:38, 43`).
- The external `opentibiabr/login-server` image is unmodified by policy (`README.md:17`, `STATUS.md:206-210`, `docker-compose.yaml:38-59`).
- The verified 15.25 systems (bestiary/charms, prey, forge, wheel, store, market, cyclopedia) must not regress.
- Stale ports/docs (`Dockerfile:51-65`, `docker-compose.yaml:61-76`, `README.md:74-80`, `src/definitions.h:16-18`) are **not** fixed here; design against `game_port_modern = 7183` / `status_port = 7184`.

**Invariants this design discovers and then relies on:**

1. *One MySQL instance serves every world's schema.* This is what makes a cross-world character list possible from one connection, and it is already how this codebase reaches `information_schema` (`src/databasemanager.cpp:18`). It becomes a stated deployment invariant.
2. *The world registry is immutable after boot*, and no accept handler runs before boot finishes (`src/otserv.cpp:269-275`). Therefore registry reads from the connection strand and the dispatcher need no synchronisation.
3. *The world name on the wire is whatever the login source advertises*, not `[identity].name` (`config/server.toml:4` vs `docker-compose.yaml:51` vs `harness/modern_client.py:121`).
4. *Character creation is already world-local* — the only `INSERT INTO players` in the tree runs inside a world process against its own schema (`src/game.cpp:5783-5826`). No cross-world index is needed to keep character ownership truthful.
5. *`account_storage` cannot be shared*: `src/game.cpp:6819` deletes the whole table and reinserts from one process's memory. Hoisting it to a shared schema would make each world's save destroy the other's rows.
6. *`account_bans`, `account_ban_history` and `account_viplist` cannot be hoisted as-is*: each carries an FK into per-world `players(id)` (`schema.sql:1093, 1100, 1113`).

---

## 3. Proposed design

### 3.0 Where the phase boundary falls on "a second connection"

**No second `Database` is needed — not in phase 1, and not in any later phase of this design.** MySQL scopes a table reference per statement; the connection's default schema only supplies the implicit qualifier, and this tree already exercises that by querying `information_schema` on the world connection (`src/databasemanager.cpp:18, 41, 47`; `data/migrations/6.lua:4`). So:

- `Database::getInstance()`, `DBTransaction`, `DBInsert` and `g_databaseTasks` (`src/databasetasks.cpp:13`) are **untouched**.
- The shared auth schema is reached two ways, chosen per call site by whether the SQL is new or existing:
  - **Existing SQL stays unqualified** and resolves through a per-world *view* onto the auth base table (3.2).
  - **New cross-world SQL is schema-qualified by construction** from the registry (3.4).
- A single connection also buys transactional atomicity across the two schemas, which two connections could never give.

### 3.1 What a world is: `BlackTek::World::Registry`

A world is declared once, in a file deployed identically to every world, and validated against the process at boot. Following the `BlackTek::Store::System` precedent (`src/store.cpp:53-84`) the subsystem parses its own TOML rather than expanding `ConfigManager`'s flat arrays.

`config/worlds.toml` (new):

```toml
# The world list this deployment serves. Deploy this SAME file to every world.
# `id`      - the world-id byte the login protocol puts on the wire
# `name`    - EXACTLY what the client is told the world is called; the client
#             echoes it back as the plaintext preamble on the game connection
# `address` / `port` - what the client dials for that world's game server
# `schema`  - that world's MySQL database, on the shared MySQL instance

[[world]]
id      = 0
name    = "Arkenfall"
address = "127.0.0.1"
port    = 7183
schema  = "arkot_world_0"

[[world]]
id      = 1
name    = "Arkenfall-Hardcore"
address = "127.0.0.1"
port    = 7283
schema  = "arkot_world_1"
```

`config/server.toml` gains `[world].id = 0`; `config/database.toml` gains `auth_database = ""` under `[mysql]` (empty or equal to `database` means "single world, no shared auth schema").

`src/world.h` (new):

```cpp
#pragma once

#include <cstdint>
#include <expected>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace BlackTek::World
{
	// the world-id byte the login protocol puts on the wire
	using Id = uint8_t;

	// one row of config/worlds.toml; a plain aggregate with no invariant of its own
	struct Entry
	{
		std::string	name;		// exactly what the client echoes back in its preamble
		std::string	address;	// what the client dials
		std::string	schema;		// that world's MySQL database
		uint16_t	port = 0;	// that world's game_port_modern
		Id			id = 0;
	};

	// Loaded once in mainLoader, immutable afterwards. Boot refuses on any
	// error, so a Registry that is reachable is always non-empty and always
	// knows which entry is this process.
	class Registry
	{
		public:
			enum class Error : uint8_t
			{
				ParseFailed,
				NoWorlds,
				EmptyField,
				DuplicateId,
				DuplicateName,
				SelfMissing,
				SelfAddressMismatch,
				SelfPortMismatch,
				SelfSchemaMismatch,
			};

			// what this process believes it is, handed in from config
			struct Identity
			{
				std::string	address;
				std::string	schema;
				uint16_t	port = 0;
				Id			id = 0;
			};

			// non-copyable
			Registry(const Registry&) = delete;
			Registry& operator=(const Registry&) = delete;

			static Registry& GetInstance() noexcept
			{
				static Registry instance;
				return instance;
			}

			// Reads config/worlds.toml when present, otherwise synthesises the
			// single world described by `self`. Cross-checks `self` against its
			// own row so a mis-provisioned world can never boot.
			std::expected<void, Error> Load(const Identity& self);

			[[nodiscard]] std::span<const Entry>	All() const noexcept	{ return entries; }
			[[nodiscard]] const Entry&				Self() const noexcept	{ return entries[self_index]; }
			[[nodiscard]] const Entry*				Find(Id id) const noexcept;
			[[nodiscard]] const Entry*				Find(std::string_view name) const noexcept;
			[[nodiscard]] bool						IsSelf(std::string_view name) const noexcept;

			[[nodiscard]] static std::string_view	Describe(Error error) noexcept;

		private:
			Registry() = default;

			std::vector<Entry>	entries;
			size_t				self_index = 0;
	};

	// callers outside the subsystem never need the registry's shape
	[[nodiscard]] bool IsLocalWorld(std::string_view name) noexcept;
	[[nodiscard]] const Entry& Local() noexcept;
}
```

Design notes, by mechanism:

- **Misuse made structurally hard.** `Load` is the only mutator and returns `std::expected<void, Error>` (the project already uses `std::expected`: `src/combat.h:531`, `src/iomap.h:137`). `mainLoader` calls `startupErrorMessage(...)` on failure, so `Self()` is unreachable on a half-built registry — no half-built object ever escapes.
- **Drift caught at boot, not at login.** `Load` rejects a registry that does not contain `self.id`, or whose row disagrees with this process's `IP`, `game_port_modern` or `MYSQL_DB`. That eliminates the entire class of "world A advertises world B's port" faults, in the same style as the existing refusal at `src/otserv.cpp:576-587`.
- **Layout by access pattern.** N is a handful and lookups happen once per login; a contiguous `std::vector<Entry>` with linear `Find` is correct and cheapest. No map, no handle table, no interning.
- **Naming.** New namespace-scope names are `PascalCase` per `CONTRIBUTING.md:337` and the `ItemManager::LoadItems` example at `:356`, matching `Zones::ZoneManager`'s registry-shaped precedent. If the owner prefers the `BlackTek::Store::System` camelCase precedent instead, that is a pure rename with no design consequence — cpp-coder must not decide it silently.
- **Case handling.** `IsSelf` trims a trailing `\r`/whitespace and compares with `caseInsensitiveEqual` (`src/tools.h:64`), because the wire name travels through the webservice's `SERVER_NAME` (`docker-compose.yaml:51`) where case drift is plausible and a false rejection is a total outage.

### 3.2 The shared auth schema, reached through per-world views

**Base tables that move to the auth schema:** `accounts` (`schema.sql:35-51`), `account_sessions` (`:695-703`), `store_history` (`:588-599`).

Justification per table:
- `accounts` — forced. One account identity across worlds is what makes a cross-world character list and account-wide coins possible at all.
- `account_sessions` — forced by routing. The external webservice writes one row (`src/iologindata.cpp:156-162`); every world must be able to read it.
- `store_history` — follows coins, and it is safe: append-only `INSERT` plus `SELECT ... WHERE account_id` (`src/store.cpp:455, 466, 476`), never a whole-table rewrite.

**Tables that stay per-world, with reasons:**
- `account_storage` — `src/game.cpp:6819` deletes the whole table and reinserts from this process's memory. Sharing it would let world A's save destroy world B's rows. (Behaviour change to flag: account storage silently becomes per-world.)
- `account_bans`, `account_ban_history` — FK `banned_by` into per-world `players(id)` (`schema.sql:1093, 1100`), written from Lua (`data/scripts/talkactions/ban.lua:29`) and swept at boot (`data/scripts/globalevents/startup.lua:12-17`). (Behaviour change to flag: a ban on world A does not bar world B. Owner decision, D5 remnant.)
- `account_viplist` — FK `player_id` into per-world `players(id)` (`schema.sql:1113`), read by account id at `src/iologindata.cpp:1126, 1979`.

**Each world schema gets a view of the same name over each hoisted base table.** This is the mechanism that keeps *all 28 C++ sites, the Lua site at `remove_tutor.lua:6, 22`, and the unmodified third-party login-server* working with zero query churn: every unqualified `accounts` / `account_sessions` / `store_history` reference resolves through the view into the one auth schema.

Consequences, stated rather than hidden:
- The seven `accounts(id)` FKs (`schema.sql:598, 702, 1092, 1099, 1106, 1112, 1176`) cannot reference a view. `store_history` and `account_sessions` move with `accounts` and keep their FK beside it in the auth schema. The remaining five (`players`, `account_bans`, `account_ban_history`, `account_storage`, `account_viplist` `schema.sql:1112`) either become cross-schema FKs to `auth`.`accounts` or are dropped — see Open Question O2; the design does **not** depend on cross-schema FKs being available.
- Migrations must never `ALTER` a hoisted table from a world process — it would hit a view. The two existing account migrations guard on `information_schema.COLUMNS`, which reports view columns, so their guards pass and no `ALTER` fires (`data/migrations/1.lua:33-38`, `data/migrations/6.lua:4-7`). The auth schema gets its own out-of-band script; this is a documented rule plus the boot probe in 3.3, not a code mechanism.
- **Single-world installs need no DB change at all.** When `auth_database` is empty or equal to `database`, there is no auth schema, no views, and every existing FK stands. That property is what makes every migration step below individually shippable.

### 3.3 Boot sequence additions (`mainLoader`, `src/otserv.cpp`)

Inserted after `Database::getInstance().connect()` succeeds (`src/otserv.cpp:384-388`) and before `DatabaseManager::updateDatabase()` (`:402`):

1. `BlackTek::World::Registry::GetInstance().Load({...})` with `IP`, `MYSQL_DB`, `GAME_PORT_MODERN` and the new `WORLD_ID`. On error → `startupErrorMessage(fmt::format("World registry: {:s}", Registry::Describe(err)))` and return.
2. A single auth probe: `SELECT 1 FROM accounts LIMIT 1` plus a check that the resolved schema of `accounts` matches `auth_database` when one is configured. On failure → `startupErrorMessage`, so a world booting against a schema whose views were never created stops instead of serving a broken login.
3. `Console::printProgress("World", true, fmt::format("{:s} (id {:d})", Local().name, Local().id));` next to the existing lines at `src/otserv.cpp:434-446`.

### 3.4 Cross-world character list

The core problem the brief names: the process serving login can see its own `players` and the shared auth schema, but not other worlds' character tables. **Resolved by reading the other worlds' `players` tables directly, schema-qualified from the registry, on the same connection** — no index, therefore nothing to keep truthful.

`src/account.h` changes `characters` from `std::vector<std::string>` to a world-tagged list (only four use sites exist: `src/iologindata.cpp:107, 113`, `src/protocollogin.cpp:90, 113`):

```cpp
struct CharacterEntry
{
	std::string			name;
	BlackTek::World::Id	world = 0;
};

using CharacterList = std::vector<CharacterEntry>;

struct Account {
	CharacterList	characters;
	std::string		name;
	// ... unchanged
};
```

`IOLoginData::loginserverAuthentication` (`src/iologindata.cpp:87-117`) keeps its auth half unchanged (the `accounts` view resolves it) and replaces the single charlist query at `:110` with one query per registry entry:

```sql
SELECT `name` FROM `<entry.schema>`.`players`
 WHERE `account_id` = <id> AND `deletion` = 0 ORDER BY `name` ASC
```

built with `fmt::format` from `Registry::All()`, in registry order, tagging each row with `entry.id`.

- **One query per world, never a UNION.** A world whose schema is missing or unreadable then contributes zero characters and logs `Console::Database::Warn`, instead of nulling the entire list. Failure is contained to the world that failed.
- **Truthfulness when a world is down.** The character rows live in that world's own schema on the shared instance; a *process* being down does not hide them, because nothing is cached or mirrored. The player still sees the world and its characters, dials that world's port, and the client reports a connection failure — exactly as a real Tibia world list behaves. There is no index, so "crash mid-write" and "rolled back" cannot desynchronise anything: the `players` table *is* the index, and character creation (`src/game.cpp:5783-5826`) already writes it transactionally in the owning world.
- **The instance being down** (as opposed to a world process) is the only case that empties the list, and then login cannot authenticate either — a consistent, self-evident failure.
- `AccountManager::NAME` (`src/iologindata.cpp:106-108`) is emitted once **per registry entry**, since the account manager exists in every world process (`src/protocolgame.cpp:246-249`).
- The list is capped at 255 entries by the wire (`src/protocollogin.cpp:90`); with N worlds the cap now applies across worlds. Keep the clamp, log a warning when it truncates.

### 3.5 In-binary `ProtocolLogin` (gated on G1, section 6)

`src/protocollogin.cpp:88-120` is rewritten:

```cpp
	// world list, from the registry
	output->addByte(0x64);
	output->addByte(static_cast<uint8_t>(worlds.size()));

	for (const auto& world : worlds)
	{
		output->addByte(world.id);
		output->addString(world.name);
		output->addString(world.address);
		output->add<uint16_t>(world.port);
		output->addByte(0);
	}

	output->addByte(size);

	for (const auto& character : account.characters | std::views::take(size))
	{
		output->addByte(character.world);
		output->addString(character.name);
	}
```

- `ONLINE_OFFLINE_CHARLIST` is **deleted**, not worked around: `src/configmanager.h:49`, `src/configmanager.cpp:168`, `src/luascript.cpp:2223`, `config/server.toml:54`, and its two branches at `src/protocollogin.cpp:92-101, 114-119`. The world-id byte reverts to meaning a world id. This also removes the only place that would have needed cross-world online status, which the per-process `g_game.getPlayerByName` (`src/protocollogin.cpp:115`) could never have answered.
- The advertised port is the registry entry's `port`, never `ConfigManager::GAME_PORT` (which is 0 on this fork).
- The version gate at `src/protocollogin.cpp:177-180` switches from `CLIENT_VERSION_MIN/MAX` to `BlackTek::Network::resolveProfile(version, TransportGeneration::Legacy)`... **and this is the decision point G1 depends on**: if the login-protocol connection arrives with modern framing, `ProtocolLogin` needs a modern sibling (`ProtocolLoginModern`, `server_sends_first` semantics and `setTransportGeneration(Modern)` mirroring `src/protocolgame.h:560-573`) so `src/connection.cpp:161` consumes the preamble instead of parsing it as a length. Which of the two is required is exactly what G1 measures; the plan does not guess. `src/definitions.h:16-18` is **not** touched either way.
- Every `std::cout` on lines the rewrite touches migrates to `BlackTek::Console` (`CONTRIBUTING.md:201-234`).

### 3.6 Wrong-world rejection

Two-stage, with the check on the side that can still talk to the client:

**Stage 1 — `Connection` stays transport-only** (`src/connection.cpp:224-271`):
- `:256`'s `std::cout` becomes `BlackTek::Console::Net::Trace("Connection::skipWorldNameByte: world-name preamble '{:s}'", modern_world_line);` and `:268`'s becomes `BlackTek::Console::Net::Error("Connection::skipWorldNameByte: {:s}", e.what());`.
- `src/connection.h` gains `[[nodiscard]] std::string_view GetWorldLine() const noexcept { return modern_world_line; }` in the public section. The member is renamed to `modern_world_line` (and `modernLineByte`/`modernLineSkipped`/`modernWorldNameConsumed` likewise) per `CONTRIBUTING.md:334`; every use site is already inside the two functions being edited (`src/connection.cpp:161-181, 224-271`), so this is opportunistic migration in the sense of `CONTRIBUTING.md:233`, not a drive-by sweep.

**Stage 2 — `ProtocolGame::onRecvFirstMessage` rejects**, inserted immediately after `setChecksumMode(...)` (`src/protocolgame.cpp:530-533`) and before the OS/opcode block at `:535`:

```cpp
	// 13.40+ clients announce the world they think they dialled before any
	// framed traffic; a mismatch means the login source routed them wrong.
	if (const auto connection = getConnection())
	{
		const auto announced = connection->GetWorldLine();
		if (not announced.empty() and not BlackTek::World::IsLocalWorld(announced))
		{
			BlackTek::Console::Net::Warn("ProtocolGame::onRecvFirstMessage: rejected a client announcing world '{:s}' on world '{:s}'.", announced, BlackTek::World::Local().name);
			disconnectClient(fmt::format("This is {:s}. Please pick that world in your client's world list.", BlackTek::World::Local().name));
			return;
		}
	}
```

- **Why here, not in `Connection`:** XTEA is enabled at `:527-528`, so a `disconnectClient` (`src/protocolgame.cpp:748-755`) from this point is framed and encrypted exactly as the client expects, and the player sees a real message instead of a silent socket close. It is still before RSA-adjacent work, before credential parsing, and before any database touch.
- **Absence is never a rejection.** The harness and any client that skips the preamble fall through `src/connection.cpp:180` with an empty line and are unaffected.
- **Deployment requirement this creates:** `worlds.toml`'s `name` must equal the webservice's `SERVER_NAME` (`docker-compose.yaml:51`) and the harness literal (`harness/modern_client.py:121`), which today is `BlackTek` — *not* `config/server.toml:4`'s `"Black Tek"`. Case and trailing whitespace are tolerated (3.1); a genuine name difference is a hard outage and must be caught by G2.

Character-level scoping needs no new code: each world process resolves the character name against its own schema's `players` (`src/iologindata.cpp:124-125, 161-162`), so a world-B character offered on world A simply does not resolve and the existing refusal fires.

### 3.7 The coin correctness fix belongs to phase 1

`src/store.cpp:449` writes coins absolutely. **Phase 1 owns this fix, because phase 1 is what creates the concurrent-writer condition:** once `accounts` is shared and `one_player_per_account` remains process-local (`src/protocolgame.cpp:246-249`), one account can be online on two worlds and the second absolute write destroys the first's spending. It is not a follow-up; it is the same change.

- `Database` gains, next to `getLastInsertId()` (`src/database.h:91-93`):

```cpp
			/**
			 * Rows changed by the last query; a guarded UPDATE reports 0 when
			 * its guard rejected it.
			 */
			[[nodiscard]] uint64_t getAffectedRows() const noexcept {
				return static_cast<uint64_t>(mysql_affected_rows(handle));
			}
```

- `System::saveCoins` (`src/store.cpp:446-450`) is replaced by a guarded delta applied by `addCoins`/`removeCoins` (`src/store.cpp:401-444`), which already know the deltas before they mutate the player:

```sql
UPDATE `accounts`
   SET `coins` = `coins` + <regularDelta>,
       `coins_transferable` = `coins_transferable` + <transferableDelta>
 WHERE `id` = <accountId>
   AND `coins` + <regularDelta> >= 0
   AND `coins_transferable` + <transferableDelta> >= 0
```

  followed by `getAffectedRows() == 1`; on 0 the purchase fails with `Error::Purchase` and the in-memory balance is **not** mutated. On success, re-`SELECT` the two columns and `player->setCoins(...)` from the database truth before `sendStoreBalances()`, so the other world's concurrent spend is reflected rather than overwritten.
- The columns are `int UNSIGNED` (`schema.sql:49-50`); the guard must be written so the subtraction never underflows in SQL — express deltas as signed values added to the column and guard on the sum, as above.
- `src/store.cpp:367`'s recipient delta is already correct and unchanged; `record(...)` at `:452-457` is unchanged.

### 3.8 Error strategy and concurrency, stated per layer

- **Boot/config layer** (`Registry::Load`, the auth probe): `std::expected<void, Error>`; every failure is a `startupErrorMessage` refusal. A world that cannot prove its identity does not serve.
- **Login/routing layer** (charlist, preamble check, session auth): no exceptions; failures are a `Console` log plus a client-visible refusal. Per-world charlist query failure degrades to "that world has no characters" rather than failing the login.
- **Store/coin layer**: boolean success from a guarded write, with the balance re-read on success. No exceptions.
- **Threading**: unchanged. The registry is written once on the dispatcher inside `mainLoader` and read afterwards from the dispatcher (charlist, `authenticateAndLogin`) and the connection strand (`ProtocolGame::onRecvFirstMessage`). `src/otserv.cpp:269-275` guarantees no reader can run before the writer completes, so no atomics, no mutex, no `jthread`, no new threads.

### 3.9 What phase 1 must not foreclose (named, not designed)

Market/guild/house/bestiary world scoping, highscores (`src/networkopcodes.h:158`), cross-world chat (`src/chat.h:109-149`), supervision/systemd/port assignment, and the per-world map pipeline are all untouched here. Phase 1 foreclosing risks and their mitigations: the registry `Entry` is the single place a world's attributes are declared, so a later phase adds fields (pvp type, `log_dir`, `metrics_dir`) there rather than inventing a second source of truth; nothing in phase 1 writes a world id into any character-scoped table, so per-world scoping of market/guild/house remains a free later choice; `account_storage`, bans and viplist stay per-world precisely so a later phase can hoist them with a purpose-built delta-write model instead of inheriting `src/game.cpp:6819`'s whole-table rewrite.

---

## 4. Alternatives considered

**A. N worlds per process (D11's alternative).** Rejected by owner decision, and independently by the evidence: `src/map.cpp:22-23`'s `thread_local` chunk cache is keyed only by chunk coordinate and read from `Map::getTile`, so two `Map` instances would return each other's tiles on the single dispatcher thread; `src/zones.h:615-627` is `inline static` keyed by bare `Position`; `g_game` is referenced 813 times including from `Game`'s own members. Recorded and closed.

**B. Cross-world character index table in the auth schema.** Rejected on truthfulness grounds. An index is a second copy of a fact whose source of truth is each world's `players` table; keeping it correct across world crashes, rollbacks and out-of-band character deletion (the website) requires machinery this design can avoid entirely, because every world's `players` lives on the same MySQL instance (`config/database.toml:4-8`) and one connection can qualify any schema — proven in-tree by `src/databasemanager.cpp:18`. Zero copies beats a maintained copy.

**C. The login process holding N connections, one per world DB.** Rejected: it breaks the `Database` singleton (`src/database.h:30-34`) and `DBTransaction`/`DBInsert`'s hardwiring (`:190, 200, 209`) for no gain, puts every world's credentials in every world's config (O(N²) config coupling), and loses cross-schema transactional atomicity that one connection gives for free.

**D. A dedicated login-only process.** Rejected for phase 1: the binary's boot path loads items, scripts, zones and a ~10 GB map before any listener opens (`src/otserv.cpp:453-596`, `STATUS.md:149`); making that skippable is a boot-order refactor with a blast radius far beyond login routing. It also reintroduces a single point of failure that the symmetric design (every world process can serve the identical world list and charlist) does not have. Revisit only if G1 forces it.

**E. Schema-qualifying the 28 account-table C++ sites instead of using views.** Rejected on two mechanisms: it misses Lua (`data/scripts/talkactions/remove_tutor.lua:6, 22`) unless that is also rewritten, and — decisively — it breaks the third-party `opentibiabr/login-server`, which is unmodifiable by policy (`README.md:17`, `STATUS.md:206-210`) and issues unqualified SQL against one `MYSQL_DBNAME` (`docker-compose.yaml:48`). With views, pointing one login-server instance per world at that world's schema keeps it working untouched — which is also what makes the G1-fails fallback viable.

**F. One shared database keyed by `world_id` (D2's alternative).** Closed by owner decision; also would require a predicate on ~100 inline SQL strings and rework of `players.name` UNIQUE (`schema.sql:852-855`).

**G. Rejecting the wrong world inside `Connection`.** Rejected: at `src/connection.cpp:254` XTEA is not yet established, so any refusal is either an unencrypted frame the client cannot parse or a silent close. Moving the check ten lines later into `ProtocolGame` (after `src/protocolgame.cpp:527-533`) costs nothing and buys a readable message, and keeps `Connection` transport-only.

**H. Deriving the world name from `[identity].name`.** Rejected by direct evidence: `config/server.toml:4` is `"Black Tek"` while the name the client actually sends is `BlackTek` (`docker-compose.yaml:51`, `harness/modern_client.py:121`). The registry's `name` is the wire name and is declared independently.

---

## 5. Migration plan

**Gate first.** Steps 6-8 are only dispatched if G1 (section 6) answers yes. Steps 1-5 and 9 are independent of G1 and are worth shipping either way. Every step leaves a single-world deployment working unchanged, because `auth_database` empty means no views and no auth schema.

---

**Step 1 — `BlackTek::World` registry and boot validation.**
*Scope:* new `src/world.h` / `src/world.cpp`; new `config/worlds.toml`; `[world].id` in `config/server.toml`; `WORLD_ID` in `ConfigManager::IntegerConfig` loaded in the load-once block (`src/configmanager.h:114-188`, `src/configmanager.cpp:99-149`); `Registry::Load` call plus `startupErrorMessage` and the `Console::printProgress("World", ...)` line in `mainLoader` after `src/otserv.cpp:388`.
*Blast radius:* boot path only. No protocol, no SQL, no gameplay. `premake5.lua:43`'s glob picks up the new TU; premake must be re-run.
*Done when:* a process with no `worlds.toml` boots and reports its synthesised single world; a process whose `[world].id` is absent from `worlds.toml`, or whose row disagrees with `IP`/`game_port_modern`/`MYSQL_DB`, refuses to boot with a specific message.
*Behavioural change:* new startup refusals on misconfiguration. Intentional.

**Step 2 — Registry unit test.**
*Scope:* `tests/test_world_registry.cpp` alongside the existing suites (`tests/test_transport.cpp`, `tests/testregistry.h`).
*Blast radius:* tests only.
*Done when:* duplicate ids, duplicate names, empty fields, missing self, and each of the three self-mismatches each produce their distinct `Error`, and a valid two-world file resolves `Find(id)`, `Find(name)`, `IsSelf` (including case and trailing-`\r` tolerance) and `Self()`.

**Step 3 — World-line accessor, `Console` migration, wrong-world rejection.**
*Scope:* `src/connection.h` (public `GetWorldLine`, member renames), `src/connection.cpp:161-181, 224-271` (both `std::cout` migrated), the rejection block in `src/protocolgame.cpp` after `:533`.
*Blast radius:* every modern game connection. The check is a no-op for empty preambles.
*Done when:* a client announcing a foreign world name receives the refusal text and disconnects; a client announcing the local name (case-insensitively) logs in normally; the harness (`harness/modern_client.py:121`) still logs in with `worlds.toml` naming the world `BlackTek`; no `std::cout` remains in the touched functions.
*Behavioural change:* wrong-world connections are refused with a message where they previously proceeded. Intentional and the point of the step.

**Step 4 — Auth schema provisioning script and boot probe.**
*Scope:* new `auth_schema.sql` (creates the auth schema with `accounts`, `account_sessions`, `store_history` and their intra-schema FKs, plus the per-world `CREATE VIEW` statements), `auth_database` in `config/database.toml` and `MYSQL_AUTH_DB` in `ConfigManager::StringConfig` (`src/configmanager.h:86-112`, load-once block), and the boot probe in `mainLoader`. Documentation of the migration rule (no `ALTER` of a hoisted table from a world process) and of the MySQL grant requirement (SELECT on every world schema for the login-serving user).
*Blast radius:* deployment and boot. No C++ query changes at all — every existing account-table site resolves through the view.
*Done when:* a world booted with `auth_database` set, against a provisioned instance, passes the probe and logs in through the existing webservice path with coins, store history and sessions intact; a world booted with `auth_database` set against an unprovisioned schema refuses to boot.
*Blocked on:* O1 and O2 (section 6).
*Behavioural change:* account storage, bans and viplist become per-world by construction. Flagged, owner-visible.

**Step 5 — World-tagged character list in `IOLoginData`.**
*Scope:* `src/account.h` (`CharacterEntry`, `CharacterList`), `src/iologindata.cpp:106-115` (per-registry-entry queries, per-world `AccountManager::NAME`, per-world failure logging), and the two read sites at `src/protocollogin.cpp:90, 113` updated to compile against the new type.
*Blast radius:* four call sites; the only caller of `loginserverAuthentication` is dead code today (`src/protocollogin.cpp:56`), so this step is observably inert until step 6 or the G1-fails fallback.
*Done when:* with a two-world registry and both schemas populated, the assembled list carries each character with its own world id; with one schema dropped, the other world's characters still list and a `Console::Database::Warn` names the failed world.

**Step 6 (G1-gated) — In-binary world list and charlist wire.**
*Scope:* `src/protocollogin.cpp:88-120` rewritten per 3.5; `ONLINE_OFFLINE_CHARLIST` deleted from `src/configmanager.h:49`, `src/configmanager.cpp:168`, `src/luascript.cpp:2223`, `config/server.toml:54`, and both branches in `src/protocollogin.cpp`.
*Blast radius:* the login protocol only, plus the removal of one Lua-visible config key.
*Done when:* `login_port` set, a client reaches the port and receives N worlds with correct name/address/port and a character list whose world bytes match the registry; `grep ONLINE_OFFLINE_CHARLIST` returns nothing in `src/` or `config/`.
*Behavioural change:* `online_offline_charlist` is removed. Intentional, settled.

**Step 7 (G1-gated) — Version gate and framing for `ProtocolLogin`.**
*Scope:* replace `CLIENT_VERSION_MIN/MAX` at `src/protocollogin.cpp:177-180` with `resolveProfile`, and — only if G1 shows the client dials the login port with modern framing — add `ProtocolLoginModern` mirroring `ProtocolGameModern` (`src/protocolgame.h:560-573`) so `src/connection.cpp:161` consumes the preamble. `src/definitions.h:16-18` untouched.
*Blast radius:* the login listener. `ProtocolOld` coexistence on the same port is preserved (`src/server.cpp:122-135`).
*Done when:* the real 15.25 client reaches the login port, is accepted by the version gate, and renders the world list.
*Blocked on:* G1's concrete finding about framing and reachability.

**Step 8 (G1-gated) — Deployment documentation for N worlds.**
*Scope:* a doc describing per-world working directories, `worlds.toml` deployed identically, per-world `config/`, `key.pem`, ports, schema, grants and the auth schema. No code, no touching `Dockerfile`/`docker-compose.yaml`/`README.md` port lines (explicitly out of scope).
*Done when:* two worlds boot side by side on one host and each refuses the other's world name.

**Step 9 — Coin delta correctness (not gated; ships with or before step 4 going live).**
*Scope:* `Database::getAffectedRows` (`src/database.h`, beside `:91-93`), `src/store.cpp:401-450` restructured per 3.7.
*Blast radius:* every coin mutation: purchases, gifts, refunds, transfers. The store is one of the verified 15.25 systems, so this step carries the highest regression risk in the phase.
*Done when:* a purchase that the guard rejects leaves both the DB row and the in-memory balance unchanged and surfaces `Error::Purchase`; a successful purchase leaves the row reduced by exactly the price and the client balance equal to the row; two concurrent spends from one account cannot produce a balance higher than the pre-spend total.
*Ordering note:* must land before any deployment enables `auth_database` with more than one world, since that is the moment two writers become possible.

---

## 6. Risks and open questions

**G1 (gate, blocks steps 6-8) — Can a real 15.25 client be pointed at an in-binary login port?**
In-repo evidence says the path is currently impossible for four separate reasons: `ProtocolLogin::server_sends_first = false` (`src/protocollogin.h:16`) means a modern client's preamble is parsed as a length header (`src/connection.cpp:161, 183`); the version gate refuses anything outside 1097..1098 (`src/protocollogin.cpp:177-180`); the 0x64 charlist layout (`src/protocollogin.cpp:83-130`) is the 10.x/11.x shape and 15.25's is unverified in this tree; and `README.md:40` documents HTTP login as the supported path. Three of the four are fixable here (steps 6-7); the fourth is client-side and is the actual gate.
*How to resolve, cheaply and first:* (a) read the client's own entergame module — `STATUS.md:219-220` records the build at `~/Documents/BlackTek15`, outside this repository — for whether a non-HTTP login target is selectable at protocol 1525, and what framing and charlist layout it expects; (b) if yes, set `login_port` in a scratch config, point the client at it, and record the session with `harness/capture_proxy.py` (`README.md:38`) for `harness/packet_diff.py --decode`. Do not proceed to step 6 on inference.
*If the answer is no:* steps 6-8 are dropped and the world list stays with the webservice, deployed **once per world** (N containers, each with its own `SERVER_NAME`/`SERVER_IP`/`SERVER_PORT` and `MYSQL_DBNAME` pointed at that world's schema) — which works **unmodified** precisely because of the view design in 3.2. The player then picks the world at the client's login-target level rather than in a world-list packet. Steps 1-5 and 9 are unaffected and still deliver world identity, wrong-world rejection, account-wide coins and the shared auth schema. If the owner instead wants one unified world list under that outcome, the only remaining route is modifying or replacing `opentibiabr/login-server` — **an explicit owner call the plan does not make** (`README.md:17`, `STATUS.md:206-210`).

**G2 (blocks step 3 going live) — What exact string does the client send?**
The harness hardcodes `BlackTek` (`harness/modern_client.py:121`) and the webservice is configured `SERVER_NAME=BlackTek` (`docker-compose.yaml:51`), while `config/server.toml:4` is `"Black Tek"`. *Resolve by:* capturing one real client session with `harness/capture_proxy.py` and reading the first bytes; set `worlds.toml`'s `name` to exactly that. Until confirmed, step 3's rejection is a potential total outage, which is why the check tolerates case and trailing whitespace and never rejects an absent line.

**O1 — Are `SELECT * FROM auth.<table>` views insertable and updatable for these tables?** The design needs `INSERT INTO accounts` (`src/game.cpp:5735, 6043`), `UPDATE accounts` (`src/game.cpp:5881`, `src/iologindata.cpp:497, 2013`, `src/store.cpp:367` and step 9's guarded delta) and `INSERT INTO store_history` (`src/store.cpp:455`) to work through a view. This is a MySQL/MariaDB server behaviour that the checkout cannot establish. *Resolve by:* provisioning the auth schema plus views on the pinned `mariadb:latest` image (`docker-compose.yaml:3`) and running exactly those statements. If any is not view-writable, that table's call sites (a small, enumerated set) get schema-qualified instead, and the views become read-only for the third-party login-server's benefit.

**O2 — Can the four remaining `accounts(id)` FKs survive as cross-schema FKs?** `players` (`schema.sql:1176`), `account_bans` (`:1092`), `account_ban_history` (`:1099`), `account_storage` (`:1106`) would need to reference `auth`.`accounts`. The repository establishes only what the constraints *are*, not whether InnoDB accepts them across schemas on one instance. *Resolve by:* attempting the four `ALTER TABLE ... ADD CONSTRAINT ... REFERENCES <auth>.accounts(id)` on the provisioning rig. **The design does not depend on the answer:** if they cannot be created they are dropped, and the invariant (`ON DELETE CASCADE` of an account's rows) moves to the account-deletion procedure, which must then be documented. Flag for the owner: dropping them means an orphaned `players` row is no longer impossible at the database level.

**O3 — Is the MySQL user permitted on every world schema?** The charlist reads `<other_world>.players`. *Resolve by:* stating the grant as a deployment prerequisite in step 8 and having the boot probe (3.3) extended to `SELECT 1 FROM <entry.schema>.players LIMIT 1` for each registry entry, warning (not refusing) per world that fails.

**O4 — How many worlds, and how many characters per account?** The charlist is one query per world and the wire caps at 255 characters (`src/protocollogin.cpp:90`). Both are fine for a handful of worlds; neither has a measured number behind it. *Resolve by:* asking the owner for the intended world count before anyone optimises the charlist path. No optimisation is proposed on an unmeasured path.

**O5 — Residual: one account, two simultaneous worlds.** `one_player_per_account` is enforced against this process's player map only (`src/protocolgame.cpp:246-249`), so the same account can be in two worlds at once. Step 9 makes coins safe under that (no negative balance, no resurrected spend), but a stale cached balance is still visible until the next store action refreshes it. D6 remains the owner's open decision; phase 1 deliberately keeps the default (per-world) and does not build a cross-world presence registry.

**O6 — Migration drift across worlds.** Each world runs `updateDatabase()` at boot with no lock (`src/otserv.cpp:402`, `src/databasemanager.cpp:70-120`); with per-world schemas they can reach different `db_version`s on the same binary, and `server_config` (`schema.sql:711-718`) is per-world. Phase 1 does not change this. The one new rule — never `ALTER` a hoisted table from a world process — is documentation plus the step 4 boot probe, not an enforced mechanism. Flag for a later phase.

---

## 7. Validation

No performance claims are made in this plan, so nothing here asks for a benchmark. What to exercise:

1. **Registry** — `tests/test_world_registry.cpp` (step 2) covers every `Error` branch, `Find`, `IsSelf` case/`\r` tolerance and `Self()`. Pure, DB-free, client-free; it is the cheapest proof the identity model is airtight.
2. **Boot refusals** — run a world with (a) a missing `[world].id`, (b) an id absent from `worlds.toml`, (c) a `port`/`address`/`schema` disagreeing with `server.toml`/`database.toml`, (d) `auth_database` set against an unprovisioned schema. Each must print a distinct message and stop.
3. **Wrong-world rejection** — `harness/modern_client.py` with its preamble literal (`:121`) matching the registry: logs in. The same client with a modified literal: receives the refusal string and disconnects. An absent preamble: unaffected. Record both with `harness/capture_proxy.py` for the log.
4. **No regression on the verified path** — the full check `README.md:38` prescribes: `./blacktek_tests`, `harness/modern_client.py --webservice ...`, and a headless real-client run exercising bestiary/charms, prey, forge, wheel, store, market and cyclopedia. This is mandatory after step 4 (schema move) and after step 9 (coin rewrite); those are the two steps that can silently break a verified system.
5. **Cross-world charlist truthfulness** — with two schemas populated, confirm each character carries its own world byte; then stop world B's *process* and confirm its characters still list (proving nothing is process-cached); then revoke access to world B's *schema* and confirm world A's characters still list with a warning logged (proving per-world query isolation).
6. **Coin correctness** — with one account logged into two worlds: spend on world A, spend on world B, and confirm (a) the row never goes negative, (b) neither spend restores the other's balance, (c) a rejected guard leaves the in-memory balance untouched, (d) `store_history` records both. Then repeat with a transfer (`src/store.cpp:367`) in the mix.
7. **Third-party login-server compatibility after the schema move** — point one unmodified `opentibiabr/login-server` instance at a world schema carrying the views and confirm it still authenticates, returns a charlist, and writes `account_sessions` that `src/iologindata.cpp:152-177` accepts. This is the check that keeps the G1-fails fallback alive.

---

### Files that matter for this work

- `/home/josh/Documents/BlackTek-Server/src/connection.cpp`, `/home/josh/Documents/BlackTek-Server/src/connection.h`
- `/home/josh/Documents/BlackTek-Server/src/protocollogin.cpp`, `/home/josh/Documents/BlackTek-Server/src/protocollogin.h`, `/home/josh/Documents/BlackTek-Server/src/protocolold.h`
- `/home/josh/Documents/BlackTek-Server/src/protocolgame.cpp`, `/home/josh/Documents/BlackTek-Server/src/protocolgame.h`, `/home/josh/Documents/BlackTek-Server/src/protocolprofile.h`
- `/home/josh/Documents/BlackTek-Server/src/iologindata.cpp`, `/home/josh/Documents/BlackTek-Server/src/iologindata.h`, `/home/josh/Documents/BlackTek-Server/src/account.h`
- `/home/josh/Documents/BlackTek-Server/src/otserv.cpp`, `/home/josh/Documents/BlackTek-Server/src/server.cpp`, `/home/josh/Documents/BlackTek-Server/src/server.h`
- `/home/josh/Documents/BlackTek-Server/src/configmanager.cpp`, `/home/josh/Documents/BlackTek-Server/src/configmanager.h`, `/home/josh/Documents/BlackTek-Server/src/luascript.cpp`
- `/home/josh/Documents/BlackTek-Server/src/database.h`, `/home/josh/Documents/BlackTek-Server/src/database.cpp`, `/home/josh/Documents/BlackTek-Server/src/databasemanager.cpp`, `/home/josh/Documents/BlackTek-Server/src/databasetasks.cpp`
- `/home/josh/Documents/BlackTek-Server/src/store.cpp`, `/home/josh/Documents/BlackTek-Server/src/store.h`, `/home/josh/Documents/BlackTek-Server/src/game.cpp`, `/home/josh/Documents/BlackTek-Server/src/ban.cpp`
- `/home/josh/Documents/BlackTek-Server/schema.sql`, `/home/josh/Documents/BlackTek-Server/config/server.toml`, `/home/josh/Documents/BlackTek-Server/config/database.toml`
- `/home/josh/Documents/BlackTek-Server/harness/modern_client.py`, `/home/josh/Documents/BlackTek-Server/docker-compose.yaml`, `/home/josh/Documents/BlackTek-Server/premake5.lua`
- New: `src/world.h`, `src/world.cpp`, `config/worlds.toml`, `auth_schema.sql`, `tests/test_world_registry.cpp`agentId: a092bccff0da4de12 (use SendMessage with to: 'a092bccff0da4de12', summary: '<5-10 word recap>' to continue this agent)
<usage>subagent_tokens: 198563
tool_uses: 64
duration_ms: 732369</usage>