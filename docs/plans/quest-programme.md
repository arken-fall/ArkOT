# The quest programme

Quests in ArkOT's own format, engine and data alike, and every held-back script closed.

The owner set two rules that shape everything below:

- **"We do NOT use Canary coding — for both data and engine level."** Their Lua libs and their
  ported scripts are reference for *what a piece of content has to do*, never code to adopt. What
  ships is ours, in this repository's idiom, under CONTRIBUTING.md.
- **"I want to fix everything if possible."** So the systems previously parked are in scope, and
  where something is genuinely not worth building, this document says so with the mechanism rather
  than dropping it quietly.

Scope also includes the 69 NPCs who cannot hand out their quest (`roadmap.md:187`) — added by the
owner on 2026-09-19. That phase is being designed and lands in this document when it is ready.

---

## What exists today

### Three unrelated things are called "a quest"

**The quest log is already ArkOT-native, declarative TOML.** `src/quests.cpp:136-221` walks
`data/quests/`, and **each top-level table is one quest**, with ids assigned `++id` in sorted-path
order (`quests.cpp:139-161`). 50 files, 369 missions. It reloads in-process
(`RELOAD_TYPE_QUESTS`, `src/game.cpp:8214`).

**Quest furniture is 726 machine-ported Canary revscripts.** The *registration* shape is already
ours — `harness/build_canary_quests.py:94-105` rewrites `Action()`/`MoveEvent()` into `ItemEvent()`
and `onStepIn/onStepOut` into `onStepOn/onStepOff`. What is still Canary's is the content: storage
paths out of the generated `data/lib/canary/storages.lua`, world state through a volatile Lua table,
and one hand-written file per lever.

**Rooms and spawns are already ArkOT-native TOML, and far more capable than anything uses.**
`src/zones.cpp:2045-2226` parses `data/world/<map>-zones/*.toml` with `spawn_type`, `policy`,
`trigger`, `range`, `positions`, `flags`, `cooldown`, `weekdays`, waves, a master and delayed
minions. **`Zone::RunBossTriggered` (`zones.cpp:1577-1700`) already implements the whole boss-room
lifecycle** — wait for a trigger, spawn master and minions, watch players enter and leave, catch the
master's death — and `HandleMasterDeath` (`zones.cpp:807-847`) despawns minions, restores the master
entry and sleeps out the cooldown before rearming. All 16,704 loaded zones are plain converted
spawns; nothing has ever used the triggered policy.

### The gap, measured

- 726 scripts installed, **≥239 held back across 55 quests** (`docs/plans/quest-port-gaps.md`).
- 60 files call `BossLever`: **42 are pure configuration data**, 18 also carry a hook
  (`onUseExtra`, `createFunction`, `encounter`).
- Soul War is **12** files and Soul Pit **8** — 20 parked, not the 23 first reported.
- `Encounter` 6 scripts, `Hazard` 1, familiars 1, animus mastery 1, bosstiary 5.

### The grader lies in both directions

`harness/build_canary_quests.py` inflates the gap three ways and deflates it a fourth:

1. `code_only()` (`:192-196`) strips `--[[ ]]` comments but not bare `[[ long strings ]]`, so quest
   prose becomes "missing symbols" — `North`, `mountains`, `years`, `argh`.
2. `known_globals()` (`:141-153`) misses `luaL_register` tables, so `configManager` and `bit` read as
   missing though the engine binds them (`src/luascript.cpp:1212-1225`).
3. `canary_only()` (`:66-91`) never subtracts the engine's own registered globals.
4. All three scan `data/`, which **now contains the generator's own output**, so a re-run grades 739
   scripts as portable against a tree holding 726. **239 is a floor, not a ceiling.**

### Verified small gaps

- `Creature:getMonster()`/`getNpc()` do not exist; `getPlayer` is one line of Lua
  (`data/lib/core/creature.lua:31-33`). 19 scripts.
