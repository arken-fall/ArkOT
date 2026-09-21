# Avarion — feature list

Every feature of the game, what state it is in, what a player gets from it, and what work it
needs **on the map** rather than in code. Generated against commit `9c0ff1f`.

Companion lists, where a percentage rests on a count big enough to name:
[`bestiary-coverage.md`](bestiary-coverage.md).

---

## How to read this

**The bars are two different kinds of number, and the label says which.** A count and an opinion
should not look alike.

| Label | Means | How to check it |
| --- | --- | --- |
| **(C) Counted** | A ratio of two real counts in the tree. No opinion in it. | Re-run the cited pattern. |
| **(B) Binary** | It exists or it does not. 0% or 100%. | One citation. |
| **(J) Judgement** | A weighted estimate over named parts. Each part is cited; the weighting is a call. | Stated so you can re-weight it. |

🟩 90%+ · 🟨 60-89% · 🟧 30-59% · 🟥 under 30% · ⬜ remaining

A bar that says 60% where nobody can say what the 60 counts is worse than no bar, so judgement
figures name their parts.

---

# Part 1 — Map actions

Everything below is work in the **map**, not the code: action ids, unique ids, tile flags,
spawn positions, teleport destinations. Ordered by how directly it blocks a player.

> **The single biggest item on this list is #6.** `Zone::RunBossTriggered` implements the whole
> boss-room lifecycle — entry, bounds, teleport, master spawn, minion delays, despawn, restore,
> cooldown (`src/zones.cpp:1577-1700`, `:807-847`) — and **not one of your 16,690 zones uses it.**
> Every single one is `policy = "fixed"`, verified by counting. Roughly 42 boss rooms are pure
> data against an engine that is already finished, and they are what hold back most of the 239
> quest scripts still on the shelf.

| # | Map action | Evidence | Size |
| --- | --- | --- | --- |
| 1 | **Action id on The First Dragon's lair door at `33047,32712,3`, and the return door at `31994,32390,9`** — then change `lairEntrance:id(25160)` to `:aid(<that id>)` | `data/scripts/quests/the_first_dragon/actions_lair_entrance.lua:9,13,21` | Minutes. Clears the last duplicate item-event registration at boot. The teleport destinations are already written, so nothing else moves. |
| 2 | **Audit the nine Rookie Guard tile action ids** — 50312, 50319, 50321, 50323, 50325, 50335, 50336, 50351, 50352 | `data/scripts/quests/the_rookie_guard/missions.lua:239` | Hours. Affects every new character. A wrong id means the player walks past with no message, no arrow, and no way to know. |
| 3 | **Verify the four Monk shrines (item 50242)** at `32046,31861,5`, `32082,31879,5`, `32048,31888,6`, `32067,31915,6` | `data/scripts/quests/the_way_of_the_monk/shrines_dawnport.lua:2-5,36` | Minutes. Registered by absolute position — a shrine one tile out is a dead quest step with no error. |
| 4 | **Correct id or action id for two quest items on this map** — the New Frontier beaver (9843 is a lit wall lamp here) and the Ferumbras grave flower (22873 is a candle) | `docs/plans/quest-programme.md:249,253` | Hours. |
| 5 | **Author real raids**, or leave them off | `data/raids/README.md` | Hours. The engine is finished; it needs coordinates. See 7.5. |
| 6 | **~42 boss rooms** — per room: lever action id, entry tiles, room bounds, teleport-in and exit destinations, master and minion spawn positions, cooldown. Authored as `policy = "triggered"` zones | `src/zones.cpp:1577-1700` (engine ready), `docs/plans/quest-programme.md:46-47` | **The largest block of content work on the server.** Unlocks ~239 held-back quest scripts and gives the 139 bosstiary-marked monsters somewhere to be fought. |
| 7 | **A reward chest tile in each new boss room** | `src/itemevents.cpp:2281-2352` | Folds into #6. |
| 8 | **Quest-door action id sweep** — every quest door's action id must equal the storage key its quest writes | `data/scripts/doors/door_lib.lua:542-548` | Systematic and scriptable: diff the OTBM's door action ids against `data/lib/canary/storages.lua`. A mismatched door is sealed forever; a door with action id 0 tells nobody why. |
| 9 | **Town, temple, position and house-ownership migration** from the OTBM's own town list | `schema.sql:323,741-747`; `data/migrations/` stops at 8 | Medium. Also unblocks wheel respec, which needs a correct temple within 10 tiles. |
| 10 | **PvP, protection and no-logout zone flags** — 12 flag zones exist across 17.9M tiles | `README.md:69` | Medium. Arena floors, war zones and any planned open-PvP area are unflagged. |
| 11 | **Per-town service audit** — depot, banker, spell teacher, and bed-bearing houses in all 19 towns | `data/world/canary-zones/`, `data/world/canary-house.xml` | Hours. A bedless town means no offline training for its residents. |
| 12 | **Bigfoot's Burden warzone rooms** and the Versperoth spawn position | `docs/plans/quest-port-gaps.md:20-27` | Folds into #6. |
| 13 | **Sources for the 97 mounts with no in-world grant path** | `config/mounts.toml`, `data/scripts/store/store.lua:187-189` | Design decision before map work. |
| 14 | **Re-verify three Wrath of the Emperor levers** and the addon-quest ids before re-enabling their disabled pack counterparts | `data/scripts/realmap/**/#*.lua` | Hours. This is the pack-versus-port collision class: five times out of six, the ported script was the one watching the wrong item. |

### Two one-line datapack fixes worth folding into the same pass

- **The Carnage charm costs 4,500 points and does nothing.** `config/charms.toml:270-278` — a
  major charm at 600/900/3000, joint most expensive in the game, with no `modifiers` block. Nine
  other charms are also inert, but Carnage is the one that can eat a player's whole budget. What
  it *should* do is a balance decision, which is why it is listed rather than fixed.
- **Five bestiary race-id collisions** — the butterfly variants and the Druid's/Monk's Apparition
  pair share ids, so one of each pair is unreachable in the bestiary.

---
# Part 2 — Features

## 🟩 1. Character & progression

### 1.1 Vocations

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (C)

**Evidence.** 5 of 5 vocation TOMLs present with both tiers (`data/vocations/`). The deduction is the Monk's missing content, counted separately in 1.2.

**Description.** Five playable vocations, each promoting: Knight/Elite Knight, Paladin/Royal Paladin, Sorcerer/Master Sorcerer, Druid/Elder Druid, and Monk/Exalted Monk. Per-level HP, mana and capacity, regeneration intervals, skill rates and damage modifiers are all data. Promotion, the Oracle and Captain Dreadnought all work, and six NPCs now say "five vocations" rather than four.

