#!/usr/bin/env python3
"""Port Canary's monsters that BlackTek does not define yet.

Canary (opentibiabr/canary, data-otservbr-global/monster) writes monsters in
the same revscript shape BlackTek registers through
data/scripts/lib/register_monster_type.lua, with a few differences this
script rewrites; everything else (voices, elements, immunities, callbacks,
local helper code) is kept as Canary wrote it:

  - monster.Bestiary {race = BESTY_RACE_X, FirstUnlock, CharmsPoints, ...}
    -> monster.bestiary {race = "X", firstUnlock, charmPoints, ...}
  - flags.targetDistance / staticAttackChance / runHealth are also set at
    the top level, where BlackTek reads them
  - monster.summon {maxSummons, summons {count}} -> monster.maxSummons and
    monster.summons {max}
  - loot names and client item ids, outfit lookTypeEx and spell outfitItem
    -> server item ids (Canary's data/items/items.xml names client ids;
    data/items/modern_client_ids.tsv turns them into server ids)
  - spell speedChange -> speed, outfitMonster -> monster, and a condition's
    totalDamage -> minDamage = maxDamage = totalDamage (Canary's own reading)

Monsters BlackTek already defines (by name) are skipped. Files land in
<out>/<Canary sub folder>/<file>.lua. The report lists loot BlackTek has no
item for, callbacks BlackTek does not bind (their assignment is commented
out), and named monster spells no BlackTek spell script registers.

Usage:
  python3 harness/build_canary_monsters.py --canary ~/Documents/canary \\
      [--out data/scripts/monsters/monsters/canary] [--report report.md]
"""

import argparse
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_quest_log import Parser, Raw, Ref  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent

RACES = ["", "Amphibic", "Aquatic", "Bird", "Construct", "Demon", "Dragon", "Elemental", "Fey", "Giant", "Human",
         "Humanoid", "Lycanthrope", "Magical", "Mammal", "Plant", "Reptile", "Slime", "Undead", "Vermin",
         "Extra Dimensional", "Inkborn"]
BESTIARY_KEYS = {"class": "class", "toKill": "toKill", "FirstUnlock": "firstUnlock", "SecondUnlock": "secondUnlock",
                 "CharmsPoints": "charmPoints", "Stars": "stars", "Occurrence": "occurrence", "Locations": "locations"}
BOUND_CALLBACKS = {"onThink", "onAppear", "onDisappear", "onMove", "onSay"}
BUILTIN_SPELLS = {"melee", "combat", "speed", "outfit", "invisible", "drunk", "firefield", "poisonfield",
                  "energyfield", "physical", "energy", "fire", "earth", "poison", "ice", "holy", "death", "drown",
                  "lifedrain", "manadrain", "healing", "condition", "strength", "effect"}
IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def lua(value, depth=0):
    """Serialise a parsed value back to Lua in Canary's layout."""
    if isinstance(value, bool):
        return "true" if value else "false"
    if value is None:
        return "nil"
    if isinstance(value, (int, float)):
        return repr(value)
    if isinstance(value, str):
        escaped = value.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
        return f'"{escaped}"'
    if isinstance(value, Ref):
        return value.name
    if isinstance(value, Raw):
        return value.text
    if not value:
        return "{}"

    array = [value[index] for index in range(1, len(value) + 1) if index in value]
    named = [(key, item) for key, item in value.items() if not (isinstance(key, int) and 1 <= key <= len(array))]
    parts = [f"{key} = {lua(item, depth + 1)}" if isinstance(key, str) and IDENTIFIER.match(key)
             else f"[{lua(key)}] = {lua(item, depth + 1)}" for key, item in named]
    parts += [lua(item, depth + 1) for item in array]

    flat = all(not isinstance(item, dict) for _, item in named) and all(not isinstance(item, dict) for item in array)
    single = "{ " + ", ".join(parts) + " }"
    if flat and depth > 0 and len(single) <= 160:
        return single
    inner = "\t" * (depth + 1)
    return "{\n" + "".join(f"{inner}{part},\n" for part in parts) + "\t" * depth + "}"


