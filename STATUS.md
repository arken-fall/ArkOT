# Modern Protocol Port — STATUS

Branch: `modern-protocol`. Last session: 2026-09-14.
Public remote: https://github.com/arken-fall/ArkOT (this branch pushed as `main`).

**2026-09-14 — Outfit change + kill tracker crash (real-client verified).**
`parseSetOutfit` now reads the 12.81+ layout (window byte, mount colours,
mounted flag, familiar, randomize flag) — the legacy read garbled the
looktype and left the character invisible. The kill-tracker Lua binding
unwrapped the corpse userdata as a container instead of its item and threw
`bad_alloc` on every kill ("Allocation failed, server out of memory"); fixed.
Kill, loot and impact trackers and the outfit change verified live.

**2026-09-14 — Live-test fixes.** From Josh's first session on the deployed
build: (1) fluids on 12.x+ clients are sent by the client's own fluid list
(blood was showing as mana/pink) — `ModernFluidId`; (2) use/rotate/wrap/trade
requests compare by appearance, since aliased server ids share one and the
reverse id map returns the canonical one (random "You cannot use this
object" on smart left-click) — `Items::sharesAppearance`; (3) the hunt
analysers now get their packets: impact tracker 0xCC (heal, damage dealt,
damage received by element) from the combat notifications, supply tracker
0xCE from any use that consumed the item, a charge or a portion, loot
tracker 0xCF and kill tracker 0xD1 from the drop-loot callback
(`player:sendLootTracker`, `player:sendKillTracker`); feature bit
`HuntAnalytics`. Not a server issue: zone respawns near players are the
datapack's `passive`/`forced` zone flags by design; blank cyclopedia tabs and
the dead Customise Character menu were the client resolving bare layout
names against the wrong directory during the render pass (absolute paths
in the cyclopedia tab modules and the outfit module; a blanket rewrite of
all 78 loads caused a reconnect loop and was reverted).

**2026-09-14 — Contribution-guide pass.** The bestiary, prey and forge
sources were audited against `CONTRIBUTING.md`: enums now nest inside
their owning class, `continue` loops became filtered views, free helpers
are PascalCase, struct fields and inline getters are column-aligned. No
behaviour change; all three harnesses rerun clean on the real client.

**2026-09-14 — Exaltation forge (real-client verified).** `src/forge.h/.cpp`,
`config/forge.toml`. Rig proof: price list and tuning at login (four
classes, ten class-4 tiers with 64-bit gold prices, cores per tier,
convergence prices), the forge window sorts the carried items into fusion
pairs, convergence groups, donors and receivers; fusion of two terra rods
(a failure that spent the second rod, then a success to tier 1), a tier-2
transfer between two class-2 legs (receiver at tier 1), 20 dust -> 3
slivers, 50 slivers -> 1 exalted core, the dust limit raised, history paged
1/2, dust/sliver/core balances after every step; zero protocol exceptions.
Tier rides on the item as the custom attribute `forgetier` (saves, trades
and shows in the item's tier byte); dust and its cap are `players`
columns, history is `forge_history`, migration 4 (5.lua sentinel). Dust
drops from kills (`Forge::System::onKill`). Lua: `player:getForgeDust`,
`addForgeDust`, `getForgeDustLevel`, `openForge`; `item:getForgeTier`,
`setForgeTier`; using an exaltation forge (39497-39499) opens the window.
Side fixes found by the rig: generated 15.25 items now borrow their
appearance's flags (stackable, pickupable, moveable, blocking, top order,
rotatable, useable, hangable) since they have no legacy dat entry; 16
monster files had their bestiary block placed before `local monster = {}`
(the generator now anchors on that line when there is no description).
Client API for the harness: `g_game.forgeRequest(action, convergence,
firstId, tier, secondId, improve, tierLoss)`, `sendForgeBrowseHistoryRequest(page)`.

**2026-09-14 — Prey system (real-client verified).** `src/prey.h/.cpp`,
`config/prey.toml`. Rig proof: two slots offer nine creatures at login
(third locked, store unlock), pick -> active with a rolled bonus (damage
boost 15% grade 5), wildcard bonus reroll (loot 34% grade 8), full-bestiary
list of 430 races, free list reroll with the 20-hour timer shown, countdown,
wildcards 10 -> 4, all rows persisted. Lua: `player:getPreyExperiencePercentage`,
`getPreyLootPercentage` (used by the drop script), `getPreyWildcards`,
`addPreyWildcards`. Client API for the harness: `g_game.preyAction(slot,
action, index)`, `preyRequest()`.

**2026-09-14 — Bestiary system (real-client verified).** New
`BlackTek::Bestiary` module (`src/bestiary.h/.cpp`): race registry built as
monsters load (`monster.raceId` / `monster.bestiary` in the monster Lua),
kill stages, loot rarity bands, charm table from `config/charms.toml`, charm
purchase/assign/unassign, and assigned charms as augments filtered by the
creature's name. Player state: kills per race, charm points, charm slots
(`player_bestiary`, `player_charms`, `players.charm_points`; migration 2).
`harness/build_bestiary_data.py` gave 456 of 740 monsters their entries
from Canary's datapack by name. Rig proof: races 21/430, overview Mammal 49,
rat page stage 4, tracker refresh on kill, kill count 250 -> 252 persisted,
Wound bought (5000 -> 4760 points) and assigned to rat (persisted).
GOTCHAS: client binds `g_game.BuyCharmRune` (capital B) and
`requestBestiaryOverview(name, false, {})` needs the id list.

**2026-09-14 — Phase D tranche 2 (real-client verified).** Prey (three
locked slots + prices, at login and on 0xED), bestiary (0xE1 races, 0xE2
overview, 0xE4 charms, empty), object inspection (0xCD -> 0x76) with the
item's name, look and description rows, character inspection (0xCE and
cyclopedia type 9) with the worn items and outfit. Base info now writes the
outfit without a mount, which the client reads that way (2 leftover bytes
had been showing as an "unhandled opcode 0x01" warning client-side).

