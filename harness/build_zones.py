#!/usr/bin/env python3
"""Converts a TFS spawn XML into BlackTek zone files, one per floor.

Each <spawn centerx centery centerz radius> becomes a fixed, passive, forced
monster zone whose range is the spawn square and whose creatures sit at
their offset from the range's top-left corner, the same shape the shipped
forgotten-zones carry.

  python3 harness/build_zones.py --spawns world/map1-spawn.xml --out data/world/realmap-zones
"""
import argparse
import collections
import xml.etree.ElementTree as ET
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split('\n', 1)[0])
    parser.add_argument('--spawns', required=True)
    parser.add_argument('--out', required=True)
    parser.add_argument('--interval-max', type=int, default=0, help='cap spawn intervals in seconds (0 = keep)')
    args = parser.parse_args()

    floors = collections.defaultdict(list)
    counters = collections.Counter()
    total = 0
    for spawn in ET.parse(args.spawns).getroot().iter('spawn'):
        cx, cy, cz = int(spawn.get('centerx')), int(spawn.get('centery')), int(spawn.get('centerz'))
        radius = int(spawn.get('radius'))
        creatures = []
        for kind in ('monster', 'npc'):
            for node in spawn.iter(kind):
                dx, dy = int(node.get('x')), int(node.get('y'))
                interval = int(node.get('spawntime', '60'))
                if args.interval_max:
                    interval = min(interval, args.interval_max)
                creatures.append((kind, node.get('name'), radius + dx, radius + dy, interval))
        if not creatures:
            continue
        # npcs are placed by their own files in BlackTek; keep monsters only
        monsters = [c for c in creatures if c[0] == 'monster']
        if not monsters:
            continue
        counters[cz] += 1
        name = f'ConvertedSpawn_z{cz}_{counters[cz]}'
        lines = [f'[{name}]',
                 f'range = {{ start = "{cx - radius}:{cy - radius}:{cz}", end = "{cx + radius}:{cy + radius}:{cz}" }}',
                 'spawn_type = "monster"', 'policy = "fixed"', 'passive = true', 'forced = true', 'monsters = [']
        for _, mname, ox, oy, interval in monsters:
            lines.append(f'    {{ position = "{ox}:{oy}:0", interval = {interval}, name = "{mname}" }},')
        lines.append(']')
        floors[cz].append('\n'.join(lines))
        total += len(monsters)

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob('floor-*.toml'):
        old.unlink()
    for z, zones in sorted(floors.items()):
        (out / f'floor-{z}.toml').write_text('\n\n'.join(zones) + '\n')
    print(f'wrote {sum(counters.values())} zones with {total} creatures over {len(floors)} floors to {out}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