- `Combat.setParameter` is not registered — only explicit setters (`luascript.cpp:3402-3418`) — so
  `setCombatParam` (`data/lib/compat/compat.lua:306`) binds nil. 13 scripts. The
  `COMBAT_PARAM_* → setter` map already exists at `harness/build_canary_monster_spells.py:53-63`.
- `Zone:getActiveCreatures` returns only creatures the zone spawned (`luascript.cpp:17232`).
- World state does not persist: `Game.get/setStorageValue` are a plain Lua table
  (`data/lib/core/game.lua:58-68`); there is no `world_storage` table.
- `Player::addStorageValue` **silently refuses** unknown keys in the reserved range
  (`src/player.cpp:1426-1439`), and every write runs `Quests::isQuestStorage`, an O(quests × missions)
  scan (`quests.cpp:244-258`).
- Creature icons go out as a hard zero (`src/protocolgame.cpp:6440, 6460`) — there is no channel for
  a status badge.

### Corrections made during verification

- **`SpawnTrigger::Use` *is* fired.** `Game::playerUseItem` (`src/game.cpp:3515`) and
  `playerUseItemEx` (`src/game.cpp:3451`) both raise it. The real constraint is narrower: the overlay
  comes from `GetSpawns(player->getPosition())`, so it fires for zones overlaying the **player**, not
  the used item — a lever pulled from outside its room still cannot trigger that room. The proposed
  `Zones::FireTrigger` shrinks to closing that positional gap.
- Soul War is 12 files, not 13.

---

## The design

### A quest is one TOML file

The quest log it already has, plus declarative blocks for its furniture:

| Block | What it declares |
| --- | --- |
| `[<QuestName>]` | the quest log — unchanged, read by the existing `src/quests.cpp` |
| `[[encounter]]` | a boss room: entries, bounds, master, minions, cooldown, exit |
| `[[gate]]` | a tile or lever admitting a player when a condition holds |
| `[[reward]]` | a one-time payout keyed to a storage flag |
| `[[state]]` | a door, wall or lever that transforms and optionally reverts |
| `[[script]]` | names the bespoke Lua file owning this piece — documentation, so it is findable |

**The seam that makes this free:** `Quests::loadFromToml` only reads top-level *tables*
(`value.is_table()`, `quests.cpp:155`). A TOML array-of-tables is not a table, so `[[encounter]]`
blocks are invisible to the existing loader. The 50 existing files keep their quest ids untouched.

Bespoke logic stays Lua, in our idiom, under `data/scripts/quests/<quest>/`, on helpers in
`data/lib/core/` — never `data/lib/canary/`, which is machine-generated.

**Why this is worth doing:** 42 of 60 boss levers are ~40 lines of near-identical Lua differing only
by coordinates. As data they are ~15 lines, they run on a coroutine the engine already has, they
reload without a restart, and a mistake in one cannot take down the `lua_State` shared by every other
script.

### New subsystem: `BlackTek::Quests`

`src/questcontent.h` / `.cpp`. A process-lifetime `Registry` owning four vectors of plain
definition structs (`EncounterDef`, `GateDef`, `RewardDef`, `StateDef`), handing out
generation-checked `ContentHandle`s the way `Zones::ZonePool` does. `ItemEvent`s hold a handle, never
a pointer, so a reload that rebuilds the vectors turns a stale handle into a `nullptr` and a warning
rather than undefined behaviour.

`Load()` returns `std::expected<size_t, std::string>`: a malformed quest file is an expected failure
and leaves the previous content running. Runtime handlers return the `bool`/`uint32_t` the
`ItemEvent` contract demands and log through `BlackTek::Console::Script`. No exceptions cross the
boundary. No threading — everything runs on the dispatcher, like `Quests`, `Zones` and `ItemEvents`
today.

### One engine change makes native handlers possible

`ItemEventActionFunction` and `ItemEventStepFunction` (`src/itemevents.h:125-128`) do not receive the
`ItemEvent` that matched, so a native handler cannot tell which declaration fired.
`ItemEventEquipFunction` on the next line already takes `const ItemEvent*` — follow that precedent,
and give `ItemEvent` one `ContentHandle` field. Blast radius: two aliases, four `Defaults::`
functions, three call sites (`itemevents.cpp:981`, `:1036`, `:2175`).

