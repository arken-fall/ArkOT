# Multi-world planning brief — ArkOT

## 0. SETTLED — do not re-ask these

The owner has decided the product shape. Design to it; do not reopen it.

- **A character belongs to one world, permanently.** Created on a world, lives and dies there. No
  character transfer, ever. (This resolves D3 below: the default, "yes, Tibia's model", is chosen.)
- **Store coins are account-wide.** Coins bought once are spendable on every world.
- **What a purchase unlocks is per-character.** Outfits, mounts and the like apply to the character
  that bought them, not to the account. (Together these resolve D5 below.)
- A player may hold characters on several worlds and play them independently.

### What those decisions cost — read this before choosing D2

Account-wide coins is the decision that makes this an engine change rather than a configuration
change, because it pulls the `accounts` row across the world boundary:

- `src/databasemanager.cpp:18,41,47` treats `MYSQL_DB` as the world's identity, so "one database per
  world" is nearly free for everything character-shaped — but it forks `accounts`, and with it coins,
  once per world. That silently breaks the settled decision.
- Sharing the account row therefore requires either a shared auth schema alongside per-world schemas
  (which needs a second connection — `Database::getInstance()` is a single-instance singleton holding
  one `MYSQL*`, `src/database.h:30-34`), or one database keyed by `world_id` (which needs a predicate
  on every character-scoped query and a rework of `players.name` / `guilds.name` uniqueness).
- Whichever is chosen, `src/store.cpp:449` writes coins as an ABSOLUTE value
  (`SET coins = <n> WHERE id = ...`). With one account logged into two worlds, the second write
  destroys the first's spending. It must become a delta, the way line 367 already does for
  `coins_transferable`. Treat this as a correctness requirement of the design, not a follow-up.
- Worth the planner confirming: InnoDB supports foreign keys across schemas on the same MySQL
  instance, which would let the six `accounts(id)` FKs survive a shared-auth-schema split
  (`schema.sql:598, 702, 1092-1113, 1176`).

### The finding to design from

`src/connection.cpp:254-257`: the 15.25 client ALREADY sends a plaintext world-name preamble before
the game protocol starts. Today the server reads it, prints it, and throws it away. The wire already
carries the world identity this design needs — nothing has to be invented to get it there.

---

# PLANNING BRIEF — Multi-world (one account, N worlds) for BlackTek-Server

Repo: `/home/josh/Documents/BlackTek-Server` (C++20, BlackTek/TFS fork, 15.25-protocol only).
This brief is scouting output, not a design. Five read-only scouts produced the evidence below.
Do not accept any claim here without re-reading the cited lines.

## 1. GOAL

A player creates one account and logs in once. The client's world list shows N worlds (e.g. a
normal-PvP world and a hardcore world, or an old world and a fresh-start world). Each world has its
own characters, its own map and population, its own houses, its own economy and its own online list;
picking a world from the list routes the client to that world's game server and only that world's
characters are offered there. Some things follow the account across every world (at minimum: the
login itself; probably premium, store coins and bans), and some things deliberately do not (at
minimum: characters, houses, the market order book, guilds). A character created on world A never
appears on world B, and nothing a player does on world A can corrupt or duplicate state on world B.

## 2. ENTRY POINTS — read these first

### Login, session auth, world discovery
- `src/protocollogin.cpp:85-120` — the ONLY in-binary world list: `addByte(1); // number of worlds`
  at :103, world id 0 at :104, name/IP/port from `g_config` at :105-107; per-character wire carries
  only a name + an online byte (:111-120). Currently unreachable (`login_port = 0`).
- `src/protocolgame.cpp:452-637` — modern/legacy shared first-packet handler; generation is fixed by
  which port the connection arrived on (:466-472); one opaque credential string (:555-561); character
  name at :612. No world parameter is read anywhere.
- `src/protocolgame.cpp:639-702` — `authenticateAndLogin`: session-key path vs email/password path
  (:678-680), then `login(characterId, accountId, ...)`. Character resolved by name, scoped only by account.