**2026-09-14 — Phase D tranche 1 (real-client verified).** Cyclopedia
character pages and the blessings dialog, driven from a harness rc that
requests every info type. Two 15.25 deltas the client's own feature table
settled: the tournament u32 left the general stats page at 13.14, and the
forge-skill quartet left the combat page at 14.10 (both now gated on the
profile). Unhandled client opcodes now log on the network channel at debug
level, so the next gaps show up in the rig log instead of a guess.

**2026-09-13 — Phase E tranche 2 (real-client verified).** Same headless rig,
this time creating a market counter beside the GM through the admin Lua
channel (`Game.createItem(14405, 1, p)`), using it (proves the client-id
reverse mapping: the client names the counter 12903), then browse item /
own offers / own history / leave: every packet parsed, zero exceptions.
Regression caught by the capture: heal and experience messages shared one
case in `AddTextMessage`; the u64 widening now applies to experience only.

**2026-09-13 — Phase E tranche 1 (real-client verified).** Headless rig:
`xvfb-run -a ./otclient` with a harness `otclientrc.lua` that logs in as
`GM Josh`, requests the outfit window and quest log, `/goto Eryn`, opens the
shop over the NPC channel and logs out. Result: 0xC8 parses (56 outfits,
100 mounts), 0x7A lists 45 wares with 15.25 ids/names, 0x7B + two 0xEE
balances parse, /goto lands next to the NPC, no protocol exceptions.
GOTCHA: this client build's `EnterGame.setAccountName/setPassword` decrypt
their input — write `accountNameTextEdit`/`accountPasswordTextEdit` directly.

**2026-09-13 — upstream trunk merged.** `origin/master` (BlackTek 2.0 +
the Aug 2026 trunk: unified ItemEvents, shared-pooled allocator, detached
coro-timers, spectator broadcast helpers, dispatcher-side login) merged
into `modern-protocol`. Three conflicts, all in the protocol layer: the
login parse now hands off to `authenticateAndLogin` on the dispatcher with
the session key carried as its own argument; upstream's static
`AddMagicEffect`/`AddDistanceShoot` (one message for every spectator) take
the layout of the enabled listener via `ProtocolGame::setSharedModernLayout`,
and the server refuses to start with both `game_port` and
`game_port_modern` enabled. Verified: release build clean, blacktek_tests
10/10, gate A (scripted 15.25 login + walk) green on the rig.

