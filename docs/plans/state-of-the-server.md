# State of the server

An inventory and triage of Avarion (ArkOT) as of `modern-protocol` @ `2d44d74`, answering three
questions kept deliberately separate:

1. **What is wrong** — things that exist and misbehave, or exist and are half-wired.
2. **What is unfinished** — capability genuinely present but incomplete.
3. **What is absent** — systems with no implementation at all.

For each item, one further judgement: **engine (C++) or datapack (Lua/TOML/XML/map)?** Much of what
looks unfinished here is data, not code, and that determines who can fix it and how fast.

Every claim carries a `file:line` citation. Where the README disagrees with the checkout, the
checkout wins and the disagreement is recorded.

---

## A correction, recorded

The planning pass that produced this document made one finding that **failed verification**, and it
concerned the `WEAPON_FIST` work in flight at the time. It is kept here rather than quietly deleted,
because the reasoning error is worth not repeating.

> **Claimed:** the `WEAPON_FIST` change forgets the dual-wield path — `src/player.cpp:4211`
> enumerates only `WEAPON_SWORD`, `WEAPON_CLUB` and `WEAPON_AXE`, so an off-hand fist weapon would
> never strike and never advance `SKILL_FIST`.

**That code is unreachable.** Four lines above, `src/player.cpp:4204` guards the entire block with
`if (g_itemEvents->hasWeaponBehavior(secondaryTool))`, and `hasWeaponBehavior`
(`src/itemevents.cpp:1896-1914`) returns `true` unconditionally for sword, club, axe, distance and
ammo. The `else` arm has been dead for every melee weapon since well before fists existed — it can
only be reached by a wand without a script, a quiver, or `WEAPON_NONE`.

A fist weapon therefore takes the `useAsWeapon` path into `useMeleeWeapon`
(`src/itemevents.cpp:1664-1712`), which strikes, then calls `GetMeleeSkillType` — returning
`SKILL_FIST` — and passes it to `OnUsedWeapon`. Off-hand fist weapons attack and train correctly with
no further change.

The lesson: a `case` list read without its guard is not evidence of a gap.

---

## 1. What is wrong

### 1.1 Engine defects

None of these carries a TODO marker. That is the most useful thing to know about the TODO list.

**D-1 — `DBTransaction::begin()` unlocks a mutex it never locked. Undefined behaviour.**
`src/database.h:207-210` sets `state = STATE_START` *before* calling `Database::beginTransaction()`.
`src/database.cpp:52-60` returns `false` **without locking `databaseLock`** when `BEGIN` fails. The
destructor at `src/database.h:197-201` then sees `STATE_START` and calls `Database::rollback()`,
which unconditionally calls `databaseLock.unlock()` (`src/database.cpp:66`, `:70`). Unlocking a
`std::recursive_mutex` not held by the calling thread is undefined behaviour. Reachable on any lost
or rejected connection at `BEGIN`.

The invariant to establish: *`state == STATE_START` implies this thread holds `databaseLock`* — which
is exactly what both the destructor and `commit()` already assume.

```cpp
bool begin()
{
	if (not Database::getInstance().beginTransaction())
		return false;

	state = STATE_START;
	return true;
}
```

**Engine. ~3 lines. Restart.**

**D-2 — a failed coin transfer destroys coins and writes a receipt saying they arrived.**
`Store::System::transfer` (`src/store.cpp:443-480`) debits the sender through the guarded
`removeCoins` path (`:463`), then credits the recipient with a bare `db.executeQuery(...)` whose
return value is discarded (`:470`), and writes the gift history row unconditionally (`:471`). If the
credit fails the coins are gone and the log says they were delivered. Contrast `ApplyCoinDelta`
(`src/store.cpp:73-104`), which does check.

The fix: check the credit, refund the sender on failure, and move `record(...)` and the recipient's
cache update *after* the check rather than before it.

**Engine. ~15 lines. Restart.**

**D-3 — a failed migration does not stop boot.**
`DatabaseManager::updateDatabase()` returns `void` (`src/databasemanager.h:17`) and `break`s out of
its loop on any failure (`src/databasemanager.cpp:91-92`, `:103-104`). `src/otserv.cpp:803` calls it
and ignores everything. The only thing between a half-migrated schema and a running server is the
single `ProbeBannedByName` check at `src/otserv.cpp:809`.