**Rewards.** Access to vocation-gated spells, weapons and wheel layouts. Promotion doubles regeneration and soul capacity.

**Map actions needed.** None for the four classic vocations. For Monk, see 1.2.

### 1.2 Monk vocation completion

🟧🟧🟧⬜⬜⬜⬜⬜⬜⬜ **30%** · (J)

**Evidence.** Counted parts: vocation TOML 1/1; wheel mapping present (`src/wheel.cpp:156-158`); potions gated in 5 entries; **spells 7 of ~32, and all 7 are shared utility spells** — light, great light, haste, levitate, magic rope, find person, cure poison; **monk-exclusive spells 0**; **augments 0** (`data/augments/` has the other four vocations and no `monk.toml`); **outfits 0**; **Harmony/Mantra 0** (`src/protocolgame.cpp:3063` writes a literal zero); **store starter kit 0**.

**Description.** The fifth vocation is playable end to end: a character can be created, reach level 8, be sent by the Oracle, choose Monk, level, train Fist Fighting, promote, and turn the wheel. It has no magic of its own, no visual identity and none of its signature mechanic. The vocation file says so itself.

**Rewards.** Fist Fighting as a primary skill, knight-tier capacity with paladin-tier regeneration, and the Avatar of Balance wheel branch. No unique spell, outfit, augment or currency.

**Map actions needed.** **Map action #3.** The Way of the Monk quest needs the four Dawnport shrine items present at their exact tiles — the script registers by absolute position, so a shrine one tile out is a dead step with no error.

### 1.3 Skills, levels and experience

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (B)

**Evidence.** Seven skills persisted with try counts (`schema.sql:347-360`), magic level via `manaspent`, experience as `bigint unsigned`, stages and rates configurable.

**Description.** The whole progression curve. `SKILL_FIST` trains correctly, including from an off-hand fist weapon.

**Rewards.** Levels, skills, magic level — the core loop.

**Map actions needed.** None.

### 1.4 Offline training

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (J)

**Evidence.** The bed path is complete: `src/itemevents.cpp:2220-2251`, the modal window (`src/game.cpp:95-104`), the answer handler (`:8060-8073`) and `data/scripts/creaturescripts/offlinetraining.lua`. 12-hour cap enforced. Missing: the client-initiated `StartOfflineTraining = 0x74` has no handler.

**Description.** Sleep in a house bed as a premium character, choose a skill from a modal window, log out, and the time accrues as training tries. Shielding trains alongside. **This corrects an earlier audit of mine that called offline training absent — it is not; only the client-initiated entry point is.**

**Rewards.** Skill and magic-level tries, up to 12 hours per bed session.

**Map actions needed.** **Map action #11.** House beds must exist and be reachable — a town whose houses ship with no beds offers its residents no offline training.

### 1.5 Wheel of Destiny

🟧🟧🟧🟧🟧🟧⬜⬜⬜⬜ **55%** · (J)

**Evidence.** 36 slots, gems, stat application and persistence are real — four tables (`schema.sql:609-661`), gem atelier and open/save all handled. **Perks and instants: 0 of 25 reach gameplay** — 16 perk and 9 instant names are declared (`src/wheel.cpp:144-153`) and of eight wheel Lua bindings only `unlockWheelScroll` has a caller. `critical_damage` now applies; `dodge` and `damage` are still earned and dropped, now warning once rather than silently.

**Description.** From level 51 a promoted premium character spends a point per level across 36 slots. Health, mana, magic level, skills, capacity, resistance, mitigation, leech and healing all apply for real. What does not exist is the half players actually talk about: the five Avatars, Executioner's Throw, Divine Grenade, Battle Instinct and Sanctuary are names in an enum with no behaviour behind them. A separate defect that made every wheel modifier double on each login was fixed in `6d4323d`.

**Rewards.** Real stat gains and gem-driven modifiers. Scrolls grant 3/5/9/13/20 points. No perk, instant or Avatar reward exists yet.

**Map actions needed.** **Map action #9.** Respec is gated on standing within 10 tiles of a temple, inside its protection zone, so every town's temple position and PZ flag must be right or its residents can never take points back.

### 1.6 Blessings

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **75%** · (J)

**Evidence.** 6 blessings implemented, named and persisted; dialog handled; sold in the store and by NPC. Modern Tibia ships 8 — the two mountain blessings are absent. The wire sends the count dynamically, so adding them is data plus two array entries, not a protocol change.

**Description.** Six blessings reduce death penalty, bought with gold or coins.

**Rewards.** Reduced experience and skill loss on death; equipment retention.

**Map actions needed.** If blessings are to be bought in-world rather than only from `bless.lua`, their NPCs or shrines need spawn entries.

### 1.7 Outfits and addons

🟨🟨🟨🟨🟨🟨🟨⬜⬜⬜ **70%** · (J)

**Evidence.** 110 outfits defined, ownership persisted, request and set handled, 3 sold in the store. Blocked: Monk looktypes cannot be chosen because 1,443 client appearances are unnamed.

**Description.** Outfits and their two addons work. Three addon-granting quest scripts are among the 124 retired pack scripts.

**Rewards.** Cosmetic appearance and addons. Some outfits carry no stat effect at all, which is correct.

**Map actions needed.** **Map action #14.** Before the three disabled addon quests are revived, each id they register against must be checked against what it now *is* on this map.

### 1.8 Mounts

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (C)

**Evidence.** 100 mounts defined, taming and current-mount persistence, toggle handled, 3 sold in the store. **The store's three mount ids were wrong and are now fixed** (`9c0ff1f`) — it was selling Widow Queen as Racing Bird, Racing Bird as War Bear and Black Sheep as Midnight Panther, because `Store::System` tames by raw id.

**Description.** Mounts grant +20 speed and are premium-gated.

**Rewards.** +20 speed, cosmetic.

**Map actions needed.** **Map action #13.** 97 of 100 mounts have no in-world source at all — only three are purchasable and one box script grants others. If mounts are to be earned rather than bought, each needs a spawn, a taming item placement or a quest chest tile.

## 🟩 2. Combat and equipment

### 2.1 Core combat, formulas and conditions

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (B)

**Evidence.** Four damage resolutions configured independently — pvp, pvm, mvp, mvm, each with its own formula block (`config/combat.toml:90-112`) — plus multi-floor combat, stairhop delay, aimbot toggle and the full condition set.

**Description.** The fighting itself, and it is configurable per direction rather than one shared formula.

**Rewards.** The game.

**Map actions needed.** None.

### 2.2 Augments and damage modifiers

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (J)

**Evidence.** Engine complete: `AttackType` covers Critical, Lifesteal, Manasteal, Piercing, Conversion; `DefenseType` covers Reflect, Resist, Weakness (`src/damagemodifier.h:70-106`), summed per type and exposed through three accessors (`src/player.h:399-415`). Content: **15 vocation augments across 4 files, 0 for Monk, and 109 item augments**.