- `src/iologindata.cpp:87-177` — all three auth entry points. `loginserverAuthentication` charlist query
  at :110 (`WHERE account_id = ? AND deletion = 0`), `gameworldAuthentication` :119-150,
  `sessionKeyAuthentication` :152-177 (SHA-256 lookup in `account_sessions`, optional character binding, expiry).
- `src/connection.cpp:161-181, 224-271` — the client's plaintext `"<worldName>\n"` preamble is sniffed,
  read into `Connection::modernWorldLine`, printed at :256, and discarded. The only world signal that
  already arrives on the wire.
- `harness/modern_client.py:78-92, 117-140` — the only in-repo description of the webservice contract:
  `playdata.worlds[].externaladdressunprotected/externalportunprotected`, `playdata.characters[].name`,
  session key as the RSA-block credential.
- `docker-compose.yaml:35-59` — where the host/port a modern client dials is ACTUALLY decided:
  `opentibiabr/login-server` with a single `SERVER_NAME` / `SERVER_IP` / `SERVER_PORT` (:51-53).
  Third-party image; no source in this repo.
- `src/protocolstatus.cpp:74-152` — one published identity; note it advertises `LOGIN_PORT` (:91-93, :147-152),
  which is 0 on this fork.

### Boot, config, CLI, listeners
- `src/otserv.cpp:320-646` — `mainLoader`, the entire boot order, unparameterised by world. Zones load
  at :521 *before* the map at :536; zone flags stamped at :546; listeners registered at :559-596.
- `src/otserv.cpp:559-596` — one listener set per process; hard startup refusal if `game_port` and
  `game_port_modern` are both set (:576-587), and `ProtocolGame::setSharedModernLayout(true)` at :586.
- `src/otserv.cpp:648-675` — the ENTIRE CLI: `--ip`, `--login-port`, `--game-port`. No `--config-dir`,
  no `--data-dir`, no `--game-port-modern`, no DB override.
- `src/otserv.cpp:41-56` — the process globals: `g_databaseTasks, g_dispatcher, g_utility_boss,
  g_scheduler, g_game, g_config, g_monsters, g_vocations, g_scripts, g_RSA`.
- `src/configmanager.cpp:82-149` — nine hardcoded relative `config/*.toml` paths (:84-92); the
  `if (not loaded)` block (:95-149) marks ports, MySQL credentials and `map_name` as load-once.
- `config/server.toml:3-4, 11-19, 25-55` — `[identity].name`, `[world].map_name`, `[network]`
  (`login_port = 0`, `game_port = 0`, `game_port_modern = 7183`, `status_port = 7184`),
  `[accounts].one_player_per_account`, `online_offline_charlist`.

### Runtime world state
- `src/game.h:206-856` — the Game god object. `Map map;` at :695; per-world player/monster/npc/guild maps,
  decay lists, `worldType`, `gameState`, `lightLevel`, `worldTime`, `playersRecord`, motd at :769-855.
- `src/map.cpp:17-54` — the anonymous-namespace `thread_local last_chunk_coord / last_chunk` cache at
  :22-23 (keyed only by chunk coordinate, never by Map instance) and the full per-map load chain in `loadMap`.
- `src/map.h:73-154` — Map's per-instance state; note `static clean()` (:81) and `static save()` (:83).
- `src/zones.h:530-631` — `ZoneManager` is all-static over `inline static` registries at :615-627
  (zones, spawn positions, world flag caches, triggered/staged/linked spawns, zone id counter), keyed by bare `Position`.
- `src/zones.cpp:2228-2291` — `LoadZones()` derives `data/world/<map_name>-zones` at :2230;
  `Clear()`/`Reload()` at :2271-2291 are global.
- `src/scriptmanager.cpp:16-73` and `src/script.cpp:23-30` — eight script-system singletons, one
  `g_luaEnvironment`, scripts resolved as `fs::current_path() / "data" / folderName`.

### Database and schema
- `src/database.h:15-125` — `Database::getInstance()` function-local static (:30-34), one `MYSQL* handle`
  and one `std::recursive_mutex` (:120-121); `DBTransaction`/`DBInsert` hardwired to the singleton (:190, :200, :209).
