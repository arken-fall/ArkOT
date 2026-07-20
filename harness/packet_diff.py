#!/usr/bin/env python3
"""Packet capture decoder and differ for BlackTek protocol work.

Takes hex-dump captures of one direction of a game-protocol TCP stream,
decrypts them with the XTEA session key (grab it from the server debug log),
splits them into frames, and either annotates them (--decode) or byte-diffs
two captures frame-by-frame grouped by leading opcode (default mode).

Capture file format: plain hex bytes. Whitespace is ignored, '#' starts a
comment until end of line. One file holds ONE direction of ONE session.

Framing layouts:
  legacy  (10.98): [u16 byteLength][u32 adler32][xtea blocks]
                   decrypted payload = [u16 innerLength][body]
  modern  (13.40+): [u16 blockCount][u32 sequence][xtea blocks]
                   wire remainder length = blockCount * 8 + 4
                   decrypted payload = [u8 padding][body][padding bytes]
                   sequence high bit set (server->client) = body is
                   raw-deflate compressed (zlib wbits=-15)

A frame's decrypted body may contain several server packets back to back;
splitting those needs full payload grammar, so grouping is by the FIRST
opcode of each frame. Golden unit tests cover exact per-packet bytes; this
tool is for eyeballing live captures against each other.
"""

import argparse
import re
import struct
import sys
import zlib
from pathlib import Path

DELTA = 0x9E3779B9
MASK = 0xFFFFFFFF


def xtea_decrypt_block(v0, v1, k):
    s = (DELTA * 32) & MASK
    for _ in range(32):
        v1 = (v1 - ((((v0 << 4) ^ (v0 >> 5)) + v0) ^ (s + k[(s >> 11) & 3]))) & MASK
        s = (s - DELTA) & MASK
        v0 = (v0 - ((((v1 << 4) ^ (v1 >> 5)) + v1) ^ (s + k[s & 3]))) & MASK
    return v0, v1


def xtea_encrypt_block(v0, v1, k):
    s = 0
    for _ in range(32):
        v0 = (v0 + ((((v1 << 4) ^ (v1 >> 5)) + v1) ^ (s + k[s & 3]))) & MASK
        s = (s + DELTA) & MASK
        v1 = (v1 + ((((v0 << 4) ^ (v0 >> 5)) + v0) ^ (s + k[(s >> 11) & 3]))) & MASK
    return v0, v1


def xtea_apply(data, key, encrypt=False):
    if len(data) % 8 != 0:
        raise ValueError(f"XTEA region not a multiple of 8: {len(data)}")
    fn = xtea_encrypt_block if encrypt else xtea_decrypt_block
    out = bytearray()
    for i in range(0, len(data), 8):
        v0, v1 = struct.unpack_from("<II", data, i)
        r0, r1 = fn(v0, v1, key)
        out += struct.pack("<II", r0, r1)
    return bytes(out)


def parse_hex_file(path):
    text = Path(path).read_text()
    text = re.sub(r"#.*", "", text)
    text = re.sub(r"\s+", "", text)
    if len(text) % 2 != 0:
        raise ValueError(f"{path}: odd number of hex digits")
    return bytes.fromhex(text)


def parse_key(spec):
    parts = spec.replace(" ", "").split(",")
    if len(parts) != 4:
        raise ValueError("XTEA key must be four comma-separated u32 values")
    return [int(p, 0) & MASK for p in parts]


class Frame:
    def __init__(self, index, seq, body, compressed, raw_len):
        self.index = index
        self.seq = seq              # adler32 (legacy) or sequence number (modern)
        self.body = body            # decrypted, decompressed payload
        self.compressed = compressed
        self.raw_len = raw_len

    @property
    def opcode(self):
        return self.body[0] if self.body else None


def split_frames(data, layout, key, decrypt=True):
    frames = []
    pos = 0
    index = 0
    # the server compresses with ONE deflate stream across the whole session
    # (Z_SYNC_FLUSH per frame), so the inflate context must be shared too;
    # each frame gets the sync-flush footer appended, mirroring mehah's
    # InputMessage::addCompressionFooter
    inflater = zlib.decompressobj(-15)
    while pos + 2 <= len(data):
        (header,) = struct.unpack_from("<H", data, pos)
        pos += 2
        if layout == "modern":
            remainder = header * 8 + 4
        else:
            remainder = header
        if pos + remainder > len(data):
            raise ValueError(
                f"frame {index}: header wants {remainder} bytes, "
                f"only {len(data) - pos} left (wrong layout or truncated capture?)"
            )
        chunk = data[pos : pos + remainder]
        pos += remainder

        (checksum,) = struct.unpack_from("<I", chunk, 0)
        encrypted = chunk[4:]
        compressed = False

        if decrypt:
            plain = xtea_apply(encrypted, key)
            if layout == "modern":
                padding = plain[0]
                body = plain[1 : len(plain) - padding]
                if checksum & 0x80000000:
                    compressed = True
                    # server deflates per-message (Z_FINISH + deflateReset),
                    # but tolerate stream-style output too via the footer
                    try:
                        body = zlib.decompressobj(-15).decompress(body)
                    except zlib.error:
                        body = inflater.decompress(body + b"\x00\x00\xff\xff")
                    checksum &= 0x7FFFFFFF
            else:
                (inner,) = struct.unpack_from("<H", plain, 0)
                if inner + 2 > len(plain):
                    raise ValueError(f"frame {index}: inner length {inner} exceeds payload")
                body = plain[2 : 2 + inner]
        else:
            body = encrypted

        frames.append(Frame(index, checksum, body, compressed, remainder + 2))
        index += 1
    if pos != len(data):
        print(f"warning: {len(data) - pos} trailing bytes ignored", file=sys.stderr)
    return frames


