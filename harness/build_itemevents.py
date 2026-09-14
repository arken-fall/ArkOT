#!/usr/bin/env python3
"""Converts a TFS 1.4 actions.xml / movements.xml pack into BlackTek item events.

Every scripted entry becomes one revscript per script file under the output
folder: the original script with its hook function made local, followed by
an ItemEvent registration carrying every id, action id and unique id the XML
bound it to. Native-function entries (equipment requirements, fields) are
skipped: BlackTek registers those from its own tables.

  python3 harness/build_itemevents.py --pack /home/josh/Downloads/realworldSeeingBlue --out data/scripts/realmap
"""
import argparse
import collections
import re
import xml.etree.ElementTree as ET
from pathlib import Path

HOOKS = {
    'use': ('use', 'onUse', 'onUse'),
    'stepin': ('stepon', 'onStepIn', 'onStepOn'),
    'stepout': ('stepoff', 'onStepOut', 'onStepOff'),
    'additem': ('additem', 'onAddItem', 'onAddItem'),
    'removeitem': ('removeitem', 'onRemoveItem', 'onRemoveItem'),
    'equip': ('equip', 'onEquip', 'onEquip'),
    'deequip': ('deequip', 'onDeEquip', 'onDeEquip'),
}


def id_range(node, single, low, high):
    if node.get(single):
        return [int(v) for v in node.get(single).split(';') if v.strip()]
    if node.get(low) and node.get(high):
        return list(range(int(node.get(low)), int(node.get(high)) + 1))
    return []


def lua_list(values):
    return ', '.join(str(v) for v in values)


def parse_xml(path: Path):
    text = path.read_text(encoding='utf-8', errors='replace').lstrip('﻿ \t\r\n')
    text = re.sub(r'&(?![a-zA-Z#][a-zA-Z0-9]*;)', '&amp;', text)
    return ET.fromstring(text)


def make_local(script: str, hook_function: str) -> str:
    return re.sub(rf'^function {hook_function}\(', f'local function {hook_function}(', script, count=1, flags=re.M)


def render(script_text: str, registrations: list[dict]) -> str:
    out = [script_text.rstrip('\n'), '', '-- registrations generated from the pack XML by harness/build_itemevents.py']
    for index, reg in enumerate(registrations):
        var = f'realmapEvent{index + 1}'
        out.append(f'local {var} = ItemEvent()')
        out.append(f'{var}:type("{reg["type"]}")')
        out.append(f'{var}.{reg["callback"]} = {reg["function"]}')
        for key, values in (('id', reg['ids']), ('aid', reg['aids']), ('uid', reg['uids'])):
            for start in range(0, len(values), 100):
                out.append(f'{var}:{key}({lua_list(values[start:start + 100])})')
        if reg.get('far'):
            out.append(f'{var}:allowFarUse(true)')
        if reg.get('tile'):
            out.append(f'{var}:tileItem(true)')
        if reg.get('slot'):
            out.append(f'{var}:slot("{reg["slot"]}")')
        if reg.get('level'):
            out.append(f'{var}:level({reg["level"]})')
        out.append(f'{var}:register()')
    return '\n'.join(out) + '\n'


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split('\n', 1)[0])
    parser.add_argument('--pack', required=True)
    parser.add_argument('--out', required=True)
    args = parser.parse_args()
    pack = Path(args.pack)
    out = Path(args.out)

    # script file -> list of registrations (one per hook the XML binds)
    groups = collections.defaultdict(lambda: collections.defaultdict(lambda: {'ids': [], 'aids': [], 'uids': []}))
    skipped = collections.Counter()

    for node in parse_xml(pack / 'actions' / 'actions.xml').findall('action'):
        script = node.get('script')
        if not script:
            skipped['action:' + node.get('function', '?')] += 1
            continue
        reg = groups[('actions', script)]['use']
        reg['ids'] += id_range(node, 'itemid', 'fromid', 'toid')
        reg['aids'] += id_range(node, 'actionid', 'fromaid', 'toaid')
        reg['uids'] += id_range(node, 'uniqueid', 'fromuid', 'touid')
        if node.get('allowfaruse') not in (None, '0', 'false'):
            reg['far'] = True

    for node in parse_xml(pack / 'movements' / 'movements.xml').findall('movevent'):
        script = node.get('script')
        event = node.get('event', '').lower()
        if not script or event not in HOOKS:
            skipped['movement:' + node.get('function', event)] += 1
            continue
        reg = groups[('movements', script)][event]
        reg['ids'] += id_range(node, 'itemid', 'fromid', 'toid')
        reg['aids'] += id_range(node, 'actionid', 'fromaid', 'toaid')
        reg['uids'] += id_range(node, 'uniqueid', 'fromuid', 'touid')
        if node.get('tileitem') not in (None, '0', 'false'):
            reg['tile'] = True
        if node.get('slot'):
            reg['slot'] = node.get('slot')
        if node.get('level'):
            reg['level'] = node.get('level')

    # BlackTek already carries its own adapted copies of the stock TFS tool,
    # potion, food, field and tile scripts; the pack's versions would only
    # register the same ids a second time with the older API
    existing_use = {p.relative_to('data/scripts/itemevents/use').as_posix() for p in Path('data/scripts/itemevents/use').rglob('*.lua')}
    existing_step = {p.name for p in Path('data/scripts/itemevents').rglob('*.lua')}
    written = 0
    missing = []
    duplicates = 0
    for (kind, script), hooks in sorted(groups.items()):
        source = pack / kind / 'scripts' / script
        if not source.exists():
            missing.append(str(source))
            continue
        if (kind == 'actions' and script in existing_use) or (kind == 'movements' and Path(script).name in existing_step):
            duplicates += 1
            continue
        text = source.read_text(encoding='utf-8', errors='replace').lstrip('﻿')
        registrations = []
        for event, reg in hooks.items():
            reg['ids'] = sorted(set(reg['ids']))
            reg['aids'] = sorted(set(reg['aids']))
            reg['uids'] = sorted(set(reg['uids']))
            if not (reg['ids'] or reg['aids'] or reg['uids']):
                continue
            type_name, function_name, callback = HOOKS[event]
            text = make_local(text, function_name)
            registrations.append({**reg, 'type': type_name, 'function': function_name, 'callback': callback})
        if not registrations:
            continue
        target = out / kind / re.sub(r'[^A-Za-z0-9_./-]+', '_', script)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(render(text, registrations))
        written += 1

    print(f'wrote {written} event scripts to {out}; left {duplicates} to BlackTek\'s own copies; skipped {dict(skipped)}; missing scripts {len(missing)}')
    for path in missing[:10]:
        print('  missing', path)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
