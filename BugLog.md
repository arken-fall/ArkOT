# 🐞 ArkOT Bug Log

> Findings from a C++ bug review of ArkOT's own changes on top of upstream BlackTek.

| | |
|---|---|
| **Reviewed commit** | `4d104a3` (branch `modern-protocol`) |
| **Scope** | `git diff 828b893..HEAD -- src`: 63 files, ~13k changed lines |
| **Out of scope** | The upstream BlackTek code that ArkOT did not change |
| **Review date** | 2026-09-16 |
| **Method** | Three independent bug-hunting passes (logic, crash/lifetime, general), then a manual check of every finding against the source |

---

## 📊 Summary

| Priority | Count | Meaning |
|:--|:--:|:--|
| 🔴 **P0: Critical** | 4 | Crash, use-after-free, or corrupted save data on normal gameplay paths |
| 🟠 **P1: High** | 4 | Data race, or an exploit that creates or bypasses in-game value |
| 🟡 **P2: Medium** | 2 | Broken game rule or malformed packet that desyncs the client |
| 🔵 **P3: Low** | 2 | Unconfirmed wire-format issue, or code owned by the multi-world work |
| **Total** | **12** | |

```
P0 Critical  ████████████████████  4
P1 High      ████████████████████  4
P2 Medium    ██████████            2
P3 Low       ██████████            2
```

---

## 📑 Index

