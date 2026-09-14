#!/usr/bin/env python3
"""Converts TFS 1.4 monster XML files into BlackTek monster Lua files.

Only creatures that BlackTek does not already define are written (by name),
in the same shape as data/scripts/monsters/monsters/*.lua.

  python3 harness/build_monsters.py --pack /home/josh/Downloads/realworldSeeingBlue --out data/scripts/monsters/monsters/realmap
"""
import argparse
import re
import xml.etree.ElementTree as ET
from pathlib import Path

MAGIC = {}
SHOOT = {}
for line in Path('src/tools.cpp').read_text(errors='replace').splitlines():
    m = re.search(r'\{"([a-z0-9]+)",\s*(CONST_(ME|ANI)_[A-Z_0-9]+)\}', line)
    if m:
        (MAGIC if m.group(3) == 'ME' else SHOOT)[m.group(1)] = m.group(2)

ELEMENTS = {
    'physical': 'COMBAT_PHYSICALDAMAGE', 'energy': 'COMBAT_ENERGYDAMAGE', 'fire': 'COMBAT_FIREDAMAGE',
    'poison': 'COMBAT_EARTHDAMAGE', 'earth': 'COMBAT_EARTHDAMAGE', 'ice': 'COMBAT_ICEDAMAGE',
    'holy': 'COMBAT_HOLYDAMAGE', 'death': 'COMBAT_DEATHDAMAGE', 'drown': 'COMBAT_DROWNDAMAGE',
    'lifedrain': 'COMBAT_LIFEDRAIN', 'manadrain': 'COMBAT_MANADRAIN',
}
COMBAT_IMMUNITIES = {'physical', 'energy', 'fire', 'poison', 'earth', 'ice', 'holy', 'death', 'drown', 'lifedrain', 'manadrain'}
CONDITION_IMMUNITIES = {'paralyze', 'outfit', 'drunk', 'invisible', 'bleed', 'energy', 'fire', 'poison', 'earth', 'ice', 'drown', 'death', 'holy'}
# melee condition attributes: xml key -> (condition constant, tick interval)
MELEE_CONDITIONS = {
    'fire': ('CONDITION_FIRE', 9000), 'poison': ('CONDITION_POISON', 4000), 'earth': ('CONDITION_POISON', 4000),
    'energy': ('CONDITION_ENERGY', 10000), 'drown': ('CONDITION_DROWN', 5000), 'freeze': ('CONDITION_FREEZING', 8000),
    'ice': ('CONDITION_FREEZING', 8000), 'dazzle': ('CONDITION_DAZZLED', 10000), 'holy': ('CONDITION_DAZZLED', 10000),
    'curse': ('CONDITION_CURSED', 4000), 'death': ('CONDITION_CURSED', 4000), 'bleed': ('CONDITION_BLEEDING', 4000),
    'physical': ('CONDITION_BLEEDING', 4000),
}
FLAGS = {
    'summonable': 'summonable', 'attackable': 'attackable', 'hostile': 'hostile', 'illusionable': 'illusionable',
    'convinceable': 'convinceable', 'pushable': 'pushable', 'canpushitems': 'canPushItems',
    'canpushcreatures': 'canPushCreatures', 'hidehealth': 'healthHidden', 'isboss': 'boss', 'boss': 'boss',
    'canwalkonenergy': 'canWalkOnEnergy', 'canwalkonfire': 'canWalkOnFire', 'canwalkonpoison': 'canWalkOnPoison',
    'ignorespawnblock': 'ignoreSpawnBlock', 'challengeable': 'challengeable',
}


def lua_string(text: str) -> str:
    return '"' + text.replace('\\', '\\\\').replace('"', '\\"') + '"'