- `src/database.cpp:22-50` — `connect()` reads MYSQL_* from `g_config` at :40.
- `src/databasetasks.h:22-44` + `src/databasetasks.cpp:13` — the only second connection in the codebase.
- `src/databasemanager.cpp:14-149` — migrations: `getDatabaseVersion` (:50-68), `updateDatabase`
  (:70-120, path built at :89), `registerDatabaseConfig` (:126-149). `MYSQL_DB` is used as the world
  identity at :18, :41, :47.
- `schema.sql:35-757` — all 43 tables. `grep -i world schema.sql` returns zero hits. Key rows:
  accounts :35-51 (coins), account_viplist :100-110, guilds :114, guild_membership :170,
  houses :214-228, market_history :262, market_offers :280, players :297-330, players_online :379,
  store_history :588-599, account_sessions :695-703, server_config :711-716, tile_store :726-735, towns :737-744.
  Uniqueness/FKs: `players.name` UNIQUE :852-855; `guilds.name`/`ownerid` UNIQUE :781-783;
  `guild_membership` PK(player_id) :800; account FKs :598, :702, :1092-1113, :1176.
- `config/database.toml:1-10` — one `[mysql]` block, db `blacktek`, port 3307.

### Cross-world feature ownership
- `src/iomapserialize.cpp:13-94, 257-370` — `DELETE FROM tile_store` (:63) and `DELETE FROM house_lists`
  (:294), both unfiltered; `loadHouseItems` (:18) replays every blob at absolute x/y/z.
- `src/house.cpp:32-106, 356-411, 469-477, 523-560` — `UPDATE houses SET owner ... WHERE id` on the
  map-local house id (:36); access lists resolve by character NAME (:402-411); `payHouses` loads and
  mutates offline owners (:547-552).
- `src/iomarket.cpp:19-265` — every query unscoped: active offers :23, own offers :53, history :74,
  expiry sweep :173, offer identity `(id & 65535)` :199, global statistics GROUP BY :263;
  offline-load-mutate-save at :98-167.
- `src/game.cpp:7583-7691, 7758-7910` — market offer creation destroys real items (:7656, :7664) and
  stores itemtype+count only (:7685); acceptance re-creates items and saves an "offline" counterparty (:7803-7863).
- `src/guild.cpp:118-224` — `SELECT id, name, balance FROM guilds` unfiltered at :121, called from `src/otserv.cpp:513`.
- `src/store.cpp:340-490` — `UPDATE accounts SET coins = <absolute>` at :449 (blind overwrite, not a delta);
  transfer at :367; `store_history` writes at :455, :466, :476.
- `src/game.cpp:6798-6840` — `account_storage` read whole at :6803, saved as `DELETE FROM account_storage` (:6819) + bulk reinsert.
- `src/iologindata.cpp:22-32, 528-539, 955-1050, 1126-1130, 1450-1477, 1767-1830` — coin load, online-status
  write, bestiary/charms/prey/wheel load, VIP list by ACCOUNT id (:1126), whole-row `savePlayer` (:1477),
  wheel delete-and-reinsert (:1767-1830).
- `data/scripts/globalevents/startup.lua:1-46` — boot-time global SQL: `TRUNCATE players_online` (:5),
  market_history delete (:9), account ban sweep (:12-20), house auction settlement (:23-39),
  `TRUNCATE towns` + reinsert (:42-46).
- `src/chat.h:109-149` and `src/party.cpp:17-45` — chat channels and parties are process-memory only,
  never persisted; party ids are a per-process counter.
- `src/bestiary.cpp:176-215` and `src/prey.cpp:108-134` — race ids come from the loaded monster data
  files and are the storage key in `player_bestiary`/`player_charms`/`player_prey`.
- `src/networkopcodes.h:157-158` — `CyclopediaHouseAuction = 0xAD` and `RequestHighscores = 0xB1` are
  declared and never handled; no highscore table or query exists anywhere.

### Deployment / footprint
- `premake5.lua:37-42` — binaries emitted into the workspace root; cwd == repo root at run time.
- `Dockerfile:51-65` — `EXPOSE 7171 7172` (stale), `WORKDIR /srv`, `VOLUME /srv`, `config/` NOT copied.
- `docker-compose.yaml:11-17, 61-76` — one MariaDB, fixed host ports 7171/7172/7173, `.:/srv` bind mount.
- `src/objectpoolconfig.cpp:15-113` — `Config::Get()` runs at static-init and WRITES `config/object_pools.toml`
  into the cwd when absent (:17-19).
