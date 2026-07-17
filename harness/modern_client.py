#!/usr/bin/env python3
"""Scripted modern (13.40+) game-protocol client for GATE A checks.

Optionally fetches a session key from the login webservice first, then runs
the modern handshake against game_port_modern: block-count framing, padding
byte payloads, sequence checksums, session-key login.

Usage:
  # full webservice flow (GATE A)
  python3 modern_client.py --webservice http://127.0.0.1:8090 \
      --email test --password test --character Tester

  # direct session key (e.g. seeded straight into account_sessions)
  python3 modern_client.py --session-key <64-hex> --character Tester

  # direct email/password login without the webservice
  python3 modern_client.py --email test --password test --character Tester --no-webservice
"""

import argparse
import json
import socket
import struct
import subprocess
import sys
import urllib.request
import zlib
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from packet_diff import xtea_apply

XTEA_KEY = [0xCAFEBABE, 0x8BADF00D, 0x0D15EA5E, 0xFEEDC0DE]


def rsa_public_key(pem_path):
    out = subprocess.check_output(
        ["openssl", "rsa", "-in", str(pem_path), "-noout", "-modulus"], text=True
    )
    return int(out.strip().split("=", 1)[1], 16), 65537


def add_string(value):
    encoded = value.encode("latin-1")
    return struct.pack("<H", len(encoded)) + encoded


def read_modern_frame(sock):
    header = sock.recv(2, socket.MSG_WAITALL)
    if len(header) < 2:
        raise ConnectionError("closed while reading frame header")
    (blocks,) = struct.unpack("<H", header)
    size = blocks * 8 + 4
    body = sock.recv(size, socket.MSG_WAITALL)
    if len(body) < size:
        raise ConnectionError("short frame body")
    return body


def decrypt_modern(body):
    seq, = struct.unpack_from("<I", body, 0)
    plain = xtea_apply(body[4:], XTEA_KEY)
    padding = plain[0]
    payload = plain[1 : len(plain) - padding]
    if seq & 0x80000000:
        payload = zlib.decompressobj(-15).decompress(payload)
    return seq & 0x7FFFFFFF, payload