def convert_ability(node: ET.Element) -> list[str]:
    name = node.get('name', '')
    lines = ['    {', f'        name = {lua_string(name)},']
    attrs = {k: v for k, v in node.attrib.items() if k != 'name'}
    if name == 'melee':
        if 'attack' in attrs and 'skill' in attrs:
            lines += [f'        attack = {attrs["attack"]},', f'        skill = {attrs["skill"]},']
        if 'min' in attrs and 'max' in attrs:
            lines += [f'        minDamage = {attrs["min"]},', f'        maxDamage = {attrs["max"]},']
        lines.append(f'        interval = {attrs.get("interval", "2000")},')
        for key, (condition, tick) in MELEE_CONDITIONS.items():
            if key in attrs:
                amount = attrs[key]
                lines.append(f'        condition = {{ type = {condition}, minDamage = -{amount}, maxDamage = -{amount}, interval = {tick} }},')
                break
    else:
        lines.append(f'        interval = {attrs.get("interval", "2000")},')
        if 'chance' in attrs:
            lines.append(f'        chance = {attrs["chance"]},')
        if 'range' in attrs:
            lines.append(f'        range = {attrs["range"]},')
        if 'min' in attrs and 'max' in attrs:
            lines += [f'        minDamage = {attrs["min"]},', f'        maxDamage = {attrs["max"]},']
        for key, dest in (('radius', 'radius'), ('length', 'length'), ('spread', 'spread'), ('ring', 'ring'), ('duration', 'duration'), ('speedchange', 'speed'), ('monster', 'monster'), ('item', 'item')):
            if key in attrs:
                value = attrs[key]
                if key in ('monster',):
                    value = lua_string(value)
                lines.append(f'        {dest} = {value},')
        if 'target' in attrs:
            lines.append(f'        target = {"true" if attrs["target"] not in ("0", "false") else "false"},')
        if 'direction' in attrs:
            lines.append(f'        direction = {"true" if attrs["direction"] not in ("0", "false") else "false"},')
        if 'script' in attrs:
            lines.append(f'        script = {lua_string(attrs["script"])},')
    for attribute in node.iter('attribute'):
        key = attribute.get('key', '').lower()
        value = attribute.get('value', '').lower()
        if key == 'shooteffect' and value in SHOOT:
            lines.append(f'        shootEffect = {SHOOT[value]},')
        elif key == 'areaeffect' and value in MAGIC:
            lines.append(f'        effect = {MAGIC[value]},')
    lines.append('    },')
    return lines


def convert_loot(items, indent='    ') -> list[str]:
    lines = []
    for item in items:
        fields = []
        if item.get('id'):
            fields.append(f'id = {item.get("id")}')
        elif item.get('name'):
            fields.append(f'id = {lua_string(item.get("name"))}')
        else:
            continue
        if item.get('chance'):
            fields.append(f'chance = {item.get("chance")}')
        if item.get('countmax'):
            fields.append(f'maxCount = {item.get("countmax")}')
        if item.get('subtype'):
            fields.append(f'subType = {item.get("subtype")}')
        if item.get('actionid'):
            fields.append(f'aid = {item.get("actionid")}')
        if item.get('text'):
            fields.append(f'text = {lua_string(item.get("text"))}')
        children = [child for child in item if child.tag == 'item']
        if children:
            lines.append(f'{indent}{{{", ".join(fields)}, child = {{')
            lines += convert_loot(children, indent + '    ')
            lines.append(f'{indent}}}}},')
        else:
            lines.append(f'{indent}{{{", ".join(fields)}}},')
    return lines


