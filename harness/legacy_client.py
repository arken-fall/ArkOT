#!/usr/bin/env python3
"""Scripted 10.98 game-protocol client for GATE 0 regression checks.

Performs the full legacy handshake against a running BlackTek server
(challenge -> RSA login -> XTEA session), then walks one tile and reports
every server opcode seen. Exits 0 only if login succeeds AND the server
answers the walk with a map update or an explicit walk answer.

Usage:
  python3 legacy_client.py [--host 127.0.0.1] [--port 7172]
                           [--account test] [--password test]
                           [--character Tester]
"""

import argparse
import socket
import struct
import subprocess
import sys
import zlib
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from packet_diff import xtea_apply

XTEA_KEY = [0xDEADBEEF, 0x11223344, 0x55667788, 0x99AABBCC]


def rsa_public_key(pem_path):
    out = subprocess.check_output(
        ["openssl", "rsa", "-in", str(pem_path), "-noout", "-modulus"], text=True
    )
    n = int(out.strip().split("=", 1)[1], 16)
    return n, 65537


def read_frame(sock):
    header = sock.recv(2, socket.MSG_WAITALL)
    if len(header) < 2:
        raise ConnectionError("connection closed while reading frame header")
    (size,) = struct.unpack("<H", header)
    body = sock.recv(size, socket.MSG_WAITALL)
    if len(body) < size:
        raise ConnectionError("short frame body")
    return body


def send_encrypted(sock, payload):
    inner = struct.pack("<H", len(payload)) + payload
    inner += bytes((8 - len(inner) % 8) % 8)
    encrypted = xtea_apply(inner, XTEA_KEY, encrypt=True)
    frame = struct.pack("<I", zlib.adler32(encrypted) & 0xFFFFFFFF) + encrypted
    sock.sendall(struct.pack("<H", len(frame)) + frame)


def decrypt_frame(body):
    encrypted = body[4:]  # skip adler32
    plain = xtea_apply(encrypted, XTEA_KEY)
    (inner_len,) = struct.unpack_from("<H", plain, 0)
    return plain[2 : 2 + inner_len]


def add_string(value):
    encoded = value.encode("latin-1")
    return struct.pack("<H", len(encoded)) + encoded


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=7172)
    parser.add_argument("--account", default="test")
    parser.add_argument("--password", default="test")
    parser.add_argument("--character", default="Tester")
    parser.add_argument("--key", default=str(Path(__file__).resolve().parent.parent / "key.pem"))
    args = parser.parse_args()

    sock = socket.create_connection((args.host, args.port), timeout=10)

    # --- challenge ---
    challenge = read_frame(sock)
    checksum, inner_len, opcode = struct.unpack_from("<IHB", challenge, 0)
    if opcode != 0x1F:
        print(f"FAIL: expected challenge 0x1F, got 0x{opcode:02X}")
        return 1
    timestamp, rand = struct.unpack_from("<IB", challenge, 7)
    print(f"challenge: ts={timestamp} rand={rand}")

    # --- login packet ---
    rsa_plain = bytearray()
    rsa_plain.append(0)
    for k in XTEA_KEY:
        rsa_plain += struct.pack("<I", k)
    rsa_plain.append(0)  # gamemaster flag
    rsa_plain += add_string(f"{args.account}\n{args.password}\n\n0")
    rsa_plain += add_string(args.character)
    rsa_plain += struct.pack("<IB", timestamp, rand)
    rsa_plain += bytes(128 - len(rsa_plain))

    n, e = rsa_public_key(args.key)
    m = int.from_bytes(rsa_plain, "big")
    rsa_block = pow(m, e, n).to_bytes(128, "big")

    body = bytearray()
    body.append(0x0A)                       # ClientPendingGame
    body += struct.pack("<H", 2)            # OS: windows
    body += struct.pack("<H", 1098)         # protocol version
    body += struct.pack("<I", 1098)         # client version u32
    body.append(0)                          # client type
    body += struct.pack("<H", 0)            # dat revision
    body += rsa_block

    frame = struct.pack("<I", zlib.adler32(bytes(body)) & 0xFFFFFFFF) + bytes(body)
    sock.sendall(struct.pack("<H", len(frame)) + frame)

    # --- read login response frames ---
    seen = []
    logged_in = False
    sock.settimeout(5)
    try:
        while len(seen) < 40:
            payload = decrypt_frame(read_frame(sock))
            if not payload:
                continue
            op = payload[0]
            seen.append(op)
            if op == 0x14:
                (length,) = struct.unpack_from("<H", payload, 1)
                print(f"FAIL: server refused login: {payload[3:3+length].decode('latin-1')}")
                return 1
            if op in (0x0A, 0x17, 0x64):
                logged_in = True
            if op == 0x64:
                break
    except (TimeoutError, socket.timeout):
        pass

    print("login opcodes:", " ".join(f"0x{op:02X}" for op in seen))
    if not logged_in:
        print("FAIL: never saw pending state / login success / map description")
        return 1
    print("PASS: logged in, map received")

    # --- walk one tile north and expect an answer ---
    send_encrypted(sock, bytes([0x65]))
    sock.settimeout(5)
    answers = []
    try:
        while len(answers) < 20:
            payload = decrypt_frame(read_frame(sock))
            offset = 0
            if payload:
                answers.append(payload[0])
                break
    except (TimeoutError, socket.timeout):
        pass

    print("walk answer opcodes:", " ".join(f"0x{op:02X}" for op in answers))
    # 0x65 = map shift north, 0x6D = creature moved, 0xB5 = cancel walk (blocked)
    if any(op in (0x65, 0x6D, 0xB5) for op in answers):
        print("PASS: server answered the walk")
        return 0

    print("FAIL: no walk-related answer")
    return 1


if __name__ == "__main__":
    sys.exit(main())
