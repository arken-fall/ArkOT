#!/usr/bin/env python3
"""Extract every action id and unique id the map carries, with its position.

Scripts register against action ids and unique ids; the map is where those ids
live. When a lever does nothing the question is always the same -- does the map
give that item the id the script is listening for -- and nothing in the running
server answers it for a tile you are not standing on.

    python3 harness/otbm_ids.py data/world/canary.otbm
    python3 harness/otbm_ids.py data/world/canary.otbm --area 32050 32050 32250 32250
    python3 harness/otbm_ids.py data/world/canary.otbm --aid 30006
    python3 harness/otbm_ids.py data/world/canary.otbm --near 32148 32105 11 --radius 6

Reads the node tree directly, so it needs no server and no map editor.
"""

import argparse
import struct
import sys
from collections import Counter

NODE_START = 0xFE
NODE_END = 0xFF
ESCAPE_CHAR = 0xFD

OTBM_TILE_AREA = 4
OTBM_TILE = 5
OTBM_ITEM = 6
OTBM_HOUSETILE = 14

ATTR_ACTION_ID = 4
ATTR_UNIQUE_ID = 5

# Every attribute the format defines, with how to skip it. "str" is a u16 length
# followed by that many bytes; the numbers are fixed byte widths. An attribute we
# cannot size would desynchronise the whole stream, so an unknown one is fatal
# rather than guessed at.
ATTR_SIZES = {
    1: "str",   # description
    2: "str",   # ext file
    3: 4,       # tile flags
    4: 2,       # action id
    5: 2,       # unique id
    6: "str",   # text
    7: "str",   # desc
    8: 5,       # teleport destination: x u16, y u16, z u8
    9: 2,       # item
    10: 2,      # depot id
    11: "str",  # ext spawn file
    12: 1,      # rune charges
    13: "str",  # ext house file
    14: 1,      # house door id
    15: 1,      # count
    16: 4,      # duration
    17: 1,      # decaying state
    18: 4,      # written date
    19: "str",  # written by
    20: 4,      # sleeper guid
    21: 4,      # sleep start
    22: 2,      # charges
}


class Props:
    """A node's property bytes, already unescaped."""

    def __init__(self, data):
        self.data = data
        self.pos = 0

    def remaining(self):
        return len(self.data) - self.pos

    def u8(self):
        value = self.data[self.pos]
        self.pos += 1
        return value

    def u16(self):
        value = struct.unpack_from("<H", self.data, self.pos)[0]
        self.pos += 2
        return value

    def u32(self):
        value = struct.unpack_from("<I", self.data, self.pos)[0]
        self.pos += 4
        return value

    def skip(self, n):
        self.pos += n

    def string(self):
        length = self.u16()
        self.pos += length


def parse_attributes(props):
    """Return (action_id, unique_id) for whatever attributes this node carries."""
    action_id = None
    unique_id = None

    while props.remaining() > 0:
        attr = props.u8()
        size = ATTR_SIZES.get(attr)

        if size is None:
            # Unknown attribute: its width is unknowable, so every byte after it
            # would be misread. Stop reading this node rather than invent data.
            raise ValueError(f"unknown OTBM attribute {attr}")

        if attr == ATTR_ACTION_ID:
            action_id = props.u16()
        elif attr == ATTR_UNIQUE_ID:
            unique_id = props.u16()
        elif size == "str":
            props.string()
        else:
            props.skip(size)

    return action_id, unique_id