Proposed shape — a failed migration is an expected, operator-recoverable condition with a message
worth showing, so `std::expected` is the right error type:

```cpp
[[nodiscard]] static std::expected<int32_t, std::string> UpdateDatabase();
```

returning the version reached, or the version that failed and why, feeding `startupErrorMessage`.

**Behavioural change to announce: a server whose migration fails will now refuse to start where it
previously started degraded.** On three live worlds that is the correct trade, but it is a change.

**Engine. Small, but boot-gating. Restart.**

**D-4 — wheel gems that roll Dodge or Critical Damage do nothing.**
`Bonuses::damage`, `Bonuses::dodge` and `Bonuses::critical_damage` are accumulated
(`src/wheel.cpp:1254-1255`, `:1302`) and never read by any consumer. `System::apply`
(`src/wheel.cpp:1373-1432`) writes health, mana, magic, skills and capacity, then builds an augment
from `resistance`, `mitigation`, `life_leech`, `mana_leech` and `healing` (`:1407-1422`) — and skips
`damage`, `dodge` and `critical_damage` entirely. A player who paid for a Dodge or Critical Damage
gem gets nothing.

`critical_damage` maps cleanly onto `DamageModifier::AttackType::Critical`. `dodge` has **no**
counterpart in `DamageModifier::DefenseType` (`src/damagemodifier.h:90-106`), and `damage` has none
either — see open question Q1. Ship `critical_damage`; warn rather than silently drop the other two.

**Symmetry constraint:** `System::clear` (`src/wheel.cpp:1349-1369`) subtracts the snapshot in
`state.applied`. Anything added to `apply` must be subtracted in `clear`, or bonuses leak across every
relog.

**Engine. ~20 lines. Restart.**

**D-5 — the prey window lies to the client.**
`src/prey.cpp:78-90` is the only code that moves a slot out of `State::Locked`, and it does so only
for `slotId < 2` or `config.free_third_slot`. `config/prey.toml:14` ships `false`. Meanwhile
`src/protocolgame.cpp:3169-3173` tells the client `PreyUnlockState::Store` — "buy it in the store" —
and `StoreProduct::Kind` (`src/storewindow.h:24-30`) has only `Other`, `Mount`, `Outfit` and `Item`.
**No product kind exists that could ever unlock it.** Every player who opens the prey window is told
to buy something that cannot be bought.

Cheapest resolution is one character in `config/prey.toml:14`. See Q6 — this is a product decision.

**Config (or engine, if the slot is meant to be sold).**

**D-6 — a port above 65535 silently drops a listener on a single-world install.**
`src/otserv.cpp:977-1055` reads ports as the config's wide type, tests `!= 0`, then narrows with
`static_cast<uint16_t>`. The multi-world path partly guards this — `gameOrLoginBound` is computed from
the *post-cast* value (`:1015`, `:1024`, `:1037`, `:1050`) and `:1068-1073` refuses boot — but that
guard only fires when a shared auth schema is configured. A single-world install gets a silently
missing listener.

**Engine. Small.**

### 1.2 Datapack defects

**D-7 — placeholder text ships to players.** `data/npc/scripts/Seymour.lua:145` says, verbatim:
`Hmmm, let me look at you. <missing message, destiny for paladin>!`. `data/npc/scripts/Arkulius.lua:136`
carries an inline `-- < Knight; FIXME !!!`.

**D-8 — six NPCs still tell players there are four vocations.** `Seymour.lua:85`, `Cipfried.lua:52`,
`Oressa.lua:52`, `Gregor.lua:252`, `Muriel.lua:299`, `Elane.lua:295`. The monk is live; these are stale.

**D-9 — WITHDRAWN. `|STATE|` is a working substitution token, not a placeholder.**
The original finding claimed 20 quest-log missions ship a literal `|STATE|` to players.
`Mission::getDescription` (`src/quests.cpp:13-22`) replaces `|STATE|` with the player's current
storage value before the description is sent. Every one of those 20 entries is a kill-count task
(`start = 0, end = 20`) that renders as, for example, "Task: A Toll on Trolls: 7". They are correct
content and need no work.

