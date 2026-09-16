# Running N worlds

How to deploy this server as more than one world: what each world gets its own copy of, what every
world must share byte for byte, which disagreements the server refuses to boot on, and what the
shared MySQL instance has to look like.

One process serves exactly one world. N worlds means N processes.

Multi-world has two phases, and both are in the tree:

| Phase | What it shares across worlds |
| --- | --- |
| 1 | Accounts, login sessions and store coin history (`accounts`, `account_sessions`, `store_history`). One login listener lists every world. |
| 2 | Account bans (`account_bans`, `account_ban_history`), and **one session per account across the whole deployment**, enforced through two presence tables (`world_presence`, `account_presence`). |

---

## Status: tested in parts, never run as two worlds

**No two worlds have ever run side by side.** The pieces below have been exercised one at a time,
against one database. Read this document as a checked design, not as a procedure a live
multi-world deployment has followed.

### What has been verified

| Verified | How |
| --- | --- |
| The shipped auth-schema SQL works on **MySQL 8.0.46** | Gate G, three runs on 2026-09-16 against throwaway schemas provisioned by `auth_schema.sql`. The last two ran the shipped `harness/auth_schema_gate.sql`. |
| **O1** — the per-world views are insertable and updatable | Gate: all views `IS_UPDATABLE = YES`; `INSERT` and `UPDATE` issued unqualified from the world schema land in the auth base tables. |
| **O2** — cross-schema foreign keys | Gate: created, enforced (an orphan insert fails with `ERROR 1452`), and `ON DELETE CASCADE` works across schemas. |
| The ban SQL | Gate: insert through the view; the guarded delete removes 1 row and 0 when resent, so history is written once. |
| The presence SQL, including the takeover race | Gate: one claim wins and a competing claim gets 0 rows; wrong-token takeover 0, right token 1; expired holder, holder with no heartbeat row, and holder that is this world are all taken over; a takeover with the correct token but a **fresh** holder heartbeat changes 0 rows. Isolation recorded as `REPEATABLE-READ`. |
| `ALTER` on a hoisted table is refused by the server | Gate: `ERROR 1347 ... is not BASE TABLE`. |
| Migration 7 (database version 8) | A live boot against a real database ran it. |
| Account bans end to end | Live: an active ban refused the login and named its issuer; an expired ban let the login through and left exactly one history row. |
| Presence and registry logic | 59 unit tests in `tests/` (33 in `test_presence.cpp`). They cover pure logic only — no database. |

### What has not

| Not verified | Why it matters |
| --- | --- |
| **Two worlds running side by side** | Nothing multi-world has happened on more than one process: not the cross-world character list, not a ban issued on one world and enforced on another, not two worlds sweeping the same expired ban. |
| **Cross-world presence, live** | The presence SQL passed the gate and the logic passed unit tests, but no account has been refused on world B while online on world A, no world has been killed and taken over, and no stall has kicked a player. The 10 s / 45 s timings are derived, not measured. |
| **A real 15.25 client on the login port** | No capture of a login packet exists. The field layout `ProtocolLogin::onRecvFirstMessage` skips is inferred from the *game* packet. If it is wrong, every login fails with "Invalid authentication token." Settle it with `harness/capture_proxy.py` between a real client and port 7171, decoded with `harness/packet_diff.py --decode`. |

`harness/login_client.py` drives the login port, but it is built on the same guessed layout (its
`--pre-rsa-bytes` and `--framing` options exist for exactly that reason), so it cannot settle the
wire question.

The cross-schema foreign keys in section 4 of `auth_schema.sql` passed the gate but have never been
applied to a real world schema.

---

## One directory per world

Every world runs from its own working directory, because the process reads almost everything by
relative path:

| Read | Path | Source |
| --- | --- | --- |
| Configuration | `config/*.toml` | literal relative paths in `src/configmanager.cpp` |
| World list | `config/worlds.toml` | `src/world.cpp:21` |
| RSA key | `key.pem` | `src/otserv.cpp:540` |
| Map | `data/world/<map_name>.otbm` | `src/game.cpp:248` |
| Assets | `data/items/assets.dat`, `data/items/appearances.dat` | `[world]` keys in `config/server.toml` |

So a world is a directory containing the binary, `config/`, `data/` and `key.pem`, and it is started
from inside that directory. Two worlds sharing one directory would share one `config/server.toml`
and therefore be the same world.

**Never run two processes with the same `[world].id`, even on different hosts.** When presence
starts, a world deletes every presence claim naming its own id (`Presence::Start`). A successful
listener bind is what proves no other process is that world, and a bind only proves it for one host.

What differs between those directories is small:

