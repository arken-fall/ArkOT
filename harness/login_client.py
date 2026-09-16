#!/usr/bin/env python3
"""Scripted client for the in-binary login protocol (plan step 7D).

Drives the login listener the way a 15.25 client is believed to: world-name
preamble, one RSA/XTEA login packet, one framed answer. Decodes the 0x64
character list into the world list and the characters tagged to each world,
so the multi-world login path can be checked without a real game client.

Nothing on this path has been exercised by a real client yet, so the two
guesses the wire depends on are command-line options rather than buried
constants (docs/plans/multi-world-phase1-steps678.md section 6):

  Q1  the pre-RSA field block the server skips   -> --pre-rsa-bytes
  Q2  block-count vs byte-count outer length     -> --framing
  Q3  the premium tail after the character list   -> decoded and printed,
      never asserted; leftover bytes are dumped

Usage:
  # default: login port, empty world line, block-count framing
  python3 login_client.py --account test --password test

  # non-empty world line, e.g. a client returning from a world (plan Q4)
  python3 login_client.py --world-line BlackTek --account test --password test

  # sweep the pre-RSA field block when the server closes without answering
  for n in 12 13 17 21 25; do python3 login_client.py --pre-rsa-bytes $n; done
"""

import argparse
import socket
import struct
import sys
import zlib
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from modern_client import XTEA_KEY, add_string, decrypt_modern, read_modern_frame, rsa_public_key
from packet_diff import xtea_apply

# Bytes the server skips between the version u16 and the first RSA block:
# src/protocollogin.cpp does msg.skipBytes(17) for version >= 971, documented
# there as a u32 protocol version, three 4-byte dat/spr/pic signatures and a
# trailing 0. That is the modern GAME packet's shape (matching
# harness/captures/mehah1525_login_client.hex:3); the 15.25 LOGIN module's
# field set is not in this repository, so the count is a guess - plan section 6,
# Q1. Wrong by even one byte and Protocol::RSA_decrypt refuses the packet and
# the server closes silently, so --pre-rsa-bytes overrides this.
PRE_RSA_FIELD_BYTES = 17

# The client OS word in the 15.25 capture
# (harness/captures/mehah1525_login_client.hex:3 -> 0a00). The server skips it.
CLIENT_OS = 10

RSA_BLOCK_BYTES = 128

# src/protocollogin.cpp opcodes, in the order getCharacterList writes them
OP_DISCONNECT_LEGACY = 0x0A
OP_DISCONNECT = 0x0B
OP_TOKEN_ACCEPTED = 0x0C
OP_TOKEN_REQUIRED = 0x0D
OP_MOTD = 0x14
OP_SESSION_KEY = 0x28
OP_CHARACTER_LIST = 0x64


class ParseError(Exception):
    """A response byte was missing or a length ran past the payload."""


class Reader:
    """Bounds-checked cursor over one decrypted payload."""

    def __init__(self, data):
        self.data = data
        self.pos = 0

    def remaining(self):
        return len(self.data) - self.pos

    def need(self, count):
        if self.pos + count > len(self.data):
            raise ParseError(
                f"wanted {count} bytes at offset {self.pos}, only {self.remaining()} left"
            )

    def u8(self):
        self.need(1)
        value = self.data[self.pos]
        self.pos += 1
        return value

    def u16(self):
        self.need(2)
        (value,) = struct.unpack_from("<H", self.data, self.pos)
        self.pos += 2
        return value

    def u32(self):
        self.need(4)
        (value,) = struct.unpack_from("<I", self.data, self.pos)
        self.pos += 4
        return value

    def string(self):
        length = self.u16()
        self.need(length)
        value = self.data[self.pos : self.pos + length].decode("latin-1")
        self.pos += length
        return value