**Description.** This is the server's own signature system and it is deeper than stock Tibia: lifesteal, manasteal, deflect, ricochet, absorb, reflect, resist and conversion, applied per damage type with per-modifier chance, all driven from TOML. 109 classic items carry resistances.

**Rewards.** Real combat power — leech, crit, reflection, elemental resistance.

**Map actions needed.** None. This is item and vocation data.

### 2.3 Fist weapons

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (C)

**Evidence.** 29 items declare `weapontype = "fist"` and now load as real weapons (`9c1161b`); engine path complete. The gating script `fists.lua` does not exist, deliberately.

**Description.** 29 fist weapons load, strike, train `SKILL_FIST` and work in the off hand. The missing piece is the level and monk-exclusivity gate, which is your decision rather than work. Until then they are ordinary melee weapons anyone can wield.

**Rewards.** 29 equippable weapons that were silently inert before.

**Map actions needed.** If any of the 29 is meant to be a quest or boss drop rather than a shop item, that is a loot-table or chest-tile placement — worth deciding alongside the gating question.

### 2.4 Spellbooks

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (C)

**Evidence.** 21 items now carry `weapontype = "shield"`; the 8 retyped spellbooks are among them (`de0492c`).

**Description.** Eight spellbooks declared an unknown weapon type, which left them `WEAPON_NONE` — and with classic slots off, the off hand demands shield-or-quiver while the weapon hand rejects `WEAPON_NONE`, so **both hands turned them away**. They now equip, defend with the shield skill instead of a skill of zero, and take part in the shield-block paths.

**Rewards.** Eight previously unequippable items, including the whole eldritch and arcanomancer line.

**Map actions needed.** None.

### 2.5 Player spells

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **78%** · (C)

**Evidence.** ~183 player spell scripts load (388 files less 204 monster spells and one example). `roadmap.md:192` counts **51 player spells with no counterpart**, including the five wheel Avatars, the vocation familiars, Executioner's Throw and Divine Grenade. 183/234 = 78%.

**Description.** Attack, healing, support, conjuring and rune spells all work and are vocation-gated. The 51 absent ones are almost entirely the modern top end and the Monk's whole repertoire.

**Rewards.** Every spell a player buys from an NPC and casts.