def walk(path, everything=False):
    """Yield (x, y, z, item_id, action_id, unique_id) for identified items.

    With everything=True, yield every item the map places rather than only the
    ones carrying an action or unique id -- which is what answers "how many of
    these are actually stacked on this tile".
    """
    with open(path, "rb") as handle:
        data = handle.read()

    # 4-byte version word, then the root node.
    pos = 4
    size = len(data)

    # Node stack: each entry is its type. Positions come from the enclosing
    # TILE_AREA plus the TILE's own offset byte pair.
    stack = []
    area = (0, 0, 0)
    tile = None
    unknown_attrs = Counter()

    while pos < size:
        byte = data[pos]

        if byte == NODE_START:
            pos += 1
            node_type = data[pos]
            pos += 1

            # Property bytes run until an unescaped NODE_START or NODE_END.
            raw = bytearray()
            while pos < size:
                b = data[pos]
                if b == ESCAPE_CHAR:
                    raw.append(data[pos + 1])
                    pos += 2
                    continue
                if b in (NODE_START, NODE_END):
                    break
                raw.append(b)
                pos += 1

            props = Props(bytes(raw))

            try:
                if node_type == OTBM_TILE_AREA:
                    area = (props.u16(), props.u16(), props.u8())
                    tile = None

                elif node_type in (OTBM_TILE, OTBM_HOUSETILE):
                    dx = props.u8()
                    dy = props.u8()
                    tile = (area[0] + dx, area[1] + dy, area[2])
                    if node_type == OTBM_HOUSETILE:
                        props.u32()  # house id
                    action_id, unique_id = parse_attributes(props)
                    if action_id or unique_id:
                        # An id on the tile itself rather than on an item.
                        yield (*tile, None, action_id, unique_id)

                elif node_type == OTBM_ITEM and tile is not None:
                    item_id = props.u16()
                    action_id, unique_id = parse_attributes(props)
                    if everything or action_id or unique_id:
                        yield (*tile, item_id, action_id, unique_id)

            except (ValueError, IndexError, struct.error) as exc:
                unknown_attrs[str(exc)] += 1

            stack.append(node_type)
            continue

        if byte == NODE_END:
            if stack:
                popped = stack.pop()
                if popped in (OTBM_TILE, OTBM_HOUSETILE):
                    tile = None
            pos += 1
            continue

        pos += 1

    if unknown_attrs:
        for message, count in unknown_attrs.most_common(5):
            print(f"  [warn] {count}x {message}", file=sys.stderr)


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("map")
    ap.add_argument("--area", nargs=4, type=int, metavar=("X1", "Y1", "X2", "Y2"))
    ap.add_argument("--near", nargs=3, type=int, metavar=("X", "Y", "Z"))
    ap.add_argument("--radius", type=int, default=5)
    ap.add_argument("--aid", type=int, help="only this action id")
    ap.add_argument("--uid", type=int, help="only this unique id")
    ap.add_argument("--summary", action="store_true",
                    help="count by action id instead of listing positions")
    ap.add_argument("--all-items", action="store_true",
                    help="every item the map places, not just identified ones")
    args = ap.parse_args()

    rows = []
    for x, y, z, item_id, action_id, unique_id in walk(args.map, everything=args.all_items):
        if args.area:
            x1, y1, x2, y2 = args.area
            if not (x1 <= x <= x2 and y1 <= y <= y2):
                continue
        if args.near:
            nx, ny, nz = args.near
            if z != nz or abs(x - nx) > args.radius or abs(y - ny) > args.radius:
                continue
        if args.aid is not None and action_id != args.aid:
            continue
        if args.uid is not None and unique_id != args.uid:
            continue
        rows.append((x, y, z, item_id, action_id, unique_id))

    if args.summary:
        counts = Counter(r[4] for r in rows if r[4])
        print(f"{len(rows)} identified items; {len(counts)} distinct action ids")
        for action_id, count in counts.most_common(40):
            print(f"  aid {action_id:<8} {count}")
        return

    print(f"{'position':<22} {'item':<8} {'aid':<8} uid")
    for x, y, z, item_id, action_id, unique_id in rows:
        where = f"{x}, {y}, {z}"
        print(f"{where:<22} {str(item_id or '-'):<8} "
              f"{str(action_id or '-'):<8} {unique_id or '-'}")
    print(f"\n{len(rows)} identified item(s)")


if __name__ == "__main__":
    main()
