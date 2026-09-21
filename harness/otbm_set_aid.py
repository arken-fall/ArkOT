#!/usr/bin/env python3
"""Set an action id on one item, on one tile, in an OTBM map.

Scripts that need to beat a generic handler must register on an action id --
item id outranks tile position, so a quest lever sharing its item id with every
other lever on the map cannot be reached any other way. This writes that id.

    python3 harness/otbm_set_aid.py data/world/canary.otbm \\
        --at 32148,32105,11 --item 1945 --aid 5638 --out new.otbm

Nothing is written in place: the result goes to --out, so the original is still
there to compare against and fall back to. Verify with otbm_ids.py afterwards.

OTBM stores no node lengths -- a node is a start marker, its escaped bytes, its
children and an end marker -- so an attribute can be inserted without fixing up
any length field. That is what makes this a contained edit rather than a rewrite.
"""

import argparse
import struct
import sys

NODE_START = 0xFE
NODE_END = 0xFF
ESCAPE_CHAR = 0xFD

OTBM_TILE_AREA = 4
OTBM_TILE = 5
OTBM_ITEM = 6
OTBM_HOUSETILE = 14

ATTR_ACTION_ID = 4


def escaped(payload):
    """Escape the bytes that would otherwise read as node markers."""
    out = bytearray()
    for byte in payload:
        if byte in (NODE_START, NODE_END, ESCAPE_CHAR):
            out.append(ESCAPE_CHAR)
        out.append(byte)
    return bytes(out)


def decode_from(data, start, count):
    """Read `count` unescaped bytes from `start`; return (values, raw_end)."""
    values = bytearray()
    pos = start
    while len(values) < count:
        byte = data[pos]
        if byte == ESCAPE_CHAR:
            values.append(data[pos + 1])
            pos += 2
            continue
        if byte in (NODE_START, NODE_END):
            raise ValueError("node ended before the expected bytes were read")
        values.append(byte)
        pos += 1
    return bytes(values), pos


def find_item_node(data, target, item_id):
    """Return the raw offset just past the item id of the matching item node."""
    pos = 4
    size = len(data)
    area = (0, 0, 0)
    tile = None
    matches = []

    while pos < size:
        byte = data[pos]

        if byte == NODE_START:
            node_type = data[pos + 1]
            props_start = pos + 2

            if node_type == OTBM_TILE_AREA:
                values, _ = decode_from(data, props_start, 5)
                area = (struct.unpack_from("<H", values, 0)[0],
                        struct.unpack_from("<H", values, 2)[0],
                        values[4])
                tile = None

            elif node_type in (OTBM_TILE, OTBM_HOUSETILE):
                values, _ = decode_from(data, props_start, 2)
                tile = (area[0] + values[0], area[1] + values[1], area[2])

            elif node_type == OTBM_ITEM and tile == target:
                values, after_id = decode_from(data, props_start, 2)
                if struct.unpack_from("<H", values, 0)[0] == item_id:
                    matches.append(after_id)

            pos = props_start
            continue

        if byte == ESCAPE_CHAR:
            pos += 2
            continue

        pos += 1

    return matches


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("map")
    ap.add_argument("--at", required=True, help="x,y,z of the tile")
    ap.add_argument("--item", required=True, type=int, help="item id to identify")
    ap.add_argument("--aid", required=True, type=int, help="action id to set")
    ap.add_argument("--out", required=True, help="write the result here")
    args = ap.parse_args()

    x, y, z = (int(part) for part in args.at.split(","))
    target = (x, y, z)

    with open(args.map, "rb") as handle:
        data = bytearray(handle.read())

    matches = find_item_node(data, target, args.item)

    if not matches:
        print(f"no item {args.item} found at {x}, {y}, {z}", file=sys.stderr)
        return 1

    # More than one would make "which one" a guess, and a guess here silently
    # identifies the wrong object.
    if len(matches) > 1:
        print(f"{len(matches)} copies of item {args.item} at {x}, {y}, {z}; "
              f"refusing to choose between them", file=sys.stderr)
        return 1

    insert_at = matches[0]
    attribute = escaped(bytes([ATTR_ACTION_ID]) + struct.pack("<H", args.aid))
    data[insert_at:insert_at] = attribute

    with open(args.out, "wb") as handle:
        handle.write(data)

    print(f"item {args.item} at {x}, {y}, {z}: action id {args.aid} written "
          f"({len(attribute)} bytes at offset {insert_at})")
    print(f"  {args.map} -> {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