**Map actions needed.** If the 51 land, each needs a seller — check the spell-teacher spawns cover every town (**map action #11**).

### 2.6 Monster spells

🟨🟨🟨🟨🟨🟨🟨🟨🟨⬜ **86%** · (C)

**Evidence.** 204 monster spell scripts exist; `roadmap.md:191` reports **40 spell names that 83 monsters ask for and nothing provides**, across 109 entries. 32 of the 40 need engine features first — chain combat, `CONDITION_ROOTED`, `CONDITION_FEARED`, damage callbacks — and 8 are scriptable today.

**Description.** Most monsters fight correctly. 83 fail to cast one or more of their signature attacks. The fight still happens; it is just easier and wrong.

**Rewards.** None directly — it affects difficulty, and therefore loot pacing.

**Map actions needed.** None.

### 2.7 PvP, skulls, death and war

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (B)

**Evidence.** Skull system configured, PvP experience range, death records, death penalty percent, and full guild war support: eight war states, war records, and two tables with cascading deletes (`src/guild.h:10-33`).

**Description.** Everything a PvP server needs at the mechanical level, including formal guild wars with kill ledgers.

**Rewards.** War kill counts, skull status, the PvP economy.

**Map actions needed.** **Map action #10.** 12 flag zones exist across 17.9M tiles. Protection zones, no-logout areas and PvP-enforced regions are tile flags — arena floors and war zones need theirs set.

## 🟨 3. Economy and trade

### 3.1 Market

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (J)

**Evidence.** Full 15.25 flow, all five opcodes handled, two tables, expiry sweep configured. The one gap: **tiered items cannot be listed at all** — `hasMarketAttributes()` rejects any attribute that is not charges or duration, and forge tier is stored as a custom attribute.

**Description.** Buy offers, sell offers, browse by category, own-offer list, history, depot-backed inventory. Works against a real client. Note the correction: the roadmap called this "every item goes out with tier 0", which reads as data loss. It is not — a forged item simply cannot be listed. Nobody loses a tier.

**Rewards.** The player-to-player gold economy.

**Map actions needed.** **Map action #11.** The market opens from a depot, so every town's depot must exist and be reachable.

### 3.2 In-game store

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (J)

**Evidence.** Engine complete — categories, offers, purchase, coin transfer, paged history, account-level coins. Content: **8 categories, 23 products**. Deductions: no Monk starter kit, and 3 outfits and 3 mounts out of 110 and 100.

**Description.** Starter kits, supplies, premium time, blessings, consumables, outfits and mounts. Coins live on the account and follow it across worlds. Two defects fixed this session: a failed coin transfer used to destroy the coins and log them as delivered (`3ceeea2`), and all three mount products delivered the wrong animal (`9c0ff1f`).

**Rewards.** Items into the store inbox, premium time, blessings, outfits, mounts, and coins transferable between accounts.

**Map actions needed.** None. But every `Category_*.png` and `Kit_*.png` named in `store.lua` must exist at the configured images URL or the client shows blanks — the same class of dangling reference, in web space rather than map space.

### 3.3 Exaltation forge

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (B)

**Evidence.** Fusion, transfer, dust-to-slivers, dust-limit increases and the convergence variants all implemented, with a history table, both opcodes handled and the full economy in config. Critically, **item eligibility comes from the client's own appearance data** (`src/appearances.cpp:65-68`), not a hand-written list.

**Description.** Tier items up to 10. Dust drops from kills, converts to slivers then cores. Because eligibility is read from the 15.25 asset set, every classified item is forgeable with no datapack work at all.

**Rewards.** Item tiers, which ride on the item permanently.

**Map actions needed.** None.

### 3.4 Bank, trade and gold

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (B)

**Evidence.** Account balance persisted, banker NPC present, player-to-player trade fully handled with proximity auto-close.

**Description.** Banking and direct trade both work.

**Rewards.** The gold economy.

**Map actions needed.** **Map action #11.** A banker in each of the 19 inhabited towns.

### 3.5 Depot, inbox and store inbox

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (J)

**Evidence.** Three real tables, depot limits configured. **Absent: the supply stash and depot search** — `src/protocolgame.cpp:2813` says in the source that stash and inbox columns "stay empty until those systems exist".

**Description.** Depot, inbox and store inbox all work. What a 15.25 player expects and does not get is the stash for bulk supplies and depot search across boxes.

**Rewards.** Storage.

**Map actions needed.** **Map action #11.** Depot tiles per town.

## 🟨 4. Social

### 4.1 Chat, channels and private messages

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **95%** · (J)

**Evidence.** Every chat opcode handled and configured. One known wart: guild channels are hard-coded (`src/chat.cpp:80`), assessed as low.

**Description.** All channel types, private messages, rule violation reporting.

**Rewards.** None material.

**Map actions needed.** None.

### 4.2 Parties and shared experience

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (J)

**Evidence.** Invite, join, revoke, pass leadership, leave and shared-exp all handled; shared exp recalculated on movement. **Absent: the party analyser** — `PartyAnalyzerAction = 0x2B` has no handler.

**Description.** Parties work fully. The client's analyser window — damage, healing, loot and supply per member — gets nothing.

**Rewards.** Shared experience.

**Map actions needed.** None.

### 4.3 Guilds

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (J)

**Evidence.** Five tables with auto-created ranks via trigger, war engine complete, and **66 guildhalls on the map**. Absent: `EditGuildMessage` and `VipGroupActions` have no handler.

**Description.** Guilds, ranks, halls and formal wars all work.

**Rewards.** Guildhalls, war kill records, ranks.

**Map actions needed.** **Map action #9.** The 66 guildhalls are declared with pre-map-switch ownership numbering; any whose house id collides with the retired map's needs reconciling in the same migration.

### 4.4 VIP list

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (C)

**Evidence.** 3 of 4 VIP opcodes handled — add, remove, edit. `VipGroupActions = 0xDF` is not. Account-level storage.

**Description.** The VIP list works; VIP *groups* do not.

**Rewards.** None material.

**Map actions needed.** None.

### 4.5 Highscores

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** `RequestHighscores = 0xB1` has no handler. No highscore query, table or cache anywhere in `src/`.

**Description.** The client has a highscores tab. It sends the request and is answered with nothing.

**Rewards.** None — this is the feature.

**Map actions needed.** None.

### 4.6 Team finder

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** `LeaderFinderWindow = 0x2C` and `MemberFinderWindow = 0x2D` have no handler.

**Description.** Absent.

**Rewards.** None.

**Map actions needed.** None.

## 🟨 5. Hunting, bestiary and prey

### 5.1 Bestiary

🟨🟨🟨🟨🟨🟨⬜⬜⬜⬜ **62%** · (C)

**Evidence.** **676 of 1,097 eligible monsters carry an entry.** Full derivation and both name lists in [`bestiary-coverage.md`](bestiary-coverage.md). The README's "741 of 1,712 = 43%" divides by every monster file, including 139 bosstiary-marked, 377 quest-only, 26 event, 16 raid and 13 boss monsters that were never meant to have one.

**Description.** Engine complete and persisted, four opcodes handled. 421 huntable monsters still cannot be tracked. Five race-id collisions make one of each colliding pair unreachable.

**Rewards.** Charm points, creature tracking, unlock thresholds — **and prey eligibility**, since prey draws its nine candidates from bestiary creatures. Every missing entry is also a monster that can never appear as prey.

**Map actions needed.** None. Pure datapack and reloadable. The `locations` field is prose, not coordinates.

### 5.2 Charms

🟨🟨🟨🟨🟨🟨⬜⬜⬜⬜ **60%** · (C)

**Evidence.** 25 charm runes defined; **15 carry a `modifiers` list, 10 do not**. The config file admits it: runes without modifiers "unlock and assign like the others and take effect once their system lands".

**Description.** Charm points buy runes in three tiers; an assigned rune becomes a real augment against that creature. 15 runes do something. The 10 that do not are Cripple, Adrenaline Burst, Numb, Cleanse, Bless, Scavenge, Gut, Fatal Hold, Void Inversion and **Carnage** — and Carnage is a major charm at 4,500 points total, so a player can spend the largest sum in the system and receive nothing.

**Rewards.** Per-creature combat modifiers, from 60% of the rune wall.

**Map actions needed.** None.

### 5.3 Prey

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (J)

**Evidence.** All three slots work and the third is now **free** (`47dfbc1`), which also stops the client being told to buy it from a store that has no product capable of selling it. Remaining deduction: prey can only offer monsters with a bestiary entry, so 5.1's shortfall caps the creature pool.

**Description.** Three slots, nine creatures each, four bonus types, two hours of bonus time, a free reroll every twenty, and wildcards for bonus rerolls and free selection.

**Rewards.** Damage boost, damage reduction, experience or loot bonus against a chosen creature; wildcards as a currency.

**Map actions needed.** None.

### 5.4 Bosstiary

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** **139 monsters already carry `monster.bosstiary` markers in the datapack.** Zero engine support: four opcodes unhandled, and `ProtocolFeature::Bosstiary` is never read.

**Description.** The data is there — 139 bosses classified and waiting. The system that reads it does not exist. It shares boss-cooldown state with the quest programme's persistence phase, so it should be built after that lands.

**Rewards.** None yet. When built: boss points, a kill ledger, a per-boss slot bonus.

**Map actions needed.** None beyond the boss rooms those 139 bosses live in — **map action #6**.

### 5.5 Task hunting

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** `TaskHuntingAction = 0xBA` has no handler. No table, no engine file.

**Description.** Absent.

**Rewards.** None.

**Map actions needed.** None.

### 5.6 Hunt analytics

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** `ProtocolFeature::HuntAnalytics` is declared and never read; the source names "the client's analyser windows: healing, damage by element, supplies" as the thing not fed.

**Description.** The kill, loot, supply and impact trackers all get nothing.

**Rewards.** None.

**Map actions needed.** None.

### 5.7 Loot

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (J)

**Evidence.** Loot tables, loot rate, the unique-item-to-top-contributor rule and reward-chest routing all work. `roadmap.md:195` counts **48 loot entries dropped** because the item has no id on this server.

**Description.** Loot works, including damage-weighted boss loot. Demonic matter, Mitmah pieces and similar simply never drop.

**Rewards.** Everything a monster drops.

**Map actions needed.** None.

## 🟧 6. Quests and bosses

**The standing numbers.** 726 quest scripts installed, **at least 239 held back across 55 quests**,
50 quest-log files with 369 missions. That is 75% of quest scripts. The held-back set is
dominated by **60 `BossLever` files** — 42 of them pure configuration.

> **Read this before the individual quests.** Most of these quests are not half-built. They are
> *finished except for the fight*. Ferumbras' Ascension has every puzzle working and ten bosses
> unreachable. The Secret Library has all five sub-areas and all four boss death scripts, and
> seven levers that do nothing. A player can complete the entire approach and hit a lever that
> does not respond. **This is map work (#6), not scripting.**

### 6.1 Soul War

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (C)

**Evidence.** `data/scripts/quests/soul_war/` does not exist; all **12** scripts held back. The monsters are ported and populated — nothing runs them.

**Description.** The endgame quest: Goshnar's seven aspects, the taint mechanic, the Ebb-and-Flow boat, the Claustrophobic Inferno. Rated ~4-5 dispatches after the persistence phase, with one known degradation — taint icons become a logged no-op because creature icons go out as a hard zero.

**Rewards.** None today. Intended: the Soulcutter and Soulshredder line, the Bag you Desire, taint-gated loot tiers.

**Map actions needed.** All of it — seven aspect boss rooms with entry tiles and bounds, the boat spots, the Inferno raid area, the entrance tiles and the reward-room teleport.

### 6.2 Soul Pit

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (C)

**Evidence.** `data/scripts/quests/soulpit/` does not exist; all **8** scripts held back.

**Description.** A staged arena driven by soul cores. Every input already exists in C++ — `stars` and `occurrence` on MonsterType, race-member lookup, forge classification — and is merely unbound to Lua. Rated ~4 dispatches.

**Rewards.** Intended: exalted cores, soul cores, animus mastery. None today.

**Map actions needed.** Arena bounds, staged spawn positions, the lever, entry and exit teleports.

### 6.3 Ferumbras' Ascension

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **75%** · (C)

**Evidence.** **46 active scripts, 1 disabled, 15 held back** = 75%. **10 of the 15 are `BossLever`**: Ferumbras, Mazoran, Plagirath, Ragiaz, Razzagorn, Shulgrax, Tarbaz, The Shatterer, Zamulosh and the rat lever.

**Description.** Every puzzle works — the flower puzzle, the colour levers, the nine habitat teleports, the bone flute, the teleportation rod, the gate of deathstruction. **Not one of the ten bosses can be fought.**

**Rewards.** None reachable. Intended: the Ferumbras hat, ascendant boss loot, the mysterious and purified soul chain.

**Map actions needed.** Ten boss rooms (**#6**). Plus the disabled grave-flower script needs the correct item or an action id — 22873 is a candle on this map (**#4**).

### 6.4 The Secret Library

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **83%** · (C)

**Evidence.** **38 installed, 8 held back** = 83%. **7 of the 8 are `BossLever`**: Ghulosh, Gorzindel, Lokathmor, Mazzinor, The Scourge of Oblivion, Brokul and Grand Master Oberon.

**Description.** All five sub-areas work — the museum, the high-and-dry boat puzzle, the lament asuras with its elemental portals, the path of defiances with its colour puzzle and totems, the Falcon order's doors. Every boss *death* script is installed. Only the levers that start the fights are missing.

**Rewards.** None reachable. Intended: the Falcon set, Oberon's loot, the library boss drops.

**Map actions needed.** Seven boss rooms (**#6**).

### 6.5 The First Dragon

🟨🟨🟨🟨🟨🟨🟨🟨🟨⬜ **88%** · (C)

**Evidence.** **15 installed, 2 held back** — the boss lever and the entrance teleport's cooldown check.

**Description.** The sacrifice chain, the five death scripts, the flower bowl, the heaven blossom, the treasure chest and the exit teleports all work. The lair door and the boss lever do not.

**Rewards.** None reachable. Intended: the treasure chest and the dragon's loot.

**Map actions needed.** **Map action #1, the sharpest single item in this document.** The lair script registers by item id 25160 — a generic closed door — so it claims every door of that type on the map and then loses the race to `normal_doors.lua` anyway. It is the last duplicate registration at boot. The script already checks two absolute positions, so the fix is exact: action id on the door at `33047,32712,3` and the return at `31994,32390,9`, then `:aid()` instead of `:id()`. The teleport destinations are already written.

### 6.6 Wrath of the Emperor

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **95%** · (C)

**Evidence.** **21 installed, 1 held back**, needing a single `Creature:getMonster()` binding.

**Description.** Twelve missions, all installed: the crate, the lights, the repair teleport, the Keeper, the snake sceptre, the mission-08 doors and lever, the sleeping dragon mixture, the message of freedom, payback time and just rewards. Boss deaths and the Zalamon kill all work. **One of the most complete large quests on the server.**

**Rewards.** Reachable today: the full mission chain and the emperor's loot.

**Map actions needed.** **Map action #14.** Three legacy pack levers are disabled and their ported replacements active — verify those three ids on this map, since that is exactly the collision class.

### 6.7 Bigfoot's Burden

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **78%** · (C)

**Evidence.** **22 installed, 7 held back**, on warzone config, boss cooldowns and config manager.

**Description.** All five gnome tasks work — ear, endurance, shooting, truffles, x-ray — plus the matchmaker, repair, extractor, mushroom, music, package, pig, spores, stone and crystal. **The three warzones and Versperoth do not.**

**Rewards.** Reachable: gnome rank progression and task rewards. Not reachable: warzone boss loot and the Versperoth chain.

**Map actions needed.** **Map action #12.** Three warzone boss rooms with entry teleports and crystal devices, the Versperoth spawn position, and the gnome base teleport.

### 6.8 The New Frontier

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **93%** · (C)

**Evidence.** **14 active, 1 disabled, 0 held back.**

**Description.** The arena, elevator, hidden note, outfit, prison secret door, vine, corruption hole, jail exit, minotaur boss, prison trap, way out and snake-head teleport all work, as do the Tirecz and Shard of Corruption kills.

**Rewards.** The quest outfit, Tirecz's loot, access to Farmine.

**Map actions needed.** **Map action #4.** The beaver script is disabled because it claims item 9843, which on this map is a lit wall lamp. One correct id or action id and it comes back.

### 6.9 The Rookie Guard

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **85%** · (J)

**Evidence.** Two script files with one held back, but `missions.lua` is a consolidated file driving **nine mission tiles by action id** (50312, 50319, 50321, 50323, 50325, 50335, 50336, 50351, 50352).

**Description.** The Rookgaard tutorial chain. Guide tiles, arrow hints and per-mission messages work; mission 12 does not.

**Rewards.** The starting-character progression, the Rookgaard outfit chain, first equipment.

**Map actions needed.** **Map action #2, and the clearest worked example of this field.** Nine tiles must carry those exact action ids, and the script also sends arrow hints to absolute positions. A missing or wrong id means the player walks past with no message, no arrow and no way to know. **Audit all nine.**

### 6.10 Dawnport

🟧🟧🟧🟧🟧⬜⬜⬜⬜⬜ **50%** · (C)

**Evidence.** **4 installed, 3 held back** — the legion helmet, the rare herb, and the vocation reward. Weighted down because the vocation reward is the quest's whole point.

**Description.** The three Morris kill tasks work. **The vocation reward does not** — the item a new character receives on choosing a vocation.

**Rewards.** Intended: the vocation starter reward, the rare herb, the legion helmet. Two of three unreachable.

**Map actions needed.** **Map actions #3 and #9.** `town_id` 1 on this map is the Dawnport tutorial and new characters default to it. The rare herb's dependency would be removed by a **unique id on the herb**. The four Monk shrines are also here.

### 6.11 Grave Danger

🟨🟨🟨🟨🟨🟨⬜⬜⬜⬜ **65%** · (C)

**Evidence.** 13 held back, **7 of them `BossLever`** — Sir Baeloc and Nictros, Count Vlarkorth, Duke Krule, Earl Osam, King Zelos, Lord Azaram and Scarlett Etzel.

**Description.** The approach works; none of the six knight bosses can be fought and the Cobra Bastion is blocked.

**Rewards.** None of the boss loot reachable.

**Map actions needed.** Seven boss rooms plus the Cobra Bastion mini-boss rooms (**#6**).

### 6.12 Forgotten Knowledge

🟨🟨🟨🟨🟨🟨⬜⬜⬜⬜ **65%** · (C)

**Evidence.** 12 held back, **6 `BossLever`** — Dragonking Zyrtarch, Lady Tenebris, Lloyd, The Last Lore Keeper, The Thorn Knight, The Time Guardian. All the death, health and prepare-death scripts *are* installed.

**Description.** Same shape as Ferumbras: the quest is there, the fights are not.

**Rewards.** None of the six bosses reachable.

**Map actions needed.** Six boss rooms (**#6**).

### 6.13 Heart of Destruction

🟧🟧🟧🟧🟧⬜⬜⬜⬜⬜ **50%** · (C)

**Evidence.** 22 held back — the largest block after Soul War. Five `BossLever` plus **17 scripts blocked on global storage** that does not persist.

**Description.** This quest needs the `world_storage` table more than it needs levers: `Game.get/setStorageValue` is currently a plain Lua table that resets on every restart.

**Rewards.** None reachable.

**Map actions needed.** Five boss rooms plus the final lever and devourer access (**#6**).

### 6.14 The rest, summarised

Each "levers" figure is that many boss rooms needing the full **#6** treatment.

| Quest | Installed / held | Levers | Blocked on |
| --- | ---: | ---: | --- |
| Cults of Tibia | 30 / 11 | 1 | `setParameter`, `:compare()`, `:updateFlag()` |
| Dangerous Depths | 21 / 3 | 0 | `setParameter`, boss cooldown |
| The Dream Courts | — / 4 | 3 | Dreamscar, Faceless Bane, Nightmare Beast |
| Rotten Blood | — / 9 | 5 | Bakragore, Chagorz, Ichgahal, Murcion, Vemiath |
| Feaster of Souls | — / 7 | 4 | Dread Maiden, Fear Feaster, Pale Worm, The Unwelcome |
| Primal Ordeal | — / 3 | 2 | Magma Bubble, The Primal Menace |
| Adventures of Galthen | 5 / 5 | 3 | Ahau, Megasylvan Yselda, Mitmah Vanguard |
| A Pirate's Tail | 1 / 6 | 2 | Ratmiral Blackwhiskers, Tentugly |
| Kilmaresh | — / 4 | 1 | Urmahlullu |
| Grimvale | — / 5 | 0 | Feroxa; needs `Spectators` |
| Hero of Rathleton | — / 12 | 0 | **Entirely global storage** — needs the persistence phase |
| The Order of the Lion | 2 / 4 | 0 | Drume; global storage commander counts |
| The Queen of the Banshees | — / 8 | 0 | Six seal levers, all needing shared tables |
| Svargrond Arena | — / 2 | 0 | `MonsterType`, `ARENA_TROPHY` |
| The Annihilator | — / 2 | 0 | `checkCreatureInsideDoor()`, `Position.removeMonster()` |
| Elemental Spheres | — / 4 | 0 | `VOCATION`, `:getBaseId()` |
| The Inquisition | — / 1 | 0 | `checkCreatureInsideDoor()` |

### 6.15 Quest log

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **95%** · (C)

**Evidence.** 50 quest files, 369 missions, all loading; both opcodes handled; hot-reloadable. The earlier `|STATE|` finding was **withdrawn** — it is a live substitution token (`src/quests.cpp:13-22`) and those 20 entries are correct kill-count tasks.

**Description.** The quest log works. **One hard constraint:** quest ids are assigned in sorted-path order and go to the client, so adding, renaming or reordering a file in `data/quests/` scrambles every player's log.

**Rewards.** None directly.

**Map actions needed.** None.

### 6.16 Quest doors

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (J)

**Evidence.** The door system is complete — use, step-on and step-off, across five door classes.

**Description.** `canOpenQuestDoor` uses **the door's action id directly as the player's storage key**. A quest door with action id 0 tells nobody why it will not open; a door whose id does not match the key its quest writes is sealed forever.

**Rewards.** Access to every gated area.

**Map actions needed.** **Map action #8.** Both sides came from Canary so they should align — but the 50 quest files were re-resolved to the storages this server writes, so any quest whose numbering changed now has a door pointing at the old key. Scriptable as a diff.

## 🟨 7. World, housing and map systems

### 7.1 Map and world content

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **95%** · (C)

**Evidence.** 17,972,761 tiles, 23,359,570 items, **993 houses** across **19 towns**, **52,903 spawn blocks**, **16,690 zones**, **1,712 monster definitions**, 1,079 NPC definitions with 1,063 scripts.

**Description.** The world itself is in place and large. The README's disagreement with itself over monster counts resolves as file count versus loaded count — 16 collide by name or race id, five of which are the known bestiary collisions.

**Rewards.** The world.

**Map actions needed.** None structural — see 7.2 and 7.4.

### 7.2 Map-switch migration

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** `data/migrations/` contains exactly `0.lua` through `8.lua`. **There is no town migration.** `players.town_id` still defaults to 1, which on this map is the Dawnport tutorial; the house file's lowest town id is 5, so towns 1-4 do not exist as house towns at all.

**Description.** Characters can be standing in the wrong town with the wrong temple, and houses can be owned under the retired map's ids. This is a live correctness problem, not a missing feature.

**Rewards.** None — this is a defect.

**Map actions needed.** **Map action #9.** The `towns` table must be repopulated from the Canary OTBM's own town list with correct temple positions, `players.town_id` and coordinates remapped, and `houses.owner` reconciled against the 993 house ids. Confirm the OTBM's town ids and temple coordinates before writing the migration.

### 7.3 Houses

🟨🟨🟨🟨🟨🟨🟨⬜⬜⬜ **70%** · (J)

**Evidence.** Ownership, access lists, rent with warnings, tile serialisation, and three talkactions. **Absent: the client's house auction and bid system** — `CyclopediaHouseAuction = 0xAD` has no handler.

**Description.** Houses are bought instantly at the door for tile count times price, premium only, one per character. There is no bidding, no auction timer and no transfer window — the 15.25 client's whole house UI is unanswered.

**Rewards.** A house, beds (which enable offline training), guildhalls for 66 of them, and item storage.

**Map actions needed.** House tiles, door ids and bed placement are all already present in the house file. The outstanding item is the `clientid` values, which the cyclopedia house window keys on, if that system is ever built.

### 7.4 Zones and spawns

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (J)

**Evidence.** 16,690 zones load. The TOML format supports spawn type, policy, trigger, range, positions, flags, cooldown, weekdays, waves, a master and delayed minions. **Every loaded zone is `policy = "fixed"`** — counted, not estimated: 16,690 fixed, zero triggered.

**Description.** The conversion produced flat fixed spawns and nothing else. The triggered policy, the wave system, weekdays and cooldowns are all unused, and they are exactly what boss rooms need.

**Rewards.** Every monster and NPC in the world.

**Map actions needed.** **Map actions #6 and #10.** Raising an area's difficulty, adding a timed spawn or creating a boss room means authoring triggered zones by hand. Separately, only 12 flag zones exist across 17.9M tiles, so PvP, no-logout and special-region flags are essentially unset.

### 7.5 Raids

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **5%** · (C)

**Evidence.** The engine is complete and running — announce, singlespawn, areaspawn and script events, loaded at init, scheduled, reloadable. Content: **zero real raids**.

**Description.** Until today this server shipped three upstream demo raids whose spawn boxes are at `[800,800,7]` on a map running around 32000 — so nothing ever spawned, while their announce events fired every two to four hours and broadcast to everyone online. Production told players "Orcs gathering near the city!" twice today and produced no orcs. They are now disabled (`9c0ff1f`) and kept as a format reference.

**Rewards.** None. Intended: raid boss loot and event participation.

**Map actions needed.** **Map action #5, and this one is 100% map work.** Every raid needs real coordinates: an areaspawn box or radius and centre, and a singlespawn position for the boss. No code, no schema. Pick the invasion sites, read off the coordinates, write the TOML.

### 7.6 Item events — actions, movements, levers, doors

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **95%** · (J)

**Evidence.** Unified actions and movements, hooks by **item id, action id, unique id or tile position**, five door classes, and a flag preserving declarative registrations across `/reload`. 124 legacy pack scripts retired, 377 active. **Exactly one duplicate registration remains.**

**Description.** The strongest piece of engine in the tree for map work: behaviour attaches to a specific tile, a unique id, an action id class or an item type, and the most specific match wins. Note the precedence — unique id, then action id, then item id, then category, then **position last** — which is why the First Dragon door cannot be fixed by registering its position.

**Rewards.** Every lever, door, chest and tile in the world.

**Map actions needed.** **Map actions #1 and #14** — the one remaining duplicate, and the pack-versus-port audit of the 377 surviving legacy scripts.

### 7.7 Multi-world

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (B)

**Evidence.** Three worlds live: two public, one private to staff and testers. Shared auth schema, presence leases with 45-second crash recovery, account-wide bans, role-gated private worlds, wrong-world rejection.

**Description.** One account, N worlds. A character belongs to one world for life; coins follow the account; a ban bars every world; one session per account. Fully documented in [`../multiworld.md`](../multiworld.md).

**Rewards.** Play any world from one login; an account-wide coin balance.

**Map actions needed.** None — but each world runs its own map, so map work must be aimed at the right one.

## 🟥 8. Client-facing 15.25 systems

**The standing number.** `ClientCode` declares **150 opcodes**. **103 have a real handler**
(plus three empty stubs), and **44 have no case at all**. Each cluster below is one of those.

### 8.1 Cyclopedia

🟨🟨🟨🟨🟨🟨🟨⬜⬜⬜ **70%** · (J)

**Evidence.** Every request type answers; character pages, inspection and the bestiary and charm tabs work. **The combat pages are over 100 literal zeros**, not the roadmap's ~57. Two extension opcodes unhandled: house auction and map.

**Description.** The important correction: the source comment saying "this server has none of those systems" is **false**. The engine already computes crit chance, crit damage, life and mana leech, armour penetration, reflection, elemental resistance and mitigation, all summed per type and exposed through three public accessors. Filling the pages is a read from existing getters — no new type, no new state. Only the imbuement, concoction and event columns are honestly zero.

**Rewards.** None directly — but a player currently cannot see what their augments and charms are doing.

**Map actions needed.** None for the combat pages. **Hard constraint:** every field must keep the same wire width and order; the layout is verified against a real client. Only the value may change.

### 8.2 Imbuements

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** Five opcodes declared and unhandled. `imbuement` appears in `src/` only as comment text, appearance fields, and a legacy deserialiser that **skips and discards** old imbuement bytes.

**Description.** Absent. Worth noting the augment system already provides most of what imbuements do mechanically — if they are wanted, time-limited augments may be a better expression than a parallel system.

**Rewards.** None.

**Map actions needed.** Imbuement shrines are traditionally placed in each town's depot, so the feature would need placement.

### 8.3 Quick loot and supply stash

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** Five opcodes unhandled. The source says in two places that stash columns "stay empty until those systems exist". No stash table.

**Description.** The client asks for these constantly and gets nothing. Rated the cheapest of the absent systems to build.

**Rewards.** None.

**Map actions needed.** None.

### 8.4 Depot search

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** Four opcodes unhandled.

**Description.** Absent.

**Rewards.** None.

**Map actions needed.** None.

### 8.5 Podiums

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** Two opcodes unhandled. **But the asset pipeline already reads the podium flag** from the client's own appearance data and branches on it when writing items — so the server knows which items are podiums; it just cannot configure one.

**Description.** Podium items exist on the map and in houses and do nothing when used.

**Rewards.** None. Intended: cosmetic display of outfits and bosses in a house.

**Map actions needed.** None — podiums are ordinary house decoration.

### 8.6 Hirelings

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** `SetHirelingName = 0xEC` unhandled; the source sends three literal zeros for hirelings, their skills and their outfits.

**Description.** Absent.

**Rewards.** None.

**Map actions needed.** None (hirelings live in houses).

### 8.7 Weapon proficiency

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (B)

**Evidence.** `WeaponProficiency = 0xB3` unhandled; a zero is sent for weapon proficiency augments.

**Description.** Absent.

**Rewards.** None.

**Map actions needed.** None.

### 8.8 Achievements

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **5%** · (B)

**Evidence.** The cyclopedia achievements request is answered with a header-only response — valid, and empty. No definitions, no table, no unlock path. Two quest scripts reference achievements by name.

**Description.** The client has an achievements tab and receives an empty header.

**Rewards.** None.

**Map actions needed.** None.

### 8.9 Reward chest

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (B)

**Evidence.** The chest is fully implemented: damage-weighted boss loot, persistence for offline players, and open and browse. Only `RewardChestCollect = 0xFF` — the collect-all button — is unhandled. **This corrects an earlier audit of mine that listed the reward chest as absent.**

**Description.** Boss loot apportioned by damage contribution, surviving logout. Players can open the chest and drag items out; they just cannot collect everything in one click.

**Rewards.** Boss loot, correctly apportioned.

**Map actions needed.** **Folds into #6 / #7.** A reward chest tile belongs in each boss room's reward area — most of the 42 unbuilt rooms will need one.

### 8.10 Protocol profiles

🟥🟥⬜⬜⬜⬜⬜⬜⬜⬜ **25%** · (C)

**Evidence.** 4 profiles declared, **1 verified against a real client**. The source states in-line that 13.40 and 14.12 reuse the 15.25 login layout and are "ASSUMED until a mehah capture confirms them". Of 32 feature bits, **13 are branched on and 19 are never read** — the code branches on client generation instead.

**Description.** 15.25 is the only supported client, and that is a deliberate decision. The unread bits cost nothing and are the declared seam the older profiles are meant to differ on.

**Rewards.** None.

**Map actions needed.** None.

### 8.11 Unanswered client chatter

⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜ **0%** · (C)

**Evidence.** 13 opcodes with no handler — counter offer, client options, typing indicator, client check, container action, trade configuration, friend system, guild message, report text, client details, aim-at-target, greet and reward-chest collect — plus three empty stubs.

**Description.** Mostly harmless; each logs an unhandled-opcode line.

**Rewards.** None.

**Map actions needed.** None.

## 🟨 9. Infrastructure and operations

### 9.1 Transport, login and session keys

🟩🟩🟩🟩🟩🟩🟩🟩🟩🟩 **100%** · (B)

**Evidence.** Sequence checksums, padded XTEA, block-count lengths, raw deflate, golden-tested. Session-key login with email and password fallback.

**Description.** The wire works and is the most tested part of the server.

**Rewards.** None.

**Map actions needed.** None.

### 9.2 Item and appearance pipeline

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **81%** · (C)

**Evidence.** 42,752 mappings both directions; **42,686 items defined** — 21,881 legacy plus 20,805 generated. **7,729 of the generated items ship with an empty name** = 37% of that set unnamed; 81% of all items are named.

**Description.** Unnamed items render and work; the client has nothing to call them, so a player sees a blank tooltip. They are appearance shells the client itself cannot name either.

**Rewards.** None directly — but every unnamed item appearing in a quest reward or shop is a blank line to a player.

**Map actions needed.** None.

### 9.3 Database, migrations and schema

🟩🟩🟩🟩🟩🟩🟩🟩🟩⬜ **90%** · (J)

**Evidence.** 44 tables plus a shared auth schema; migrations 0-8. **Outstanding:** the `world_storage` and boss-cooldown migrations do not exist, and neither does the town migration (7.2). The three known correctness defects — transaction UB, the coin-transfer refund, and migration failure refusing boot — were closed this session.

**Description.** Solid and now considerably safer. One honest limit: a migration that signals failure by *returning false* still cannot be told apart from a clean finish, so the boot gate catches migrations that fail by erroring, not those that fail by returning.

**Rewards.** None.

**Map actions needed.** See **#9**.

### 9.4 Test coverage

🟧🟧🟧🟧⬜⬜⬜⬜⬜⬜ **40%** · (J)

**Evidence.** 70 tests covering transport, id mapping, event dispatch, world identity and presence. Nothing exercises bestiary, prey, forge, wheel, store or quests — those are verified by driving a real client by hand.

**Description.** The tested parts are tested well. The gameplay systems are not covered at all, which is why the wheel duplication bug survived until a review found it rather than a test.

**Rewards.** None.

**Map actions needed.** None.

### 9.5 Creature-event coverage

🟨🟨🟨🟨🟨🟨🟨🟨⬜⬜ **80%** · (C)

**Evidence.** **82 distinct creature events are referenced by monsters and defined nowhere** — verified by diffing every `monster.events` entry against every `CreatureEvent(...)` definition. They are almost all un-ported Canary boss mechanics; `FourthTaintBossesPrepareDeath` alone is on 15 monsters. `roadmap.md:194` separately counts 39 monster callbacks commented out.

**Description.** Monsters ask for death, health-change, think and prepare-death hooks that do not exist. The monster still fights; it just skips its scripted behaviour silently, which is why the Goshnar, Cobra and Oberon fights are shallower than intended. The warning used to print once per monster instance — 2,970 lines in one boot — and now prints once per distinct name (`6ccfa34`).

**Rewards.** None directly; it affects boss difficulty and phase transitions.

**Map actions needed.** None. These arrive with the quest programme.

### 9.6 Build, CI and deployment

🟧🟧🟧🟧⬜⬜⬜⬜⬜⬜ **40%** · (J)

**Evidence.** `bootstrap.sh` always exits 1 on a triplet that no longer exists; nothing pins the compiler while the code needs GCC 14+; the compose file targets the wrong ports, names `mariadb` while production runs MySQL 8, never copies `config/`, and cannot serve a world; both CI workflows build and **neither runs the test suite**.

**Description.** The build works if you know the incantation, and the repository does not tell you it. CI proves compilation and nothing else.

**Rewards.** None.

**Map actions needed.** None.

### 9.7 Known unexplained failure

⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛ **not a feature**

One segfault after roughly 8 hours under 20,000-bot load, never reproduced and never
root-caused. `Black-Tek-Server.sym` is in the tree. Not actionable without a core dump — the
useful step is a core-dump policy so the next occurrence is diagnosable, which is a monitoring
change rather than a code one.

---

## What this list is not

Three things to hold in mind when reading the bars above.

**A judgement figure is an opinion with its parts named.** Where a feature says (J), the parts
are listed so you can disagree with the weighting rather than the number. If you think the
wheel's missing perks matter more than its working stats, move it down — the evidence does not
change.

**Absence is reported as absence.** Fourteen features on this list are at 0%, and none of them
is dressed up as partial. A system with an opcode and no handler is not "in progress".

**Several figures here correct the README and the roadmap**, which were accurate when written
and have drifted: the bestiary is 62% rather than 43%, the market's gap is un-listable tiered
items rather than stripped tiers, the cyclopedia's zeros are plumbing rather than missing
systems, offline training and the reward chest are implemented rather than absent, and the NPC
quest-giver backlog is 7 files rather than 69. Where this file and the README disagree, this
file was generated against the checkout and the README was not.
