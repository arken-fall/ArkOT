# ArkOT

**ArkOT** is the ArkenFall team's fork of [BlackTek Server](https://github.com/Black-Tek/BlackTek-Server),
rebuilt to speak the **Tibia 15.25 client protocol** and nothing else. It serves the world
[Arkenfall](https://arkenfall.org). We are not part of the BlackTek team and this fork is not
affiliated with or endorsed by them; all credit for the base server belongs to BlackTek and its
upstream lineage. Upstream's own README is preserved at the bottom of this file.

Engineering log: `arktext.md`. Port gates: `STATUS.md` (last updated 2026-09-14, a lap behind the
code). C++ rules: `CONTRIBUTING.md`, which is mandatory.

---

## At a glance

| Area | State |
| --- | --- |
| 15.25 protocol, transport, login | Working, verified against a real client |
| Item and appearance pipeline | Working |
| World content | Canary's map and datapack, machine-ported |
| Side systems (bestiary, prey, forge, wheel, store, market) | Real implementations, several with gaps |
| Multi-world (one account, N worlds) | Phase 1 written and compiling; never served a player — see Roadmap |

**Requirements to run the world:** ~12.8 GB RAM resident, GCC 14+, MySQL/MariaDB, a login
webservice, and a 15.25 client. The world ships with the server; see First boot.

---

## Engine

| System | State | Notes |
| --- | --- | --- |
| Modern 13.40+ transport | Done | Sequence checksums, padded XTEA, block-count lengths, raw deflate. Golden-tested. |
| Session-key login | Done | Opaque key from an HTTP webservice, SHA-256 lookup in `account_sessions`; email/password still works as a fallback. |
| Appearance / item-id pipeline | Done | 42,752 server↔appearance mappings, both directions, through one helper. |
| Item events | Done | Actions and movements unified; hooks by item id, action id, unique id or tile position. |
| Charms | Done | 25 runes, bought with points, applied as real augments against the creature. |
| Exaltation forge | Done | Fusion, transfer, convergence, dust economy, history; tier rides on the item. |
| Store | Done | Categories, offers, purchases, coin transfer, paged history; coins on the account. |
| Protocol profiles | Partial | 10.98 / 13.40 / 14.12 / 15.25 declared, but only 15.25 has met a real client. |
| Generated 15.25 items | Partial | 20,805 items generated from appearances; 7,729 still have no name. |
| Bestiary | Partial | Engine is complete; only 741 of 1,712 monsters carry an entry. |
| Prey | Partial | All three slots work, but nothing unlocks the third — it stays locked unless config frees it. |
| Wheel of destiny | Partial | Slots, gems and stat bonuses apply; perks, instants and stages exist only as Lua getters nothing calls. |
| Market | Partial | Full 15.25 flow, but every item goes out with tier 0 even though forge tiers exist. |
| Cyclopedia | Partial | All request types answered; the combat pages still send ~57 hard-coded zeros. |
| Legacy 10.98 listeners | Retired | `game_port = 0`, and the legacy `ProtocolLogin`/`ProtocolOld` pair is not registered on a modern server; starting both generations is refused. |
| Multi-world identity | Partial | `config/worlds.toml` is the world list; a world refuses to boot if its own row disagrees with its ip, port or schema, and a client announcing another world's name is refused. Never run with more than one world. |
| In-binary login | Partial | `ProtocolLoginModern` serves the world list on 7171, the only port a 15.25 client will take it on. Compiles; no real client has reached it. |

## World content

| Thing | Count | Where it came from |
| --- | --- | --- |
| Map | 17,972,761 tiles, 23,359,570 items | Canary v3.6.1, converted to OTBM v2 with server ids |
| Zones | 16,704 (16,691 from spawns + 12 flag zones) | Converted from the map's spawn file |
| Houses | 993 across 19 towns | The map's own house file |
| Monster types | 1,696 loaded | 740 BlackTek, 133 SeeingBlue 10.98 pack, 839 Canary |
| NPCs | 1,079 definitions, 1,063 dialogues | 900 from the 10.98 pack, 179 ported from Canary |
| Quest scripts | 726 across 100 quests | Canary |
| Quest log | 50 quests, 369 missions | Canary's catalog, resolved to the storages this server writes |
| Spells | 387 | BlackTek's own, plus 124 monster spells ported from Canary |
| Items | 42,686 defined | 21,881 legacy-era, 20,805 generated from 15.25 appearances |

## Needs work

| Item | Why it matters |
| --- | --- |
| Two datapacks claim the same items | 312 scripts from the 10.98 pack still register against a map that no longer has those ids — 1,034 duplicate registrations per boot, only the first fires. |
| 239 quest scripts held back | They need Canary machinery this server has no counterpart for: `BossLever`, `Encounter`, `Hazard`, its key-value store. |
| 69 NPCs greet and trade but cannot hand out their quest | 79 dialogue callbacks need Canary's own npc object. |
| 972 monsters have no bestiary entry | They cannot be tracked, charmed, or offered as prey. |
| 83 monsters cast spells that do not exist | 40 distinct names; 32 need engine features (chain combat, `CONDITION_ROOTED`, `CONDITION_FEARED`, damage callbacks). |
| 51 player spells and the Monk vocation missing | Including the wheel Avatars and the vocation familiars. |
| No migration for the map switch | Character towns and positions still use the retired map's numbering; Canary puts Thais at town 8. |
| 45 client requests unanswered | Imbuements, bosstiary, quick loot, depot search, party analyser and others are advertised or ignored rather than implemented. |
| Thin automated coverage | 13 golden tests cover transport, id mapping and event dispatch; everything else is verified by driving a real client. |
| Stale Docker and CI paths | The compose file still targets 7171/7172/7173 and cannot serve a world — and now 7171 means the in-binary login listener, so the mapping is actively misleading; CI builds but never runs the tests. |
| One unexplained segfault | After ~8 hours under a 20,000-bot load; never reproduced, never root-caused. |

## Roadmap

The short version is below. **[`roadmap.md`](roadmap.md) has the long one** — every open issue with
its real count, what "done" looks like, and the order the work has to happen in.

No dates. This is a small team, so the order below is intent rather than a schedule, and anything
that blocks a *player* jumps ahead of anything that merely annoys a developer.

### Now

| Work | Done looks like |
| --- | --- |
| **Multi-world** | One account, many worlds. A character belongs to one world for life; store coins follow the account, what a purchase unlocks stays with the character. Design first — the login routing and the account/world data split decide everything after them. |
| **Retire the old datapack's claim on this map** | The 312 surviving 10.98 scripts stop registering against Canary's ids, and the 1,034 duplicate item-event registrations per boot go to zero. Right now the wrong script can win a lever. |
| **Boss rooms** | An equivalent of Canary's `BossLever` / `Encounter`, which unlocks the 239 quest scripts held back because nothing here answers them. This is the single biggest block of missing content. |
| **Map-switch migration** | Character towns, positions and house ownership renumbered from the retired map to Canary's, so town 1 stops meaning two different places. |

### Next

| Work | Done looks like |
| --- | --- |
| Bestiary coverage | Entries for the 972 monsters that have none, so they can be tracked, charmed and offered as prey. |
| The missing monster spells | 40 spell names that 83 monsters ask for and nothing provides. 32 need engine work first: chain combat, `CONDITION_ROOTED`, `CONDITION_FEARED`, damage callbacks. |
| Player spells and the Monk | 51 spells with no counterpart here, the Monk vocation, the wheel Avatars and the vocation familiars. |
| Cyclopedia combat pages | Stop sending ~57 hard-coded zeros for critical, leech, dodge, mitigation and the rest, and report what the character actually has. |
| Market item tiers | Forge tiers exist on items but every market listing goes out as tier 0. |
| Prey third slot | The client is told it unlocks in the store; nothing unlocks it. |
| Wheel perks, instants and stages | They are stored and exposed to Lua, and no script calls them, so they do nothing in play. |

### Later

| Work | Done looks like |
| --- | --- |
| The rest of the 15.25 surface | 45 client requests currently unanswered — imbuements, bosstiary, quick loot, depot search and stash, party analyser, highscores, team finder, hirelings, podiums. |
| Raids | Nothing is authored for this map; only upstream's three demo raids exist. |
| Test coverage worth the name | 13 golden tests cover transport, id mapping and event dispatch. Nothing exercises bestiary, prey, forge, wheel, store or quests — those are checked by driving a real client by hand. |
| Build and CI honesty | A compose file that can actually serve a world, and CI that runs `./blacktek_tests` instead of only compiling. |

### Not planned

| | |
| --- | --- |
| **10.98 and other legacy protocols** | Retired deliberately. The listeners ship disabled and the server refuses to run two generations at once. |
| **13.40 / 14.12 support** | Declared in the profile registry but never tested against a real client of either band. They stay unsupported until somebody verifies them; a declared profile is not a promise. |

---

## Provenance and credit

**The C++ in `src/` is written here, not copied.** Where a wire format or a loader shape needed a
reference implementation, [Canary](https://github.com/opentibiabr/canary) was read as a
cross-check alongside the client's own parsers, and every place that happened says so in the source
— for example `src/protocol.cpp:3` and `src/appearances.cpp:3`. The code itself follows BlackTek's
`CONTRIBUTING.md` rather than Canary's conventions.

**The world content in `data/` is different: it was machine-ported from Canary's open datapack.**
The map, 839 monsters, 179 NPCs, 726 quest scripts, the quest log, the storage numbering and 27
library functions are derived from that work, and it is redistributed here under the same
**GPL-2.0** licence both projects use.

That porting was a one-time job and the server does not depend on it. Everything it produced is
committed — the world, the scripts, the data — so a clone builds and runs with no Python, no Canary
checkout and no conversion step. The one-way converters are kept in `harness/` as the record of how
the content was derived and to make a future re-port from a newer Canary release repeatable; nothing
at build time or runtime reads them.

With thanks to:

- **[BlackTek Server](https://github.com/Black-Tek/BlackTek-Server)** — the base server this forks.
- **[The Forgotten Server](https://github.com/otland/forgottenserver)** and
  **[OpenTibia](https://github.com/opentibia/server)** — the lineage underneath it.
- **[Canary / otservbr](https://github.com/opentibiabr/canary)** — the datapack and map this world
  is built from, and the reference implementation for modern protocol behaviour.
- **SeeingBlue and TimerTim** — the 10.98 real-map datapack whose monsters and quest libraries are
  still part of this tree.
- **[mehah's OTClient](https://github.com/mehah/otclient)** — the client every feature here is
  verified against.

---

## Build

```bash
./bootstrap.sh                                    # first time: packages, premake5, vcpkg
premake5 gmake2                                   # re-run after adding any source file
make -j$(nproc) config=release_64 CC=gcc-14 CXX=g++-14
./blacktek_tests                                  # 13 golden tests
```

GCC 14 or newer is required (the code is C++23 and uses `std::println`); `bootstrap.sh` still only
refuses GCC below 10, so an older-but-not-ancient compiler gets all the way to a failing build. It
also does not pin one, so whether a fresh clone builds depends on where `c++` points — pass
`CC`/`CXX` as above rather than trusting the default.

`bootstrap.sh` itself fails part-way on current vcpkg: after the `x64-linux` install succeeds it
runs `vcpkg install --triplet x64-linux-static` (`bootstrap.sh:205`), and that triplet no longer
exists. Premake has already written both makefiles by then and the dynamic dependencies are
installed, so the `make` line above works regardless — the failure is cosmetic unless you want a
static release build.

## First boot

1. **Database** — import `schema.sql` into MySQL/MariaDB and set `config/database.toml`. Migrations
   in `data/migrations/` then run automatically; the schema is at version 7.
2. **Unpack the world** — it ships packed, because the map is 177 MB unpacked:

   ```bash
   7z x data/world/canary.7z -odata/world
   ```

   That is the whole of it: map, spawns and houses. The spawn zones, monsters, NPCs, quests and
   items are already in the tree. `data/world/realmap.7z` (the retired 10.98 real map) and
   `forgotten.otbm` (upstream's demo map) also ship; switch with `map_name` in `config/server.toml`.
3. **Run it** from the repository root — configuration is TOML loaded by relative path:
   `./Black-Tek-Server`.

Ports come from `config/server.toml`: the modern game listener is **7183**, status is **7184**, and
the login listener is **7171** — a client-side constant, since a 15.25 client only speaks the
in-binary login protocol on that port and goes to HTTP login on any other. The legacy game listener
is off (`game_port = 0`). Boot refuses if `login_port` collides with another listener. Real clients
can still authenticate through an
[opentibiabr/login-server](https://github.com/opentibiabr/login-server)-compatible webservice, which
is not part of this repository.

## Verifying a change

`harness/` holds the packet tooling (`harness/README.md`). A full pass is: build, `./blacktek_tests`,
a scripted 15.25 login (`harness/modern_client.py`), and a headless run of the real client
(`xvfb-run -a ./otclient`) while `harness/capture_proxy.py` records the session for
`packet_diff.py --decode`.

---

## What is BlackTek Server?
__________________
**BlackTek Server** is an open source **2D Top Down MMORPG Game Server**, with tailor-made gameplay and tile based movement,  developed in modern C++. 

## What is the point of BlackTek Server?
_______________
**BlackTek Server** is intended to provide a user-friendly experience building 2D MMORPG's in a _**rapid development environment**_. Ultimately the goal is to create a user experience that removes the barrier between _**content creator**_ and _**programmer**_. 

## What sparked this idea?
__________________
BlackTek Server's origins started first with [OpenTibia](https://github.com/opentibia/server) and later [The Forgottenserver](https://github.com/otland/forgottenserver), both are game servers designed to emulate a popular 2D MMORPG known as Tibia.

Having had my fun growing up tinkering with OpenTibia servers like TFS, I always wished they were not built so strict (explicitly emulating tibia), and allowed much more custom types of things. Since that never happened, I decided to do it myself!

BlackTek Server's starting codebase is [The Forgottenserver 1.4.2](https://github.com/otland/forgottenserver/releases/tag/v1.4.2), and BlackTek Server [1.0]() and [1.1]() were built to be almost completely backwards compatible with TFS 1.4.2.

## BlackTek Goals
If you would like to get an understanding for the future plans of BlackTek Server, take a look [here](https://github.com/Black-Tek/BlackTek-Server/wiki/Official-To%E2%80%90Do-List)

## Contributing
I haven't created official contribution guidelines just yet, but any bugs found and reported is very helpful. You can also support this project financially through the discord.

## Getting Started
____________
If you wish to get started immediately you may download all the binaries along with the datapack and other required files from our [Release Section](https://github.com/Black-Tek/BlackTek-Server/releases).

Getting setup for compiling can be done the easy way by running either the ```bootstrap.bat```(Windows) or ```bootstrap.sh```(Linux).

If you prefer compiling manually, or you are looking for a more thorough getting started guide, you can find the information needed, based on your specific needs in our wiki [here](https://github.com/Black-Tek/BlackTek-Server/wiki/Getting-Started#compiling).

### Running with Docker

You can run BlackTek Server using Docker on Windows, Linux or macOS:

```bash
docker-compose up -d --build
```

This will compile your `/src` sources, start MariaDB, and run the game server on ports 7171/7172. Any changes you make to the source code will be compiled when you run with `--build`. You can manage your database through [whodb](https://github.com/clidey/whodb) at `http://localhost:8080`.

> [!NOTE]
> On Windows, if the build fails due to memory issues, increase WSL memory by creating `C:\Users\YOUR_USER\.wslconfig`:
> ```ini
> [wsl2]
> memory=16GB
> processors=8
> swap=4GB
> ```
> Then restart WSL with `wsl --shutdown` and try again.

## Where to find a compatible client?
____________
> [!NOTE]
> Upstream section — does not apply to this fork. ArkOT is 15.25-only; see "About this fork" at the top.

The BlackTek server is currently using the Tibia 10.98 client protocol. You can use either the original client which you can find [here](https://downloads.ots.me/data/tibia-clients/windows/exe/Tibia1098.exe) as an .exe, or [here](https://downloads.ots.me/data/tibia-clients/windows/zip/Tibia1098.zip) as a .zip. 

Alternatives which support this protocol include [Open Tibia Client](https://github.com/edubart/otclient) and any of it's derivatives such as [OTC Redemption](https://github.com/mehah/otclient#-otclient---redemption) & [OTCv8 (OTA)](https://github.com/OTAcademy/otclientv8).