### How a declaration becomes running content

At boot, **before** `g_scripts->loadScripts("scripts")` (`otserv.cpp:895`), so declarative content
claims its ids first and a leftover script on the same id loses deterministically rather than by
filename luck (`SelectEvent` takes the first match, `itemevents.cpp:71-76`).

`Install()` parses the TOML, builds one `Zones::Zone` per encounter through the same construction
path `ParseZoneEntry` uses — driving the already-written `RunBossTriggered` — and registers one
`ItemEvent` per declaration with `fromLua = false`, so `/reload scripts` keeps it
(`itemevents.cpp:768-782`).

Four native handlers are the whole runtime: `PullEncounterLever`, `OpenReward`, `ToggleState`,
`CrossGate`. The lever handler is BossLever expressed once — check the room is empty
(`Map::getSpectators`), collect the creature on each entry tile, level and cooldown checks, teleport
the party, stamp cooldowns, fire the trigger, transform the lever, schedule the timeout sweep.

### State the quests need

**`world_storage`** — mirroring account storage exactly (in-memory map, loaded at
`GAME_STATE_INIT`, flushed in one transaction at save, `game.cpp:172` and `:6820-6851`). Then
`Game.get/setStorageValue` become engine bindings and the volatile Lua table is deleted. ~40
`GlobalStorage.*` paths depend on it. Migration 9. **Restart.**

**`player_bosscooldowns`** — its own table keyed `(player_id, boss_name)` with a `bigint` expiry.
Not player storage: the reserved-range trap would swallow the keys silently, a unix timestamp is not
an `int32_t` past 2038, and every write would drag the `isQuestStorage` scan. Keyed by name rather
than bestiary race id because 972 of 1,712 monsters have no bestiary entry. Migration 10. **Restart.**

---

## The parked systems

| System | Scripts | Verdict |
| --- | --- | --- |
| **Soul Pit** | 8 | **Build.** Every input exists in C++ (`stars`/`occurrence` on `MonsterType`, `Registry::getRaceMembers`, forge classification) and is merely unbound to Lua. The fight is a staged `[[encounter]]`. ~4 dispatches. Animus mastery becomes a storage flag and a message — one call site does not justify a per-player system with a client window we lack. |
| **Soul War** | 12 | **Build.** The bulk is `CreatureEvent` hooks we already have; the bespoke state is small integers that fit player storage and `world_storage`. ~4-5 dispatches after the state phase. `setTaintIcon` degrades to a logged no-op: creature icons go out as a hard zero, so there is no channel for the badge until the client-surface work lands. |
| **Bosstiary** | 5 call sites | **Split.** The cooldown is real and ships with the state phase; `sendBosstiaryCooldownTimer` is the client widget and belongs to the client programme. No quest is blocked. |
| **Familiars** | 1 | **Defer.** The quest uses it as a permission check — a storage flag now, replaced by the real call when the spell programme lands. |
| **Hazard** | 1 | **Do not build.** A 16-method per-player difficulty ladder for a single death callback, wanted by nothing else in 965 scripts. Rewrite that one script to grant its reward directly. If Hazard is wanted *as a feature*, it is its own brief. |

**19 of the 20 parked scripts are reachable.** The one genuinely not worth it is Hazard, routed
around at the cost of one rewritten callback.

---

## Migration plan

### Phase 0 — make the measurement trustworthy

**0.1 Fix the grader.** `harness/build_canary_quests.py` only: strip bare long strings in
`code_only()`, add `luaL_register` names to `known_globals()`, subtract engine globals in
`canary_only()`, and exclude `data/scripts/quests` from the three `data` scans. *Done:* two runs
against the same output report identical counts, and the prose words and `configManager`/`bit`
disappear. **The count will move — that is the point.** No restart.

**0.2 Name the duplicates.** Carry `Event::getScriptId()` into the five collision warnings in
`src/itemevents.cpp:646-733` and resolve both incumbent and newcomer through
`LuaScriptInterface::getFileById` (`luascript.cpp:456`). *Done:* one boot produces 1,034 lines each
naming two files, turning `roadmap.md:34-50` into a real triage list. **Restart.**

