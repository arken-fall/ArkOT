#!/usr/bin/env python3
"""Give BlackTek's monsters their bestiary entries from a Canary datapack.

Canary's monster files carry a race id and a Bestiary block for every
creature CipSoft lists in the cyclopedia. BlackTek's monsters (a TFS 1.4.2
lineage) carry neither. This script matches the two by creature name and
writes `monster.raceId` and a `monster.bestiary` block, in BlackTek's key
style, right after the description line of each BlackTek monster file.

Usage:
    python3 harness/build_bestiary_data.py --canary ~/Documents/canary [--dry-run]

Re-running is safe: files that already carry a raceId are left alone.
"""
import argparse
import re
import sys
from pathlib import Path

RACE_ID = re.compile(r'^monster\.raceId\s*=\s*(\d+)', re.M)
CREATE = re.compile(r'Game\.createMonsterType\("([^"]+)"\)')
BESTIARY = re.compile(r'^monster\.Bestiary\s*=\s*\{(.*?)^\}', re.M | re.S)
FIELD = re.compile(r'(\w+)\s*=\s*(".*?"|\d+|[A-Z_]+)', re.S)

# Canary spells the race as an enum; BlackTek's loader takes the race name
RACE_NAMES = {
    'BESTY_RACE_AMPHIBIC': 'Amphibic', 'BESTY_RACE_AQUATIC': 'Aquatic', 'BESTY_RACE_BIRD': 'Bird',
    'BESTY_RACE_CONSTRUCT': 'Construct', 'BESTY_RACE_DEMON': 'Demon', 'BESTY_RACE_DRAGON': 'Dragon',
    'BESTY_RACE_ELEMENTAL': 'Elemental', 'BESTY_RACE_FEY': 'Fey', 'BESTY_RACE_GIANT': 'Giant',
    'BESTY_RACE_HUMAN': 'Human', 'BESTY_RACE_HUMANOID': 'Humanoid', 'BESTY_RACE_LYCANTHROPE': 'Lycanthrope',
    'BESTY_RACE_MAGICAL': 'Magical', 'BESTY_RACE_MAMMAL': 'Mammal', 'BESTY_RACE_PLANT': 'Plant',
    'BESTY_RACE_REPTILE': 'Reptile', 'BESTY_RACE_SLIME': 'Slime', 'BESTY_RACE_UNDEAD': 'Undead',
    'BESTY_RACE_VERMIN': 'Vermin', 'BESTY_RACE_EXTRA_DIMENSIONAL': 'Extra Dimensional',
    'BESTY_RACE_INKBORN': 'Inkborn',
}

# Canary key -> BlackTek key
KEYS = {
    'class': 'class', 'toKill': 'toKill', 'FirstUnlock': 'firstUnlock', 'SecondUnlock': 'secondUnlock',
    'CharmsPoints': 'charmPoints', 'Stars': 'stars', 'Occurrence': 'occurrence', 'Locations': 'locations',
}


def read_canary(root: Path) -> dict:
    entries = {}
    for path in (root / 'data-otservbr-global' / 'monster').rglob('*.lua'):
        text = path.read_text(errors='ignore')
        name = CREATE.search(text)
        race_id = RACE_ID.search(text)
        block = BESTIARY.search(text)
        if not (name and race_id and block):
            continue
        fields = {}
        for key, value in FIELD.findall(block.group(1)):
            if key == 'race':
                fields['race'] = RACE_NAMES.get(value, '')
            elif key in KEYS:
                fields[KEYS[key]] = value
        if 'locations' in fields:
            # Canary folds long strings with \z; join them into one line
            fields['locations'] = re.sub(r'\\z\s*', '', fields['locations'])
            fields['locations'] = re.sub(r'\s+', ' ', fields['locations'])
        entries[name.group(1).lower()] = (int(race_id.group(1)), fields)
    return entries


def render(race_id: int, fields: dict) -> str:
    lines = [f'monster.raceId = {race_id}', 'monster.bestiary = {']
    for key in ('race', 'class'):
        if key in fields:
            value = fields[key] if fields[key].startswith('"') else f'"{fields[key]}"'
            lines.append(f'\t{key} = {value},')
    for key in ('toKill', 'firstUnlock', 'secondUnlock', 'charmPoints', 'stars', 'occurrence'):
        if key in fields:
            lines.append(f'\t{key} = {fields[key]},')
    if 'locations' in fields:
        lines.append(f'\tlocations = {fields["locations"]},')
    lines.append('}')
    return '\n'.join(lines) + '\n'


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split('\n', 1)[0])
    parser.add_argument('--canary', required=True, type=Path)
    parser.add_argument('--monsters', type=Path, default=Path(__file__).resolve().parent.parent / 'data' / 'scripts' / 'monsters' / 'monsters')
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args()

    canary = read_canary(args.canary)
    written = skipped = unmatched = 0
    for path in sorted(args.monsters.glob('*.lua')):
        text = path.read_text(errors='ignore')
        name = CREATE.search(text)
        if not name:
            continue
        if RACE_ID.search(text):
            skipped += 1
            continue
        entry = canary.get(name.group(1).lower())
        if not entry:
            unmatched += 1
            continue
        race_id, fields = entry
        anchor = re.search(r'^monster\.description\s*=.*\n', text, re.M)
        insert_at = anchor.end() if anchor else CREATE.search(text).end() + 1
        block = ('\n' if anchor else '') + render(race_id, fields)
        if not args.dry_run:
            path.write_text(text[:insert_at] + block + text[insert_at:])
        written += 1

    print(f'bestiary entries written: {written}, already present: {skipped}, no match in canary: {unmatched}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