def send_modern(sock, payload, sequence):
    padding = (8 - (len(payload) + 1) % 8) % 8
    plain = bytes([padding]) + payload + bytes(padding)
    encrypted = xtea_apply(plain, XTEA_KEY, encrypt=True)
    frame = struct.pack("<I", sequence) + encrypted
    sock.sendall(struct.pack("<H", len(encrypted) // 8) + frame)


def webservice_login(base_url, email, password):
    request = urllib.request.Request(
        base_url.rstrip("/") + "/login",
        data=json.dumps({"type": "login", "email": email, "password": password}).encode(),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(request, timeout=10) as response:
        payload = json.loads(response.read())
    if "errorMessage" in payload:
        raise SystemExit(f"webservice refused login: {payload}")
    session = payload["session"]["sessionkey"]
    worlds = payload["playdata"]["worlds"]
    characters = [c["name"] for c in payload["playdata"]["characters"]]
    print(f"webservice: session key issued, worlds={[(w['externaladdressunprotected'], w['externalportunprotected']) for w in worlds]}, characters={characters}")
    return session


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=7173)
    parser.add_argument("--webservice")
    parser.add_argument("--email")
    parser.add_argument("--password")
    parser.add_argument("--session-key")
    parser.add_argument("--character", default="Tester")
    parser.add_argument("--protocol-version", type=int, default=1340)
    parser.add_argument("--key", default=str(Path(__file__).resolve().parent.parent / "key.pem"))
    args = parser.parse_args()

    if args.webservice:
        session_key = webservice_login(args.webservice, args.email, args.password)
    elif args.session_key:
        session_key = args.session_key
    elif args.email:
        session_key = f"{args.email}\n{args.password}"
    else:
        parser.error("need --webservice, --session-key, or --email/--password")

    sock = socket.create_connection((args.host, args.port), timeout=10)

    # --- modern challenge: [u16 blocks][u32 adler][01 1F ts rand 71] ---
    challenge = read_modern_frame(sock)
    checksum, lead, opcode = struct.unpack_from("<IBB", challenge, 0)
    if (lead, opcode) != (0x01, 0x1F):
        print(f"FAIL: unexpected challenge lead bytes {lead:02X} {opcode:02X}")
        return 1
    timestamp, rand = struct.unpack_from("<IB", challenge, 6)
    print(f"challenge: ts={timestamp} rand={rand}")

    # --- first packet ---
    rsa_plain = bytearray()
    rsa_plain.append(0)
    for k in XTEA_KEY:
        rsa_plain += struct.pack("<I", k)
    rsa_plain.append(0)  # gamemaster flag
    rsa_plain += add_string(session_key)
    rsa_plain += add_string(args.character)
    rsa_plain += struct.pack("<IB", timestamp, rand)
    if len(rsa_plain) > 128:
        raise SystemExit(f"RSA payload too large: {len(rsa_plain)}")
    rsa_plain += bytes(128 - len(rsa_plain))

    n, e = rsa_public_key(args.key)
    rsa_block = pow(int.from_bytes(rsa_plain, "big"), e, n).to_bytes(128, "big")

    body = bytearray()
    body.append(0x0A)                                   # ClientPendingGame
    body += struct.pack("<H", 11)                       # OS: otclient windows
    body += struct.pack("<H", args.protocol_version)
    body += struct.pack("<I", args.protocol_version * 100)  # full build number
    body += add_string(f"{args.protocol_version // 100}.{args.protocol_version % 100}")
    body += add_string("0000000000000000")              # assets hash
    body.append(0)                                      # preview state
    body += rsa_block

    # first frame: [u16 blocks][u32 seq=0][u8 padcount][body][padding]
    padding = (8 - (len(body) + 1) % 8) % 8
    inner = bytes([padding]) + bytes(body) + bytes(padding)
    sock.sendall(struct.pack("<H", len(inner) // 8) + struct.pack("<I", 0) + inner)

    # --- responses ---
    # Frames bundle packets and saved conditions can reorder the leading
    # opcode, so this only screens for an explicit refusal; the authoritative
    # in-world proof is the answered walk below.
    seen = []
    refused = None
    sock.settimeout(3)
    try:
        while len(seen) < 8:
            seq, payload = decrypt_modern(read_modern_frame(sock))
            if not payload:
                continue
            seen.append(payload[0])
            op = payload[0]
            if op == 0x32 and len(payload) > 4:
                seen.append(payload[4])  # greeting is fixed-size; peek behind it
                op = payload[4]
            if op == 0x14:
                offset = 1 if payload[0] == 0x14 else 5
                (length,) = struct.unpack_from("<H", payload, offset)
                refused = payload[offset+2 : offset+2+length].decode("latin-1")
                break
    except (TimeoutError, socket.timeout):
        pass

    print("login frame opcodes:", " ".join(f"0x{op:02X}" for op in seen))
    if refused is not None:
        print(f"FAIL: server refused login: {refused}")
        return 1
    if not seen:
        print("FAIL: no response to login packet")
        return 1

    # --- walk one tile (also proves inbound sequence checksums parse) ---
    send_modern(sock, bytes([0x65]), 1)
    answers = []
    sock.settimeout(5)
    try:
        while not answers:
            seq, payload = decrypt_modern(read_modern_frame(sock))
            if payload:
                answers.append(payload[0])
    except (TimeoutError, socket.timeout):
        pass

    print("walk answer opcodes:", " ".join(f"0x{op:02X}" for op in answers))
    if any(op in (0x65, 0x6D, 0xB5) for op in answers):
        print("PASS: session accepted, in world, walk answered over modern transport")
        return 0
    print("FAIL: no walk-related answer")
    return 1


if __name__ == "__main__":
    sys.exit(main())