def hexdump(data, limit=512):
    lines = []
    view = data[:limit]
    for offset in range(0, len(view), 16):
        chunk = view[offset : offset + 16]
        text = "".join(chr(b) if 0x20 <= b < 0x7F else "." for b in chunk)
        lines.append(f"  {offset:04X}  {chunk.hex(' '):<47}  {text}")
    if len(data) > limit:
        lines.append(f"  ... {len(data) - limit} more bytes")
    return "\n".join(lines) if lines else "  (empty)"


def pre_rsa_fields(protocol_version, count):
    """The block src/protocollogin.cpp skips, truncated or zero-padded to count."""
    fields = struct.pack("<I", protocol_version * 100)  # full client version
    fields += struct.pack("<III", 0, 0, 0)              # dat, spr, pic signatures
    fields += bytes(1)                                  # trailing 0 / preview state
    if count <= len(fields):
        return fields[:count]
    return fields + bytes(count - len(fields))


def rsa_encrypt(plain, key_path):
    if len(plain) > RSA_BLOCK_BYTES:
        raise SystemExit(f"RSA payload too large: {len(plain)} > {RSA_BLOCK_BYTES}")
    block = bytes(plain) + bytes(RSA_BLOCK_BYTES - len(plain))
    n, e = rsa_public_key(key_path)
    return pow(int.from_bytes(block, "big"), e, n).to_bytes(RSA_BLOCK_BYTES, "big")


def login_rsa_block(account, password, key_path):
    """Block one, read forward by src/protocollogin.cpp after RSA_decrypt."""
    plain = bytearray()
    plain.append(0)  # RSA_decrypt asserts this byte is zero
    for word in XTEA_KEY:
        plain += struct.pack("<I", word)
    plain += add_string(account)
    plain += add_string(password)
    return rsa_encrypt(plain, key_path)


def token_rsa_block(token, stay_logged_in, key_path):
    """Block two, located by the server from the END of the message."""
    plain = bytearray()
    plain.append(0)
    plain += add_string(token)
    plain.append(1 if stay_logged_in else 0)  # stay-logged-in flag, unread today
    return rsa_encrypt(plain, key_path)


def send_login_frame(sock, body, framing):
    """Write the first frame and describe it. Never encrypted: XTEA starts after."""
    if framing == "blocks":
        # matches harness/captures/mehah1525_login_client.hex:3 -
        # [u16 blockCount][u32 header][u8 padCount][payload][padding]
        padding = (8 - (len(body) + 1) % 8) % 8
        inner = bytes([padding]) + bytes(body) + bytes(padding)
        blocks = len(inner) // 8
        sock.sendall(struct.pack("<HI", blocks, 0) + inner)
        return f"blockCount={blocks} (0x{blocks:04X}), padCount={padding}, {len(body)} body bytes"

    # Q2 fallback: legacy [u16 byteLength][u32 adler32][payload], no padding
    # count. The server has to be on the legacy generation to parse this, and
    # its version gate then refuses 1525 - a readable 0x0B refusal is still a
    # far better answer than silence, which is the point of the flag.
    frame = struct.pack("<I", zlib.adler32(bytes(body)) & 0xFFFFFFFF) + bytes(body)
    sock.sendall(struct.pack("<H", len(frame)) + frame)
    return f"byteLength={len(frame)} (0x{len(frame):04X}), {len(body)} body bytes"


def read_legacy_frame(sock):
    header = sock.recv(2, socket.MSG_WAITALL)
    if len(header) < 2:
        raise ConnectionError("closed while reading frame header")
    (size,) = struct.unpack("<H", header)
    body = sock.recv(size, socket.MSG_WAITALL)
    if len(body) < size:
        raise ConnectionError("short frame body")
    return body


def decrypt_legacy(body):
    plain = xtea_apply(body[4:], XTEA_KEY)  # skip the adler32
    (inner,) = struct.unpack_from("<H", plain, 0)
    if inner + 2 > len(plain):
        raise ValueError(f"inner length {inner} runs past the {len(plain)}-byte frame")
    return 0, plain[2 : 2 + inner]


