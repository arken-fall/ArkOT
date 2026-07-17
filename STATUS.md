# Modern Protocol Port — STATUS

Branch: `modern-protocol` (local only). Last session: 2026-07-16.
Reference checkouts: `~/Documents/canary`, `~/Documents/login-server` (both shallow clones).

## Gates

| Gate | State | Evidence |
|------|-------|----------|
| H — harness | **PASS** | `harness/packet_diff.py` decodes/diffs legacy+modern fixtures; `blacktek_tests` 7/7 green |
| 0 — merge, legacy intact | **PASS** | scripted 10.98 client (`harness/legacy_client.py`) logs in + walks against live server; full build clean (GCC 14, release_64) |
| A — session login | **PASS** | POST /login on opentibiabr/login-server → session key → modern handshake on 7173 → "Tester has logged in." → walk answered. Legacy re-run green. |
| B — asset/ID pipeline | **NOT STARTED** | |
| C — enter world (mehah) | **NOT STARTED** | blocked on B; also needs a mehah client (GUI) for the real gate |
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

## Exact next actions (Phase B)

1. Vendor canary's appearances `.proto` (`src/protobuf/appearances.proto` in
   canary) and add `protobuf` to vcpkg.json; premake needs a codegen step —
   check how canary's CMake invokes protoc and mirror minimally.
2. `src/appearances.h/cpp`: load `appearances.dat`, expose client-id → flags;
   gate behind `ProtocolFeature::ProtobufAppearances`.
3. Audit `getClientID()` call sites; add u16→u32 handling behind
   `ItemsOverU16Capacity` in the NetworkMessage item writers.
4. GATE B: golden round-trip 20 representative items (stackable, fluid,
   container, podium) server-id ↔ 15.25 client-id. Needs a 13/14/15.x
   `appearances.dat` — get one from a mehah-compatible client package.
5. Then Phase C in the listed writer order, each with a golden test; the
   0x32-greeting + 0x17 bundling behavior seen by `modern_client.py` is a
   handy smoke reference for frame bundling.

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
