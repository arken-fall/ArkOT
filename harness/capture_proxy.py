#!/usr/bin/env python3
"""Transparent TCP proxy that hex-logs both directions of a game session.

Sits between a real client and the server so captures land as packet_diff.py
compatible hex files - no tcpdump/root needed. Each connection gets a pair:

  harness/captures/<n>_client.hex   (client -> server)
  harness/captures/<n>_server.hex   (server -> client)

Usage:
  python3 capture_proxy.py [--listen 7174] [--target 127.0.0.1:7173]
"""

import argparse
import socket
import threading
from pathlib import Path

CAPTURES = Path(__file__).resolve().parent / "captures"


def pump(src, dst, out_path, label):
    total = 0
    with open(out_path, "w") as out:
        out.write(f"# {label}\n")
        while True:
            try:
                data = src.recv(65536)
            except OSError:
                break
            if not data:
                break
            out.write(data.hex() + "\n")
            out.flush()
            total += len(data)
            try:
                dst.sendall(data)
            except OSError:
                break
    for sock in (src, dst):
        try:
            sock.shutdown(socket.SHUT_RDWR)
        except OSError:
            pass
    print(f"  {label}: {total} bytes -> {out_path.name}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--listen", type=int, default=7174)
    parser.add_argument("--target", default="127.0.0.1:7173")
    args = parser.parse_args()

    host, port = args.target.rsplit(":", 1)
    CAPTURES.mkdir(exist_ok=True)

    listener = socket.create_server(("0.0.0.0", args.listen))
    print(f"capture proxy: {args.listen} -> {args.target}, captures in {CAPTURES}")

    session = 0
    while True:
        client, addr = listener.accept()
        session += 1
        print(f"session {session} from {addr[0]}")
        try:
            server = socket.create_connection((host, int(port)), timeout=10)
        except OSError as exc:
            print(f"  cannot reach target: {exc}")
            client.close()
            continue
        threading.Thread(target=pump, args=(client, server, CAPTURES / f"{session}_client.hex", f"session {session} client->server"), daemon=True).start()
        threading.Thread(target=pump, args=(server, client, CAPTURES / f"{session}_server.hex", f"session {session} server->client"), daemon=True).start()


if __name__ == "__main__":
    main()