- `src/game.cpp:83-90` + `config/object_pools.toml:12-15` — the 512 MB arena, allocated before `main()`.
- `src/iomap.cpp:117-122` — tile buffer sized `tile_count * (sizeof(Tile) + 64)`.
- `STATUS.md:149` — the real map (13.3 M tiles) boots in 8 s at ~10 GB RSS. `data/world` is 723 MB on disk.

## 3. WHAT THE CODE ASSUMES TODAY — constraints the design must confront

**There is no world concept at all.** `grep -rn "world_id|worldId|world_name"` over `src/`, `config/`,
`schema.sql` and `data/` returns zero hits; `grep -i world schema.sql` returns zero hits across all 43 tables.
Nothing is a migration of an existing abstraction — everything here is greenfield.

**The live login path is not in this repository.** `login_port = 0` (`config/server.toml:35`) means
`services->add<ProtocolLogin>` (`src/otserv.cpp:567-570`) never runs and `src/protocollogin.cpp:88-120`
is dead code. A 15.25 client gets its character list AND its world list from the external
`opentibiabr/login-server` (`docker-compose.yaml:35-59`), which writes `account_sessions` and which this
server only reads (`src/iologindata.cpp:152-177`). Multi-world may be deliverable entirely outside this
repo — or not at all inside it — depending on decision D1.

**The wire format already supports N worlds; this server has never had more than one to advertise.**
`src/protocollogin.cpp:103-107` writes a world-count byte, a world id, a name, an IP and a port. There is
no registry behind it, and `ONLINE_OFFLINE_CHARLIST` squats on the world-id byte
(`src/protocollogin.cpp:92-101` emits two fake "Offline"/"Online" worlds at the same IP/port;
`:114-119` writes the per-character world id as an online flag). That feature is off in shipped config
(`config/server.toml:54`) but must be deleted or redesigned, not worked around.

**The connection already announces a world name and the server throws it away.**
`src/connection.cpp:256` prints `modernWorldLine` and `:257` accepts. Grep confirms nothing else in the
tree reads it. This is the cheapest wrong-world rejection available and it is currently unused.

**N worlds in ONE process is not feasible without a large refactor.** Three findings make this categorical,
not merely expensive:
- `src/map.cpp:22-23` — a file-scope `thread_local` chunk cache keyed only by chunk coordinate, read in
  `Map::getTile` (:88-100, :658-668). Two Map instances return each other's tiles. All game logic runs on
  one dispatcher thread, so this is a guaranteed wrong answer, not a race.
- `src/zones.h:615-627` — the entire zone and spawn system is `inline static` keyed by bare `Position`.
  Same coordinate in two worlds is the same key; `ZoneManager::Clear()` (`src/zones.cpp:2271-2285`) clears
  all worlds at once; spawn coroutines call `g_game.placeCreature` unconditionally (`src/zones.cpp:357, 738-739, 793-794`).
- 813 `g_game` references across `src/`, including inside Game's own members (`src/game.cpp:249, 6865-6868`),
  so a second Game instance would write into the first.
Plus: `SpawnCoroTask::s_pool` is one static memory resource (`src/zones.h:263`, repointed by
`src/game.cpp:130-133`); `ProtocolGame::shared_modern_layout` is a process-wide static
(`src/protocolgame.h:551-553`, set at `src/otserv.cpp:586`); `Item::items`, `Outfits`, `Appearances`,
`IOMarket`, `Bestiary::Registry`, `Prey/Forge/Wheel/Store::getInstance()`, `g_bans`,
`Database::getInstance()` are all one-per-process.