### Phase 1 — the declarative content system

1.1 `ItemEvent` handler signatures plus the `quest_content` field. **Restart.**
1.2 `BlackTek::Quests::Registry` and the TOML parser — `Load()` only.
1.3 `Zones::FireTrigger` plus a `Zone:fire` binding — a **new name**, because `Zone:trigger` is
already the `configured_trigger` accessor (`luascript.cpp:17147`). Scope narrowed by the correction
above: `Use` already fires from the player's position, so this closes the positional gap.
1.4 `Install()`, the four handlers, the boot hook. *Done:* Dark Trails' Ravager runs entirely from
TOML and its Lua file is disabled. **Flagged:** that boss gains a per-player cooldown it lacked.
1.5 `/reload questcontent`. **This is what makes the rest landable on a live server.**

### Phase 2 — persistent state (land together, all restart-gated)

2.1 `world_storage` + migration 9 + bindings; delete the volatile Lua table. **Flagged:** world state
starts surviving restarts, so quests that silently reset will stop.
2.2 `player_bosscooldowns` + migration 10 + `IOLoginData` load/save + bindings.
2.3 `Combat.setParameter` over the existing setters — unknown parameters warn and return false rather
than binding nil. 13 scripts.
2.4 The cheap Lua surface: `Creature.getMonster`/`getNpc` (19 scripts), `Game.getTimeInWords`,
the `Position` helpers, and the bestiary/forge bindings the Soul Pit needs.

### Phase 3 — convert the boss rooms

3.1 An extractor emitting `[[encounter]]` blocks from the 42 pure-data levers' config tables —
reference data only, no code copied.
3.2 Land the 42 in four batches of ~10 quests, each verified with a real client.
3.3 The 18 levers with a hook: declarative room, `Zone:fire` to start, only the hook body as Lua.
3.4 The hand-rolled levers already installed among the 726.

### Phase 4 — convert the remaining shapes

4.1 Extend the extractor to recognise gate, reward and state shapes across all 965 and **report
coverage**. This is a measurement, and it is the gate on Phase 4's real size — do not commit to 4.2
before reading it.
4.2+ Batch conversion, ~40 declarations per dispatch, each client-verified.
4.x Retire `data/lib/canary/` once nothing references it.

### Phase 5 — the parked systems

Soul Pit first (smaller, self-contained), then Soul War.

### Known: ported quest scripts claiming the wrong items

Measured 2026-09-20 from the boot log, after the 10.98 pack's dead registrations were retired.
Six item ids are claimed by two scripts at once, and in five of them **the ported quest script is
the one that is wrong**: it carries a Canary id that means something else on this map, and the
generic script that beats it is correct.

| Quest script | Claims | Which here is | Beaten by | Done |
| --- | --- | --- | --- | --- |
| `ferumbras_ascension/actions_grave_flower.lua` | 22873 | a candle | `itemevents/use/others/transforms.lua` | disabled |
| `forgotten_knowledge/actions_plant.lua` | 23810 | the Lion's Heart | `itemevents/use/others/taming.lua` | id dropped, keeps 23811 |
| `others/actions_fire_bug.lua` | 5467 | a bunch of sugar cane | `itemevents/use/others/sugar_oat.lua` | disabled |
| `rottin_wood_and_married_men/actions_corpse.lua` | 12189 | a closed door | `doors/normal_doors.lua` | disabled |
| `the_new_frontier/action_beaver.lua` | 9843 | a lit wall lamp | `itemevents/use/others/transforms.lua` | disabled |
| `the_first_dragon/actions_lair_entrance.lua` | 25160 | a closed door | `doors/normal_doors.lua` | **left enabled** |