class Items:
    def __init__(self, canary):
        self.by_name = {}
        for item in ET.parse(canary / "data/items/items.xml").getroot():
            name = (item.get("name") or "").lower()
            ids = [int(item.get("id"))] if item.get("id") else range(int(item.get("fromid", 0)), int(item.get("toid", -1)) + 1)
            for client_id in ids:
                if name:
                    self.by_name.setdefault(name, client_id)
        self.server = {}
        for line in (ROOT / "data/items/modern_client_ids.tsv").read_text().splitlines():
            if line and not line.startswith("#"):
                server, appearance = line.split("\t")[:2]
                self.server.setdefault(int(appearance), int(server))

    def from_client(self, client_id):
        return self.server.get(client_id)

    def from_name(self, name):
        client_id = self.by_name.get(name.lower())
        return self.server.get(client_id) if client_id is not None else None


def statements(text):
    """Yield (key, value, start, end) for every top-level `monster.<key> = <value>`."""
    parser = Parser(text)
    tokens = parser.tokens
    index = 0
    while index + 3 < len(tokens):
        kind, word, start = tokens[index]
        at_line_start = start == 0 or text[text.rfind("\n", 0, start) + 1:start].strip() == ""
        if (word == "monster" and at_line_start and tokens[index + 1][1] == "." and tokens[index + 2][0] == "name"
                and tokens[index + 3][1] == "="):
            parser.index = index + 4
            value = parser.value()
            last = tokens[parser.index - 1]
            yield tokens[index + 2][1], value, start, last[2] + len(last[1])
            index = parser.index
        else:
            index += 1