**One process = one config tree, and only via the working directory.** Twenty TOML files are opened by
hardcoded relative literals from 11 translation units (`src/configmanager.cpp:84-92`, plus
`src/console.h:369`, `src/bestiary.cpp:113`, `src/forge.cpp:86`, `src/metrics.cpp:222`, `src/mounts.cpp:21`,
`src/objectpoolconfig.cpp:15`, `src/prey.cpp:61`, `src/store.cpp:58`, `src/wheel.cpp:543`). The RSA key is
the bare literal `"key.pem"` (`src/otserv.cpp:375`). The CLI overrides only `--ip`, `--login-port`,
`--game-port` (`src/otserv.cpp:648-675`) — the live listener `game_port_modern` and `status_port` have no
override at all. The only env var in the server is `BLACKTEK_DEBUG_XTEA` (`src/protocolgame.cpp:522`).

**Only map-adjacent content is name-parameterised.** `data/world/<map_name>.otbm` (`src/game.cpp:248`),
`<map_name>-spawn.xml` / `<map_name>-house.xml` (`src/iomap.h:139-160`), `data/world/<map_name>-zones`
(`src/zones.cpp:2230`). Everything else — scripts, NPCs, quests, items, augments, vocations, raids, events,
chat channels — is a hardcoded `data/...` literal (`src/script.cpp:27`, `src/scriptmanager.cpp:41`,
`src/quests.cpp:141`, `src/npc.cpp:76`, `src/items.cpp:314`, `src/chat.cpp:272`, `src/raids.h:79`).
Four complete map sets already ship side by side in `data/world/`.

**Sharing one database between worlds is currently data-destroying, not merely wrong.** Unfiltered
whole-table wipes: `DELETE FROM tile_store` (`src/iomapserialize.cpp:63`), `DELETE FROM house_lists`
(`src/iomapserialize.cpp:294`), `DELETE FROM account_storage` (`src/game.cpp:6819`),
`TRUNCATE TABLE players_online` and `TRUNCATE TABLE towns` (`data/scripts/globalevents/startup.lua:5, 42`).

**Id spaces collide across maps.** House ids come from `<map>-house.xml` (`src/house.cpp:493-518`) — a
scout measured 116 house ids shared between `map1-house.xml` and `canary-house.xml`, and 61 between map1
and forgotten. Town ids are map-local small integers and `players.town_id` is a bare int (`schema.sql:319`).
Bestiary race ids come from each world's own monster data (`src/bestiary.cpp:186-192`) and are the PK of
`player_bestiary` (`schema.sql:533`).

**Global uniqueness constraints pre-decide product questions.** `players.name` UNIQUE
(`schema.sql:852-855`) — a character name can exist on only one world under a shared DB.
`guilds.name` and `guilds.ownerid` UNIQUE (`schema.sql:781-783`) — one player can never lead a guild on
two worlds. `guild_membership` PRIMARY KEY (player_id) (`schema.sql:800`) — one guild per character, database-wide.

**Account-scoped state is already cross-world by construction, and unsafe if two worlds are live at once.**
`accounts.coins` is written as a blind absolute `UPDATE` (`src/store.cpp:449`) from a value cached at login
(`src/iologindata.cpp:25-31`), while transfers use a `coins + N` delta (`src/store.cpp:367`) — spend in two
worlds and one write restores the other's balance. `one_player_per_account` is enforced only against this
process's in-memory player map (`src/protocolgame.cpp:246-249`). `account_viplist` is account-keyed but
points at world-specific `players.id` (`schema.sql:100-110, 1112-1113`).

**Offline-player mutation is process-local by definition.** `Player::isOffline()` is `getID() == 0`
(`src/player.h:538`). The market (`src/game.cpp:7803-7863`) and house rent (`src/house.cpp:547-552`) load a
character from the DB, mutate it, and write the whole row back via `IOLoginData::savePlayer`
(`src/iologindata.cpp:1477` — full-row UPDATE plus delete-and-reinsert of every child table).
With two worlds on one DB this silently destroys the other world's session.

**Global singletons in `server_config` and migrations.** `server_config` is PK'd on `config` alone
(`schema.sql:939`) and holds `db_version`, `motd_num`, `motd_hash`, `players_record`
(`src/game.cpp:7186-7238`, `src/databasemanager.cpp:126-149`). Every process calls `updateDatabase()`
at boot (`src/otserv.cpp:402`) with no lock; migrations use `TABLE_SCHEMA = DATABASE()`
(`data/migrations/0.lua:7-8` and others), so they are inherently whole-schema.