| File | Per world | Notes |
| --- | --- | --- |
| `config/worlds.toml` | **byte-identical everywhere** | see below |
| `config/server.toml` | `[world].id`, `[network].game_port_modern`, `[network].login_port`, and `[network].ip` where hosts differ | everything else can be identical, and two keys **must** be — see [Settings that must agree](#settings-that-must-agree-on-every-world) |
| `config/database.toml` | `[mysql].database` differs; `[mysql].auth_database` identical | |
| `key.pem` | its own copy | the content may be the same file copied N times |
| `data/` | identical | the map and datapack are the same world content unless you intend otherwise |

---

## `config/worlds.toml` — the same bytes on every world

`config/worlds.toml` is the world list. Deploy the **same file** to every world directory.

That is what makes the world list identical from every world, and it is why any world can serve the
list: `ProtocolLogin::getCharacterList` writes one entry per registry row, in registry order, taking
each world's advertised `address` and `port` from that world's own row rather than from the serving
process's configuration (`src/protocollogin.cpp`). A world can only advertise another world
correctly if it was handed the same list. The same list is also where a presence refusal gets the
name of the world an account is already online on.

A row is:

| Field | Meaning | Validation |
| --- | --- | --- |
| `id` | the world-id byte on the wire | 0–255, unique across the file |
| `name` | exactly what the client is told the world is called, and what it echoes back on the game connection | non-empty, unique across the file (whitespace-trimmed) |
| `address` | what the client dials for that world's game server | non-empty; must equal that world's `[network].ip` |
| `port` | what the client dials | 1–65535; must equal that world's `[network].game_port_modern` |
| `schema` | that world's MySQL database | non-empty; must equal that world's `[mysql].database` |

`name` is **not** `[identity].name` from `config/server.toml`. `[identity].name` ships as
`"Black Tek"` while the shipped world row is `"BlackTek"`; nothing cross-checks them, and only the
`worlds.toml` name reaches the client.

Deleting `config/worlds.toml` is supported and means single-world: the process synthesises one row
from its own configuration (`[identity].name`, `[network].ip`, `[network].game_port_modern`,
`[mysql].database`) and boots as it did before the file existed. That is the fallback, not the
multi-world path.

---

## `config/server.toml` — what each world changes

```toml
[world]
id = 0                      # this process's row in config/worlds.toml

[network]
ip               = "127.0.0.1"   # must equal this world's worlds.toml address
game_port_modern = 7183          # must equal this world's worlds.toml port
login_port       = 7171          # exactly one world in the deployment; 0 on the rest
status_port      = 7184          # must not be 7171
```

### The refusals

At boot the registry finds this process's row by `[world].id` and cross-checks it against the rest
of this process's configuration. Any disagreement stops the boot — it never degrades into a
running server that advertises the wrong address. Read from `src/world.cpp` and `src/otserv.cpp`:

| Condition | What the refusal means |
| --- | --- |
| `[world].id` is outside 0–255 | The id is a single wire byte. Nothing else was checked yet. |
| `config/worlds.toml` could not be parsed | TOML syntax error; the parser's own description is logged first. |
| The file declares no `[[world]]` entries | An empty or missing `[[world]]` array. Delete the file entirely if you want single-world. |
| A `[[world]]` entry is missing a required field | One of `id`, `name`, `address`, `port`, `schema` is absent, empty after trimming, or out of range (`id` 0–255, `port` 1–65535). |
| Two `[[world]]` entries share the same id | Two worlds would claim the same wire byte, so characters could not be attributed. |
| Two `[[world]]` entries share the same name | The wrong-world check matches by name, so two worlds with one name cannot be told apart. Names compare case-insensitively after trimming. |
| No `[[world]]` entry matches this process's `[world].id` | This process cannot prove which world it is. Usually a copied `server.toml` whose `[world].id` was never changed, or a `worlds.toml` that was never updated for the new world. |
| This world's declared address does not match `[network].ip` | The registry would tell clients to dial an address this process does not bind. Compared exactly after trimming — `localhost` and `127.0.0.1` are a mismatch. |
| This world's declared port does not match `[network].game_port_modern` | Same, for the port. Note it is `game_port_modern` that is checked, not `game_port`. |
| This world's declared schema does not match `[mysql].database` | This process would serve characters out of a database the list attributes to some other world. |

Two more refusals come from the listener wiring rather than the registry:

| Condition | What the refusal means |
| --- | --- |
| `game_port` and `game_port_modern` are both non-zero | Two protocol generations at once is not supported; set `game_port = 0`. |
| `login_port` is non-zero and equals `status_port`, `game_port` or `game_port_modern` | A port collision. `ServiceManager::add` would otherwise only print and silently disable one of the two listeners, and which one depends on registration order. |

`status_port == game_port_modern` is **not** checked. That collision still silently disables a
listener.

The database-side refusals, including the phase-2 ones, are listed under
[Every boot refusal from the shared auth schema](#every-boot-refusal-from-the-shared-auth-schema).

---

## Settings that must agree on every world

| Key | Default | Must be |
| --- | --- | --- |
| `[accounts].one_player_per_account` | `true` | the same on every world |
| `[network].allow_clones` | `false` | the same on every world |

A login takes part in the deployment-wide one-session rule only when, on the world it arrives at,
`one_player_per_account = true` **and** `allow_clones = false` (`src/protocolgame.cpp`, the
`singleSession` flag). A world where either is not so **neither claims nor checks**: its logins
write no presence row and read none.

That does not only relax that one world. An account online on the lax world is invisible to every
strict world, which will let the same account in. An account online on a strict world can still log
in on the lax world, which does not look. The rule is silently weakened for the whole deployment.

**Nothing in the server can detect this.** Each process reads only its own `config/server.toml`,
and no world ever sees another world's settings. The check is yours to make and to keep making,
exactly like the webservice settings further down.

---

## `config/database.toml`

```toml
[mysql]
host          = "127.0.0.1"
port          = 3307
user          = "forgottenserver"
pass          = "..."
database      = "blacktek_world_0"   # differs per world
auth_database = "arkot_auth"         # identical on every world
```

`[mysql].database` is this world's schema and must equal its `worlds.toml` `schema`.

`[mysql].auth_database` is the shared auth schema and must be the same string on every world. It
ships **empty**, which means single world: no auth schema, no views, no shared-auth boot probe, and
no cross-world presence. Setting it (to something other than `database`, compared
case-insensitively) is what turns on the shared-account probe, the one-session rule across worlds,
and the presence heartbeat. A multi-world deployment must set it.

**Clearing it on a world whose account tables are already views does not make that world
single-world.** It boots — the views still resolve into the auth schema — but it no longer claims or
checks presence, which weakens the one-session rule for every world the same way `allow_clones`
does, and nothing reports it. The only time to boot a provisioned world with `auth_database` empty
is the one migration boot in [Upgrading a phase-1 deployment](#upgrading-a-phase-1-deployment).

---

## `key.pem`

Loaded as the literal relative path `key.pem` from the working directory, before the database
connection is opened. Each world directory needs its own copy of the file. The *content* may be the
same key on every world — nothing ties a key to a world — but a directory without the file refuses
to boot with the loader's own error.

---

## Ports

| Port | Listener | Key |
| --- | --- | --- |
| 7171 | in-binary login | `[network].login_port` |
| this world's game port | modern game (13.40+) | `[network].game_port_modern` |
| this world's status port | status / server info | `[network].status_port` |

Defaults matter here, because a key omitted from `server.toml` is not a disabled listener:

| Key | Default when the key is absent |
| --- | --- |
| `login_port` | 7171 |
| `game_port` | 7172 |
| `game_port_modern` | 7173 |
| `status_port` | **7171** |

So a `server.toml` with no `status_port` collides with the login port and the boot is refused. The
shipped file sets `status_port = 7184`.

With `auth_database` set, a world must also bind at least one game or login listener
(`game_port`, `game_port_modern` or `login_port`). The status port does not count. See the refusal
table below.

### 7171 is a client-side constant

A 15.25 client only speaks to an in-binary login server on port **7171**. On any other port it
sends the login to HTTP login instead. The port cannot be moved, renegotiated or advertised
elsewhere, so **anything colliding with 7171 has to be the thing that moves.** That is why the boot
refuses on a collision rather than logging it: the fixable side is always the other listener.

### One login listener for the whole deployment

Because 7171 cannot vary, N worlds on one host cannot each run a login listener — they would all try
to bind the same port on the same address.

The recommended arrangement is **one login listener for the entire deployment**:

- exactly one world sets `login_port = 7171`,
- every other world sets `login_port = 0`.

This is safe because the world list is identical everywhere by construction: `config/worlds.toml`
is deployed byte-identical, so the list the login-serving world hands the client is the same list
any other world would have handed it. The login-serving world is not special in any other way — it
holds no extra state, and the character list it builds is read live from every world's schema on the
shared MySQL instance, not from its own process.

**Failover is flipping that one key.** Set `login_port = 0` on the world that has it, set
`login_port = 7171` on another, restart both. Nothing else changes, and no world list has to be
edited.

The alternative, if you want a login listener per world, is to give each world its own address:
set `bind_only_global_address = true` and a distinct `[network].ip` per world. With that flag every
listener binds `[network].ip` instead of `0.0.0.0`, so two worlds on separate addresses can each
hold 7171. Note that `[network].ip` is also what the registry checks against the world's
`worlds.toml` `address`, so the row has to name the same address — which it should anyway.

---

## MySQL

### The server is MySQL 8.0

The deployment database is **MySQL 8.0** — the `blacktek-db` container runs `mysql:8.0`, and every
result in this document was taken on 8.0.46. It is not MariaDB, whatever `docker-compose.yaml`
still says. Two facts about it have already mattered to this project:

- **Unsigned arithmetic below zero is an error.** Adding a negative value to an `UNSIGNED` column,
  when the result would go below zero, raises `ERROR 1690`; it does not evaluate as signed. The
  store's coin guard casts to `SIGNED` for this reason. Anyone writing SQL against these tables must
  do the same.
- **The design assumes the default `REPEATABLE-READ` isolation.** The presence takeover re-checks
  the holder world's heartbeat inside its `UPDATE`, and it is that locking read under
  `REPEATABLE-READ` that serialises a takeover against the holder world's recovering heartbeat. The
  server never sets an isolation level itself. The gate records `@@GLOBAL.transaction_isolation`;
  do not change it.

Gate results only hold for the server version they were taken on — see [The gate](#the-gate).

### One instance

**Every world's schema must live on one MySQL instance.** This is not a preference. The
cross-world character list is a single connection that schema-qualifies each world's `players`
table — one `COUNT(*)` plus one `SELECT name` per world, per login — and the shared auth schema is
reached through per-world views on that same connection. Split the worlds across instances and the
design stops working.

All presence staleness is judged with the database's `UNIX_TIMESTAMP()`, never a process clock, so
world hosts with drifting clocks still agree. That, too, depends on one instance.

### Grants

The MySQL user must hold `SELECT` on **every** world's schema, not just its own:

```sql
GRANT SELECT ON `blacktek_world_0`.* TO '<user>'@'%';
GRANT SELECT ON `blacktek_world_1`.* TO '<user>'@'%';   -- ... and so on
```

and, because the views are created `SQL SECURITY INVOKER`, and presence writes the auth schema
directly, on the auth schema in its own right:

```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON `arkot_auth`.* TO '<user>'@'%';
```

A world that lacks the `SELECT` on some other world's schema still boots and still serves its own
players. It **warns per world that fails**, at boot and again at each login, and that world's
characters are simply missing from the list:

```
cannot read `blacktek_world_1`.`players` for world 'BlackTek-Hardcore' (id 1);
that world's characters will be missing from the character list.
Grant this MySQL user SELECT on that schema.
```

One unreachable world never stops another world from serving. That is deliberate — the queries are
issued one per world rather than as a single `UNION`, so a failure costs one world's characters
instead of the whole list.

### What is shared and what stays per world

| Table | Where it lives | Notes |
| --- | --- | --- |
| `accounts`, `account_sessions`, `store_history` | auth schema, behind a same-named view in each world | phase 1 |
| `account_bans`, `account_ban_history` | auth schema, behind a same-named view in each world | phase 2 — see [Account-wide bans](#account-wide-bans) |
| `world_presence`, `account_presence` | auth schema **only**, no view | phase 2 — the server names the auth schema directly |
| `account_storage` | each world | saved as an unfiltered `DELETE` plus reinsert from one process's memory; shared, one world's save would delete every other world's rows |
| `account_viplist` | each world | **must never be hoisted** — see below |
| `ip_bans` | each world | an IP ban on one world does not bar another |

`account_viplist` stores character ids of *its own* world, written from a name resolved on that
world and read back with names from that world's `players`. Hoisted, world A's ids would be loaded
on world B and silently show whichever unrelated world-B characters happen to hold those ids. It
stays per world, with its per-world foreign key on `player_id`.

Consequences players will notice: account storage is per world, a VIP list is per world, and an IP
ban is per world — but an account ban is everywhere.

### `auth_schema.sql`

The file has five sections. Only sections 1 and 3 run as shipped; 2 and 4 are commented out.

| Section | What it does | Runs |
| --- | --- | --- |
| 1 | Creates the auth schema and its seven base tables: the five hoisted tables plus `world_presence` and `account_presence`. `IF NOT EXISTS`; a no-op after the first world. | yes |
| 2 | One-time hoist of a world's existing rows, and the `DROP TABLE`s that free the names for views. 2a accounts/sessions/store history, 2b bans, 2c the foreign keys that point at the world's local `accounts`, 2d the drops. Destroys data. | commented out |
| 3 | `CREATE OR REPLACE` the five per-world views. Re-runnable. | yes |
| 4 | Cross-schema foreign keys from the world's `players`, `account_storage` and `account_viplist` back to the auth `accounts`. Depends on section 2. | commented out |
| 5 | Comments only: the exact queries the boot probes issue, so you can run them yourself. | — |

Run it **once per world**, with that world's schema substituted. The file runs top to bottom in one
invocation, so whatever you uncomment in section 2 runs after section 1 and before section 3:

```bash
sed -e 's/__AUTH_SCHEMA__/arkot_auth/g' \
    -e 's/__WORLD_SCHEMA__/blacktek_world_0/g' \
    auth_schema.sql | mysql -h 127.0.0.1 -P 3307 -u root -p
```

`__AUTH_SCHEMA__` must equal `[mysql].auth_database`; `__WORLD_SCHEMA__` must equal that world's
`[mysql].database`.

Read section 2's notes before uncommenting anything, and take a `mysqldump` first. For a brand-new
world imported from `schema.sql`, uncomment **2c and 2d**: a fresh schema still owns real
`accounts`, `account_sessions`, `store_history`, `account_bans` and `account_ban_history` tables, and
a view cannot take a name a base table holds. Run as shipped against such a schema, the file stops
with an error at section 3 — the loud, safe outcome. An existing, populated world needs more; for a
phase-1 world see [Upgrading a phase-1 deployment](#upgrading-a-phase-1-deployment).

### The migration rule

**A world process must never `ALTER` a hoisted table.** In a world schema the five hoisted names
are views, and MySQL 8.0 refuses an `ALTER` on a view outright with `ERROR 1347`. The auth schema is
provisioned out of band, by `auth_schema.sql` alone.

Migrations that touch a hoisted name guard on `information_schema`. The one phase-2 migration,
`data/migrations/7.lua` (it moves the database to version 8), checks each ban table's
`TABLE_TYPE`:

| The world's ban table is | Migration 7 does |
| --- | --- |
| a base table | adds `banned_by_name` if missing, backfills it from this world's `players` where it is empty, and drops every foreign key from the table to `players` |
| a view that has `banned_by_name` | nothing, and succeeds |
| a view without `banned_by_name` | prints ``> `account_bans` is a view without `banned_by_name`: re-run section 3 of auth_schema.sql for this world, then restart`` and stops |
| missing | prints ``> `account_bans` does not exist in this schema; cannot add `banned_by_name` `` and stops |

A migration that stops leaves the database version where it was; boot then continues to the ban
column check below, which refuses.

After any change to an auth base table, re-run section 3 for **every** world: a `SELECT *` view
freezes its column list at creation time and keeps serving the old columns.

### Every boot refusal from the shared auth schema

In boot order. The first group runs only with `auth_database` set, and **before** any migration.

| Condition | Message begins | Meaning and fix |
| --- | --- | --- |
| `accounts` cannot be read from this world's schema | `` Shared auth schema: `accounts` cannot be read from schema ... `` | Run `auth_schema.sql` for this world. |
| Any of the five hoisted names is not a view in this world's schema | `Shared auth schema: schema '<world>' has no view for <names>. This world was never provisioned against auth schema ...` | For a fresh world, run `auth_schema.sql` with 2c/2d. **A phase-1 world names `account_bans, account_ban_history` here** — "never provisioned" is misleading in that case; follow [Upgrading a phase-1 deployment](#upgrading-a-phase-1-deployment). |
| Any of the five is not a base table in the auth schema | `Shared auth schema: auth schema '<auth>' has no base table for <names>. Run section 1 of auth_schema.sql.` | Run section 1. |
| **Missing presence tables:** `world_presence` or `account_presence` is not a base table in the auth schema | `Shared auth schema: auth schema '<auth>' has no base table for <names>, which cross-world login presence needs.` | Run section 1 against the auth schema. |
| **An auth ban base table lacks `banned_by_name`** | `` Shared auth schema: base table <names> in auth schema '<auth>' has no `banned_by_name` column ... `` | The table predates the column. Section 1 will not add it (`IF NOT EXISTS`); add it by hand as section 1 defines it — ``ALTER TABLE `arkot_auth`.`account_bans` ADD COLUMN `banned_by_name` varchar(255) NOT NULL DEFAULT '' AFTER `banned_by` `` (and the same for `account_ban_history`) — then re-run section 3 for **every** world. |
| **A world ban view lacks `banned_by_name`** | `` Shared auth schema: view <names> in schema '<world>' has no `banned_by_name` column - it was created before the column existed ... `` | Re-run section 3 for that world. |

The three refusals that offer clearing `auth_database` as a remedy say when it applies: only when
this world's account tables are genuinely base tables.

Two checks in this group only warn: a view whose stored definition does not name the auth schema
(also empty without `SHOW VIEW`), and each registry world's `<schema>.players` being unreadable.

Then, on **every install, whatever `auth_database` says**, after migrations have run:

| Condition | Message begins | Meaning and fix |
| --- | --- | --- |
| **`banned_by_name` missing after migration**: this world's `account_bans` or `account_ban_history` — base table or view — lacks the column | `` Ban check: <names> in schema '<world>' has no `banned_by_name` column, so ban checks would fail and let banned accounts log in. `` | A failed ban query reads as "not banned", so this refuses rather than admit every banned account. If the names are views: re-run section 3 for this world, and if `auth_database` was cleared the message also tells you to set it back. If they are base tables: migration 7 did not finish — read its output above the refusal, fix the cause, restart. |

Then, after every listener has bound, only with `auth_database` set:

| Condition | Message begins | Meaning and fix |
| --- | --- | --- |
| **Presence enabled with no game or login listener bound** | `Cross-world presence: no game or login listener is bound, so nothing proves this is the only process serving this world ...` | Starting presence deletes this world's leftover claims, which is only safe once a bind has proven no other process serves this world. The status port does not count. Give `game_port_modern` or `game_port` a nonzero port, or clear `auth_database` if the world is genuinely single-world. |
| Presence could not start | `World::Presence::Start: ...` | `the auth schema name ... contains a backtick` — rename the schema. `could not clear world N's leftover claims` or `could not write world N's heartbeat` — check the auth-schema grants above and that the database is reachable. |

Every refusal in the listener group takes the already-bound listeners down with it.

---

## Upgrading a phase-1 deployment

**This order matters.** A phase-1 world cannot simply be started on the phase-2 build with
`auth_database` set. The boot probe now requires `account_bans` and `account_ban_history` to be
views, and on a phase-1 world they are still per-world base tables, without `banned_by_name`, with
foreign keys to that world's `players`.

Before you start: stop **every** world, and take a `mysqldump` of the auth schema and of every world
schema. Deploy the phase-2 build **and its `data/`** to every world directory — migration 7 lives in
`data/migrations/7.lua`, and the phase-1 file of that name does nothing.

### 1. Migrate each world with `auth_database` empty

On each world, set `[mysql].auth_database = ""` and start it once.

With the setting empty the shared-auth probe is skipped, so nothing refuses before migrations run.
A phase-1 world is at database version 7, so migration 7 runs against the world's own **base** ban
tables: it adds `banned_by_name`, backfills it from this world's `players`, and drops the foreign
keys to `players`. Expect:

```
> Updating database to version 8 : Ban issuer names (banned_by_name)
> Database has been updated to version 8.
```

The ban column check then passes, and the boot sweep retires any bans that have expired.

This is a full boot — there is no migrate-only mode. It runs without presence, so keep players off
it, and shut it down cleanly once it is up. Do not leave any world running like this.

### 2. Hoist the bans with section 2

For each world in turn, edit a copy of `auth_schema.sql`:

- uncomment **2b-i** (both statements — the variant for a world that already has `banned_by_name`),
- uncomment the **two ban-table lines of 2d** (`DROP TABLE ... account_bans`,
  `DROP TABLE ... account_ban_history`),
- leave 2a, 2b-ii, 2c and the other 2d lines commented: phase 1 already did them.

If more than one world has ban rows, first run the conflict query in 2b's notes for the world you are
about to move. `account_bans` holds one ban per account, and `INSERT IGNORE` keeps the ban already in
the auth schema and silently skips this world's. Resolve any rows it lists by hand.

### 3. Re-run section 3 for the views

Run the edited file through the usual `sed | mysql` pipeline for that world. Because the file runs
top to bottom, that single invocation is steps 2 and 3 together:

1. section 1 creates the auth `account_bans`, `account_ban_history`, `world_presence` and
   `account_presence` (a no-op after the first world),
2. section 2 copies this world's bans into the auth schema and drops the world's ban tables,
3. section 3 recreates all five views, the two new ban views included.

If you run section 2's statements by hand instead, run section 1 before them and section 3 after.

### 4. Set `auth_database` and boot

On every world, set `[mysql].auth_database` back to the shared schema, then start the worlds. The
probe finds five views, seven base tables and `banned_by_name` on both layers. Database version is
already 8, so no migration runs.

### What goes wrong if you skip or reorder a step

| Mistake | What happens |
| --- | --- |
| **Skip everything:** start a phase-1 world with `auth_database` set | Refused before migrations, nothing written: `Shared auth schema: schema '<world>' has no view for account_bans, account_ban_history. This world was never provisioned ...` Do not clear `auth_database` to get past it except for step 1. |
| **Skip step 1**, then run step 2 with 2b-i | 2b-i reads `banned_by_name` from a world table that does not have it yet. The `mysql` client stops at that first error: section 1's tables were created (harmless), no ban was copied, nothing was dropped, and section 3 never ran. Boot with `auth_database` set is still refused as above. Do step 1, then repeat step 2. |
| **Skip step 2:** run `auth_schema.sql` as shipped | Section 3 refreshes the three account views, then stops at `account_bans`, because a base table still holds that name. Boot with `auth_database` set is refused naming `account_bans, account_ban_history`. |
| **Skip step 3:** run section 2's drops by hand without recreating the views | The world schema now has no `account_bans` at all. With `auth_database` set: the same "no view for" refusal. With it empty: migration 7 already ran, so nothing adds anything, and the `` Ban check: ... has no `banned_by_name` column `` refusal stops the boot. Run section 3 for that world. |
| **Skip step 4:** leave `auth_database` empty and play | **Nothing refuses.** The views have the column, so every check passes, and the world serves logins with shared accounts and shared bans but **no presence**: it neither claims nor checks, and the one-session rule is silently weakened for every world. |
| Leave any world on the phase-1 build | A phase-1 build has no presence code, so it neither claims nor checks — the same silent weakening. Upgrade every world in one window. |

The reverse of steps 1 and 2 also works, and `auth_schema.sql` says so: hoist first with **2b-ii**,
which backfills `banned_by_name` from the world's `players` the same way, and migration 7 later finds
views that already have the column and succeeds without altering anything. This document follows the
order `auth_schema.sql` recommends — migrate first, then move the bans.

---

## Account-wide bans

`account_bans` and `account_ban_history` live in the auth schema behind per-world views, exactly
like `accounts`. A ban issued on any world bars that account on every world.

| | |
| --- | --- |
| Issuer | Each ban row stores `banned_by_name`, the issuer's character name frozen at ban time. That is what the refusal shows. `banned_by` is still written for compatibility, but it is a character id on whichever world issued the ban, and nothing resolves it. |
| Issuing | `/ban` still resolves the account by a character name **on the GM's own world**. A GM cannot name a character that only exists on another world. |
| Online elsewhere | `/ban` only kicks a target who is online on the GM's world. A banned player online on another world is **not kicked**; the ban applies at their next login. |
| `/unban` | Also resolves the name on the GM's own world. Its account-ban delete goes through the view, so it lifts the ban everywhere; its `ip_bans` delete only clears this world's. |
| Expiry | Checked at login and swept once at every boot. The delete is guarded on the exact ban, and only the caller whose delete removed the row writes history, so worlds noticing the same expiry at once still write one history row. |
| Deleting a GM | No longer deletes the bans that GM issued. Migration 7 dropped the foreign key to `players` whose `ON DELETE CASCADE` used to do that. |
| Exemption | `PlayerFlag_CannotBeBanned` comes from each world's own `config/groups.toml`. |

The refusal a banned player sees names the issuer:

```
Your account has been banned until <date> by <issuer>.

Reason specified:
<reason>
```

or `Your account has been permanently banned by <issuer>.` for a ban with no expiry.

---

## One session per account

With `auth_database` set, an account may be online on **one world of the deployment at a time**.

### Who the rule applies to

A login is held to the rule when all of these are true on the world it arrives at
(`src/protocolgame.cpp`):

- `[accounts].one_player_per_account = true`,
- `[network].allow_clones = false`,
- the character is not the Account Manager,
- the account type is below Gamemaster (`IsSingleSessionExempt`: `accounts.type` ≥ 4 — Gamemaster,
  Community Manager, God — is exempt). Account type is account-level and shared, so the exemption is
  the same on every world. Group access, such as Tutor, does not exempt.

An exempt login writes no presence row and is not checked against one.

### What a player sees

The local check comes first. If the account is already online **on this world**:

```
You may only login with one character
of your account at the same time.
```

Then the ban check. Then, if the account is online **on another world**:

```
Your account is already online on <world> as <character>.
Log out there first, then try again.
```

`<world>` is the name from `config/worlds.toml`, or `another world` if that id is not in this world's
list.

If the check itself cannot run — the claim query fails, or three attempts do not settle it:

```
Your login could not be checked right now.
Please try again in a moment.
```

**Presence fails closed.** A database that cannot answer refuses logins; it never lets them through
unchecked.

The claim is taken before the login queue, so a player refused by presence does not lose a queue
place. A logging-out player's claim is released only after their character is saved, so another
world never loads that account's state before it is written.

### How presence works

Two tables in the auth schema, no views:

| Table | Row | Written |
| --- | --- | --- |
| `world_presence` | one per running world: `world_id`, `beat_at` | every heartbeat |
| `account_presence` | one per claimed account: world, character, a random `claim_token` | at login; deleted at logout |

The timings are constants in `src/presence.h`:

| Constant | Value | Meaning |
| --- | --- | --- |
| `Presence::BeatInterval` | **10 s** | how often a world writes its heartbeat |
| `Presence::Lease` | **45 s** | how old a world's last heartbeat must be before its claims count as abandoned |

The lease is longer than the database connection's 30 s read/write timeout plus one interval, so one
timed-out heartbeat does not expire a live world. The values are derived, not measured.

A claim held by another world is taken over when that world's heartbeat is more than 45 s old by the
database's clock, or it has no heartbeat row. A claim naming *this* world for an account not online
here is leftover and taken over at once.

| Event | What happens |
| --- | --- |
| Clean shutdown | After kicking every player, the world deletes all its claims and its heartbeat row. Its accounts are free immediately. |
| **World crashes and stays down** | Its claims stay in the table. Once its last heartbeat is more than 45 s old, another world takes a claim over at that account's next login. Until then, those accounts are refused elsewhere with "already online on <crashed world>" — up to about 45 s after the crash. |
| **World crashes and restarts** | Once its listeners have bound, the restarted world deletes every claim naming its own id and writes a fresh heartbeat. Its accounts are free from that moment, on every world. |
| Two worlds log the same account in at once | The primary key lets exactly one claim land; the other login is refused naming the winner. |
| Two worlds take over the same abandoned claim | The token comparison lets exactly one win. |

### A stall can kick players

The heartbeat runs on the dispatcher, on purpose: a world that cannot write to the database, or
whose dispatcher is stuck, **should** lose its claims. So:

1. World A stalls — a database outage, a hung query, a dispatcher blocked — for longer than the lease.
2. Its heartbeat goes stale; world B takes over the claim of an account that is still in A's world,
   and admits the login. For a while the account is in two worlds.
3. When A's heartbeat lands again, A sees the stall, reads its remaining claims, and kicks every
   player whose claim is gone. Each one is sent:

```
Your account logged in on another world while this world was unreachable.
```

A logs `World::Presence::Reconcile: world <id> stalled past its lease; kicked <n> player(s) whose
claims were taken over.` on every such check, including when `n` is 0. A reconcile runs when the
heartbeat was at least 35 s old (`Lease - BeatInterval`), so it can run and kick nobody. If A cannot
read its claims it kicks nobody and tries again on the next landed heartbeat.

Heartbeat failures are logged as warnings (`World::Presence::Beat: world <id>'s heartbeat failed
...`). Repeated ones are the early sign that kicks are coming.

---

## The gate

`harness/auth_schema_gate.sql` proves, statement by statement on the MySQL server it is run against,
that what `auth_schema.sql` ships works the way a world process uses it: O1, the coin guard, the ban
SQL, the presence SQL including every takeover case, O2, and the two expected errors.

**Re-run it whenever `auth_schema.sql` changes or the MySQL version moves**, and before a real
multi-world deployment. Its results only hold for the version its first check (`G0`) prints.

Run it against **throwaway schemas** only. It writes into the shipped tables and removes its rows
again, and it reserves world ids 254 and 255 in `world_presence`. Provision the two scratch schemas
with sections 1 and 3 of `auth_schema.sql` first. The user needs `CREATE`, `DROP`, `ALTER`,
`REFERENCES`, `SELECT`, `INSERT`, `UPDATE`, `DELETE` on the world scratch schema and `REFERENCES`
plus DML on the auth scratch schema; the header lists exactly why.

It runs in two passes, selected by marker lines in the file:

```bash
# Pass 1 -- every check except the expected errors, strict
sed -e 's/__AUTH_SCHEMA__/gate_auth/g' \
    -e 's/__WORLD_SCHEMA__/gate_world/g' \
    -e '/^-- >>> EXPECTED-ERRORS BEGIN/,/^-- <<< EXPECTED-ERRORS END/d' \
    harness/auth_schema_gate.sql | mysql -t -h 127.0.0.1 -P 3307 -u <user> -p

# Pass 2 -- the expected errors only, with --force
sed -n -e 's/__AUTH_SCHEMA__/gate_auth/g' \
       -e 's/__WORLD_SCHEMA__/gate_world/g' \
       -e '/^-- >>> EXPECTED-ERRORS BEGIN/,/^-- <<< EXPECTED-ERRORS END/p' \
       harness/auth_schema_gate.sql | mysql -t --force -h 127.0.0.1 -P 3307 -u <user> -p 2>&1
```

| Pass | Passes when |
| --- | --- |
| 1 | it runs to the end with no `ERROR` line, and every row's `actual` equals its `expected` |
| 2 | its output holds exactly two `ERROR` lines, `ERROR 1452` then `ERROR 1347`, and every row's `actual` equals its `expected`. Any other error code means a fixture failed and proved nothing. |

If pass 1 aborts after its pre-flight, the file's `CLEANUP` block (between the
`-- >>> CLEANUP BEGIN` and `-- <<< CLEANUP END` markers, extracted the same way as pass 2 but without
`--force`) is idempotent and removes only the gate's own objects. If pass 1 aborts **at** pre-flight
because world 254 or 255 already has a row, that row is not the gate's — do not run cleanup.

---

## If you also deploy the login webservice

The in-binary login listener on 7171 and an `opentibiabr/login-server` instance can both be live.
They are different transports on different ports and the client's configured port picks one: 7171
means in-binary, anything else means HTTP login. Nothing in the server chooses.

**If the webservice is deployed, its `SERVER_NAME`, `SERVER_IP` and `SERVER_PORT` must equal that
world's `worlds.toml` row — `name`, `address` and `port`.**

A client that logs in over HTTP takes its world name from what the webservice told it and sends that
name as the plaintext preamble on the game connection. The game protocol refuses any client
announcing a world that is not this one:

```
This is <world>. Please pick that world in your client's world list.
```

If `SERVER_NAME` and the registry `name` disagree, **every** HTTP-login player is refused. That is a
total outage for the HTTP path, not a degradation, and players logging in through 7171 are
unaffected — which makes it easy to miss. Only case and surrounding whitespace are tolerated in that
comparison.

**Nothing in the server can verify this.** The registry proves that a world's row agrees with its
own process; it has no knowledge of the webservice's environment at all. The check is yours to make
and to keep making.

A `SERVER_IP`/`SERVER_PORT` mismatch is less dramatic: HTTP players dial whatever the webservice
says, in-binary players dial the registry row, and they end up on different servers or on nothing.

Whether the webservice reads or writes `account_bans` is unknown — its source is not in this
repository. The ban views keep the table names and every old column, and the new column defaults to
`''`.

---

## Worked example: two new worlds on one host

`config/worlds.toml`, identical in both directories:

```toml
[[world]]
id      = 0
name    = "BlackTek"
address = "127.0.0.1"
port    = 7183
schema  = "blacktek_world_0"

[[world]]
id      = 1
name    = "BlackTek-Hardcore"
address = "127.0.0.1"
port    = 7283
schema  = "blacktek_world_1"
```

| | `/srv/world0` | `/srv/world1` |
| --- | --- | --- |
| `[world].id` | `0` | `1` |
| `[network].ip` | `127.0.0.1` | `127.0.0.1` |
| `[network].game_port_modern` | `7183` | `7283` |
| `[network].status_port` | `7184` | `7284` |
| `[network].login_port` | `7171` | `0` |
| `[accounts].one_player_per_account` | `true` | `true` |
| `[network].allow_clones` | `false` | `false` |
| `[mysql].database` | `blacktek_world_0` | `blacktek_world_1` |
| `[mysql].auth_database` | `arkot_auth` | `arkot_auth` |
| `key.pem` | its own copy | its own copy |

Provisioning, once, with both world schemas freshly imported from `schema.sql` and sections 2c and 2d
of a copy of `auth_schema.sql` uncommented (named `auth_schema.new-world.sql` here):

```bash
sed -e 's/__AUTH_SCHEMA__/arkot_auth/g' -e 's/__WORLD_SCHEMA__/blacktek_world_0/g' \
    auth_schema.new-world.sql | mysql -h 127.0.0.1 -P 3307 -u root -p
sed -e 's/__AUTH_SCHEMA__/arkot_auth/g' -e 's/__WORLD_SCHEMA__/blacktek_world_1/g' \
    auth_schema.new-world.sql | mysql -h 127.0.0.1 -P 3307 -u root -p
```

Then start each world from its own directory. On first boot each runs every migration; migration 7
finds ban views that already carry `banned_by_name` and changes nothing. World 0 holds the only login
listener; a client pointed at `127.0.0.1:7171` sees both worlds and, under each, only that world's
characters, and an account online on one is refused on the other.

For existing phase-1 worlds, use [Upgrading a phase-1 deployment](#upgrading-a-phase-1-deployment)
instead.

---

## Limits and costs

| | |
| --- | --- |
| Worlds on the wire | 255. The registry allows 256 ids; the 256th is clamped off the list with a warning. |
| Characters in the list | 255, across all worlds combined, clamped with a warning. |
| Queries per login, character list | Two per world — one `COUNT(*)`, one `SELECT name` — on the one connection. This number has never been measured under load. |
| Queries per game login, presence | One `INSERT IGNORE` when the account is free. A contested claim adds a lookup and possibly a takeover `UPDATE`, up to three attempts. Logout adds one `DELETE`. |
| Heartbeat | Two queries per world every 10 s (read its heartbeat age, then upsert it), regardless of player count. |
| Account Manager | With `[account_manager].enabled = true`, an "Account Manager" entry is offered once **per world**, so N worlds means N entries in the list. |

---

## Known stale elsewhere

`Dockerfile`, `docker-compose.yaml` and the port line in `README.md` predate this work and are not
updated by it — the compose file still maps 7171/7172/7173 and cannot serve a world, which
`README.md` already records. Do not read ports out of them. The compose file also still names a
`mariadb:latest` image; the deployment runs `mysql:8.0`.

Two more things in the tree still describe phase 1 or MariaDB:

- the comment above `auth_database` in `config/database.toml` lists only `accounts`,
  `account_sessions` and `store_history` as shared;
- the boot log prints the database client library's version under the label `MariaDB`.
