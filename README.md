# Black Tek Server 
__________________
[![Discord Shield](https://discordapp.com/api/guilds/1251683017441677372/widget.png?style=shield)](https://discord.gg/dy5wXSzbPG)
[![Linux Build](https://github.com/Black-Tek/BlackTek-Server/actions/workflows/linux_build_runner.yml/badge.svg?branch=master)](https://github.com/Black-Tek/BlackTek-Server/actions/workflows/linux_build_runner.yml) 
[![Windows Build](https://github.com/Black-Tek/BlackTek-Server/actions/workflows/windows_build_runner.yml/badge.svg)](https://github.com/Black-Tek/BlackTek-Server/actions/workflows/windows_build_runner.yml)

## About this fork — ArkOT, by the ArkenFall team
__________________
This repository (**ArkOT**) is the ArkenFall team's fork of BlackTek Server, updated to speak the **modern Tibia 15.25 client protocol**. We are **not part of the BlackTek team** and this fork is not affiliated with or endorsed by them — all credit for the base server belongs to the BlackTek project and its upstream lineage (TFS / OpenTibia). Everything below this section is their original README.

**Where it stands (2026-09-13).** The fork tracks upstream BlackTek `master` (2.0 "Rise After Midnight" plus the August 2026 trunk: unified ItemEvents, shared-pooled allocator, detached coro-timers, spectator broadcast helpers, dispatcher-side login) and is verified against a real [mehah OTClient](https://github.com/mehah/otclient) 15.25 build entering the world, walking, chatting and using the windows listed below with zero parse errors. Progress is tracked gate by gate in `STATUS.md`; every change and the reasoning behind it is recorded in `arktext.md`.

What we changed to get from 10.98 to 15.25:

- **Protocol profiles** (`src/protocolprofile.h`) — a registry describing each supported protocol generation (10.98 / 13.40 / 14.12 / 15.25) with per-version feature bits and a data-driven login layout. It is the only place version numbers appear; everything else asks the profile.
- **Modern transport** — the 13.40+ wire framing: sequence-number checksums, the padded XTEA layout, block-count outer lengths, and raw-deflate compression, golden-tested against independently generated fixtures.
- **HTTP login flow** — modern clients authenticate through a login webservice (compatible with [opentibiabr/login-server](https://github.com/opentibiabr/login-server)) that hands out opaque session keys; the server validates them via SHA-256 lookup in a new `account_sessions` table (DB migration included). Authentication runs on the dispatcher, as upstream now does it.
- **A dedicated modern game port** (`game_port_modern`) — the modern handshake is framed differently from the legacy one, so each generation gets its own listener instead of byte-sniffing. Shared spectator broadcasts are written once per server in the layout of the enabled listener; running both listeners at once is refused at startup.
- **Protobuf appearances** — the server loads a 15.25 `appearances.dat` and maps its unified item ids to modern appearance ids (~42k entries), pruning stale rows at load. The 20,805 appearances with no 10.98 item are registered as server items with gameplay attributes joined from community data.
- **Ported game-packet writers** — login, stats, skills, creatures, items, effects and map descriptions rewritten for the 15.25 wire format where it diverges, gated on the protocol profile.
- **Windows a player opens first (Phase E)** — NPC shop and sale lists (currency block, client ids, u16 amounts, resource balances), the outfit window (12.81+ list layout), death and text windows, quest log and quest lines with mission ids, the market (request bytes, item tiers, u64 prices, the full 15.25 description set), u16 spell cooldowns, u64 experience messages, and the gamemaster map-click teleport.
- **Cyclopedia, blessings, inspection (Phase D)** — every cyclopedia character-info request type is answered (general, combat, offence, defence and misc stats, recent deaths from the database, item summary, outfits and mounts, store summary, badges, titles, inspection), the blessings status and dialog, and the object and character inspection windows.
- **Bestiary and charms (Phase D, real system)** — a `BlackTek::Bestiary` module: race ids and bestiary entries on the monster types (`monster.raceId`, `monster.bestiary` in the monster Lua; 456 creatures filled from public bestiary data by name via `harness/build_bestiary_data.py`), kill tracking per character with staged creature pages and the cyclopedia tracker, charm points on completion, and the 25 charm runes from `config/charms.toml` that are bought with points, assigned to a completed creature and applied as augments against it. State lives in `player_bestiary`, `player_charms` and `players.charm_points` (migration included).
- **Prey (Phase D, real system)** — a `BlackTek::Prey` module driven by `config/prey.toml`: three slots (two free, the third by config or store), nine-creature lists drawn from the bestiary by the character's level band, bonus rolls with rarity (damage boost, damage reduction, experience, loot), rerolls for gold or wildcards, full-bestiary picks, automatic-reroll and lock options, a once-a-minute countdown, and the bonuses themselves: damage boost and reduction as augments against the creature, experience at the gain, loot in the drop script. State lives in `player_prey` and `players.prey_wildcards` (migration included).
- **Legacy retired** — this fork is 15.25-only: the 10.98 game/login listeners ship disabled (`game_port = 0`, `login_port = 0`; `0` disables a listener).

Behaviour for the modern packets is taken from the client's own parsers, with [Canary](https://github.com/opentibiabr/canary) as a cross-check; the code itself follows BlackTek's conventions (see `CONTRIBUTING.md`) rather than theirs.

Still to come: the exaltation forge, the wheel of destiny and the 12.x store protocol, which are stubbed off so the client is in-world without them; and a real-map datapack in BlackTek's Lua/TOML layout.

**Verifying a change.** `harness/` holds the packet-diff and scripted-client tools (`harness/README.md`). A full check is: build, `./blacktek_tests`, the scripted 15.25 login (`harness/modern_client.py`), and a headless run of the real client (`xvfb-run -a ./otclient` with an `otclientrc.lua` that logs in and exercises the feature) while `harness/capture_proxy.py` records the session for `packet_diff.py --decode`.

To connect, use a mehah OTClient build with 15.25 assets and HTTP login pointed at your login webservice — the client section further down describes upstream's 10.98 setup, which does not apply to this fork.

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