def convert(path: Path) -> str | None:
    # the pack's files are hand-edited: strip byte-order marks and leading
    # whitespace, and escape bare ampersands before parsing
    text = path.read_text(encoding='utf-8', errors='replace').lstrip('\ufeff \t\r\n')
    text = re.sub(r'&(?![a-zA-Z#][a-zA-Z0-9]*;)', '&amp;', text)
    try:
        root = ET.fromstring(text)
    except ET.ParseError as error:
        print(f'skip {path}: {error}')
        return None
    name = root.get('name')
    out = [f'local mtype = Game.createMonsterType({lua_string(name)})', 'local monster = {}', '',
           f'monster.name = {lua_string(name)}', f'monster.description = {lua_string(root.get("nameDescription", "a " + name.lower()))}', '']
    out.append(f'monster.experience = {root.get("experience", "0")}')
    out.append(f'monster.race = {lua_string(root.get("race", "blood"))}')
    health = root.find('health')
    if health is not None:
        out.append(f'monster.maxHealth = {health.get("max", "100")}')
        out.append(f'monster.health = {health.get("now", health.get("max", "100"))}')
    out.append(f'monster.speed = {root.get("speed", "100")}')
    out.append(f'monster.manaCost = {root.get("manacost", "0")}')
    if root.get('skull'):
        out.append(f'monster.skull = {lua_string(root.get("skull"))}')
    look = root.find('look')
    if look is not None:
        if look.get('corpse'):
            out.append(f'monster.corpse = {look.get("corpse")}')
        parts = []
        if look.get('typeex'):
            parts.append(f'lookTypeEx = {look.get("typeex")}')
        else:
            parts.append(f'lookType = {look.get("type", "0")}')
            for key, dest in (('head', 'lookHead'), ('body', 'lookBody'), ('legs', 'lookLegs'), ('feet', 'lookFeet'), ('addons', 'lookAddons'), ('mount', 'lookMount')):
                if look.get(key):
                    parts.append(f'{dest} = {look.get(key)}')
        out.append(f'monster.outfit = {{ {", ".join(parts)} }}')
    target = root.find('targetchange')
    if target is not None:
        out += ['monster.changeTarget = {', f'    interval = {target.get("interval", target.get("speed", "4000"))},', f'    chance = {target.get("chance", "0")},', '}']
    flags = {}
    for flag in root.iter('flag'):
        for key, value in flag.attrib.items():
            key = key.lower()
            if key == 'targetdistance':
                out.append(f'monster.targetDistance = {value}')
            elif key == 'staticattack':
                out.append(f'monster.staticAttackChance = {value}')
            elif key == 'runonhealth':
                out.append(f'monster.runHealth = {value}')
            elif key == 'lightlevel':
                flags['_lightlevel'] = value
            elif key == 'lightcolor':
                flags['_lightcolor'] = value
            elif key in FLAGS:
                flags[FLAGS[key]] = 'true' if value not in ('0', 'false') else 'false'
    if '_lightlevel' in flags or '_lightcolor' in flags:
        out.append(f'monster.light = {{ level = {flags.pop("_lightlevel", "0")}, color = {flags.pop("_lightcolor", "0")} }}')
    if flags:
        out.append('monster.flags = {')
        out += [f'    {key} = {value},' for key, value in flags.items()]
        out.append('}')
    attacks = root.find('attacks')
    if attacks is not None and len(attacks):
        out.append('monster.attacks = {')
        for attack in attacks.findall('attack'):
            out += convert_ability(attack)
        out.append('}')
    defenses = root.find('defenses')
    if defenses is not None:
        out.append('monster.defenses = {')
        out.append(f'    defense = {defenses.get("defense", "0")},')
        out.append(f'    armor = {defenses.get("armor", "0")},')
        for defense in defenses.findall('defense'):
            out += convert_ability(defense)
        out.append('}')
    elements = root.find('elements')
    if elements is not None and len(elements):
        out.append('monster.elements = {')
        for element in elements.findall('element'):
            for key, value in element.attrib.items():
                base = key.lower().replace('percent', '')
                if base in ELEMENTS:
                    out.append(f'    {{type = {ELEMENTS[base]}, percent = {value}}},')
        out.append('}')
    immunities = root.find('immunities')
    if immunities is not None and len(immunities):
        out.append('monster.immunities = {')
        for immunity in immunities.findall('immunity'):
            for key, value in immunity.attrib.items():
                key = key.lower()
                if value in ('0', 'false'):
                    continue
                fields = [f'type = {lua_string(key)}']
                if key in COMBAT_IMMUNITIES:
                    fields.append('combat = true')
                if key in CONDITION_IMMUNITIES:
                    fields.append('condition = true')
                out.append(f'    {{{", ".join(fields)}}},')
        out.append('}')
    summons = root.find('summons')
    if summons is not None:
        out.append(f'monster.maxSummons = {summons.get("maxSummons", "1")}')
        out.append('monster.summons = {')
        for summon in summons.findall('summon'):
            out.append(f'    {{name = {lua_string(summon.get("name", ""))}, interval = {summon.get("interval", "2000")}, chance = {summon.get("chance", "10")}, max = {summon.get("max", "1")}}},')
        out.append('}')
    voices = root.find('voices')
    if voices is not None and len(voices):
        out.append('monster.voices = {')
        out.append(f'    interval = {voices.get("interval", "5000")},')
        out.append(f'    chance = {voices.get("chance", "10")},')
        for voice in voices.findall('voice'):
            yell = 'true' if voice.get('yell') not in (None, '0', 'false') else 'false'
            out.append(f'    {{text = {lua_string(voice.get("sentence", ""))}, yell = {yell}}},')
        out.append('}')
    loot = root.find('loot')
    if loot is not None and len(loot):
        out.append('monster.loot = {')
        out += convert_loot(loot.findall('item'))
        out.append('}')
    script = root.find('script')
    if script is not None and len(script):
        out.append('monster.events = {')
        out += [f'    {lua_string(event.get("name", ""))},' for event in script.findall('event')]
        out.append('}')
    out += ['', 'mtype:register(monster)', '']
    return '\n'.join(out)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split('\n', 1)[0])
    parser.add_argument('--pack', required=True)
    parser.add_argument('--out', required=True)
    parser.add_argument('--all', action='store_true', help='convert every creature, not only the missing ones')
    args = parser.parse_args()

    have = set()
    for path in Path('data/scripts/monsters').rglob('*.lua'):
        match = re.search(r'Game\.createMonsterType\("([^"]+)"\)', path.read_text(errors='replace'))
        if match:
            have.add(match.group(1).lower())

    # the pack's index decides which file a name means; later duplicates lose
    index = {}
    root = ET.parse(Path(args.pack) / 'monster' / 'monsters.xml').getroot()
    for entry in root.findall('monster'):
        index.setdefault(entry.get('name').lower(), Path(args.pack) / 'monster' / entry.get('file'))

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    written = 0
    for name, path in sorted(index.items()):
        if not args.all and name in have:
            continue
        if not path.exists():
            print(f'missing file for {name}: {path}')
            continue
        lua = convert(path)
        if lua is None:
            continue
        filename = re.sub(r'[^a-z0-9]+', '_', name).strip('_') + '.lua'
        (out / filename).write_text(lua)
        written += 1
    print(f'wrote {written} monster files to {out}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
