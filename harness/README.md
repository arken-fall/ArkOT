# Protocol verification harness

Tooling for the 10.98 → modern protocol port. Two halves:

## packet_diff.py

Decrypts and inspects hex-dump captures of a game-protocol TCP stream.

```
# annotate one capture
python3 packet_diff.py capture.hex --decode --layout modern --xtea 0x...,0x...,0x...,0x... --dir server

# diff two captures (e.g. BlackTek vs Canary sending the same scene)
python3 packet_diff.py blacktek.hex canary.hex --layout modern --xtea ...
```

The XTEA session key is printed by the server debug log at login. Capture
files are plain hex; whitespace ignored, `#` comments allowed. One file per
direction per session. Opcode names are parsed live from
`src/networkopcodes.h`, so new enumerators show up automatically.

Frames are grouped by their *first* opcode — a server frame can contain
several packets back-to-back, and splitting those needs the full grammar.
Exact per-packet bytes belong in the golden tests, not here.

`make_fixture.py` regenerates the synthetic captures in `golden/fixtures/`
used to smoke-test this tool.

## golden/ + blacktek_tests

`blacktek_tests` (premake project, builds alongside the server) links every
server translation unit except `otserv.cpp` and runs golden byte-string
tests: each ported packet writer gets a test asserting its exact output
bytes, generated independently (Python or a Canary capture) so the C++ code
can't bless itself.

```
make -j`nproc` config=release_64 blacktek_tests
./blacktek_tests            # run all
./blacktek_tests xtea       # run tests whose name contains "xtea"
```

Exit code is non-zero on any failure. Add new tests under `tests/` with
`BT_TEST(name) { ... }` — see `tests/test_transport.cpp` for the pattern.
