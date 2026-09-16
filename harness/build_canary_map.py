#!/usr/bin/env python3
"""Convert Canary's world map release into a map BlackTek loads.

Canary (opentibiabr/canary) ships its world as a release asset,
otservbr.otbm, plus data-otservbr-global/world/otservbr-{monster,npc,house,
zones}.xml. That map is OTBM version 4 and names every item by its client
(appearance) id. BlackTek reads OTBM versions 1-2 with server ids, so this
rewrites the map in one pass:

  - root header version 4 -> 2
  - every item id (tile inline items, item nodes, container contents) from
    appearance id to server id through data/items/modern_client_ids.tsv
  - map data attributes: the monster and npc spawn files become one TFS
    spawn file, the house file is kept, the zone file attribute is dropped
  - tile zone nodes are dropped from the map and written to a sidecar
    (<name>-zones.tsv: zone id, zone name, x, y, z) for later use

The companion files are written next to the map: <name>-spawn.xml (Canary's
monster and npc spawns merged under <spawns>) and <name>-house.xml.
A report lists item ids with no server id and spawns naming monsters or NPCs
ArkOT does not define.

Usage:
  python3 harness/build_canary_map.py --otbm otservbr.otbm \\
      --canary ~/Documents/canary --out data/world/canary.otbm
"""

import argparse
import re
import struct
import sys
import time
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

NODE_START = 0xFE
NODE_END = 0xFF
ESCAPE = 0xFD

OTBM_MAP_DATA = 2
OTBM_TILE_AREA = 4
OTBM_TILE = 5
OTBM_ITEM = 6
OTBM_HOUSETILE = 14
OTBM_TILE_ZONE = 19

ATTR_DESCRIPTION = 1
ATTR_TILE_FLAGS = 3
ATTR_ITEM = 9
ATTR_EXT_SPAWN_FILE = 11
ATTR_EXT_HOUSE_FILE = 13
ATTR_EXT_SPAWN_NPC_FILE = 23
ATTR_EXT_ZONE_FILE = 24


def unescape(segment):
    if ESCAPE not in segment:
        return segment
    out = bytearray()
    index = 0
    while index < len(segment):
        byte = segment[index]
        if byte == ESCAPE:
            index += 1
            byte = segment[index]
        out.append(byte)
        index += 1
    return bytes(out)


def escape(data):
    if not any(byte in data for byte in (ESCAPE, NODE_START, NODE_END)):
        return data
    out = bytearray()
    for byte in data:
        if byte in (ESCAPE, NODE_START, NODE_END):
            out.append(ESCAPE)
        out.append(byte)
    return bytes(out)


def load_translation(path):
    """appearance id -> server id; the first (lowest) server id wins, as in Items::loadModernClientIds."""
    translation = {}
    for line in Path(path).read_text().splitlines():
        if not line or line.startswith("#"):
            continue
        fields = line.split("\t")
        translation.setdefault(int(fields[1]), int(fields[0]))
    return translation


class Converter:
    def __init__(self, translation, spawn_name, house_name):
        self.translation = translation
        self.spawn_name = spawn_name
        self.house_name = house_name
        self.missing = {}
        self.items = 0
        self.zones = []

    def item_id(self, appearance):
        server = self.translation.get(appearance)
        if server is None:
            self.missing[appearance] = self.missing.get(appearance, 0) + 1
            return None
        self.items += 1
        return server

    def root(self, props):
        return struct.pack("<I", 2) + props[4:]

    def map_data(self, props):
        out = bytearray()
        index = 0
        while index < len(props):
            attribute = props[index]
            (length,) = struct.unpack_from("<H", props, index + 1)
            value = props[index + 3:index + 3 + length]
            index += 3 + length
            if attribute == ATTR_EXT_SPAWN_FILE:
                value = self.spawn_name.encode()
            elif attribute == ATTR_EXT_HOUSE_FILE:
                value = self.house_name.encode()
            elif attribute in (ATTR_EXT_SPAWN_NPC_FILE, ATTR_EXT_ZONE_FILE):
                continue
            out += bytes([attribute]) + struct.pack("<H", len(value)) + value
        return bytes(out)

    def tile(self, props, house):
        offset = 2 + (4 if house else 0)
        out = bytearray(props[:offset])
        index = offset
        while index < len(props):
            attribute = props[index]
            if attribute == ATTR_TILE_FLAGS:
                out += props[index:index + 5]
                index += 5
            elif attribute == ATTR_ITEM:
                (appearance,) = struct.unpack_from("<H", props, index + 1)
                server = self.item_id(appearance)
                if server is not None:
                    out += bytes([ATTR_ITEM]) + struct.pack("<H", server)
                index += 3
            else:
                raise ValueError(f"unknown tile attribute {attribute}")
        return bytes(out)

    def item(self, props):
        (appearance,) = struct.unpack_from("<H", props, 0)
        server = self.item_id(appearance)
        if server is None:
            return None
        return struct.pack("<H", server) + props[2:]