**2026-08-11 — legacy 10.98 retired.** This server is 15.25-only by decision:
`game_port`/`login_port` now support 0-to-disable (like `game_port_modern`)
and ship disabled, so no listener speaks the legacy framing. Gate 0's
scripted 10.98 client and the legacy half of the packet-diff harness are
kept for reference but no longer run against a live port.
Reference checkouts: `~/Documents/canary`, `~/Documents/login-server` (both shallow clones).
Real client: `~/Documents/BlackTek15` (mehah OTClient Redemption, built from source, 15.25 assets auto-installed).

## Gates

| Gate | State | Evidence |
|------|-------|----------|
| H — harness | **PASS** | `harness/packet_diff.py` decodes/diffs legacy+modern fixtures; `blacktek_tests` 10/10 green |
| 0 — merge, legacy intact | **PASS** | scripted 10.98 client (`harness/legacy_client.py --account testacc --port 7182`) logs in + walks; full build clean (GCC 14, release_64) |
| A — session login | **PASS** | POST /login on opentibiabr/login-server → session key → modern handshake → "Tester has logged in." → walk answered |
| B — asset/ID pipeline | **PASS** | 21 golden items round-trip serverId↔15.25 appearanceId; full table appearance-backed (41 stale rows pruned); blacktek_tests 10/10 |
| C — enter world (mehah) | **PASS** | **real mehah 15.25 client renders the world and walks, zero parse errors / zero invalid-thing warnings** (2026-07-20). Autonomous edit/build/launch/screenshot loop via `otclientrc.lua` auto-login harness |
| D — feature stubs | IN PROGRESS | 2026-09-14: cyclopedia character info (all 15 request types answered; base, general, combat, offence, defence, misc, deaths, item summary, outfits/mounts, store summary, badges, titles carry real data where the server has it) and the blessings status + dialog verified on the real 15.25 client; prey slots (locked, with prices) sent at login and on request, bestiary races/overview/charms answered empty, object and character inspection windows (0x76) and the cyclopedia inspection page verified on the real client; **bestiary is a real system** (race ids + entries on 456 monsters from Canary's data, kill tracking persisted in `player_bestiary`, staged creature pages, tracker, charm points, `config/charms.toml` runes unlocked/assigned/persisted in `player_charms`, assigned runes applied as augments against the creature) — verified on the real client; **prey is a real system** (`BlackTek::Prey`: three slots, nine-creature lists by level band, bonus rolls with rarity, gold/wildcard rerolls, full-list picks, options, once-a-minute countdown, damage bonuses as augments, experience and loot bonuses at their hooks, `player_prey` + `players.prey_wildcards`, migration 3) — verified on the real client; **the exaltation forge is a real system** (`BlackTek::Forge`: classification price tables in `config/forge.toml`, fusion with success/bonus rolls, tier transfer, dust from kills capped by a raisable dust level, dust -> slivers -> exalted cores as items, forge history in `forge_history`, tier on the item as a custom attribute, migration 4) — verified on the real client; wheel/store still stubbed off |
| E — long tail | IN PROGRESS | 2026-09-13: NPC shop (0x7A/0x7B + 0xEE balances), outfit window (0xC8), death window, text windows, quest line, GM map teleport (0x73), market (enter/browse/own offers/history/leave with request bytes, tiers, u64 prices, 15.25 descriptions), client item ids reverse-mapped for use/move/rotate/wrap/trade/equip/shop — all verified on the real 15.25 client; u16 spell cooldowns and u64 experience messages ported by layout (GM has no cooldowns, so not client-verified); cyclopedia still pending |
| F — real map | **PASS** | 2026-09-14: `realmap.otbm` (13.3 M tiles) boots in 8 s at ~10 GB RSS with 14,162 spawn zones (65,652 monsters), 876 NPCs and 1164 houses; the SeeingBlue actions/movements/monsters/quest libs converted to BlackTek revscripts; headless 15.25 login at the Thais temple, NPC greet/heal/farewell over the NPC channel, zero decode errors. Engine fix: environmental damage (traps, fields, `doTargetCombat(0, ...)`) no longer dereferences a null attacker (`Combat::strike_environment`). Unpack `data/world/realmap.7z` before the first boot. |
| G — wheel of destiny | **PASS** | 2026-09-14: `src/wheel.h/.cpp`, opcodes 0x61/0x62/0xE7 in, 0x5F/0xC5 out, resource balances 0x51-0x55; headless 15.25 client on a level-400 elite knight: window renders (8 starting gems, 46+23 grade rows), 350 points saved with slot rules enforced (+150 health, +200 mana as the tables say), gem reveal/lock/destroy/rotate all round-trip, rows persist across relog, zero decode errors, 10/10 tests. Fix: gold now paid from bank when the purse is short (wheel and forge). |

### Phase C ground truth (2026-07-20)

Real client caught two desyncs internal consistency never could:
- **AddCreature** was missing the `GameCreatureIcons` single-icon byte
  (between the vocation/summon block and the mark). One byte shifted the
  entire map stream → `getThing: invalid thing id`.
- **sendItems (0xF5)** wrote u16 counts where 15.25 reads a *packed
  varint* (`readPackedCount1500`). One byte per entry drifted the
  action-bar list → 42 bogus `0xXX00` item ids.

All modern writers are gated on `protocol_profile->generation == Modern`
(and finer `ProtocolFeature` bits). Legacy 10.98 path is byte-for-byte
untouched and re-verified each session. To decode a live capture set
`BLACKTEK_DEBUG_XTEA=1` and feed the logged key to `packet_diff.py --xtea`.

Auto-login harness: `~/Documents/BlackTek15/otclientrc.lua` fills the
Enter Game form, logs in via the webservice, picks `Tester`, and walks a
short loop on `onGameStart`. Delete that block for a normal client.

## What exists now

- `src/protocolprofile.h` — profile registry (10.98 / 13.40 / 14.12 / 15.25),
  `ProtocolFeature` bits, data-driven `GameLoginLayout`, `resolveProfile()`.
  The ONLY place version numbers appear.
- Modern transport in `Protocol`/`Connection`/`OutputMessage`: sequence
  checksums, padding-byte XTEA layout, block-count outer length, raw-deflate
  compression (≥128 bytes, high bit of sequence). Golden-tested in
  `tests/test_modern_framing.cpp` against Python-generated vectors.
- **Dual-port design**: the server-first challenge is framed differently per
  generation, so generation = port, no byte sniffing. `game_port_modern`
  (default 7173, `[network]` in server.toml, 0 disables) served by
  `ProtocolGameModern` (thin subclass tag; `ProtocolGame` lost its `final`).
  Modern clients learn the port from the login webservice JSON.
- `onRecvFirstMessage` rewritten layout-driven; both generations share the
  credential/ban/auth tail. Opaque session keys → `IOLoginData::
  sessionKeyAuthentication` (SHA-256 lookup in `account_sessions`);
  `email\npassword` direct login also works on the modern port.
- DB: migration to version 2 creates `account_sessions` + adds
  `premdays`/`lastday` compat columns to `accounts` (the webservice SELECTs
  them; `premium_ends_at` stays authoritative server-side).
- ~60 modern client opcodes named in `networkopcodes.h` (verified against
  canary's dispatch). Handlers NOT wired yet — names only.
- docker-compose gained a `login-server` service. Note: **build its image
  from source** (`docker build -f docker/Dockerfile .` in the login-server
  repo) — the compose entry references `opentibiabr/login-server:latest`,
  which may lag the source; the session-mode+hints code I verified is from
  the repo, and my live test used a source-built image (`login-server-local`).

## Deviations from the handoff doc (deliberate, with reasons)

1. **No `port/` folder existed** — the Tranche 0 files it promised were never
   on disk. Everything described was re-derived directly from canary source
   and written fresh. Treat all of it as this session's work, not a merge.
2. **`account_sessions`, not `sessions`** — the handoff's table spec
   (token/ip/created/character_name) predates reading login-server source.
   The Go service stores `sha256(sessionKey)` as `id` in `account_sessions`;
   reusing it unmodified means matching that. Kept the extra audit columns
   (ip/created/character_name nullable) on top.
3. **Separate modern game port** instead of one dual-generation port — the
   challenge is sent before the client speaks, so one port cannot serve both
   framings deterministically. Canary "solves" this with per-IP session
   hints; the port split is simpler and testable. Revisit only if a single
   port becomes a hard requirement.

## Layout assumptions — VALIDATED against a real client (2026-07-20)

A live mehah OTClient Redemption 15.25 (built from source at
~/Documents/BlackTek15, assets auto-installed by its client_assets module)
logged in end-to-end. Results:

- **NEW ground truth**: clients >= 1200 send a plaintext `"<worldName>\n"`
  line as the very first bytes on the game connection, BEFORE any framed
  traffic (mehah `Protocol::onConnect`). Server consumes it now
  (Connection::skipWorldNameByte, commit 0a38c61). Captures 4/5 in
  harness/captures/ show the original failure.
- Modern first-frame layout otherwise CONFIRMED: client computes remaining
  size as `blockCount * 8 + 4` for >= 1405 (mehah
  `Protocol::internalRecvHeader`) — matches our writer exactly.
- Challenge frame CONFIRMED parseable by the real client (pad byte consumed
  by first-recv `getU8()`, 0x1F handled, login packet sent in reply).
- Session-key login, RSA, XTEA, sequence framing, and compression all
  CONFIRMED — server log shows "Tester has logged in" from the real client.
- The client then parses world packets until drift after opcode 0xA0
  (player stats): `Unhandled opcode 0x00 with 11525 unread bytes; previous
  opcode 0xA0; next bytes 40 9C 00 00 68`. That is the 10.98-vs-15.25
  writer boundary — Phase C's porting surface, now precisely located.

Still unvalidated:
- 13.40 and 14.12 login layouts assumed identical to 15.25's.
- Modern challenge tail byte `0x71` copied from canary verbatim; meaning
  unknown.
- Feature-bit assignments for 13.40 vs 14.12 vs 15.25 (which systems each
  band expects) are coarse; refine as writers land in Phase C/E.

## How to run the live setup

```bash
# DB (already running as docker container blacktek-test-db, port 3307,
# root/bt_test, db blacktek, user forgottenserver/bt_test)
docker start blacktek-test-db

# login webservice (container blacktek-login, HTTP on 127.0.0.1:5185).
# CRITICAL: SERVER_PORT env must be 7174 (the capture proxy) for capture
# work, or 7183 (game_port_modern) to bypass it. Another agent session's
# rig scripts recreate this container with SERVER_PORT=7182 (legacy port),
# which silently breaks modern logins - re-check after any rig restart.
docker start blacktek-login

# game server (config/database.toml + config/server.toml locally modified -
# intentionally NOT committed; ports moved to 7181/7182/7183 because the
# ArkEngine dev server owns 7171/7172 on this machine)
cd ~/Documents/BlackTek-Server && ./Black-Tek-Server

# capture proxy (byte captures land in harness/captures/, written on
# connection close)
python3 harness/capture_proxy.py --listen 7174 --target 127.0.0.1:7183

# gates
python3 harness/legacy_client.py --character Legacy
python3 harness/modern_client.py --webservice http://127.0.0.1:5185 \
    --email test@test.com --password test --character Tester --port 7174
./blacktek_tests

# real client (mehah Redemption 15.25, built from source)
cd ~/Documents/BlackTek15 && ./otclient
# Enter Game: HTTP login on, server http://127.0.0.1:5185/login,
# version 1525, test@test.com / test
```

Build: `~/.local/bin/premake5 gmake2 && make -j24 config=release_64 CC=gcc-14 CXX=g++-14`
(system gcc-13 lacks `std::println`; vcpkg deps: `~/vcpkg/vcpkg install --triplet x64-linux`
from the repo root. Do NOT also install x64-linux-static — manifest mode
removes the other triplet's files; the Linux link only uses x64-linux.)

## Phase B facts (established this session)

- **BlackTek's unified item ids are TFS server ids** (assets.dat is indexed
  by them; the wire writes them raw). The handoff's "items.otb stays the
  server-id source" was stale — there is no OTB anymore, and no clientId
  field anywhere.
- **CipSoft appearance ids are append-only across generations**: a 10.98
  client id IS the 15.25 appearance id (verified: gold coin 3031, bag 2853,
  red apple 3585, torch 2920). So the modern mapping is simply the classic
  TFS 10.98 OTB server→client table.
- `harness/build_modern_ids.py` regenerates `data/items/modern_client_ids.tsv`
  (21,881 rows, 76.4% name-verified against canary's items.xml; needs
  ~/Documents/forgottenserver-ref + ~/Documents/canary checkouts).
- `data/items/appearances.dat` is **canary's in-repo file** (their custom
  15.25-compatible asset data, 42,107 objects) — fine for validation and
  flag-parity work, but Phase C testing against a real client should use the
  client's own appearances file (config: `[world] appearances_dat_path`).
- Loader: `src/appearances.h/cpp` (protobuf-lite; proto vendored at
  `src/protobuf/appearances.proto`, codegen runs AT PREMAKE TIME into
  `src/protobuf/generated/` — leave that dir untracked; re-run premake after
  vcpkg install, bootstrap.sh now does this itself).
- `Items::getModernClientId()/getItemIdByModernClientId()`; rows whose
  appearance no longer exists (CipSoft deleted 41 of them) are pruned at
  load when appearances are present.
- Client-flag drift is real and the flag test catches it: food (red apple,
  brown mushroom) is stackable client-side in modern clients even though the
  10.98 server types aren't. Phase C writers must consult AppearanceInfo for
  wire classes, not ItemType alone.
- Wire-write audit: all 28 item-id writes live in protocolgame.cpp via
  NetworkMessage::addItem/addItemId (plus Lua's networkMessage:addItemId).
  NetworkMessage has no protocol context, so Phase C should funnel modern
  translation through one ProtocolGame-level helper rather than touching
  NetworkMessage. Appearance ids fit u16 today (max ~42k... they do NOT fit
  u16 above 65535 — current max is below that; the mapper is u32 internally
  and a Phase C writer must guard the u16 narrowing).

## Exact next actions (Phase C)

1. Get a mehah OTClient Redemption build + 15.25 assets on the desktop
   (Josh confirmed Redemption/15.25 as the target client). First capture:
   the game-login packet, to validate the ASSUMED first-frame layout
   (`[seq u32][pad u8][0x0A]`) and the 13.40-vs-15.25 login layout rows.
2. Port writers in the handoff's Phase C order, each with a golden test:
   login success block, pending state, map description, creature add/update,
   player stats 0xA0 (PlayerLevelPercentU16), skills, magic effects
   (ExtendedMagicEffects), text messages, channels, walking codes.
3. Add the ProtocolGame item-write helper (server id → appearance id via
   Items::getModernClientId, wire class from AppearanceInfo, u16 guard),
   feature-gated on ProtobufAppearances.
4. Phase D stubs (protocolgame_stubs.cpp) can start in parallel once the
   enter-world skeleton exists.

## Watch out for

- `enableunitybuild` is ON — anonymous-namespace name collisions across
  src files will bite; keep test/probe classes inside tests/.
- Adding files requires re-running premake (`gmake2`) — the Makefile globs
  are baked at generation time.
- `pkill -f Black-Tek-Server` from a script whose own cmdline contains the
  pattern kills the script; use `pkill -x`.
- The live player stays seated after a scripted client disconnects, so
  back-to-back logins of the same character hit the reconnect path — use
  separate characters per test (Tester=modern, Legacy=legacy).