class Monster:
    def __init__(self, path, items, report):
        self.path = path
        self.items = items
        self.report = report
        self.text = path.read_text(errors="replace")
        self.name = re.search(r'createMonsterType\("([^"]+)"', self.text).group(1)

    def note(self, section, entry):
        self.report.setdefault(section, []).append(f"{self.name}: {entry}")

    def loot(self, entries):
        kept = {}
        for entry in (entries[key] for key in sorted(k for k in entries if isinstance(k, int))):
            entry = dict(entry)
            if "name" in entry:
                label = entry.pop("name")
                server = self.items.from_name(label)
            else:
                label = entry.get("id")
                server = self.items.from_client(entry["id"]) if isinstance(entry.get("id"), int) else None
            if server is None:
                self.note("Loot without a BlackTek item", str(label or entry))
                continue
            entry = {"id": server, **{key: value for key, value in entry.items() if key not in ("id", "name")}}
            if isinstance(entry.get("child"), dict):
                entry["child"] = self.loot(entry["child"])
            kept[len(kept) + 1] = entry
        return kept

    def spells(self, entries, known_spells):
        for key in [k for k in entries if isinstance(k, int)]:
            spell = dict(entries[key])
            if "speedChange" in spell:
                spell["speed"] = spell.pop("speedChange")
            if "outfitMonster" in spell:
                spell["monster"] = spell.pop("outfitMonster")
            if "outfitItem" in spell:
                server = self.items.from_client(spell.pop("outfitItem"))
                if server is not None:
                    spell["item"] = server
            condition = spell.get("condition")
            if isinstance(condition, dict) and "totalDamage" in condition:
                condition = dict(condition)
                total = condition.pop("totalDamage")
                condition.setdefault("minDamage", total)
                condition.setdefault("maxDamage", total)
                spell["condition"] = condition
            name = spell.get("name")
            if isinstance(name, str) and name not in BUILTIN_SPELLS and name.lower() not in known_spells:
                self.note("Spells no BlackTek script registers", name)
            entries[key] = spell
        return entries

    def convert(self, known_spells):
        pieces = []
        cursor = 0
        extra = []
        for key, value, start, end in list(statements(self.text)):
            replacement = None
            if key == "Bestiary" and isinstance(value, dict):
                bestiary = {}
                race = value.get("race")
                if isinstance(race, Ref) and race.name.startswith("BESTY_RACE_"):
                    bestiary["race"] = race.name[len("BESTY_RACE_"):].replace("_", " ").title()
                elif isinstance(race, int) and 0 <= race < len(RACES):
                    bestiary["race"] = RACES[race]
                for canary_key, blacktek_key in BESTIARY_KEYS.items():
                    if canary_key in value:
                        bestiary[blacktek_key] = value[canary_key]
                replacement = f"monster.bestiary = {lua(bestiary)}"
            elif key == "flags" and isinstance(value, dict):
                extra = [f"monster.{field} = {lua(value[field])}" for field in ("targetDistance", "staticAttackChance", "runHealth") if field in value]
                replacement = f"monster.flags = {lua(value)}" + "".join(f"\n{line}" for line in extra)
            elif key == "summon" and isinstance(value, dict):
                lines = []
                if "maxSummons" in value:
                    lines.append(f"monster.maxSummons = {lua(value['maxSummons'])}")
                summons = value.get("summons", {})
                converted = {}
                for index in sorted(k for k in summons if isinstance(k, int)):
                    summon = dict(summons[index])
                    if "count" in summon:
                        summon["max"] = summon.pop("count")
                    converted[len(converted) + 1] = summon
                lines.append(f"monster.summons = {lua(converted)}")
                replacement = "\n".join(lines)
            elif key == "loot" and isinstance(value, dict):
                replacement = f"monster.loot = {lua(self.loot(value))}"
            elif key == "outfit" and isinstance(value, dict) and isinstance(value.get("lookTypeEx"), int) and value["lookTypeEx"]:
                outfit = dict(value)
                server = self.items.from_client(outfit["lookTypeEx"])
                if server is None:
                    self.note("Loot without a BlackTek item", f"outfit lookTypeEx {outfit['lookTypeEx']}")
                else:
                    outfit["lookTypeEx"] = server
                replacement = f"monster.outfit = {lua(outfit)}"
            elif key in ("attacks", "defenses") and isinstance(value, dict):
                replacement = f"monster.{key} = {lua(self.spells(dict(value), known_spells))}"

            if replacement is not None:
                pieces.append(self.text[cursor:start])
                pieces.append(replacement)
                cursor = end
        pieces.append(self.text[cursor:])
        text = "".join(pieces)

        def unbound(match):
            self.note("Callbacks BlackTek does not bind (commented out)", match.group(1))
            body = match.group(0)
            return "-- Canary-only callback, not bound by BlackTek:\n" + "\n".join("-- " + line for line in body.splitlines())

        # a callback runs from its assignment to the `end` at column 0 that closes it
        text = re.sub(r"^mType\.(\w+) = function\b.*?^end\b", lambda m: m.group(0) if m.group(1) in BOUND_CALLBACKS else unbound(m), text, flags=re.M | re.S)
        return text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--canary", required=True)
    parser.add_argument("--out", default=str(ROOT / "data/scripts/monsters/monsters/canary"))
    parser.add_argument("--report", default=None)
    parser.add_argument("--only", action="append", help="monster name to port (default: every missing one)")
    args = parser.parse_args()

    canary = Path(args.canary).expanduser()
    source = canary / "data-otservbr-global/monster"
    out = Path(args.out)
    items = Items(canary)

    known = set()
    for path in (ROOT / "data/scripts/monsters").rglob("*.lua"):
        if out in path.parents:
            continue
        known.update(name.lower() for name in re.findall(r'createMonsterType\("([^"]+)"', path.read_text(errors="replace")))
    known_spells = set()
    for path in (ROOT / "data/scripts/spells").rglob("*.lua"):
        known_spells.update(name.lower() for name in re.findall(r'spell:name\("([^"]+)"\)', path.read_text(errors="replace")))

    report = {}
    written = 0
    wanted = {name.lower() for name in args.only} if args.only else None
    for path in sorted(source.rglob("*.lua")):
        match = re.search(r'createMonsterType\("([^"]+)"', path.read_text(errors="replace"))
        if not match or match.group(1).lower() in known:
            continue
        if wanted is not None and match.group(1).lower() not in wanted:
            continue
        monster = Monster(path, items, report)
        target = out / path.relative_to(source)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(monster.convert(known_spells))
        known.add(monster.name.lower())
        written += 1

    lines = [f"# Canary monster port: {written} monsters written to {out}", ""]
    for section, entries in sorted(report.items()):
        lines.append(f"## {section} ({len(entries)})")
        lines.extend(f"- {entry}" for entry in entries)
        lines.append("")
    if args.report:
        Path(args.report).write_text("\n".join(lines))
    print(lines[0])
    for section, entries in sorted(report.items()):
        print(f"  {section}: {len(entries)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