def convert(source, target, converter):
    raw = memoryview(Path(source).read_bytes())
    markers = re.compile(rb"[\xfd\xfe\xff]")
    out = bytearray(raw[:4])

    # each open node: [type, first props segment still pending, dropped, tile position]
    stack = []
    area = (0, 0, 0)
    tile_position = None
    position = 4
    pending_start = None
    # the escape byte shields the next byte, so walk markers by hand around it
    for match in markers.finditer(raw, 4):
        at = match.start()
        if at < position:
            continue
        byte = raw[at]
        if byte == ESCAPE:
            position = at + 2
            continue

        if stack and stack[-1][1]:
            node = stack[-1]
            props = unescape(raw[pending_start:at].tobytes())
            node[1] = False
            node_type = node[0]
            if node[2]:
                if node_type == OTBM_TILE_ZONE and tile_position is not None:
                    (count,) = struct.unpack_from("<H", props, 0)
                    for zone in struct.unpack_from(f"<{count}H", props, 2):
                        converter.zones.append((zone, *tile_position))
            else:
                if len(stack) == 1:
                    props = converter.root(props)
                elif node_type == OTBM_MAP_DATA:
                    props = converter.map_data(props)
                elif node_type == OTBM_TILE_AREA:
                    area = struct.unpack_from("<HHB", props, 0)
                elif node_type in (OTBM_TILE, OTBM_HOUSETILE):
                    tile_position = (area[0] + props[0], area[1] + props[1], area[2])
                    props = converter.tile(props, node_type == OTBM_HOUSETILE)
                elif node_type == OTBM_ITEM:
                    converted = converter.item(props)
                    if converted is None:
                        node[2] = True
                        out[node[3]:] = b""
                    else:
                        props = converted
                if not node[2]:
                    out += escape(props)

        if byte == NODE_START:
            node_type = raw[at + 1]
            dropped = bool(stack and stack[-1][2]) or node_type == OTBM_TILE_ZONE
            stack.append([node_type, True, dropped, len(out)])
            if not dropped:
                out += bytes([NODE_START, node_type])
            pending_start = at + 2
            position = at + 2
        else:
            node = stack.pop()
            if not node[2]:
                out.append(NODE_END)
            position = at + 1
            pending_start = position
            if stack:
                stack[-1][1] = False
    Path(target).write_bytes(out)


def merge_spawns(monster_file, npc_file, target):
    spawns = ET.Element("spawns")
    counts = {"monster": 0, "npc": 0}
    names = {"monster": set(), "npc": set()}
    # the engine opens data/npc/<name>.xml by the spawn's spelling, and a few of
    # ArkOT's own npc files capitalise differently than Canary's spawns
    defined = {path.stem.lower(): path.stem for path in (ROOT / "data/npc").glob("*.xml")}
    for path, kind in ((monster_file, "monster"), (npc_file, "npc")):
        for group in ET.parse(path).getroot():
            spawn = ET.SubElement(spawns, "spawn", {key: group.get(key) for key in ("centerx", "centery", "centerz", "radius")})
            for creature in group:
                attributes = dict(creature.attrib)
                if kind == "npc":
                    attributes["name"] = defined.get(attributes.get("name", "").lower(), attributes.get("name"))
                ET.SubElement(spawn, kind, attributes)
                counts[kind] += 1
                names[kind].add(attributes.get("name"))
    ET.indent(spawns, "\t")
    ET.ElementTree(spawns).write(target, encoding="unicode", xml_declaration=True)
    return counts, names


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--otbm", required=True, help="Canary release otservbr.otbm")
    parser.add_argument("--canary", required=True, help="Canary checkout, for data-otservbr-global/world/*.xml")
    parser.add_argument("--out", default=str(ROOT / "data/world/canary.otbm"))
    parser.add_argument("--mapping", default=str(ROOT / "data/items/modern_client_ids.tsv"))
    args = parser.parse_args()

    target = Path(args.out)
    stem = target.stem
    world = Path(args.canary).expanduser() / "data-otservbr-global/world"
    converter = Converter(load_translation(args.mapping), f"{stem}-spawn.xml", f"{stem}-house.xml")

    started = time.time()
    convert(args.otbm, target, converter)
    print(f"map: {converter.items} items translated in {time.time() - started:.0f}s -> {target}")

    counts, names = merge_spawns(world / "otservbr-monster.xml", world / "otservbr-npc.xml", target.with_name(f"{stem}-spawn.xml"))
    print(f"spawns: {counts['monster']} monsters, {counts['npc']} npcs -> {stem}-spawn.xml")
    target.with_name(f"{stem}-house.xml").write_text((world / "otservbr-house.xml").read_text())

    zone_names = {int(zone.get("zoneid")): zone.get("name") for zone in ET.parse(world / "otservbr-zones.xml").getroot()}
    with open(target.with_name(f"{stem}-zones.tsv"), "w") as sidecar:
        sidecar.write("# zone_id\tname\tx\ty\tz\n")
        for zone, x, y, z in converter.zones:
            sidecar.write(f"{zone}\t{zone_names.get(zone, '')}\t{x}\t{y}\t{z}\n")
    print(f"zones: {len(converter.zones)} tile zone entries -> {stem}-zones.tsv")

    known_npcs = {path.stem.lower() for path in (ROOT / "data/npc").glob("*.xml")}
    monster_text = "\n".join(path.read_text(errors="replace") for path in (ROOT / "data/scripts/monsters").rglob("*.lua"))
    known_monsters = {name.lower() for name in re.findall(r'createMonsterType\("([^"]+)"', monster_text)}
    missing_npcs = sorted(name for name in names["npc"] if name.lower() not in known_npcs)
    missing_monsters = sorted(name for name in names["monster"] if name.lower() not in known_monsters)
    print(f"unmapped item ids: {dict(sorted(converter.missing.items()))}")
    print(f"npcs ArkOT lacks ({len(missing_npcs)} of {len(names['npc'])}): {missing_npcs}")
    print(f"monsters ArkOT lacks ({len(missing_monsters)} of {len(names['monster'])}): {missing_monsters}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
