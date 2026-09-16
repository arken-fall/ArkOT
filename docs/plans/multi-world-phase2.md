# Phase 2 plan: splitting account data from world data

> **Verification notes, added 2026-09-16 after the plan was checked against the checkout.**
>
> - **The deployment database is MySQL 8.0.46, not MariaDB.** The running `blacktek-db` container is
>   `mysql:8.0`; `docker-compose.yaml:3` still says `mariadb:latest`. Read "MariaDB" below as "the
>   deployment's MySQL".
> - **This already mattered once.** On MySQL 8.0, adding a negative value to an `UNSIGNED` column
>   raises `ERROR 1690` when the result would go below zero; it does not evaluate as signed. The
>   phase-1 coin guard assumed otherwise; it now casts to `SIGNED` (commit `7e9106c`).
> - Confirmed by reading the code: `allow_clones` did not bypass the one-session check before phase 2 (phase 2's `singleSession` flag now does)
>   (`src/protocolgame.cpp:216` vs `:247-250`); `g_databaseTasks` is destroyed after `g_game` and
>   `g_config` before it (`src/otserv.cpp:47-53`); the logout save and online-status update run on
>   every removal, not only on logout (`src/player.cpp:2012-2064`); and `DBTransaction::begin()` sets
>   `STATE_START` before `BEGIN` can fail, so its destructor can unlock a mutex it never locked
>   (`src/database.h:207-210`, `src/database.cpp:52-70`).
>
> **Gate G — PASSED on MySQL 8.0.46, 2026-09-16.** Run against two throwaway schemas
> (`bt_gate_auth`, `bt_gate_world`) created under a grant scoped to `bt\_gate\_%`, then dropped and
> the grant revoked. The shipped `auth_schema.sql` provisioned them unmodified. Every write was issued
> unqualified from the world schema, as a world process issues it.
>
> | Check | Result |
> | --- | --- |
> | **O1** — views writable | All three views `IS_UPDATABLE = YES`; `INSERT`/`UPDATE` through them land in the auth base table |
> | **O2** — cross-schema FKs | Created, **enforced** (orphan insert fails with 1452), and `ON DELETE CASCADE` works across schemas |
> | Coin guard | affordable → 1 row, exact → 1, **unaffordable → 0 with no error**, credit → 1 |
> | Ban SQL (3.B) | insert via view → 1; guarded delete → 1; **resent delete → 0**, so history is written exactly once |
> | Presence SQL (3.A) | claim → 1; **competing claim → 0**; holder/expiry lookup correct; wrong-token takeover → 0, right → 1; release → 1 |
> | `ALTER` on a hoisted table | Refused with 1347 `is not BASE TABLE` — the migration rule is enforced by the server |
>
> Consequences for this plan: steps 1 onward are unblocked, and step 0b's "if O1 fails" branch does
> not apply. O2 passing is better than the design needed — `auth_schema.sql` section 4's cross-schema
> foreign keys can be enabled, so account deletion cascades at the database level and an orphaned
> `players` row stays impossible.
>
> **Gate G re-run — PASSED on MySQL 8.0.46, 2026-09-16, against the shipped artifacts.** The first run
> used gate-created copies of the ban and presence tables. After Step 1 moved those tables into
> `auth_schema.sql`, the gate was turned into `harness/auth_schema_gate.sql` and re-run against schemas
> provisioned by the shipped `auth_schema.sql` (7 auth base tables, 5 world views). Pass 1: 43 checks,
> 0 errors, 0 mismatches — adding coverage the first run lacked: a mixed-column coin debit and credit,
> `banned_by_name` visible through both ban views (what Step 4's boot probe checks), and the
> **expired-holder takeover** (a stale world's claim reads `expired = 1` and is taken over; the new holder
> reads `expired = 0`) — the crash-recovery path. Pass 2: exactly `ERROR 1452` then `ERROR 1347`, with
> nothing written. Cleanup left all 12 shipped objects intact. Re-run the gate whenever
> `auth_schema.sql` changes or the MySQL version moves.
>
> **Gate G third run — PASSED on MySQL 8.0.46, 2026-09-16, after the takeover race was closed.**
> Implementation found that `Claim`'s takeover `UPDATE` guarded only on `claim_token`, so a world that
> recovered between another world's lookup and its write still lost its claim — and a follow-up
> reconcile could not bound that, because `executeQuery` retries a lost connection indefinitely. The
> takeover now re-checks staleness at write time (`AND (world_id = self OR NOT EXISTS (SELECT 1 FROM
> world_presence WHERE world_id = p.world_id AND beat_at >= UNIX_TIMESTAMP() - Lease))`). Pass 1: 56
> checks, 0 errors, 0 mismatches, including **takeover with the correct holder token but a fresh holder
> heartbeat → 0 rows, claim untouched**; expired holder → 1; holder with no heartbeat row → 1; holder
> that is this world → 1. Global isolation recorded as `REPEATABLE-READ`, which the ordering argument
> relies on: the takeover's shared lock on the heartbeat row serialises it against the recovery upsert.
> Pass 2: `ERROR 1452` then `ERROR 1347`, nothing written.


Short version:
- **Presence:** yes, it needs a schema change. Two new plain tables go in the auth schema only. The world can prove it is still alive, and each claim carries a random token that is compared before it is taken over, so a crashed world frees its accounts within 45 seconds.
- **Bans:** they move behind per-world views, like `accounts`. Each ban stores the banner's name, which replaces the link to a per-world character.
- **VIP list:** needs nothing.
- **Presence and O1/O2:** presence does not depend on O1 or O2.
- **Bans and O1:** the ban move does depend on O1, and if O1 fails, phase 1 is broken as well.

Nothing was built, run or modified. Line numbers are from the current tree; several differ from the older plan documents.

---

## 1. Current state

### 1.1 The one-session check is per process
- The check is at `src/protocolgame.cpp:247-254`, not 246-249. It runs inside `ProtocolGame::login` on the dispatcher (`:212`), after `IOLoginData::preloadPlayer` (`:223`). It only looks at this process's player map (`Game::getPlayerByAccount`, `src/game.cpp:579-587`).
- It skips the Account Manager by `characterId != AccountManager::ID` (`:248`) and skips accounts with `getAccountType() >= ACCOUNT_TYPE_GAMEMASTER` (`:249`).
- **`allow_clones` does not bypass this check today.** `ALLOW_CLONES` only enters the fresh-login branch at `:216`. The check at `:247` then runs anyway, so a clone of the same account is still refused.
- Order after the check: ban check (`:256-276`), then waiting list `clientLogin` (`:278-288`), then `loadPlayerById` (`:292`), then placement (`:313-333`). Every one of those can return early.
- `clientLogin` takes an admitted player off the waiting list (`:175`), so a refusal after it costs the player their queue place.
- A player is marked online at `Player::onCreatureAppear` (`src/player.cpp:1929`) and offline at `Player::onRemoveCreature` (`:2052-2054`). The offline block is inside `if (creature == getCreature())` (`:2013`), not inside `if (isLogout)`, so it runs on every removal, deaths included. The player save loop follows at `:2056-2066`.
- `SHUTDOWN` kicks every player (`src/game.cpp:182-186`) before `g_databaseTasks.stop()` (`:195`).

### 1.2 Why `players_online` can't be the source of truth
- It is a MEMORY table (`schema.sql:379`), emptied at every boot (`data/scripts/globalevents/startup.lua:5`).
- Its writer does nothing when `allow_clones` is on (`src/iologindata.cpp:563-565`).
- Ghost mode deletes and re-inserts the row (`src/luascript.cpp:14372, 14381`).

### 1.3 What "God character/access" can mean in the code
- **Account type:** `accounts.type` (`schema.sql:40`) maps to `AccountType_t`, where `GAMEMASTER = 4`, `COMMUNITYMANAGER = 5`, `GOD = 6` (`src/enums.h:170-177`). It is loaded before the check (`src/iologindata.cpp:592`). It is account-level and shared across worlds through the `accounts` view. The existing exemption uses it (`protocolgame.cpp:249`, also the queue bypass at `:140`).
- **Group access:** `Group::access` (`src/groups.h:15`) is read from `config/groups.toml` (`src/groups.cpp:68`). It is `true` for Tutor, Senior Tutor, Gamemaster, Community Manager and Administrator (`config/groups.toml:14, 25, 37, 57, 84`) and `false` only for Player (`:7`). The code exposes it as `Player::isAccessPlayer()` (`src/player.h:541`) and Lua gates `/ban` and `/unban` on it (`ban.lua:4`, `unban.lua:2`). It is per character.
- **"God"** is literally `ACCOUNT_TYPE_GOD` (`enums.h:176`) or group 6 "Administrator" (`groups.toml:81-87`). Nothing ties the two together.

### 1.4 Bans
- `account_bans`: primary key `account_id` (`schema.sql:756`), so one active ban per account. `banned_by int NOT NULL` (`:64`) has a foreign key to `players(id)` with ON DELETE CASCADE (`:1093`).
- `account_ban_history` has the same foreign key (`:1100`). No migration touches either table (grep of `data/migrations`).
- **Readers:**
  - `IOBan::isAccountBanned` looks up the banner's name with an unqualified subquery against this world's `players` (`src/ban.cpp:51`).
  - When a ban has expired, it moves it to history with two queued background queries (`:59-60`) and returns `false` (`:61`).
- **Writers:**
  - `ban.lua:29` stores `player:getGuid()`, having found the target account by a character name on this world (`ban.lua:17`, `data/lib/compat/compat.lua:592-600`).
  - `ban.lua:32-36` only kicks a target who is online on this world.
  - `unban.lua:11` deletes the ban; `unban.lua:12` deletes the per-world `ip_bans` row.
  - The boot sweep (`startup.lua:12-20`) does select, insert into history, delete, all queued.
- `ip_bans` also links `banned_by` to `players` (`schema.sql:1158`) and is not part of the owner's decision.

### 1.5 VIP list
- Reads by account id: `src/iologindata.cpp:1159` (the brief's `:1126` has moved) and `:2012`. The name comes from a subquery on the local `players`.
- Writes: `:2030, 2036, 2041`.
- Entries are added by resolving a name on the local world (`src/game.cpp:4587-4602`).
- The table is not moved to the auth schema (`auth_schema.sql:110-113`; not in `AuthSharedTables`, `src/otserv.cpp:249`).

### 1.6 What phase 1 left in place
- **Auth probe:** `AuthSharedTables` lists 3 names (`otserv.cpp:249`), and the name list is also written out by hand as a string (`:279`). `ProbeSharedAuthSchema` (`:256-370`) runs before `DatabaseManager::updateDatabase()` (`:633` vs `:655`).
- **Listeners** bind inside `mainLoader`, and `AddListener` refuses to boot on a failed bind, taking every listener down (`:500-514`). Its comment treats a failed bind as "a second copy of this same server". The status listener is the last to bind (`:879-880`).
- **Affected rows:** `Database::getAffectedRows()` exists (`src/database.h:100-102`). `store.cpp:71-84` already relies on calling it right after `executeQuery`. The connection opens with client flags `0` (`src/database.cpp:40`), so affected rows counts rows *changed*, not rows matched. Auto-reconnect is on (`:32-33`).
- `executeQuery` resends a query on connection loss (`database.cpp:93-101`).
- **Background queries:** `g_databaseTasks` has its own connection (`src/databasetasks.cpp:13`), silently drops tasks once stopped (`:41-44`), and its callback only gets `(DBResult_ptr, bool)`, not affected rows (`:64-65`).
- **Destruction order:** `g_databaseTasks` is defined before `g_game` in the same file (`src/otserv.cpp:47, 52`), so it is destroyed after `g_game`. `g_config` (`:53`) is destroyed before `g_game`.
- Scheduled tasks run on the dispatcher (`src/scheduler.cpp:32`). Self-rescheduling precedent: `Game::checkLight` (`src/game.cpp:6968-6969`).
- `7.lua` is the "no more migrations" placeholder that returns `false` (`data/migrations/7.lua`). File N moves the database to version N+1 (`data/migrations/6.lua:2`; `databasemanager.cpp:86-118`). `schema.sql:718` starts new installs at version 0.

---

## 2. Constraints and invariants

- **Settled and not reopened:** one process per world, per-world databases plus one auth schema on one MySQL instance, a single `Database` connection, 15.25 only, the external login-server left unmodified, no renaming of the legacy namespaces, and `account_storage` left exactly as it is.
- **The external login-server** reads `accounts` and writes `account_sessions` through views. Phase 2 only adds *new* auth tables and adds a column to the ban tables, so any table it might read keeps its name and a superset of its columns.
- **Single-world installs** (`auth_database` empty) must keep booting. Everything here is inactive when that setting is empty, except two things: the ban-name column (a guarded migration) and the ban sweep moving into C++, which keeps the same behaviour.
- **A world process never `ALTER`s a table that has moved to the auth schema** (`auth_schema.sql:84-96`).

The design relies on four facts:
1. **All worlds share one database clock.** Staleness is judged with `UNIX_TIMESTAMP()`, never a process's own clock, so worlds on different hosts with clock drift agree.
2. **A world is the authority on its own rows.** The local check (`protocolgame.cpp:247`) runs in the same dispatcher task as the claim, with nothing in between. So a claim row that names *this* world for an account that is not online here is provably leftover.
3. **A successful listener bind means no other process is running this world** on this host (`otserv.cpp:495-499, 862-863`). Clearing this world's presence rows is only safe after the binds.
4. **Each claim token is unique per claim.** Every guarded write compares the token, so resending a query after a lost connection is harmless.

---

## 3. Proposed design

### 3.A Cross-world presence

**Schema change: yes, in the auth schema only.** Two plain InnoDB tables with no views: nothing old queries them, so all SQL for them names the auth schema directly. That means **presence depends on neither O1 nor O2**. Its only foreign key is inside the auth schema. It uses InnoDB rather than MEMORY because a MySQL restart must not silently free every claim.

```sql
CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`world_presence` (
    `world_id` tinyint UNSIGNED NOT NULL PRIMARY KEY,
    `beat_at`  bigint NOT NULL DEFAULT '0'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

CREATE TABLE IF NOT EXISTS `__AUTH_SCHEMA__`.`account_presence` (
    `account_id`     int NOT NULL PRIMARY KEY,
    `world_id`       tinyint UNSIGNED NOT NULL,
    `player_id`      int NOT NULL,
    `character_name` varchar(255) NOT NULL,
    `claim_token`    bigint UNSIGNED NOT NULL,
    `claimed_at`     bigint NOT NULL DEFAULT '0',
    INDEX `world_id` (`world_id`),
    FOREIGN KEY (`account_id`) REFERENCES `__AUTH_SCHEMA__`.`accounts` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;
```

Liveness belongs to the world process, not to each player. That gives one heartbeat write per world per interval, no matter how many players are online.

**New `src/presence.h`:**

```cpp
#pragma once

#include "world.h"

#include <chrono>
#include <cstdint>
#include <expected>
#include <string>
#include <string_view>

namespace BlackTek::World
{
	// One account's deployment-wide login slot. Move-only; a default-constructed
	// claim holds nothing. Destroying a held claim queues its release, so every
	// early return between claiming and entering the world frees the account.
	class PresenceClaim
	{
		public:
			PresenceClaim() noexcept = default;
			~PresenceClaim();

			PresenceClaim(PresenceClaim&& other) noexcept;
			PresenceClaim& operator=(PresenceClaim&& other) noexcept;	// releases a held claim first

			// non-copyable
			PresenceClaim(const PresenceClaim&) = delete;
			PresenceClaim& operator=(const PresenceClaim&) = delete;

			// synchronous, dispatcher only: the logout path
			void Release() noexcept;

			[[nodiscard]] bool		IsHeld() const noexcept		{ return token != 0; }
			[[nodiscard]] uint64_t	Token() const noexcept		{ return token; }

		private:
			friend class Presence;

			PresenceClaim(std::string releaseQuery, uint64_t claimToken) noexcept;

			std::string	release_query;	// prebuilt: the destructor must never read g_config
			uint64_t	token = 0;
	};

	class Presence
	{
		public:
			static constexpr std::chrono::seconds BeatInterval{ 10 };
			// longer than the connection's 30 s read/write timeout (database.cpp:35-37)
			// plus one interval, so one timed-out beat never expires a live world
			static constexpr std::chrono::seconds Lease{ 45 };

			enum class Refusal : uint8_t
			{
				AlreadyOnline,
				Unavailable,
			};

			enum class Holder : uint8_t
			{
				Ours,		// our own token: a resent write already landed
				Abandoned,	// this world's leftover row, or the holder world stopped beating
				Live,
			};

			struct Refused
			{
				std::string	character_name;
				Refusal		reason = Refusal::Unavailable;
				Id			world = 0;
			};

			using ClaimResult = std::expected<PresenceClaim, Refused>;

			Presence(const Presence&) = delete;
			Presence& operator=(const Presence&) = delete;

			static Presence& GetInstance() noexcept
			{
				static Presence instance;
				return instance;
			}

			// mainLoader, once, after every listener is bound. Refuses a schema name
			// containing '`'; deletes this world's rows; writes the first beat; arms Beat().
			std::expected<void, std::string> Start(std::string_view authSchema);

			// Game::setGameState(SHUTDOWN), after the kick loop
			void Retire() noexcept;

			[[nodiscard]] bool			IsEnabled() const noexcept	{ return not auth_schema.empty() and not retired; }

			// dispatcher; only after the local one-session check passed in the same task.
			// [[nodiscard]]: discarding the claim releases it immediately.
			[[nodiscard]] ClaimResult	Claim(uint32_t accountId, uint32_t playerId, std::string_view characterName);

			[[nodiscard]] static Holder	Classify(uint64_t holderToken, Id holderWorld, bool holderExpired, uint64_t ourToken, Id ourWorld) noexcept;

		private:
			Presence() = default;

			void	Beat();
			void	Reconcile();

			std::string								auth_schema;
			std::chrono::steady_clock::time_point	last_beat{};
			bool									retired = false;
	};
}
```

**`Classify`** (pure):
- holder token equals ours: `Ours`
- holder world is this world: `Abandoned` (fact 2)
- holder world's heartbeat expired: `Abandoned`
- otherwise: `Live`

**`Claim`**, for at most 3 attempts. The token is a non-zero 64-bit value made from two draws of `getRandomGenerator()` (`src/tools.h:77`). `A` is the account id.
1. `INSERT IGNORE INTO \`<auth>\`.\`account_presence\` (...) VALUES (A, self, playerId, name, token, UNIX_TIMESTAMP())`
   - If the query fails: `Refused{Unavailable}` plus a `Console::Database::Error`.
   - If `getAffectedRows() == 1`: the claim is ours.
2. `SELECT p.world_id, p.claim_token, p.character_name, (COALESCE(w.beat_at, 0) < UNIX_TIMESTAMP() - <Lease>) AS expired FROM <auth>.account_presence p LEFT JOIN <auth>.world_presence w ON w.world_id = p.world_id WHERE p.account_id = A`
   - No row (the holder released between the two queries): next attempt.
3. Act on `Classify`:
   - `Ours`: the claim is ours.
   - `Live`: `Refused{AlreadyOnline, holder world, holder character}`.
   - `Abandoned`: `UPDATE ... SET world_id, player_id, character_name, claim_token = ours, claimed_at WHERE account_id = A AND claim_token = <holder token>`. One affected row means the claim is ours; zero means another world won, so go to the next attempt.
4. After 3 attempts: `Refused{Unavailable}`.

Release query: `DELETE FROM <auth>.account_presence WHERE account_id = A AND claim_token = T`.
- The **destructor** queues it with `g_databaseTasks.addTask`. That queue is thread-safe and drops the task after stop (`databasetasks.cpp:40-45`). It outlives `g_game` at static destruction (`otserv.cpp:47, 52`).
- **`Release()`** runs it synchronously on the dispatcher, so a logout on world A is visible immediately to a login on world B.

**`Beat`** re-arms itself first, like `checkLight`, then:
- returns immediately if `retired`;
- runs `INSERT INTO <auth>.world_presence VALUES (self, UNIX_TIMESTAMP()) ON DUPLICATE KEY UPDATE beat_at = UNIX_TIMESTAMP()`;
- on success, if `last_beat` was set and `steady_clock::now() - last_beat >= Lease - BeatInterval`, calls `Reconcile()`;
- then sets `last_beat`.

The beat stays on the dispatcher on purpose: a stuck dispatcher *should* lose its claims.

**`Reconcile`** handles the case where this world stalled long enough that another world may have taken its claims:
- `SELECT claim_token FROM <auth>.account_presence WHERE world_id = self` into a sorted `std::vector<uint64_t>`.
- Filter `g_game.getPlayers() | std::views::values` for players whose token is set but not found by `std::ranges::binary_search`, and copy them into a vector. The map is changed by kicking, same as `game.cpp:182-186`.
- For each: `sendTextMessage(MESSAGE_STATUS_WARNING, "Your account logged in on another world while this world was unreachable.")`, then `kickPlayer(true)`.

**`Retire`** (synchronous): `DELETE FROM <auth>.account_presence WHERE world_id = self`, `DELETE FROM <auth>.world_presence WHERE world_id = self`, then `retired = true`.

**Crashes and races:**

| Scenario | Outcome |
| --- | --- |
| World crashes and stays down | Its rows count as abandoned once `beat_at` is more than `Lease` old. Lockout on other worlds is at most 45 s. |
| Crashed world restarts | `Start` deletes its rows. Lockout on that world is 0. |
| Clean shutdown | `Retire` frees every claim at once. |
| Two worlds log the same account in together | The primary key lets exactly one `INSERT IGNORE` succeed; the other is refused with the winner's world and character. |
| Two worlds take over the same abandoned claim | The token comparison lets exactly one win. |
| `executeQuery` resends after a lost connection | Our own token is found, so it counts as `Ours`. |

**Login wiring (`src/protocolgame.cpp`):**

```cpp
namespace
{
	// account-level, shared across worlds through the `accounts` view; the same
	// accounts the per-world rule already exempted (protocolgame.cpp:249). See Q-A.
	[[nodiscard]] bool IsSingleSessionExempt(const PlayerConstPtr& player) noexcept
	{
		return player->getAccountType() >= ACCOUNT_TYPE_GAMEMASTER;
	}

	[[nodiscard]] std::string DescribePresenceRefusal(const BlackTek::World::Presence::Refused& refused);
}
```

- Replace `:247-254` with a single flag: `const bool singleSession = ONE_PLAYER_ON_ACCOUNT and not ALLOW_CLONES and characterId != AccountManager::ID and not IsSingleSessionExempt(player);`. Keep the local `getPlayerByAccount` check and its current message.
- After the ban block (`:276`) and **before** `clientLogin` (`:278`), because admission takes the player off the queue (`:175`):
  - declare `BlackTek::World::PresenceClaim presenceClaim;`
  - if `singleSession and Presence::GetInstance().IsEnabled()`, call `Claim(player->getAccount(), player->getGUID(), player->getName())`;
  - on refusal: `disconnectClient(DescribePresenceRefusal(...)); return;`.
  - Every later early return releases the claim through the destructor.
- After the placement if/else (`:337`): `player->adoptPresenceClaim(std::move(presenceClaim));`.
- **Refusal text:**
  - `AlreadyOnline`: `"Your account is already online on {world} as {character}.\nLog out there first, then try again."`. If `Registry::Find(world)` finds nothing, "another world".
  - `Unavailable`: `"Your login could not be checked right now.\nPlease try again in a moment."`. This fails closed; failing open would silently defeat the owner's rule.

**`Player`:**
- private member `BlackTek::World::PresenceClaim presence_claim;`
- public `void adoptPresenceClaim(BlackTek::World::PresenceClaim claim) noexcept` and `[[nodiscard]] uint64_t getPresenceToken() const noexcept`
- `presence_claim.Release();` in `onRemoveCreature` right after the save loop (`player.cpp:2066`), so the account stays claimed until its state is saved.
- Players loaded offline (market, house rent) never hold a claim, so their destructor does nothing.

**Boot and shutdown:**
- `ProbeSharedAuthSchema` also requires `account_presence` and `world_presence` to be base tables in the auth schema.
- `Presence::Start` runs right after `AddListener<ProtocolStatus>` (`otserv.cpp:879-880`). On failure: `services->AbandonListeners(); startupErrorMessage(...); return;`, mirroring `:510-512`.
- `Presence::GetInstance().Retire()` runs in the `SHUTDOWN` case right after the kick loop (`game.cpp:186`).

**Threading:** everything runs on the dispatcher except the destructor's queued release. No atomics or mutexes are added. The `Presence` state is written once in `mainLoader` and then only by the dispatcher.

### 3.B Account-wide bans

- **Move** `account_bans` and `account_ban_history` into the auth schema, with same-named views in each world, exactly like `accounts`. The primary key and the `account_id` foreign key to `accounts` stay inside the auth schema, so no cross-schema foreign key is needed (no O2 dependency).
- **Resolve `banned_by`:** add `banned_by_name varchar(255) NOT NULL DEFAULT ''` after `banned_by`, and drop the foreign key to `players`. `banned_by` stays for compatibility. The display name comes from the new column.
  - **Lost:** the database no longer guarantees `banned_by` names a real character (impossible across worlds anyway), and a raw `banned_by` id can't be traced without knowing which world issued the ban.
  - **Also lost, on purpose:** the `ON DELETE CASCADE` (`schema.sql:1093, 1100`) that deleted a ban and its history whenever the banning GM's character was deleted. That was a defect.
  - The name is frozen at ban time, which is correct for a historical record.
  - No fallback lookup by `banned_by` in `players`: in multi-world it would return whoever has that id on *this* world, which is worse than an empty name.
- **`IOBan`** (`src/ban.cpp`):
  - `isAccountBanned` selects `reason, expires_at, banned_at, banned_by, banned_by_name` with no subquery, and sets `bannedBy` from `banned_by_name`.
  - For an expired ban it calls `RetireExpiredBan` (anonymous namespace):

```cpp
struct ExpiredBan
{
	std::string	reason;
	std::string	banned_by_name;
	int64_t		banned_at = 0;
	int64_t		expires_at = 0;
	uint32_t	account_id = 0;
	uint32_t	banned_by = 0;
};

// the guarded DELETE decides who moves the ban: only the caller whose DELETE
// removed the row writes history, however many worlds notice the expiry at once
void RetireExpiredBan(const ExpiredBan& ban);
```

  - `RetireExpiredBan` runs synchronously on the main connection: `DELETE FROM account_bans WHERE account_id = A AND banned_at = B AND expires_at = E`. If `getAffectedRows() == 1`, it inserts the history row including `banned_by_name`; if that insert fails, it logs `Console::Database::Error`.
  - Why synchronous: the affected-rows answer must come from the connection that ran the delete, and `g_databaseTasks` has no way to return it (`databasetasks.cpp:64-65`).
  - `DBTransaction` is avoided on purpose; see section 6.
- **New `static void IOBan::sweepExpiredAccountBans();`** reads every expired ban into a `std::vector<ExpiredBan>`, then calls `RetireExpiredBan` for each. It is called from `mainLoader` right after `updateDatabase()` (`otserv.cpp:655`). It is safe to run from every world at once.
- **Lua:**
  - Delete `startup.lua:11-20`.
  - `ban.lua:29` adds `banned_by_name` with `db.escapeString(player:getName())`.
  - `unban.lua` is unchanged (its delete goes through the view).
- **Consequences to flag:**
  - A GM still bans by naming a character on their own world (`ban.lua:17`).
  - A target online on another world is not kicked; the ban applies at their next login.
  - `ip_bans` stays per world, so `unban.lua:12` only clears this world's IP ban.
  - `PlayerFlag_CannotBeBanned` comes from each world's `groups.toml`.
- **Migration** `data/migrations/7.lua` (version 8), and a new placeholder `8.lua` returning `false`. For each ban table:
  - check `information_schema.TABLES.TABLE_TYPE`;
  - **if it is a base table and lacks the column:** add the column, backfill with `UPDATE t JOIN players p ON p.id = t.banned_by SET t.banned_by_name = p.name WHERE t.banned_by_name = ''`, and drop the foreign key that `information_schema.KEY_COLUMN_USAGE` reports pointing at `players` (constraint names vary, `auth_schema.sql:254-258`);
  - **if it is a view and lacks the column:** print "re-run section 3 of auth_schema.sql" and return `false`. A world process never alters a moved table.
  - `schema.sql:59-65, 73-80` gain the column for new installs.
- **Boot probe:** `AuthSharedTables` grows to 5 names, and the SQL name list is built from the array instead of being written by hand (`:279`). Boot also refuses unless `banned_by_name` exists in both the auth base tables and the world views; a stale `SELECT *` view would otherwise make the ban query fail. Without that refusal, `storeQuery` returning null would read as "not banned", and banned players would get in.

### 3.C `account_viplist`: nothing needed in this phase

It is already per world:
- In a split deployment each world owns its own table (`auth_schema.sql:110-113`).
- Entries are written with ids resolved on that world (`game.cpp:4587-4602`).
- They are read back from that world's table (`iologindata.cpp:1159`) with names from that world's `players` (`:2012`).
- The account id only groups entries within the world. Characters never change worlds (settled), so a cross-world VIP entry would point at nothing.

It must **never** be moved to the auth schema: world A's ids would be fed into world B's `addVIPInternal` (`:1161`) and name lookup (`:2012`), silently showing the wrong characters. The per-world foreign key on `player_id` (`schema.sql:1113`) is correct and stays.

### 3.D Error strategy by layer
- **Boot:** probes and `Presence::Start` return a reason, and boot refuses on it.
- **Login:** `std::expected<PresenceClaim, Refused>`; the refusal is shown to the player as framed text. It fails closed.
- **Ban expiry:** guarded writes with logged errors; a failed history insert never brings back an expired ban.
- **Heartbeat and reconcile:** logged warnings, never a crash.
- No exceptions anywhere.

---

## 4. Alternatives considered

- **Use `players_online` or put claims inside `updateOnlineStatus`:** rejected. It is a MEMORY table, emptied at boot, skipped when `allow_clones` is on, and ghost mode deletes the row (`schema.sql:379`, `startup.lua:5`, `iologindata.cpp:563`, `luascript.cpp:14372`).
- **A heartbeat column on every presence row:** rejected. It costs one write per online player per interval, when liveness really belongs to the world process.
- **`SELECT ... FOR UPDATE` or gap locks:** rejected. Whether gap locks exist depends on the transaction isolation level (they are disabled under READ COMMITTED). The primary key plus a token comparison works at any isolation level, needs no transaction, and survives a resent query.
- **An `ON DUPLICATE KEY UPDATE` with a subquery on `world_presence`:** rejected. It rests on server behaviour this repository can't verify.
- **A per-world view for the presence tables:** rejected. There are no old queries to keep working, and a view would pull in O1 for no benefit.
- **Releasing a claim only in `Player`'s destructor:** rejected. Player destruction time isn't proven, and a claim leaked on a live world would never go stale. Hence: explicit synchronous release on logout, a scoped claim during login, and the destructor only as a backstop.
- **Claiming after the waiting list:** rejected, because admission costs the player their queue place (`protocolgame.cpp:175`).
- **`banned_by_world` plus a registry lookup of the name:** rejected. It adds a cross-schema query per banned login, depends on grants and the registry, loses the name when a character is deleted or a world is retired, and Lua would need `WORLD_ID` exposed.
- **Dropping `banned_by`:** rejected. The column is NOT NULL, has existing writers, and unknown outside readers (such as a website).
- **Keeping the Lua boot ban sweep:** rejected. N worlds would race and write duplicate history rows, and Lua can't read affected rows.
- **A `DBTransaction` for the ban move:** rejected, because of the `begin()` defect (section 6) and auto-reconnect silently losing transactions (`database.cpp:32-33`).

---

## 5. Migration plan

**Gate G:** steps 1 onward wait for step 0b. Steps marked **[O1]** change shape if O1 fails.

**Step 0a: gate script (SQL only).**
- **Scope:** new `harness/auth_schema_gate.sql`, using the same placeholders. Every write is followed by `SELECT ROW_COUNT();`.
  - G0: `SELECT VERSION()`.
  - G1: the phase-1 O1 statements (`auth_schema.sql:131-139`).
  - G2: scratch versions of the two ban tables in the new shape plus MERGE views, then insert, guarded delete (expect 1, resend expects 0) and history insert *through the views*.
  - G3: `INSERT IGNORE` twice on `account_presence` (expect 1, then 0); token-guarded update with the right token (1) and a wrong one (0).
  - G4: `information_schema.VIEWS.IS_UPDATABLE` for all 5 views; `information_schema.COLUMNS` lists view columns; `ALTER TABLE` on a view is refused.
  - G5: `auth_schema.sql` section 4.
  - Cleanup.
- **Blast radius:** none. **Done when:** the script runs start to finish after `auth_schema.sql` sections 1 and 3 on a scratch instance.

**Step 0b: owner runs it** on the actual MariaDB image and records the results. Not a coder task.
- **If O1 fails:** phase 1 is already broken (account writes through views), and the login-server's `account_sessions` writes may be too, which is an owner call. Steps 1 and 2 change: the ban SQL in C++ names the auth schema directly, and Lua gets a `data/lib` helper built on a newly exposed `configKeys.MYSQL_AUTH_DB`. Steps 3-6 are unchanged.
- **If O2 fails:** nothing in phase 2 changes.

**Step 1 [O1]: schema files.**
- **Scope:**
  - `auth_schema.sql`: section 1 adds 4 tables; section 2 adds the ban move, copying `banned_by_name` or backfilling it from `players` and not copying history `id`s; section 3 adds 2 views; header updates, including "viplist must never be moved" with the reason.
  - `schema.sql:59-80`: the new column.
  - `data/migrations/7.lua` and `8.lua`.
- **Blast radius:** database only. Single-world installs gain one column with backfilled names.
- **Done when:** the migration adds and backfills the column and drops the `players` foreign keys on base tables, and refuses on a view that lacks the column.
- **Behaviour change:** deleting a GM's character no longer deletes their bans.

**Step 2 [O1]: `IOBan` and Lua.**
- **Scope:** `src/ban.cpp`, `src/ban.h` (the sweep declaration), `otserv.cpp:655` (the sweep call), `startup.lua:11-20` removed, `ban.lua:29`.
- **Blast radius:** every login's ban check.
- **Done when:** the ban message shows the issuer's name; an expired ban produces exactly one history row even when two worlds run the sweep at the same time; no `players` subquery remains in `isAccountBanned`.

**Step 3: `BlackTek::World::Presence` translation unit and tests.**
- **Scope:** `src/presence.h`, `src/presence.cpp` as in 3.A; `tests/test_presence.cpp` covering every `Classify` branch, following `tests/test_world_registry.cpp`.
- **Blast radius:** none; not wired in yet.
- **Done when:** the tests cover Ours, same-world Abandoned, expired Abandoned and Live; the destructor of a moved-from claim does nothing.

**Step 4: boot probe, start and retire.**
- **Scope:** `otserv.cpp` (5-name list, presence base-table check, column check, `Start` after `:880`), `game.cpp:186` (`Retire`).
- **Done when:** boot refuses on a missing presence table or a stale ban view; a running world keeps `beat_at` current; shutdown removes both of this world's rows; single-world boots unchanged.

**Step 5: login and player wiring.**
- **Scope:** `protocolgame.cpp:247-337`, `player.h`, `player.cpp:2066`.
- **Blast radius:** every login.
- **Done when:** the scenarios in section 7 pass.
- **Behaviour changes:** the one-session rule becomes deployment-wide; **`allow_clones = true` now bypasses the rule** (today it doesn't, `:216` vs `:247`); new refusal text.

**Step 6: reconcile after a stall.**
- **Scope:** `Presence::Beat` and `Reconcile`.
- **Done when:** a world stalled longer than `Lease` whose claim was taken kicks exactly that player, with the message.
- **Behaviour change:** players can be kicked after a database or dispatcher stall.

**Step 7: documentation.**
- **Scope:** `docs/deployment/multi-world.md` (what is shared now, the lease, bans, ip_bans and VIP staying per world, `one_player_per_account` and `allow_clones` needing the same value on every world, provisioning order: migrate to version 8 before moving the ban tables).

---

## 6. Risks and open questions

- **Q-A (owner): what counts as "God character/access".** Default: account type ≥ GAMEMASTER, which is today's account-level exemption. Adding `or player->isAccessPlayer()` would also exempt the Tutor and Senior Tutor groups (`groups.toml:14, 25`), and the exemption would then be per character. Narrowing to `ACCOUNT_TYPE_GOD` is also a one-line change. **Resolve:** ask the owner.
- **Q-B: does the external login-server read or write `account_bans`?** Its source isn't in the repo. The views keep the name and existing columns, and the new column defaults to `''`. **Resolve:** read the image's queries, or capture its SQL.
- **Q-C: mixed per-world config.** A world with `allow_clones = true` or `one_player_per_account = false` neither claims nor checks, which silently weakens the rule for everyone. The server can't see other worlds' config. **Resolve:** a documentation rule (step 7).
- **Q-D: the lease values** (10 s beat, 45 s lease) are derived from the 30 s connection timeout, not measured. **Resolve:** log the time between beats and count reconcile kicks in staging.
- **Q-E: pinned MariaDB version.** Gate results only hold for the version recorded in G0.
- **Resends (brief defect 2):** presence is safe (the `Ours` case). A resent ban delete loses that ban's history row rather than duplicating it.
- **New adjacent defect, not absorbed:** `DBTransaction::begin()` sets `STATE_START` before `beginTransaction()` succeeds (`database.h:207-210`). If `BEGIN` fails, the destructor's `rollback()` unlocks a mutex that was never locked (`database.cpp:54-58, 62-71`), which is undefined behaviour.
- **Migration drift (brief defect 3):** step 1's migration only alters base tables and refuses on views.
- **Coin transfer credit (brief defect 1, `store.cpp:464`):** untouched and still open.
- **`status_port` vs `game_port_modern` (brief defect 4):** untouched. Presence only relies on the game-port bind (`otserv.cpp:862-863`).

---

## 7. Validation

No speed claims are made. What to exercise:

1. **Gate:** step 0b results recorded before step 1.
2. **Unit tests:** `tests/test_presence.cpp`.
3. **Two worlds, one account:**
   - Log in on A, then try B: refused naming A and the character.
   - Log out on A, then log in on B right away: accepted.
   - Log two worlds in at the same moment: exactly one succeeds.
4. **Crash:** kill A with SIGKILL.
   - B refuses until `beat_at` is more than 45 s old, then accepts.
   - Restart A: its leftover rows are gone before its listeners accept connections.
5. **Failed login paths:** force failures after the claim (ban, queue, load, placement). The `account_presence` row disappears each time and the account can log in on B.
6. **Exemptions:**
   - `allow_clones = true`: no row is written, and the same account works on both worlds.
   - Account type ≥ 4: no row is written.
   - Account Manager: unaffected.
7. **Stall:** freeze A's database connection for longer than the lease, log in on B, unfreeze A: A kicks that player.
8. **Bans:**
   - Ban on A, log in on B: refused with the issuer's name.
   - Expired ban with both worlds booting together: exactly one history row.
   - Single-world install: migration backfills names, and the ban message is unchanged.
9. **No regressions:** `./blacktek_tests`, `harness/modern_client.py`, and a real-client pass over store, market and the other checked 15.25 systems after steps 2 and 5. Also point an unmodified login-server at a world schema with the ban views.

### Files involved
- **To modify:**
  - `/home/josh/Documents/BlackTek-Server/auth_schema.sql`
  - `/home/josh/Documents/BlackTek-Server/schema.sql`
  - `/home/josh/Documents/BlackTek-Server/data/migrations/7.lua`
  - `/home/josh/Documents/BlackTek-Server/src/ban.cpp`, `/home/josh/Documents/BlackTek-Server/src/ban.h`
  - `/home/josh/Documents/BlackTek-Server/src/otserv.cpp`
  - `/home/josh/Documents/BlackTek-Server/src/game.cpp`
  - `/home/josh/Documents/BlackTek-Server/src/protocolgame.cpp`
  - `/home/josh/Documents/BlackTek-Server/src/player.h`, `/home/josh/Documents/BlackTek-Server/src/player.cpp`
  - `/home/josh/Documents/BlackTek-Server/data/scripts/globalevents/startup.lua`
  - `/home/josh/Documents/BlackTek-Server/data/scripts/talkactions/ban.lua`
  - `/home/josh/Documents/BlackTek-Server/docs/deployment/multi-world.md`
- **New:**
  - `/home/josh/Documents/BlackTek-Server/src/presence.h`, `/home/josh/Documents/BlackTek-Server/src/presence.cpp`
  - `/home/josh/Documents/BlackTek-Server/tests/test_presence.cpp`
  - `/home/josh/Documents/BlackTek-Server/data/migrations/8.lua`
  - `/home/josh/Documents/BlackTek-Server/harness/auth_schema_gate.sql`