The error: a token was assumed to be a placeholder on the strength of its appearance, without
reading the one function that consumes it.

**D-10 — a monster asks for a creature event that does not exist.**
`data/scripts/monsters/monsters/canary/quests/soul_war/normal_monsters/furious_crater/cloak_of_terror.lua:31`
registers `"CloakOfTerrorHealthLoss"`; nothing in the tree defines it.

**D-11 — the last duplicate item-event registration.** The First Dragon lair entrance door needs an
action id on the map (`docs/plans/quest-programme.md:254`, `:261-265`).

### 1.3 Documentation defects in the source

- `src/protocolprofile.h:64` says each modern side system "is a stub until its phase lands". **Stale** —
  six of them (prey, bestiary, wheel, forge, store, cyclopedia) are implemented. Their feature bits are
  simply never read.
- `src/networkopcodes.h:54` says `// missing = 0x86` while `ConfigureShowOffSocket = 0x86` is declared
  at `:199`. `:109` says `// missing = 0xEE` while `Greet = 0xEE` is declared at `:174`.

### 1.4 The TODO/FIXME list, assessed

Eleven of the twelve markers in `src/` are cosmetic or cold-path. **Marker density is not defect
density in this tree** — every defect in §1.1 is unmarked.

| Marker | What | Verdict |
| --- | --- | --- |
| `src/globalevent.cpp:187` | `getEventMap` returns by value | One caller (`src/game.cpp:7228`), fires on a players-online record. **Not worth doing.** |
| `src/otserv.cpp:1087` | Load timings on the console | Cosmetic. **Not worth doing.** |
| `src/condition.cpp:1309` | Metrics record the formula tick, not HP lost | Metrics fidelity only. Low. |
| `src/condition.cpp:1912` | 8-bit colour/level serialisation | A format change needing a migration, for two bytes. **Not worth doing.** |
| `src/chat.cpp:80` | Guild channels hard-coded | Low. |
| `src/game.cpp:7521` | Debug assertions to the database | Low; the 15.25 client no longer sends them. |
| `src/luascript.cpp:5394` | `catch (...)` too broad | Real but low. |
| `src/luascript.cpp:25479` | `reload` does not recurse | Low. |
| `src/protocolgame.cpp:4630` | Market detail omits chance-to-hit/range | Cosmetic. |
| `src/player.cpp:2156` | Offline-training modal id hard-coded | Moot — offline training is unimplemented. |
| `src/const.h:315` | `MESSAGE_STATUS_CONSOLE_BLUE` | A comment. |
| `src/protocolprofile.h:64` | "stub until its phase lands" | Stale documentation, not a code defect. |

---

## 2. What is unfinished

| Item | Engine or data | State |
| --- | --- | --- |
| **Bestiary** | **Datapack** | Engine complete (`src/bestiary.cpp:237-363`, bound at `src/luascript.cpp:21228-21253`). **741** monster files carry a `bestiary = {` block, measured. The shortfall is ~950 Lua blocks. |
| **Cyclopedia combat pages** | **Engine** | All four pages answer; every bonus column is a literal zero. See §2.1 — this is plumbing, not a missing subsystem. |
| **Market** | **Engine + migration** | Full 15.25 flow works. Tiered items cannot be *listed at all*. See §2.2. |
| **Wheel** | **Engine + datapack** | Slots, gems and stat bonuses apply. Of eight wheel Lua bindings (`src/luascript.cpp:2912-2924`), **only `unlockWheelScroll` has a caller** — `data/scripts/itemevents/use/others/promotion_scrolls.lua:5`. Perks, instants and stages reach nothing. |
| **Quest content** | **Both** | 726 of 978 installed; ≥239 held back. `docs/plans/quest-programme.md`, Phases 0-5 plus 1b, all outstanding. |
| **NPC quest givers** | **Datapack + harness** | 69 NPCs greet but never hand out a quest. `quest-programme.md:271-330`, Phase 1b. |
| **Monk** | **Both** | Vocation, Oracle and Dreadnought, wheel mapping, 7 spells and potions landed. Outstanding: 25 spells (unspecified), outfit looktypes (blocked — 1,443 unnamed appearances, wiki unreachable), Harmony/Mantra (not started). |
| **`WEAPON_FIST`** | **Both** | Engine implemented; 29 items in `data/items/items_1525.toml` declare `weapontype = "fist"`. The gating script `data/scripts/itemevents/weapons/Melee/fists.lua` is deliberately unwritten pending a decision on levels and monk-exclusivity. |
| **Protocol profiles** | **Engine** | 4 declared, 1 tested. `src/protocolprofile.h:149-151` states in-source that 13.40/14.12 reuse the 15.25 login layout and are "ASSUMED until a mehah capture confirms them". **19 of 32 `ProtocolFeature` bits are never read anywhere in `src/*.cpp`.** Everything else branches on `usesModernLayout()` (`src/protocolgame.h:543-545`), which tests the generation, not a feature. |
| **Test coverage** | **Engine** | Transport, ids and world identity only. |