**There is no query chokepoint.** ~100 hand-written `fmt::format` SQL strings across 11 C++ files
(ban, databasemanager, forge, game, guild, house, iologindata, iomapserialize, iomarket, monster, store),
plus raw `db.query` from Lua (`src/luascript.cpp:1221, 4962-5080`), `data/global.lua:76-124`,
`data/scripts/creaturescripts/playerdeath.lua:50-77`, and ~40 NPC scripts writing `guilds.balance`
(e.g. `data/npc/scripts/Finarfin.lua:60`).

**Deployment does not exist.** No systemd unit, no ExecStart, no deploy script anywhere in the repo.
`bootstrap.sh` prints `./Black-Tek-Server`. `README.md:74-80`, `Dockerfile:51-65` and `docker-compose.yaml`
all still describe 7171/7172/7173 while the live listener is 7183/7184 — do not trust documented ports.
The data tree is written at runtime (`src/objectpoolconfig.cpp:17-19`, `src/game.cpp:7512`,
`src/zones.cpp:2235, 2570, 2580`), so it cannot simply be shared read-only.

**Footprint per world.** 512 MB arena allocated at static-init before any flag could change it
(`src/game.cpp:83-90`), plus `tile_count * (sizeof(Tile) + 64)` (`src/iomap.cpp:119-121`).
STATUS.md:149 measures ~10 GB RSS for the 13.3 M-tile real map, and `data/world` is 723 MB on disk
with no sharing or mmap between processes even for the same map.

**Two unresolved contradictions in the tree the designer should not paper over:**
- `src/protocolstatus.cpp:91-93, :147-152` publishes `LOGIN_PORT`, which is 0 on this fork, and
  `src/configmanager.cpp:148` defaults `status_port` to 7171 — a second instance that loses its
  `server.toml` silently collides with the legacy login port.
- `src/definitions.h:16-18` still declares `CLIENT_VERSION_MIN/MAX/STR` as 1097/1098/"10.98" while
  `config/server.toml:33` states the server is 15.25-only.

## 4. DECISIONS THE OWNER MUST MAKE

Each is stated as **default → alternative**. The default is what the code leans toward, not a recommendation.

**D1. Who owns the world list?**
Default: the external `opentibiabr/login-server` stays the owner and is taught about N worlds — it already
returns a `worlds[]` array (`harness/modern_client.py:88-91`) and this fork has deliberately kept it
unmodified (README.md:17, STATUS.md:206-210). Alternative: revive/rewrite `ProtocolLogin` in this binary
(`src/protocollogin.cpp:88-120`) and serve the world list in-process. These are very different projects;
the second is only reachable if a 15.25 client can be pointed at an in-binary login port at all.

**D2. One database per world, or one shared database keyed by `world_id`?**
Default: **database per world** — `MYSQL_DB` already functions as the world identity
(`src/databasemanager.cpp:18, 41, 47`) and ~100 inline SQL strings need no change. Cost: `accounts`,
coins, `store_history`, bans and `account_sessions` fork per world unless hoisted into a shared auth
schema, which breaks six FKs to `accounts(id)` (`schema.sql:598, 702, 1092-1113, 1176`) and needs a second
`Database` the singleton cannot express (`src/database.h:30-34`). Alternative: **shared DB + `world_id`** —
a column on ~16-35 tables, a predicate on every query, rework of `players.name` /`guilds.name` unique keys,
and fixes to every unfiltered DELETE/TRUNCATE listed above.

**D3. Is a character bound to one world at creation? — SETTLED: YES (see section 0)**
Default: **yes, Tibia's model** — a character exists on exactly one world. This makes
`player_bestiary`, `player_charms`, `player_prey`, `forge_history`, all four wheel tables, and every
`player_*` item table safe with no schema change. Alternative: account-wide characters that can enter any
world — which makes `guild_membership` PK(player_id) (`schema.sql:800`) an outright blocker and requires
per-world position/town rows.

**D4. Are character names globally reserved or per-world reusable?**
Default follows D2: separate DBs ⇒ per-world reusable (two "Arkanaut"s can exist); shared DB ⇒ globally
reserved unless the unique key becomes `(world_id, name)` and every lookup takes a world
(`src/iologindata.cpp:1862, 1875, 1899`).