The first five never ran and would have done the wrong thing if they had, so they are disabled with
the reason written at the top of each. **They are quest content that does not work**, and the fix is
the id each should be watching — which is the same job as the NPC id mismatches (Gnomally trades
"muck" using 16101, this map's premium scroll).

**The sixth is ours to fix properly.** The First Dragon's lair entrance is a real door the quest
means to gate, registered by item id — so it claims every door of that type and loses to the generic
door script anyway. It needs the map's door to carry an action id and the script to register that,
which is a map edit rather than a script edit. It is left enabled on purpose: its one duplicate
warning at every boot is the reminder.

**A rule worth keeping from this:** when a ported script and a script written for this map claim the
same id, check what the id *is* before assuming the specific script should win. Five times out of six
here, the generic one was right.

### Phase 1b — NPC quest givers (independent of Phase 1; runs in parallel)

69 NPCs greet, sell and answer keywords but never hand out their quest: 79
`npcHandler:setCallback` lines are commented out across 69 files.

**The roadmap's explanation is wrong, and the repository says so.** It attributes this to Canary's
npc object being needed "for its own shop windows". Shop windows are **2 NPCs**. Of the 46 blocking
`npc:` call sites, **41 are `npc:getId()` (21) and `npc:getPosition()` (20)** — both of which this
engine has answered all along: `Npc()` with no argument returns the NPC whose script is running
(`src/luascript.cpp:15128`), because the engine binds it before every event call
(`src/npc.cpp:1494`), and the shared NPC lib already relies on this
(`data/npc/lib/npcsystem/npchandler.lua:362`).

**The blocker is one regex.** `harness/build_canary_npcs.py:130` discards a translated callback if
any token matches `\bnpc[:.]\w+|\bnpc\b(?!Handler)` — so a callback is thrown away for calling two
accessors we have. Everything else in those callbacks the tool already rewrites correctly.

The genuinely unanswerable residue is five method names across three NPCs: the category shop
(Rabaz), and Canary's banker module (Lokur — and ArkOT already ships `data/npc/scripts/bank.lua`).

**Steps — all data and harness. None needs a restart; every one lands with `/reload npcs`.**

**1b.1 Narrow the guard and bind the npc.** `harness/build_canary_npcs.py` only: restrict `UNMAPPED`
to the five genuinely unmapped methods, add rewrites for `npc:openShopWindow(creature)` and the
`, npc, creature` argument shape, and emit `local npc = Npc()` at the head of any translated callback
that uses it. *Done:* a dry run reports **≤6 NPCs still carrying a commented callback**, against 69
today, and the residue is exactly Albinius/Gnomally (shop), Rabaz (categories), Lokur (bank). Any
other name is an unmapped method nobody has found yet and must be investigated before 1b.3.

**1b.2 `NpcHandler:openShop`.** One additive method in `data/npc/lib/npcsystem/npchandler.lua`,
doing what `ShopModule.requestTrade` (`modules.lua:1103-1132`) does but reached from dialogue rather
than a keyword. `requestTrade` is left untouched: collapsing the two would change behaviour for every
trading NPC on the map for no gain here. *Done:* `/reload npcs`, and every existing trading NPC still
opens its shop on "trade".

**1b.3 Regenerate and land in three batches of ~23 NPCs.** *Hazard:* the generator rewrites both the
XML and the script for every NPC it touches, and some of those names were pack-authored and later
replaced — **diff before copying**, so a regeneration cannot silently revert a hand-tuned shop list.
*Done per batch:* each NPC drives its quest step against a real client and **the storage value
actually moves** — a greeting is not evidence. **Flagged behavioural change:** these NPCs currently
go no further than hello; afterwards they hand out quests, so a player standing in front of one can
suddenly progress.

**1b.4 The tail.** Rewrite rules for `VOCATION`, `TOWNS_LIST` and `addCustomGreetKeyword` (36
occurrences over 18 files); point Lokur at our own banker; give Rabaz a flat shop. *Done:* zero
commented-out callbacks remain, and Rabaz's dropped categories are a named omission in the
generator's report rather than a silent one.

**Not built: shop categories.** `ShopModule` keeps one flat item list fed from two flat XML strings;
adding a category dimension touches the parser, the module, the XML schema and every shop NPC's data
— to serve one NPC. Rabaz sells the same wares without sub-menus. If categories are wanted as a
feature for all traders, that is its own brief.

**Rejected: a `[[giver]]` block in the quest TOML.** These callbacks branch on storage, keep
per-player tables, mutate the greeting mid-conversation and release focus conditionally. A schema
expressive enough to hold that is a scripting language spelled in TOML. What the quest file should
carry is an `[[npc]]` entry naming the giver and its role — read by nothing, there so one file names
every moving part of the quest.

**Four dispatches**, and the cheapest player-visible win in the programme.

---

## Scale

| | Count |
| --- | --- |
| Canary quest scripts | 978 |
| Installed, Canary-shaped | 726 |
| Held back | ≥239 (floor) |
| Boss levers | 60 — 42 data, 18 with a hook |
| Soul War + Soul Pit | 12 + 8 |
| Existing quest TOML / missions | 50 / 369 |
| Pack scripts still active / duplicate registrations | 312 / 1,034 over 844 ids |

**Roughly 28-34 dispatches, plus the NPC phase.** Twelve need a restart; about twenty are TOML and
Lua landing with a reload.

**Why a generator rather than hand-authoring:** 965 files at 20-40 minutes each is 320-640 hours and
is not finishable. The generator reads Canary's config tables as *data* and emits ArkOT-format
content; whatever it cannot map is listed rather than hidden. Reading the map alone cannot work as
the sole source — the OTBM carries every lever's ids and the zone TOMLs carry every spawn, but which
lever opens which room exists only in the scripts. It serves as a cross-check that an emitted anchor
really exists on this map.

---

## Risks and open questions

1. **Do array-of-tables perturb quest ids?** They should not (`quests.cpp:155` skips non-tables), but
   ids go to the client. Compare the boot ordering before 1.4. A shifted id scrambles every player's
   quest log.
2. **How many of the 1,034 duplicates are pack-versus-port at all?** The tool sees only literal
   registrations and found 10 clashes against 844 affected ids. Step 0.2 answers it.
3. **Does `RunBossTriggered` actually rearm?** It reads correctly, but no zone in the tree uses the
   triggered policy, and there is a visible edge where the master entry may not be restored
   (`zones.cpp:1686-1687`). Exercise it in 1.3 before 42 levers depend on it.
4. **`Use` versus `Enter` as the start signal.** `Use` fires from the player's position; teleporting
   players in and letting `Enter` start the room may need no new firing path at all.
5. **Extraction coverage.** If 4.1 reports below ~60%, Phase 4's estimate is wrong and the plan
   should be re-cut around hand work for the residue.
6. **`world_storage` under two worlds.** Per-world tables in per-world schemas matches the
   one-character-one-world rule, but check the auth-schema layout before writing migration 9.
7. **Does `Install()` before `loadScripts` actually win the id race?** Verify at 1.4 with a
   deliberately conflicting test script.

---

## Validation

- **Grader:** run the harness twice against the same output — written and held-back counts must be
  identical. Today they are 739 and 726.
- **Duplicates:** warning count at boot must not change, only the text.
- **Precedence:** install a declaration on an id a pack script also claims; the declarative one must
  fire, and the warning must name both files.
- **Reload:** with a player inside a boss room, edit the encounter and reload — the running fight is
  unaffected, the next pull uses the new value.
- **Room lifecycle, per batch:** too few players refused; right party teleported and boss spawned;
  minions on their delays; kill clears the room per `minion_behavior`; a pull inside the cooldown
  refused naming the wait; a pull after it works.
- **Persistence:** set a value and a cooldown, clean shutdown, reboot, read both back. Then kill the
  process uncleanly and confirm the failure mode is "lost since last save", not corruption.
- **No regression on the 726:** the Lua error count at boot is zero and must stay zero.
- **Performance:** no claim is made and none is needed — every path here runs when a player pulls a
  lever. If anyone later argues the quest system is a cost, measure `isQuestStorage` first: it is
  O(quests × missions) on every storage write, and it is the only thing here that runs per write.