### 2.1 The Cyclopedia zeros are plumbing, not missing systems

This is the largest correction to the roadmap's own framing.

Counting literal zeros: `sendCyclopediaCharacterCombatStats` ~20 (`src/protocolgame.cpp:2719-2768`),
`...OffenceStats` ~65 (`:2976-3045`), `...DefenceStats` ~18 (`:3047-3079`), `...MiscStats` 12+
(`:3081-3105`). Well over 100, not the ~57 the README claims.

**But the comment at `src/protocolgame.cpp:2973-2975` — "this server has none of those systems" — is
false.** The engine already computes every number those pages want:

- `DamageModifier::AttackType` (`src/damagemodifier.h:70-88`) has `Critical`, `Lifesteal`,
  `Manasteal`, `Piercing` (armour penetration) and `Conversion`.
- `DamageModifier::DefenseType` (`src/damagemodifier.h:90-106`) has `Reflect`, `Resist` and `Weakness`.
- Both are summed per type into `ModifierSum` (`src/damagemodifier.h:287-295`) inside
  `BlackTek::ModifierCache` (`src/player.h:135-155`), already exposed through three public
  `[[nodiscard]] noexcept` accessors: `getMainAttackModSums()`, `getMainAttackModPostSums()`,
  `getMainDefenseModSums()` (`src/player.h:399-415`).
- `src/player.h:141` carries the matching TODO in so many words: *"make the critical chance and value
  stored here, show in client"*.
- The wheel column has its own source in `Bonuses` (`src/luascript.cpp:13240-13247`).

Filling these is a read from existing getters. No new type, no new state. The `imbuement`,
`concoction` and `event` columns stay zero **because those systems genuinely do not exist** — a zero
there is honest.

**Hard constraint:** every field written must keep the same wire width and order. This layout is
verified against a real client; only the value may change.

### 2.2 The market tier framing is wrong

The README says "every item goes out with tier 0", which reads as silent data loss. It is not.

`addMarketItemId` writes a hard zero tier (`src/protocolgame.cpp:6382-6386`) and `getMarketItemId`
skips the incoming byte (`:6399-6403`). But a forged item can never reach the market in the first
place: `Item::setForgeTier` stores the tier as an `ITEM_ATTRIBUTE_CUSTOM` entry
(`src/item.h:834-845`), and `Item::hasMarketAttributes()` returns `false` for any attribute that is
not `CHARGES` or `DURATION` (`src/item.cpp:2478-2493`). Both the depot ware list
(`src/protocolgame.cpp:4415`) and the sell-side collector (`src/game.cpp:7991`) filter on it.

**Accurate statement: tiered items cannot be listed at all, and the wire tier byte is a placeholder.**
Nobody loses a tier. See §5 for why this should be deferred indefinitely.

---

## 3. What is absent

No engine file, no data, no handler. The only trace is a name in `src/networkopcodes.h` and, in a few
cases, a zero written to the client so the packet layout stays valid.