**D5. Are premium, store coins, store history and account bans shared or per-world? — SETTLED for coins: ACCOUNT-WIDE (see section 0). Premium, bans and store history still open.**
Default under D2-separate-DBs: they silently become **per-world**, which is a product decision made by
accident. Alternative: hoist `accounts` to a shared auth DB and share them deliberately — which then
requires `src/store.cpp:449`'s absolute coin write to become a transactional delta, and requires something
to stop one account being online in two worlds at once (`src/protocolgame.cpp:246-249` is process-local only).

**D6. Is `one_player_per_account` per world or across all worlds?**
Default: **per world** (an account may be online in every world simultaneously; nothing notices today).
Alternative: global — must become a DB/registry check, and `players_online` cannot serve as the guard
because it is TRUNCATEd at every boot (`data/scripts/globalevents/startup.lua:5`).

**D7. Should `account_sessions` be world-scoped?**
Default: **no** — a session key admits any world that can read the row (`src/iologindata.cpp:152-177`,
`schema.sql:695-703`). Alternative: add a world column, which means modifying or replacing the third-party
login service. Related, nearly free either way: validate `Connection::modernWorldLine`
(`src/connection.cpp:256`) against this process's identity and reject a mismatch.

**D8. Is the market per-world, mirrored, or shared?**
Default: **per-world** (follows D2). Alternative: shared — note `market_offers` carries no item attributes
(`schema.sql:280-288`) while `player_items` does (`schema.sql:474-483`), so a cross-world market strips
augments/skills/stats and re-creates items from an itemtype id (`src/game.cpp:7646-7666`, `src/iomarket.cpp:125-152`).
Offer identity is `(id & 0xFFFF)` off a single AUTO_INCREMENT (`src/iomarket.cpp:199`) and aliases more
densely the more worlds share the table.

**D9. Are guilds per-world or account-wide?**
Default: **per-world**. Alternative: shared, which means world A's players can squat every guild name in
world B (`schema.sql:791`) and one player can never lead a guild on two worlds (`schema.sql:783`).

**D10. Do worlds share one content tree or each get their own?**
Default: **share `data/`, differ only by `map_name`** — map, spawn, house and zones are already
name-parameterised. Alternative: per-world content (different scripts, NPCs, items, vocations), which
requires a data-root indirection that does not exist and ~723 MB of map duplicated per world.

**D11. N processes, or refactor toward N worlds per process?**
Default: **N processes** — zero engine changes today; a second world needs only a second working directory
with its own `config/`, `key.pem`, ports and MySQL db. Alternative: de-globalise `g_game`, `ZoneManager`,
the `thread_local` chunk cache and every singleton — a whole-engine refactor. If N processes is chosen,
decide separately whether to add `--config-dir` / `--data-dir` / `--game-port-modern`
(`src/otserv.cpp:648-675`) or to keep the working-directory convention.

**D12. How are worlds supervised and ports assigned?**
Default: hand-assigned ports in per-world `server.toml` + a systemd unit template per world (none exists
today). Alternative: a launcher or orchestration layer that allocates ports and composes configs.
Whatever is chosen must also give each world its own `log_dir` (`config/logging.toml:2`,
`src/console.h:198`) and metrics dump dir (`config/metrics.toml:18, 29`), because two processes in one cwd
interleave and race on rotation/retention.

**D13. Who runs migrations, and when?**
Default under separate DBs: each world runs its own at boot (`src/otserv.cpp:402`) and they can drift to
different `db_version`s on the same binary. Alternative under a shared DB: N processes race the same
unguarded `db_version` row (`src/databasemanager.cpp:50-120`) and need a lock or an out-of-band migration step.