| ID | Priority | Title | Class | Area | Status |
|:--|:--|:--|:--|:--|:--:|
| [BUG-01](#bug-01) | 🔴 P0 | Offline mail delivery reads columns missing from the query | Undefined behavior · data corruption | Persistence | ⬜ Open |
| [BUG-02](#bug-02) | 🔴 P0 | Bestiary keeps pointers to freed monster types after reload | Use-after-free | Bestiary | ⬜ Open |
| [BUG-03](#bug-03) | 🔴 P0 | Heal with no caster dereferences null | Crash | Combat / Lua | ⬜ Open |
| [BUG-04](#bug-04) | 🔴 P0 | Wheel augment is added again on every login | Persistent data corruption | Wheel of Destiny | ⬜ Open |
| [BUG-05](#bug-05) | 🟠 P1 | Bestiary overview reads player state on the network thread | Data race | Protocol | ⬜ Open |
| [BUG-06](#bug-06) | 🟠 P1 | Convergence fusion accepts any carried item | Exploit · item loss | Forge | ⬜ Open |
| [BUG-07](#bug-07) | 🟠 P1 | Destroying every gem re-grants the starting set | Exploit · item duplication | Wheel of Destiny | ⬜ Open |
| [BUG-08](#bug-08) | 🟠 P1 | Prey reroll and charm removal are free with banked gold | Exploit · economy | Prey / Bestiary | ⬜ Open |
| [BUG-09](#bug-09) | 🟡 P2 | Wheel points can be removed outside a temple | Incorrect behavior | Wheel of Destiny | ⬜ Open |
| [BUG-10](#bug-10) | 🟡 P2 | Bestiary tracker packet count doesn't match its entries | Malformed packet | Protocol | ⬜ Open |
| [BUG-11](#bug-11) | 🔵 P3 | Own-summon type update leaves out the master id (likely) | Malformed packet | Protocol | ⬜ Open |
| [BUG-12](#bug-12) | 🔵 P3 | Legacy-port servers advertise game port 0 `[multi-world]` | Incorrect behavior | Login / Multi-world | ⬜ Open |

**Status key:** ⬜ Open · 🟨 In progress · ✅ Fixed · ⛔ Won't fix

---

## 🔴 P0: Critical

<a id="bug-01"></a>
### BUG-01: Offline mail delivery reads columns missing from the query

| Class | Area | Files |
|:--|:--|:--|
| Undefined behavior · persistent data corruption | Persistence | [`src/iologindata.cpp:603-607`](src/iologindata.cpp#L603), [`src/iologindata.cpp:637-640`](src/iologindata.cpp#L637) |

**Problem.** Only `loadPlayerById` got the four new columns added to its SELECT. `loadPlayerByName` still stops at `direction`, but `loadPlayer` (used by both) now reads all four columns.

```cpp
// loadPlayerByName
... `skill_fishing_tries`, `direction` FROM `players` WHERE `name` = {:s}

// loadPlayer
player->charm_points     = result->getNumber<uint32_t>("charm_points");
player->prey_wildcards   = result->getNumber<uint32_t>("prey_wildcards");
player->forge_dust_level = result->getNumber<uint16_t>("forge_dust_level");
player->forge_dust       = std::min<uint32_t>(result->getNumber<uint32_t>("forge_dust"), player->forge_dust_level);
```

`DBResult::getNumber` ([`src/database.h:149-158`](src/database.h#L149)) logs that the column is missing, then still reads `row[it->second]` with `it == listNames.end()`.

**How it happens:**
1. A parcel or letter is sent to an offline player: `Item::sendItem` ([`src/item.cpp:623`](src/item.cpp#L623)).
2. `loadPlayerByName` → `loadPlayer` reads through the end iterator (undefined behavior).
3. If the server survives, `savePlayer(tmpPlayer)` ([`src/item.cpp:631`](src/item.cpp#L631)) writes the garbage over the recipient's charm points, prey wildcards and forge dust.

**Suggested fix.** Add `charm_points`, `prey_wildcards`, `forge_dust` and `forge_dust_level` to the `loadPlayerByName` SELECT. Better still, share one column list between the two loaders.

---

<a id="bug-02"></a>
### BUG-02: Bestiary keeps pointers to freed monster types after reload

| Class | Area | Files |
|:--|:--|:--|
| Use-after-free | Bestiary | [`src/bestiary.cpp:186-196`](src/bestiary.cpp#L186), [`src/monsters.cpp:126`](src/monsters.cpp#L126) |

**Problem.** The registry stores raw `const MonsterType*` in `monsters_by_race_id` and `monsters_by_race`, and nothing ever clears them. `Monsters::reload()` runs `monsters.clear()`, which destroys every `MonsterType`.

```cpp
if (auto it = monsters_by_race_id.find(entry.race_id); it != monsters_by_race_id.end() and it->second != &monsterType)
{
    Console::Warn("...", entry.race_id, it->second->name, monsterType.name);
    return;
}
```

**How it happens:**
1. `RELOAD_TYPE_MONSTERS` ([`src/game.cpp:8195`](src/game.cpp#L8195)) or a scripts reload ([`src/game.cpp:8263`](src/game.cpp#L8263)) frees all monster types.
2. Monster scripts register again. `it->second->name` reads a freed object.
3. The early `return` keeps the stale pointer. From then on, prey rolls, charm augments at login and every bestiary packet use freed memory.

**Suggested fix.** Clear the registry's monster maps at the start of `Monsters::reload()`, before the scripts re-register.

---

<a id="bug-03"></a>
### BUG-03: Heal with no caster dereferences null

| Class | Area | Files |
|:--|:--|:--|
| Crash | Combat / Lua | [`src/luascript.cpp:4535`](src/luascript.cpp#L4535), [`src/combat.cpp:3079`](src/combat.cpp#L3079), [`src/combat.cpp:3216`](src/combat.cpp#L3216) |

**Problem.** `luaDoTargetCombat` accepts `cid == 0` on purpose ([`src/luascript.cpp:4501`](src/luascript.cpp#L4501)), and `strike_environment` passes `nullptr` directly. `heal_target` does not null-check `caster` before using it.

```cpp
strike->heal_target(creature, target);            // luascript.cpp: creature may be null
heal_target(nullptr, defender, true, spectators); // combat.cpp: strike_environment
if (caster->is_player())                          // combat.cpp: heal_target, unguarded
```

**How it happens:** `doTargetCombat(0, target, COMBAT_HEALING, min, max, effect)` on a target missing health → `HealthTarget` branch → `caster->is_player()` on null. The mana, stamina and soul branches have the same unguarded check (lines 3239, 3263, 3286).

**Suggested fix.** Guard each branch with `if (caster and caster->is_player())`.

---

<a id="bug-04"></a>
### BUG-04: Wheel augment is added again on every login

| Class | Area | Files |
|:--|:--|:--|
| Persistent data corruption · state grows without limit | Wheel of Destiny | [`src/wheel.cpp:1349`](src/wheel.cpp#L1349), [`src/wheel.cpp:1422`](src/wheel.cpp#L1422), [`src/iologindata.cpp:1082`](src/iologindata.cpp#L1082) |

**Problem.** `clear()` only removes the augment when `applied_any` is set, and that flag is always false on a freshly loaded `Player`.

```cpp
if (not state.applied_any) { return; }   // System::clear
...
player->addAugment(augment);             // System::apply
```

**How it happens:**
1. `saveAugments` saves every augment on the player, including "Wheel of Destiny".
2. On login, saved augments are re-added ([`src/iologindata.cpp:973-984`](src/iologindata.cpp#L973)), then `Wheel::System::apply` runs.
3. `clear()` returns early, so `apply()` adds a second copy.
4. Resistances and leech stack with each login. Past `MAX_AUGMENT_COUNT` (100), `saveAugments` returns false ([`src/iologindata.cpp:1330`](src/iologindata.cpp#L1330)) and that character can no longer be saved.

**Suggested fix.** Always call `player->removeAugment(augmentName())` in `clear()`, as prey and charms already do, or leave the wheel augment out of `saveAugments`.

---

## 🟠 P1: High

<a id="bug-05"></a>
### BUG-05: Bestiary overview reads player state on the network thread

| Class | Area | Files |
|:--|:--|:--|
| Data race | Protocol | [`src/protocolgame.cpp:1501-1527`](src/protocolgame.cpp#L1501) |

**Problem.** `parsePacket` runs on the connection thread. Every other handler defers its work with `addGameTask`, but this one reads the `std::map` `bestiary_kills` and the registry maps directly.

```cpp
if (const MonsterType* monsterType = bestiary.getMonster(raceId); monsterType and player->getBestiaryKills(raceId) > 0)
```

**How it happens:** the client sends a bestiary search with up to 65,535 race ids while its character is killing monsters. The dispatcher thread inserts into the same map through `addBestiaryKills` ([`src/player.h:889`](src/player.h#L889)). A lookup while another thread inserts is undefined behavior.

**Suggested fix.** Parse only the raw race ids or the name on the network thread, and do the registry and kill lookups inside the game task.

---

<a id="bug-06"></a>
### BUG-06: Convergence fusion accepts any carried item

| Class | Area | Files |
|:--|:--|:--|
| Exploit · item loss | Forge | [`src/forge.cpp:231-238`](src/forge.cpp#L231), [`src/forge.cpp:302`](src/forge.cpp#L302) |

**Problem.** With `convergence` set, nothing checks the second item. `findItem` matches any carried item at the requested tier, and every untiered item counts as tier 0.

```cpp
if (classification == 0 or tier >= config.max_tier or (not convergence and itemId != secondItemId))
...
const ItemPtr second = findItem(player, secondItemId, tier, first);
```

**How it happens:** a convergence fusion always succeeds. The first item goes up a tier, and `internalRemoveItem(second, 1)` takes whatever item the client named. Any cheap item can pay for a tier upgrade. If the client names the container holding the first item, the upgraded item is destroyed with it.

**Suggested fix.** For convergence, require the second item to share the first item's classification (and slot, if that is the design), and reject a second item that is a container holding `first`.

---

<a id="bug-07"></a>
### BUG-07: Destroying every gem re-grants the starting set

| Class | Area | Files |
|:--|:--|:--|
| Exploit · item duplication | Wheel of Destiny | [`src/wheel.cpp:945-948`](src/wheel.cpp#L945), [`src/wheel.cpp:1000-1036`](src/wheel.cpp#L1000), [`src/protocolgame.cpp:3329`](src/protocolgame.cpp#L3329) |

**Problem.** The starting gems are granted whenever the gem list is empty, and nothing records that they were already given.

```cpp
if (not state.gems.empty()) { return; }   // grantInitialGems
wheel.grantInitialGems(player);           // sendWheelWindow
```

**How it happens:** destroy all 8 gems (each gives 1-10 real fragment items). The final `destroyGem` calls `sendWheelWindow`, which grants 8 fresh gems. This can be repeated forever.

**Suggested fix.** Persist a `starter_gems_granted` flag and check it instead of `gems.empty()`.

---

<a id="bug-08"></a>
### BUG-08: Prey reroll and charm removal are free with banked gold

| Class | Area | Files |
|:--|:--|:--|
| Exploit · economy | Prey / Bestiary | [`src/prey.cpp:252-257`](src/prey.cpp#L252), [`src/bestiary.cpp:399-405`](src/bestiary.cpp#L399) |

**Problem.** The affordability check counts bank gold, but `Game::removeMoney` ([`src/game.cpp:2523`](src/game.cpp#L2523)) only takes carried gold and returns false when that isn't enough. Neither caller checks the result.

```cpp
if (player->getMoney() + player->getBankBalance() < price) { ... }
g_game.removeMoney({ .player = player }, price);
```

**How it happens:** a player carrying 0 gold with enough in the bank rerolls a prey list or removes a charm, and nothing is charged.

**Suggested fix.** Use `Player::payGold` ([`src/player.cpp:5215`](src/player.cpp#L5215)), which forge and wheel already use, and stop if it returns false.

---

## 🟡 P2: Medium

<a id="bug-09"></a>
### BUG-09: Wheel points can be removed outside a temple

| Class | Area | Files |
|:--|:--|:--|
| Incorrect behavior | Wheel of Destiny | [`src/wheel.cpp:868-873`](src/wheel.cpp#L868), [`src/wheel.cpp:899`](src/wheel.cpp#L899) |

**Problem.** Outside a temple, `getOptions` returns `AddOnly` ([`src/wheel.cpp:755-773`](src/wheel.cpp#L755)). But slots the client sends as `0` are filtered out before the `AddOnly` check, and `working.points` starts at zero.

```cpp
auto wanting = pending | std::views::filter([&](Slot slot) { return points[std::to_underlying(slot)] != 0; });
... (options == Options::AddOnly and wanted < state.points[index])
state.points = working.points;
```

**How it happens:** outside a temple, the client saves the wheel with `0` for slots that have points. Those points are removed and returned to the budget, the same as a temple reset.

**Suggested fix.** In `AddOnly` mode, loop over every slot and reject any `points[i] < state.points[i]`, including zeros.

---

<a id="bug-10"></a>
### BUG-10: Bestiary tracker packet count doesn't match its entries

| Class | Area | Files |
|:--|:--|:--|
| Malformed packet · client desync | Protocol | [`src/protocolgame.cpp:3996-3997`](src/protocolgame.cpp#L3996), [`src/player.cpp:4786-4796`](src/player.cpp#L4786) |

**Problem.** The count byte is the size of the whole tracked set, but entries are written only for race ids the registry knows, and the loop isn't capped at 255. `setBestiaryTracking` inserts any race id the client sends, without checking it and without a limit.

```cpp
msg.addByte(std::min<size_t>(tracked.size(), std::numeric_limits<uint8_t>::max()));
auto known = tracked | std::views::filter([&](uint16_t raceId) { return bestiary.getMonster(raceId) != nullptr; });
```

**How it happens:** the client tracks an unknown race id, so the count is larger than the entries written and the client misreads the packets that follow. With more than 255 known entries, the loop writes more entries than the count says. The tracked set can also grow to 65,535 entries.

**Suggested fix.** Reject unknown race ids in `setBestiaryTracking`, cap the set size, and write a count computed from the entries actually sent.

---

## 🔵 P3: Low

<a id="bug-11"></a>
### BUG-11: Own-summon type update leaves out the master id (likely)

| Class | Area | Files |
|:--|:--|:--|
| Malformed packet (likely) | Protocol | [`src/protocolgame.cpp:2015-2018`](src/protocolgame.cpp#L2015) |

**Problem.** `game.cpp:7170` sends `CREATURETYPE_SUMMON_OWN` through `sendCreatureType`. On the modern path the server's own `AddCreature` always writes a `u32` master id after that type byte ([`src/protocolgame.cpp:6348-6351`](src/protocolgame.cpp#L6348)), but `sendCreatureType` writes only the byte.

```cpp
msg.addByte(ModernCreatureType(static_cast<CreatureType_t>(creatureType)));
```

> ⚠️ **Confidence:** inferred from the server's own encoding of the same field. It needs a check against the client's wire format.

**Suggested fix.** On the modern path, write the master's id after `CREATURETYPE_SUMMON_OWN`, matching `AddCreature`.

---

<a id="bug-12"></a>
### BUG-12: Legacy-port servers advertise game port 0 `[multi-world]`

| Class | Area | Files |
|:--|:--|:--|
| Incorrect behavior | Login / Multi-world | [`src/otserv.cpp:610`](src/otserv.cpp#L610), [`src/protocollogin.cpp:123`](src/protocollogin.cpp#L123) |

> 🧭 **Ownership:** part of the multi-world work being done in a separate session. It is logged for tracking and is not treated as critical.

**Problem.** A legacy server must set `game_port_modern = 0` ([`src/otserv.cpp:825`](src/otserv.cpp#L825)). The world built from that config has `.port = 0`, and the character list now sends `world.port` where it used to send `GAME_PORT`.

```cpp
.port = static_cast<uint16_t>(g_config.GetNumber(ConfigManager::GAME_PORT_MODERN)),
output->add<uint16_t>(world.port);
```

**How it happens:** legacy config (`game_port = 7172`, `game_port_modern = 0`) → a 10.98 client logs in → the world list says port 0 → the client can't connect. With a `worlds.toml`, a legacy server fails its port check and can't boot at all.

**Suggested fix.** Build the identity's port from whichever game port is enabled, or drop legacy-port support explicitly if it is no longer a target.

---

<sub>Every finding was checked by hand against the source at commit `4d104a3`. Line numbers refer to that commit.</sub>
