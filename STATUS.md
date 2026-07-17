# Modern Protocol Port — STATUS

Branch: `modern-protocol` (local only). Last session: 2026-07-16.
Reference checkouts: `~/Documents/canary`, `~/Documents/login-server` (both shallow clones).

## Gates

| Gate | State | Evidence |
|------|-------|----------|
| H — harness | **PASS** | `harness/packet_diff.py` decodes/diffs legacy+modern fixtures; `blacktek_tests` 7/7 green |
| 0 — merge, legacy intact | **PASS** | scripted 10.98 client (`harness/legacy_client.py`) logs in + walks against live server; full build clean (GCC 14, release_64) |
| A — session login | **PASS** | POST /login on opentibiabr/login-server → session key → modern handshake on 7173 → "Tester has logged in." → walk answered. Legacy re-run green. |
| B — asset/ID pipeline | **PASS** | 21 golden items round-trip serverId↔15.25 appearanceId with client-flag agreement; full 21,840-row table verified appearance-backed (41 stale rows auto-pruned); blacktek_tests 10/10; live legacy+modern gates re-run green |
| C — enter world (mehah) | **NOT STARTED** | needs a mehah Redemption client at 15.25 (Josh confirmed that's the target client) for the real gate |
| D — feature stubs | **NOT STARTED** | |
| E — long tail | **NOT STARTED** | |

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

## Layout assumptions still UNVALIDATED (needs a real mehah capture)

- Modern first client frame = `[u16 blockCount][u32 seq][u8 padCount][0x0A]
  [fields...]` — inferred from canary skipping `CHECKSUM_LENGTH + 2`. My
  scripted client and the server agree with each other (proves internal
  consistency only, not client compat).
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

# login webservice (source-built image login-server-local, host network,
# HTTP 8090, points clients at 7173)
docker start blacktek-login

# game server (config/database.toml is locally modified to point at the
# test DB - intentionally NOT committed)
cd ~/Documents/BlackTek-Server && ./Black-Tek-Server

# gates
python3 harness/legacy_client.py --character Legacy
python3 harness/modern_client.py --webservice http://127.0.0.1:8090 \
    --email test@test.com --password test --character Tester
./blacktek_tests
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