**D14. What happens to `players_online` and `towns`?**
Default: keep the TRUNCATE-at-boot behaviour and give each world its own DB. Alternative: add a world
column (the website's online display breaks first — `data/global.lua:112-113`), or stop the server writing
them at all; nothing in `src/` reads `towns`.

**D15. Highscores — per-world, global, or not at all?**
Nothing exists: `RequestHighscores = 0xB1` (`src/networkopcodes.h:158`) is the only occurrence in `src/`,
with no handler, no table, no query. Pure product decision, zero migration cost either way.
Same for the house-auction UI opcode `0xAD` (`src/networkopcodes.h:157`), which is declared and never handled
while `data/scripts/globalevents/startup.lua:23-39` settles auctions globally at every boot.

**D16. Any cross-world chat?**
Default: **none** — chat is process-memory only with no persistence and no IPC (`src/chat.h:109-149`).
Alternative: a shared trade/help channel, which is entirely new infrastructure. Note `guildChannels` is
keyed by globally-unique guild id (`src/chat.cpp:337`) if that is ever wanted.

**D17. What is the RAM budget per host?**
512 MB arena + `tile_count * (sizeof(Tile) + 64)`; ~10 GB RSS measured for the 13.3 M-tile real map
(STATUS.md:149). Two live real-map worlds is a ~20 GB host. This dwarfs every other multi-world cost and
is a hardware decision, not a code one.

## 5. OUT OF SCOPE / NON-NEGOTIABLE

- **15.25 protocol only.** The legacy 10.98 listeners were retired 2026-08-11 (`config/server.toml:33`).
  Do not revive `game_port`, do not add a second protocol generation, do not weaken the startup refusal at
  `src/otserv.cpp:576-587`. `ProtocolGame::shared_modern_layout` (`src/protocolgame.h:551-553`) is a
  correctness requirement of the shared spectator payload, not an optimisation to route around.
- **`CONTRIBUTING.md` is mandatory and authoritative for all C++ here** (`CLAUDE.md:6-11`: where CLAUDE.md
  and CONTRIBUTING.md disagree, CONTRIBUTING.md wins). Binding rules the design must respect, not just the
  implementation: RAII only, no manual memory management (:5-11); views over `continue` (:12-35); new
  subsystems nest under `BlackTek::SystemCategory` and no new top-level namespaces (:36-55) — a world
  subsystem would be e.g. `BlackTek::World`, not a new top-level `Worlds`; aliases over verbose types
  (:56-75); enums nested in their owning class, `enum class` by default (:76-140); `noexcept` by default
  (:141-155); `[[nodiscard]]` on getters/predicates/pure computations (:156-167); struct vs class rule
  (:168-200); **never `std::cout`/`std::cerr`/`printf` — `BlackTek::Console` only** (:201-234), which the
  existing `src/connection.cpp:256` world-name print already violates; braces, alignment, casing, keywords,
  casts, aggregate-init and include rules (:235-450).
- **The external login webservice is unmodified by policy.** `opentibiabr/login-server` is a third-party
  binary image (`docker-compose.yaml:35-59`) that this fork has deliberately kept untouched
  (README.md:17, STATUS.md:206-210). Any design that requires changing it must say so explicitly and get
  that call made, not assume it.
- **`Zones`, `Components`, `ObjectPools`, `OTB`, `IOGuild`, `Titan`, `xtea` are accepted legacy top-level
  namespaces** (CONTRIBUTING.md:44-48). Do not rename or re-nest them as part of this work, even though
  `Zones::ZoneManager` is a central obstacle.
- **The 15.25 feature systems already verified on the real client stay working**: bestiary/charms, prey,
  exaltation forge, wheel of destiny, store, market, cyclopedia (STATUS.md gates D/E/G/H). Any world
  scoping applied to `player_bestiary`, `player_charms`, `player_prey`, `forge_history`, the four
  `player_wheel_*` tables or `store_history` must not regress them.
- **Do not fix the stale ports/docs as drive-by work.** `Dockerfile:51-65`, `docker-compose.yaml:61-76` and
  `README.md:74-80` all still say 7171/7172/7173; `src/definitions.h:16-18` still says 10.98. Note them,
  design around the live values (`game_port_modern = 7183`, `status_port = 7184`), and leave the cleanup to
  its own change.
- **`data/world/` map assets are generated, not committed** (`.gitignore:46-55`; `realmap.7z` unpacked
  before first boot; `harness/build_canary_map.py`). A per-world map pipeline is a build/deploy concern,
  not something the server design may assume is already on disk.
- Dungeons/instances code is owned by a separate effort — do not design into it.