def parse_opcode_names(header_path, enums):
    """Pull `Name = 0xNN` pairs out of the requested enum blocks in networkopcodes.h."""
    text = Path(header_path).read_text()
    names = {}
    for enum in enums:
        match = re.search(
            r"enum\s+class\s+" + enum + r"\b[^{]*\{(.*?)\};", text, re.DOTALL
        )
        if not match:
            continue
        for name, value in re.findall(
            r"^\s*(\w+)\s*=\s*0[xX]([0-9A-Fa-f]+)", match.group(1), re.MULTILINE
        ):
            names.setdefault(int(value, 16), name)
    return names


def hexdump(data, indent="    "):
    lines = []
    for i in range(0, len(data), 16):
        chunk = data[i : i + 16]
        hexpart = " ".join(f"{b:02X}" for b in chunk)
        ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        lines.append(f"{indent}{i:04X}  {hexpart:<47}  {ascii_part}")
    return "\n".join(lines)


def describe(frame, names):
    op = frame.opcode
    name = names.get(op, "?") if op is not None else "-"
    flags = " compressed" if frame.compressed else ""
    return (
        f"frame {frame.index}: {len(frame.body)} bytes, "
        f"seq/cksum 0x{frame.seq:08X}{flags}, opcode 0x{op:02X} ({name})"
        if op is not None
        else f"frame {frame.index}: empty body"
    )


def diff_frames(frames_a, frames_b, names):
    by_op_a = {}
    by_op_b = {}
    for f in frames_a:
        by_op_a.setdefault(f.opcode, []).append(f)
    for f in frames_b:
        by_op_b.setdefault(f.opcode, []).append(f)

    all_ops = sorted(
        (op for op in set(by_op_a) | set(by_op_b) if op is not None)
    )
    identical = 0
    for op in all_ops:
        name = names.get(op, "?")
        group_a = by_op_a.get(op, [])
        group_b = by_op_b.get(op, [])
        if len(group_a) != len(group_b):
            print(f"opcode 0x{op:02X} ({name}): count A={len(group_a)} B={len(group_b)}")
        for fa, fb in zip(group_a, group_b):
            if fa.body == fb.body:
                identical += 1
                continue
            print(f"opcode 0x{op:02X} ({name}): A frame {fa.index} != B frame {fb.index}")
            limit = max(len(fa.body), len(fb.body))
            for i in range(0, limit, 16):
                ca = fa.body[i : i + 16]
                cb = fb.body[i : i + 16]
                if ca == cb:
                    continue
                ha = " ".join(f"{b:02X}" for b in ca)
                hb = " ".join(f"{b:02X}" for b in cb)
                print(f"    {i:04X} A: {ha}")
                print(f"    {i:04X} B: {hb}")
    print(f"{identical} frame pair(s) identical")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("capture", help="hex capture file (A side for diff)")
    parser.add_argument("capture_b", nargs="?", help="second capture to diff against")
    parser.add_argument("--decode", action="store_true", help="annotate frames instead of diffing")
    parser.add_argument("--layout", choices=["legacy", "modern"], default="legacy")
    parser.add_argument("--xtea", help="session key: k0,k1,k2,k3 (hex 0x.. or decimal)")
    parser.add_argument("--no-xtea", action="store_true", help="capture is not encrypted")
    parser.add_argument("--dir", choices=["client", "server"], default="server",
                        help="which opcode namespace to use for names")
    parser.add_argument("--opcodes", default=str(Path(__file__).resolve().parent.parent / "src" / "networkopcodes.h"))
    args = parser.parse_args()

    if not args.no_xtea and not args.xtea:
        parser.error("--xtea k0,k1,k2,k3 required unless --no-xtea")
    key = parse_key(args.xtea) if args.xtea else None

    if args.dir == "client":
        enums = ["ClientCode", "ClientCodeModern"]
    else:
        enums = ["ServerCode", "ServerCodeModern"]
    names = parse_opcode_names(args.opcodes, enums)

    frames_a = split_frames(parse_hex_file(args.capture), args.layout, key, decrypt=not args.no_xtea)

    if args.decode or not args.capture_b:
        for frame in frames_a:
            print(describe(frame, names))
            print(hexdump(frame.body))
        return 0

    frames_b = split_frames(parse_hex_file(args.capture_b), args.layout, key, decrypt=not args.no_xtea)
    diff_frames(frames_a, frames_b, names)
    return 0


if __name__ == "__main__":
    sys.exit(main())