def read_character_list(reader):
    """The 0x64 payload as src/protocollogin.cpp now writes it."""
    worlds = []
    world_count = reader.u8()
    for _ in range(world_count):
        worlds.append(
            {
                "id": reader.u8(),
                "name": reader.string(),
                "address": reader.string(),
                "port": reader.u16(),
                "preview": reader.u8(),
            }
        )

    characters = []
    character_count = reader.u8()
    for _ in range(character_count):
        characters.append({"world": reader.u8(), "name": reader.string()})

    # Q3: unverified for 15.25. Decoded so a wrong tail shows up as leftover
    # bytes or nonsense here rather than as a confusing client-side symptom.
    premium = {
        "days": reader.u8(),
        "has_premium": reader.u8(),
        "ends_at": reader.u32(),
    }
    return worlds, characters, premium


def print_character_list(worlds, characters):
    print(f"worlds: {len(worlds)}")
    for world in worlds:
        print(
            f"  world {world['id']:3d}  {world['name']!r} "
            f"at {world['address']}:{world['port']}  preview={world['preview']}"
        )
        mine = [c["name"] for c in characters if c["world"] == world["id"]]
        if mine:
            for name in mine:
                print(f"      - {name}")
        else:
            print("      (no characters)")

    declared = {world["id"] for world in worlds}
    orphans = [c for c in characters if c["world"] not in declared]
    if orphans:
        print("  characters tagged with a world the list does not declare:")
        for character in orphans:
            print(f"      - {character['name']} (world {character['world']})")
    return orphans


def report_response(payload):
    """Print and assert one decrypted login answer. Returns a process exit code."""
    reader = Reader(payload)
    motd = None
    session_key = None
    worlds = None
    characters = None
    orphans = []

    try:
        while reader.remaining():
            offset = reader.pos
            opcode = reader.u8()

            if opcode in (OP_DISCONNECT, OP_DISCONNECT_LEGACY):
                print(f"REFUSED: server answered 0x{opcode:02X}: {reader.string()!r}")
                return 1

            if opcode == OP_TOKEN_REQUIRED:
                reader.u8()
                print("REFUSED: server answered 0x0D - this account has an "
                      "authenticator key and the token did not match (pass --token)")
                return 1

            if opcode == OP_TOKEN_ACCEPTED:
                reader.u8()
                print("token: accepted (0x0C)")
            elif opcode == OP_MOTD:
                motd = reader.string()
                print(f"motd: {motd!r}")
            elif opcode == OP_SESSION_KEY:
                session_key = reader.string()
                print(f"session key: {session_key!r}")
            elif opcode == OP_CHARACTER_LIST:
                worlds, characters, premium = read_character_list(reader)
                orphans = print_character_list(worlds, characters)
                print(
                    f"premium tail (plan Q3, unverified): days={premium['days']} "
                    f"hasPremium={premium['has_premium']} endsAt={premium['ends_at']}"
                )
            else:
                print(f"FAIL: unexpected opcode 0x{opcode:02X} at payload offset {offset}")
                print("payload:")
                print(hexdump(payload))
                return 1
    except ParseError as error:
        print(f"FAIL: could not parse the login response: {error}")
        print("payload:")
        print(hexdump(payload))
        return 1

    if reader.remaining():
        print(f"FAIL: {reader.remaining()} unread bytes after the character list "
              f"(the premium tail is plan Q3 - suspect it first)")
        print("payload:")
        print(hexdump(payload))
        return 1

    if session_key is None:
        print("FAIL: no 0x28 session key in the answer")
        return 1
    if worlds is None:
        print("FAIL: no 0x64 character list in the answer")
        return 1
    if not worlds:
        print("FAIL: the world list is empty; the registry always declares at least one world")
        return 1
    if orphans:
        print("FAIL: characters carry world ids the world list does not declare")
        return 1
    if not characters:
        print("WARN: the account has no characters on any world")

    print("PASS: login answered, world list and character tagging parsed cleanly")
    return 0