Measured against `parsePacket` (`src/protocolgame.cpp:930-1042`) and the `ClientCode` enum
(`src/networkopcodes.h:12-231`): **44 declared opcodes have no `case` at all**, plus three with an
empty body — `JoinAggression` (`:987`), `UpdateTile` (`:1007`), `GetObjectInfo` (`:1026`). The
README's "45" is accurate.

| System | Opcodes | Note |
| --- | --- | --- |
| Imbuements | `0x60, 0xB2, 0xD5, 0xD6, 0xD7` | `imbuement` appears in `src/` only as comment text and appearance-protobuf fields. |
| Bosstiary | `0xAE, 0xAF, 0xB0, 0xC2` | Shares boss-cooldown state with quest Phase 2 — build it *after*. |
| Quick loot & stash | `0x28, 0x8F, 0x90, 0x91, 0x95` | `src/protocolgame.cpp:2813`, `:2858` send empty stash columns "until those systems exist". |
| Depot search | `0x29, 0x92, 0x93, 0x94` | |
| Analytics & social | `0x2B, 0x2C, 0x2D, 0xB1, 0xDF` | Party analyser, team finder, highscores, VIP groups. |
| Cyclopedia extensions | `0xAD, 0xDB` | House auction, map. |
| Podiums | `0x86, 0x9F` | |
| Hirelings | `0xEC` | `src/protocolgame.cpp:2952-2954` sends three zeros. |
| Task hunting | `0xBA` | |
| Weapon proficiency | `0xB3` | `src/protocolgame.cpp:3114` sends a zero. |
| Misc client chatter | 13 more | `0x01, 0x2E, 0x38, 0x63, 0x74, 0x75, 0x76, 0x81, 0x9C, 0x9D, 0xC1, 0xC8, 0xEE, 0xFF` |

Also absent, outside the opcode table:

- **Offline training** — `ClientCode::StartOfflineTraining = 0x74` has no case.
- **Reward chest collect.**
- **Raids for this map** — only `data/raids/example_raids.toml` exists, three upstream demos.
- **Monk Harmony/Mantra** — only the protocol byte exists (`ProtocolFeature::MonkMantra`,
  `src/protocolgame.cpp:3063-3066`), which writes a zero.

Canary's Hazard ladder is already ruled out (`quest-programme.md:177`).

---

## 4. Constraints

1. **Three worlds are live.** An engine change costs a rebuild plus three restarts; a datapack change
   mostly lands with `/reload`. This is the single biggest ranking input.
2. **`CONTRIBUTING.md` binds every line proposed here** — `and`/`or`/`not`, named casts,
   `noexcept`/`[[nodiscard]]` by default, `BlackTek::Console` for output, PascalCase namespace-scope /
   snake_case members / camelCase locals.
3. **No new `virtual` methods.** Nothing here adds one.
4. **Quest ids go to the client.** `Quests::loadFromToml` assigns `++id` in sorted-path order
   (`src/quests.cpp:139-161`); perturbing file ordering scrambles every player's quest log.
5. **`hasMarketAttributes` is load-bearing for market safety.** Any script can write any custom key
   (`src/item.h:475-485`), so widening it must whitelist the forge-tier key alone — never blanket-allow
   `ITEM_ATTRIBUTE_CUSTOM`, or arbitrary scripted state starts trading.
6. **The wheel augment is rebuilt wholesale.** `apply` and `clear` must stay symmetric or bonuses leak
   across relogs.
7. **`WEAPON_FIST` numbering is persisted.** `src/const.h:499-501` records that the enum was appended
   rather than inserted because a `uint16_t` mask and private datapack content may persist the order.
   Do not renumber.
8. **The 15.25 client is the only client.** Legacy profile support is decided against
   (`README.md:136-137`).

---

## 5. Work order

Sizes are rough dispatch counts. "Restart" means all three live worlds.

### Tier A — datapack and config, reload-only, minutes each

