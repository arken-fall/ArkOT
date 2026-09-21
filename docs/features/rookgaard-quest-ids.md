# Rookgaard quest ids

What to set in the map editor, and why these numbers. Every id below was checked
against the live map and the datapack before it was assigned — nothing here
collides with anything.

---

## The constraint that drives the numbering

A quest container's **unique id is also the player's storage key**. `system.lua`
reads `storage = item.uid` and then calls `player:setStorageValue(storage, 1)`,
so a unique id must be free in **two** namespaces at once:

1. No other item on the map may carry it.
2. No script may use it as a storage key.

A collision in the first duplicates a chest; a collision in the second means
opening a box silently completes some unrelated quest. That is why the block
below was picked by intersecting both sets rather than by looking at the map
alone.

Measured at commit `4c391d6`, with `harness/otbm_ids.py`:

| | |
| --- | --- |
| Identified items on the map | 2,632 |
| Distinct action ids in use | 697 |
| Unique ids in use | 587 |
| Storage keys used by scripts | 2,749 |
| Union of both namespaces | 3,263 |
| **Identified items in all of Rookgaard** | **20** |

`system.lua` also refuses any storage above 65535 (`if storage > 65535 then
return false end`), so the whole scheme has to fit under that.

---

## The reserved block: 33500 – 33599

The largest range clear in **both** namespaces is 33333–39998, 6,666 ids wide.
This takes the first clean hundred inside it and leaves the rest for the map's
other towns to do the same thing later.

```
33500 - 33509   Bear Room quest
33510 - 33519   Katana quest
33520 - 33529   Mino Hell
33530 - 33539   Hidden treasures
33540 - 33549   Corpses and carcasses
33550 - 33599   reserved for the rest of Rookgaard
```

Verify before use, and again after any map edit:

```bash
python3 harness/otbm_ids.py data/world/canary.otbm --uid 33530
```

An empty result is what you want. Anything else means the id is taken.

---

## What to set

**Containers need two things**: action id **2000** and a unique id from the
block. 2000 is what `system.lua` registers on; the unique id is what makes the
reward once-per-player rather than a shelf anyone can keep looting. Neither
works without the other — an `aid 2000` with no uid falls through the
`storage > 65535` guard and does nothing.

**Levers need only an action id.** The scripts already exist and already name
these numbers.

| What | Position | Item | Set action id | Set unique id |
| --- | --- | ---: | ---: | ---: |
| **Bear Room lever** | `32148, 32105, 11` | 1945 | **5638** | — |
| **Katana lever** | `32182, 32145, 11` | 1946 | **5637** | — |
| Hidden dagger box | `32102, 32235, 8` | 1741 | 2000 | **33530** |
| Key chest | `32150, 32112, 12` | 1740 | 2000 *(replaces 4601)* | **33531** |
| Katana key corpse | `32176, 32132, 9` | 3058 | 2000 | **33510** |
| Katana reward corpse | `32174, 32149, 11` | 3058 | 2000 | **33511** |
| Dragon corpse | `32179, 32224, 9` | 3105 | 2000 | **33540** |
| Mino Hell box | `32130, 32066, 12` | 1741 | 2000 | **33520** |
| Mino Hell box | `32128, 32066, 12` | 1741 | 2000 | **33521** |
| Mino Hell box | `32124, 32064, 12` | 1741 | 2000 | **33522** |

### The two levers are the cheapest wins here

Both scripts are already written, already correct, and already waiting:

- `bearroom_quest_lever.lua` registers **aid 5638** and moves the stone at
  `32145, 32101, 11` — the exact stone you inspected.
- `katana_quest_lever.lua` registers **aid 5637** and unlocks the door at
  `32177, 32148, 11` — the exact door you inspected.

Neither id is used anywhere on the map, so setting them collides with nothing
and the quests work on the next `/reload scripts`. No code at all.

A note on why these and not Canary's numbers: Canary registers the same two
quests on aids 30006 and 30492, and the map carries neither. Our scripts win the
tie because they are written for the items actually on these tiles — levers 1945
and 1946 and stone 1304 — while Canary's expect 2772, 2773 and 1791, which are
not what is there.

### The key chest already has an id, and it is a dead one

`32150, 32112, 12` carries **aid 4601**, and nothing in the datapack registers
4601. It is the only thing you found that the map identified at all. Since it
needs a unique id regardless, the tidy fix is to change its action id to 2000 at
the same time and let the generic system handle it, rather than write a script
for an id used nowhere else.

### Corpses are containers

`3058` (dead human) and `3105` (dead dragon) take `aid 2000` and a unique id
exactly as a chest does. They decay — 3058 to 3059, 3105 to 3106 — so set the
ids on the item the map places, and be aware the reward stops being reachable
once it rots if the quest is meant to be repeatable-on-respawn rather than
once-per-player.

---

## What this does not fix

**Empty containers stay empty.** `system.lua` hands out what is inside; it does
not invent contents. Of the containers above, the ones you inspected reported
`[container, 0 item(s)]` — the dagger box, both katana corpses, the dragon
corpse, and two of the three Mino Hell boxes. Those need their rewards placed in
the map editor as well, or the quest will politely announce that you found
nothing.

Known from your own notes, so the contents are not a guess:

| Quest | Reward |
| --- | --- |
| Hidden dagger | Dagger |
| Bear Room | Chain Armor, Brass Helmet, 12 Arrows, 40 gp |
| Katana Room | Katana, Viking Helmet, Key 4603 |
| Dragon Corpse | Bag with Copper Shield and Legion Helmet |
| Mino Hell | Carlin Sword, 4 Poison Arrows, 10 Arrows, Fishing Rod |

**The missing shovel hole** at `32149, 32110, 11` is not an id problem. That
tile has a ground item and nothing else — the hole was never placed. It needs
the item, not a number.

**The locked door** at `32179, 32149, 10` (item 5107) has no id either. Whether
it wants an action id matching the key, or is opened by the katana lever chain,
is a decision about how that quest should play rather than a defect.

---

## Checking your work

After editing, the same tool proves it landed:

```bash
# everything identified in Rookgaard, before and after
python3 harness/otbm_ids.py data/world/canary.otbm --area 32050 32050 32260 32260

# one tile
python3 harness/otbm_ids.py data/world/canary.otbm --near 32148 32105 11 --radius 0

# nothing else took the id
python3 harness/otbm_ids.py data/world/canary.otbm --uid 33530
```

Rookgaard shows 20 identified items today. With the table above applied it
should show 30, and the two levers should work immediately on a script reload —
the containers need their contents before they do anything useful.