def main():
    parser = argparse.ArgumentParser(description="scripted in-binary login-protocol client")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=7171,
                        help="login port; 7171 is a client-side constant (default: 7171)")
    parser.add_argument("--account", default="test")
    parser.add_argument("--password", default="test")
    parser.add_argument("--token", default="", help="authenticator token, if the account has a key")
    parser.add_argument("--stay-logged-in", action="store_true",
                        help="set the stay-logged-in flag in the token block")
    parser.add_argument("--world-line", default="",
                        help="world-name preamble; empty (the default) sends a bare '\\n', "
                             "which is what a real client sends on a login connection")
    parser.add_argument("--protocol-version", type=int, default=1525)
    parser.add_argument("--pre-rsa-bytes", type=int, default=PRE_RSA_FIELD_BYTES,
                        help=f"bytes between the version u16 and the first RSA block "
                             f"(plan Q1; default: {PRE_RSA_FIELD_BYTES})")
    parser.add_argument("--framing", choices=("blocks", "bytes"), default="blocks",
                        help="outer length header: 8-byte block count (modern, default) "
                             "or byte count (legacy) - plan Q2")
    parser.add_argument("--timeout", type=float, default=10.0)
    parser.add_argument("--key", default=str(Path(__file__).resolve().parent.parent / "key.pem"))
    args = parser.parse_args()

    if args.pre_rsa_bytes < 0:
        parser.error("--pre-rsa-bytes cannot be negative")

    rsa_login = login_rsa_block(args.account, args.password, args.key)
    rsa_token = token_rsa_block(args.token, args.stay_logged_in, args.key)

    body = bytearray()
    body.append(0x01)                                   # protocol identifier
    body += struct.pack("<H", CLIENT_OS)
    body += struct.pack("<H", args.protocol_version)
    body += pre_rsa_fields(args.protocol_version, args.pre_rsa_bytes)
    body += rsa_login
    # the server locates this one from the END of the message, so it has to be
    # the last 128 bytes of the payload once the framing padding is trimmed
    body += rsa_token

    try:
        sock = socket.create_connection((args.host, args.port), timeout=args.timeout)
    except OSError as error:
        print(f"FAIL: could not connect to {args.host}:{args.port}: {error}")
        return 1

    # A real client (>= 1200) opens every connection with a plaintext
    # "<worldName>\n" line, and on a login connection that name is empty - so
    # the default preamble is the terminator on its own.
    preamble = (args.world_line + "\n").encode("latin-1")
    sock.sendall(preamble)
    print(f"preamble: {preamble!r}")

    described = send_login_frame(sock, body, args.framing)
    print(f"login frame [{args.framing}]: {described}, pre-RSA field bytes={args.pre_rsa_bytes}")

    read_frame = read_modern_frame if args.framing == "blocks" else read_legacy_frame
    decrypt_frame = decrypt_modern if args.framing == "blocks" else decrypt_legacy

    try:
        frame = read_frame(sock)
    except (ConnectionError, OSError) as error:
        print(f"FAIL: no answer to the login packet: {error}")
        print("A silent close on this path is almost always one of two things: the "
              "server's RSA_decrypt refused the login block because the pre-RSA field "
              "count is wrong (plan Q1 - sweep --pre-rsa-bytes), or the outer length "
              "header is not what the server parses (plan Q2 - try --framing bytes).")
        return 1

    try:
        sequence, payload = decrypt_frame(frame)
    except (ValueError, zlib.error) as error:
        print(f"FAIL: could not decrypt the answer: {error}")
        print("frame:")
        print(hexdump(frame))
        return 1

    print(f"answer: header=0x{sequence:08X}, {len(payload)} payload bytes")
    if not payload:
        print("FAIL: the answer decrypted to an empty payload")
        print("frame:")
        print(hexdump(frame))
        return 1

    return report_response(payload)


if __name__ == "__main__":
    sys.exit(main())
