#!/usr/bin/env python3
"""Generate synthetic captures for exercising packet_diff.py.

Writes three files into harness/golden/fixtures/:
  legacy_a.hex / legacy_b.hex  -- two legacy-layout captures that differ in
                                  one byte of one frame (a PlayerStats packet)
  modern_a.hex                 -- one modern-layout capture, including a
                                  compressed frame, for --decode smoke tests

Run from anywhere; paths are relative to this file. Deterministic output.
"""

import struct
import sys
import zlib
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from packet_diff import xtea_apply  # noqa: E402

KEY = [0x11111111, 0x22222222, 0x33333333, 0x44444444]
FIXTURES = Path(__file__).resolve().parent / "golden" / "fixtures"


def legacy_frame(body):
    inner = struct.pack("<H", len(body)) + body
    padding = (8 - len(inner) % 8) % 8
    inner += bytes(padding)
    encrypted = xtea_apply(inner, KEY, encrypt=True)
    checksum = zlib.adler32(encrypted) & 0xFFFFFFFF
    payload = struct.pack("<I", checksum) + encrypted
    return struct.pack("<H", len(payload)) + payload


def modern_frame(body, sequence, compress=False):
    flag = 0
    if compress:
        co = zlib.compressobj(6, zlib.DEFLATED, -15)
        body = co.compress(body) + co.flush(zlib.Z_FINISH)
        flag = 0x80000000
    padding = 8 - (len(body) + 1) % 8
    if padding == 8:
        padding = 0
    plain = bytes([padding]) + body + bytes(padding)
    encrypted = xtea_apply(plain, KEY, encrypt=True)
    payload = struct.pack("<I", flag | sequence) + encrypted
    block_count = len(encrypted) // 8
    return struct.pack("<H", block_count) + payload


def to_hex(data, comment):
    lines = [f"# {comment}"]
    for i in range(0, len(data), 32):
        lines.append(data[i : i + 32].hex())
    return "\n".join(lines) + "\n"


def main():
    FIXTURES.mkdir(parents=True, exist_ok=True)

    # 0xB4 TextMessage-ish and 0xA0 PlayerStats-ish bodies (shapes only,
    # not real payloads -- these exercise framing, not packet grammar)
    text_body = bytes([0xB4, 0x14]) + struct.pack("<H", 5) + b"hello"
    stats_a = bytes([0xA0]) + struct.pack("<HHH", 150, 150, 100)
    stats_b = bytes([0xA0]) + struct.pack("<HHH", 150, 150, 42)  # differs

    capture_a = legacy_frame(text_body) + legacy_frame(stats_a)
    capture_b = legacy_frame(text_body) + legacy_frame(stats_b)
    (FIXTURES / "legacy_a.hex").write_text(to_hex(capture_a, "synthetic legacy capture A"))
    (FIXTURES / "legacy_b.hex").write_text(to_hex(capture_b, "synthetic legacy capture B"))

    big_body = bytes([0x64]) + bytes(range(256)) * 2  # compressible map-ish blob
    capture_m = modern_frame(text_body, 1) + modern_frame(big_body, 2, compress=True)
    (FIXTURES / "modern_a.hex").write_text(to_hex(capture_m, "synthetic modern capture"))

    print(f"wrote fixtures to {FIXTURES}")


if __name__ == "__main__":
    main()