| # | Step | Kind | Done when |
| --- | --- | --- | --- |
| A1 | Fix the six four-vocation lines and Seymour's placeholder (D-7, D-8) | Datapack | `/reload npcs`; each NPC names five vocations; no `<missing message` string remains in `data/npc/`. Reading the greeting is not evidence — the vocation line must be read. |
| A2 | `CloakOfTerrorHealthLoss` — write the script or drop the line (D-10) | Datapack | No boot warning for that event name. |
| A3 | First Dragon lair entrance action id (D-11) | Map + datapack | Zero duplicate item-event registrations at boot. |
| A4 | `free_third_slot = true` in `config/prey.toml:14` (D-5) — **pending Q6** | Config | A fresh login shows three usable slots and the client takes the `None` branch at `src/protocolgame.cpp:3172`. **Behavioural change: every player gains a slot they did not have.** Config loads at `src/otserv.cpp:943`; check Q8 before promising no restart. |

**A1 and A2 are the cheapest player-visible wins in the tree.**

### Tier B — small engine fixes, correctness stakes, one restart

| # | Step | Done when |
| --- | --- | --- |
| B1 | `DBTransaction::begin()` UB (D-1) | A forced `BEGIN` failure leaves no unlock-of-an-unheld-mutex and does not roll back; transaction tests still pass. |
| B2 | Coin transfer refund + ordered history (D-2) | A forced credit failure refunds the sender, writes no gift row, and logs through `Console::Database::Error`. |
| B3 | `UpdateDatabase` returns `std::expected`; boot refuses on failure (D-3) | A deliberately broken migration on a scratch schema refuses boot and names the version. **Flagged: a previously-degraded boot now fails.** |
| B4 | Apply `critical_damage`; warn on unappliable `dodge`; decide `damage` (D-4, Q1) | A Critical Damage gem measurably raises critical output; `clear` subtracts exactly what `apply` added across a relog; a Dodge roll logs once rather than silently doing nothing. |
| B5 | Port narrowing guard on the single-world path (D-6) | A configured port of 65536 refuses boot with a named message instead of binding nothing. |
| B6 | Correct the stale comments (§1.3) | The comments describe the tree. Fold into another dispatch; not worth its own restart. |

### Tier C — medium engine, high visible value

| # | Step | Size | Done when |
| --- | --- | --- | --- |
| C1 | Fill the Cyclopedia combat pages from existing data (§2.1) | 2-3 dispatches | Crit chance, crit damage, life/mana leech, armour penetration, reflection, elemental resistance, mitigation and the wheel columns show real numbers against a real 15.25 client; the wire layout is byte-identical in width and order; the false comment at `:2973-2975` is gone. |
| C2 | Wheel perks and instants reach gameplay | 3-5 dispatches | At least one perk and one instant per vocation produce an observable effect. **Blocked on Q2.** |

### Tier D — standing programmes

| # | Step | Size | Note |
| --- | --- | --- | --- |
| D1 | `quest-programme.md` Phase 1b — 69 NPC quest givers | 4 dispatches | Independent of Phase 1, lands with `/reload npcs`. The plan itself calls it the cheapest player-visible win in the programme. **Run before Phase 1.** |
| D2 | `quest-programme.md` Phase 0 — grader + duplicate naming | 2 dispatches | Makes every later count trustworthy. Note the counts at `:344` are already stale against the pack-script retirement. |
| D3 | `quest-programme.md` Phases 1-5 | ~28-34 dispatches | Declarative content system, persistent state, 42 boss rooms, then Soul Pit and Soul War. |
| D4 | Bestiary entries for the ~950 monsters without one | Large, batchable | Pure data entry; parallel with everything. Unlocks charms and prey across the map. |
| D5 | Monk completion — 25 spells, outfit looktypes, Harmony/Mantra | Large | Spells unspecified, outfits blocked, Mantra not started. |
| D6 | Map-switch migration — towns, positions, house ownership | Medium | `roadmap.md:73-80`. Confirm it still bites — see Q3. |

### Tier E — absent systems, none blocking

Start one only once Tiers A-C are clear. Ascending cost: **quick loot and the stash** (the client asks
constantly and gets nothing), **depot search**, **bosstiary** (after D3 Phase 2, which builds the
boss-cooldown state it needs), **imbuements**, **highscores**, **party analyser**, **podiums**,
**task hunting**, **hirelings**, **weapon proficiency**, **raids for this map**.

### Tier F — on the list and not worth doing

- `src/globalevent.cpp:187`, `src/otserv.cpp:1087`, `src/condition.cpp:1912`, `src/const.h:315` — see §1.4.
- **Market item tiers.** The honest cost is a schema migration, a widened `MarketOffer`/`MarketOfferEx`,
  every `IOMarket` query, the wire byte, and a carefully whitelisted `hasMarketAttributes` — to enable
  trading a category of item that currently simply isn't tradeable. **Lowest value-per-effort on the
  whole list. Defer indefinitely.**
- **13.40 / 14.12 profile support.** Already decided against.

---

## 6. Open questions

**Q1 — what should the wheel's `Bonuses::damage` and `Bonuses::dodge` do?** `damage` is accumulated by
revelation stages (`src/wheel.cpp:1302`) and `dodge` by gems (`:1254`); neither has a `DamageModifier`
counterpart that fits — `DefenseType` (`src/damagemodifier.h:90-106`) has no dodge. *Resolve by asking.*
Do not invent a mechanic. Until answered, B4 ships `critical_damage` only.

**Q2 — what does each wheel perk and instant do?** `src/wheel.cpp:143-157` names 5 instants and 15
perks per vocation including the five Avatars, and `src/wheel.h:239-295` declares the enums — but
nothing in the tree says what any of them *does*. C2 cannot start without a specification. Same class
of blocker as the Monk's 25 spells.

**Q3 — is the map-switch migration (`roadmap.md:73-80`) still outstanding?** `roadmap.md` predates the
multi-world cutover and three live worlds with real characters. *Resolve by* reading `data/migrations/`
above version 8 and checking `players.town_id` on a live schema.

**Q4 — how many monster definitions are there?** 741 carry a bestiary block (measured). `README.md:71`
says 1,696 loaded; `README.md:85` and `roadmap.md:190` imply 1,713. The README disagrees with itself by
~17. Does not change the ranking — the shortfall is ~950 either way.

**Q5 — should the 29 fist weapons be monk-exclusive, and at what levels?** Not derivable from the
repository. Blocks `data/scripts/itemevents/weapons/Melee/fists.lua`.

**Q6 — is the third prey slot meant to be free, or sold?** A4 is one character either way; the
alternative is a real `StoreProduct::Kind` plus a persisted per-character unlock flag — ~2 dispatches
and a migration.

**Q7 — the unexplained segfault** (`README.md:92`, `roadmap.md:254`): after ~8 hours under 20,000-bot
load, never reproduced. Not actionable without a core dump. *Resolve by* running with a core-dump policy
and `Black-Tek-Server.sym` ready, so the next occurrence is diagnosable. A monitoring change, not a code
change.

**Q8 — does prey config have a reload path?** A4 changes a config read at `src/otserv.cpp:943` with no
reload path found. Check `RELOAD_TYPE_*` in `src/game.cpp` before promising A4 lands without a restart.

---

## 7. Validation

Per-step criteria are in §5. Beyond those:

- **Tier A** needs a `/reload` plus one client session per changed NPC or quest. A greeting is not
  evidence for A1 — the vocation line must be read on screen.
- **B1** — force `BEGIN` to fail (point the connection at a closed server mid-transaction) and confirm
  no abort and no unlock of an unheld mutex. There is no measurement to make and none should be claimed.
- **B2** — force the credit query to fail; confirm the sender's balance is whole, the recipient's
  unchanged, and `store_history` has no gift row.
- **B3** — a deliberately broken `data/migrations/<n>.lua` on a scratch schema must refuse boot and name
  the version.
- **B4** — verify symmetrically: apply, relog, confirm `state.applied` subtracts exactly what was added.
  A leak here compounds across every relog.
- **C1** — `harness/capture_proxy.py` and `packet_diff.py --decode` against a real 15.25 client, comparing
  the four cyclopedia packets byte-for-byte in *length* against the current build. Any length change is a
  bug, not a feature.
- **No performance claim is made anywhere here, and none is needed.** Every path touched runs on a player
  request, not in a loop.
