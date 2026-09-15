#!/usr/bin/env python3
"""Port Canary's monster spells into BlackTek's combat registry and spell files.

The monsters brought over by harness/build_canary_monsters.py cast spells by
name. Canary writes those spells (data-otservbr-global/scripts/spells/monster)
by building a Combat in the spell file and setting it up parameter by
parameter; BlackTek declares a spell's combat in data/scripts/lib/combats and
the spell file only references it:

    local combat = Combat(MonsterCombats.BlightwalkerCurse)

So each ported spell becomes an entry in MonsterCombats plus a spell file in
BlackTek's own shape. The combat's base properties move to the registry:

    COMBAT_PARAM_TYPE           -> damageType = Combat.DamageType.X
    COMBAT_PARAM_EFFECT         -> impactEffect
    COMBAT_PARAM_DISTANCEEFFECT -> distanceEffect
    COMBAT_PARAM_BLOCKARMOR     -> blockedByArmor
    COMBAT_PARAM_BLOCKSHIELD    -> blockedByShield
    COMBAT_PARAM_AGGRESSIVE     -> aggressive
    COMBAT_PARAM_USECHARGES     -> useCharges
    COMBAT_PARAM_CREATEITEM     -> createdItem
    COMBAT_PARAM_TARGETCASTERORTOPMOST -> topTargetOnly
    COMBAT_PARAM_IGNORERESISTANCES     -> trueDamage

An inline area table becomes a local `createCombatArea` above the registry,
as the hand-written entries there already do. Conditions stay in the spell
file on the combat, the way hirintror_skill_reducer does it, and a spell that
builds a combat per value (combat[i] in a loop) stays self-contained with its
parameters rewritten to BlackTek's setters. Spells BlackTek already registers
by name are skipped, as are spells needing engine features it does not have
(chain combat, rooted and feared conditions, damage callbacks).

Usage:
  python3 harness/build_canary_monster_spells.py --canary ~/Documents/canary \\
      [--out data/scripts/spells/monster/canary] [--report report.md]
"""

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

DAMAGE_TYPES = {
    "COMBAT_PHYSICALDAMAGE": "Physical", "COMBAT_ENERGYDAMAGE": "Energy", "COMBAT_EARTHDAMAGE": "Earth",
    "COMBAT_FIREDAMAGE": "Fire", "COMBAT_UNDEFINEDDAMAGE": "Undefined", "COMBAT_LIFEDRAIN": "LifeDrain",
    "COMBAT_MANADRAIN": "ManaDrain", "COMBAT_HEALING": "Healing", "COMBAT_DROWNDAMAGE": "Water",
    "COMBAT_ICEDAMAGE": "Ice", "COMBAT_HOLYDAMAGE": "Holy", "COMBAT_DEATHDAMAGE": "Death",
}
# Canary combat parameter -> (registry field, setter for a self-contained combat)
PARAMETERS = {
    "COMBAT_PARAM_TYPE": ("damageType", "setDamageType"),
    "COMBAT_PARAM_EFFECT": ("impactEffect", "setImpactEffect"),
    "COMBAT_PARAM_DISTANCEEFFECT": ("distanceEffect", "setDistanceEffect"),
    "COMBAT_PARAM_CREATEITEM": ("createdItem", "setCreatedItem"),
    "COMBAT_PARAM_BLOCKARMOR": ("blockedByArmor", None),
    "COMBAT_PARAM_BLOCKSHIELD": ("blockedByShield", None),
    "COMBAT_PARAM_AGGRESSIVE": ("aggressive", None),
    "COMBAT_PARAM_USECHARGES": ("useCharges", None),
    "COMBAT_PARAM_TARGETCASTERORTOPMOST": ("topTargetOnly", None),
    "COMBAT_PARAM_IGNORERESISTANCES": ("trueDamage", None),
}
# features BlackTek has no equivalent for; a spell using one is left for later
BLOCKERS = {
    "a damage callback": r"\bsetCallback\(",
    "chain combat": r"CHAIN",
    "CONDITION_ROOTED": r"\bCONDITION_ROOTED\b",
    "CONDITION_FEARED": r"\bCONDITION_FEARED\b",
    "a Canary-only call": r"\b(setMoveLocked|getNextPosition|Zone\.getByName)\b|\bKV\.",
    "a constant Canary spells it wrong": r"COMBAT_LIFEDRAINDAMAGE|COMBAT_PHYSICALDAMAGEDAMAGE|CONST_ME_CONST_ME_HOLYAREA",
}
REGISTRY = ROOT / "data/scripts/lib/combats/monster_combats.lua"


def entry_name(spell_name):
    return "".join(word.capitalize() for word in re.split(r"[^A-Za-z0-9]+", spell_name) if word)


def tidy_row(row):
    """{ 0, 1, 0 } -> {0, 1, 0}, the spacing the registry already uses."""
    return row.strip().rstrip(",").replace("{ ", "{").replace(" }", "}")


def local_area_name(name):
    return "_" + name[0].lower() + name[1:] + "Area"


def spell_name_of(text):
    match = re.search(r'spell:name\("([^"]+)"\)', text)
    return match.group(1) if match else None


def free_words(text, taken):
    """Keep Canary's ### token when BlackTek has not used it, else take the next free one."""
    match = re.search(r'spell:words\("###(\d+)"\)', text)
    wanted = int(match.group(1)) if match else None
    if wanted is not None and wanted not in taken:
        taken.add(wanted)
        return text, wanted
    number = max(taken) + 1
    taken.add(number)
    if match:
        text = text.replace(match.group(0), f'spell:words("###{number}")', 1)
    return text, number


class Spell:
    def __init__(self, path, library_areas=frozenset(), taken_entries=None):
        self.path = path
        self.library_areas = library_areas
        self.taken_entries = taken_entries if taken_entries is not None else set()
        self.text = path.read_text(errors="replace")
        self.name = spell_name_of(self.text)
        self.entry = self.free_entry(entry_name(self.name or path.stem))
        self.properties = {}
        self.area = None
        self.notes = []

    def free_entry(self, name):
        """Two spell names can fold to one entry ("lloyd wave 2" and "lloyd wave2")."""
        candidate, letter = name, ord("B")
        while candidate in self.taken_entries:
            candidate = f"{name}{chr(letter)}"
            letter += 1
        self.taken_entries.add(candidate)
        return candidate

    @property
    def dynamic(self):
        """Anything but a single plain `local combat = Combat()` keeps its combats in the file."""
        return self.text.count("local combat = Combat()") != 1 or self.text.count("Combat()") != 1

    def read_parameters(self):
        """Pull the combat's base properties out of the spell body."""
        for parameter, value in re.findall(r"combat:setParameter\((COMBAT_PARAM_\w+),\s*(.+?)\)\s*$", self.text, re.M):
            field = PARAMETERS.get(parameter)
            if not field:
                self.notes.append(f"dropped {parameter}")
                continue
            value = value.strip()
            if parameter == "COMBAT_PARAM_TYPE":
                if value not in DAMAGE_TYPES:
                    self.notes.append(f"unknown damage type {value}")
                    continue
                value = f"Combat.DamageType.{DAMAGE_TYPES[value]}"
            elif field[0] in ("blockedByArmor", "blockedByShield", "aggressive", "useCharges", "topTargetOnly", "trueDamage"):
                value = "true" if value not in ("false", "0") else "false"
            self.properties[field[0]] = value

        named = (re.search(r"combat:setArea\(createCombatArea\((AREA_\w+)\)\)", self.text)
                 or re.search(r"^\s*(?:local\s+)?\w+\s*=\s*createCombatArea\((AREA_\w+)\)\s*$", self.text, re.M))
        # a shape the spell declares itself is carried into the registry: the registry
        # loads before any spell file, and two spells can spell the same name differently
        own = None
        if named and named.group(1) not in self.library_areas:
            own = re.search(r"^" + named.group(1) + r" = \{\s*\n(\s*\{.*?\n)\}\s*$", self.text, re.M | re.S)
        inline = own or re.search(r"^(?:local\s+)?(?:\w+)\s*=\s*\{\s*\n(\s*\{.*?\n)\}\s*$", self.text, re.M | re.S)
        if named and named.group(1) in self.library_areas:
            self.area = f"createCombatArea({named.group(1)})"
        elif (own or re.search(r"combat:setArea\(|createCombatArea\(", self.text)) and inline:
            rows = [tidy_row(row) for row in inline.group(inline.re.groups) if False] or [tidy_row(row) for row in inline.group(inline.re.groups).splitlines() if row.strip()]
            self.area = "TABLE:" + "\n".join(rows)

    def registry_entry(self):
        lines = [f"    {self.entry} = {{"]
        fields = list(self.properties.items())
        if self.area:
            fields.append(("area", local_area_name(self.entry) if self.area.startswith("TABLE:") else self.area))
        width = max((len(key) for key, _ in fields), default=0)
        for key, value in fields:
            lines.append(f"        {key.ljust(width)} = {value},")
        lines.append("    },")
        return "\n".join(lines)

    def spell_file(self):
        """The spell body, with the combat's properties now coming from the registry."""
        text = self.text
        text = re.sub(r"^\s*combat:setParameter\(COMBAT_PARAM_\w+,.*\)\s*\n", "", text, flags=re.M)
        text = re.sub(r"^\s*(?:local\s+)?area\s*=\s*createCombatArea\(.*\)\s*\n", "", text, flags=re.M)
        text = re.sub(r"^\s*combat:setArea\(.*\)\s*\n", "", text, flags=re.M)
        if self.area and self.area.startswith("TABLE:"):
            text = re.sub(r"^(?:local\s+)?\w+\s*=\s*\{\s*\n\s*\{.*?\n\}\s*\n", "", text, flags=re.M | re.S, count=1)
            text = re.sub(r"^\s*(?:local\s+)?\w+\s*=\s*createCombatArea\(AREA_\w+\)\s*\n", "", text, flags=re.M)
        if self.properties or self.area:
            text = text.replace("local combat = Combat()", f"local combat = Combat(MonsterCombats.{self.entry})", 1)
        return self.finish(text)

    def self_contained(self):
        """A spell building one combat per value keeps them, with BlackTek's setters."""
        def setter(match):
            target, parameter, value = match.group(1), match.group(2), match.group(3).strip()
            field = PARAMETERS.get(parameter)
            if not field or not field[1]:
                self.notes.append(f"dropped {parameter}")
                return ""
            if parameter == "COMBAT_PARAM_TYPE":
                value = f"Combat.DamageType.{DAMAGE_TYPES.get(value, 'Undefined')}"
            return f"{target}:{field[1]}({value})"

        text = re.sub(r"(\w+(?:\[\w+\])?):setParameter\((COMBAT_PARAM_\w+),\s*(.+?)\)", setter, self.text)
        text = re.sub(r"(\w+(?:\[\w+\])?):setFormula\(COMBAT_FORMULA_\w+,\s*", r"\1:setMinMaxFormula(", text)
        text = re.sub(r"^\s*\n(?=\s*local condition)", "\n", text, flags=re.M)
        return self.finish(text)

    def finish(self, text):
        text = text.replace('Spell("instant")', "Spell(SPELL_INSTANT)")
        text = re.sub(r"\bvar\b", "variant", text)
        text = re.sub(r"^(\s*)arr = \{", r"\1local arr = {", text, flags=re.M)
        text = re.sub(r"^(local combat = .*\n)(?!\n)", r"\1\n", text, flags=re.M)
        text = re.sub(r"\n(local spell = Spell)", r"\n\n\1", text)
        text = re.sub(r"\n{3,}", "\n\n", text)
        return text.rstrip() + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--canary", required=True)
    parser.add_argument("--out", default=str(ROOT / "data/scripts/spells/monster/canary"))
    parser.add_argument("--registry", default=str(REGISTRY), help="monster_combats.lua to extend")
    parser.add_argument("--report", default=None)
    args = parser.parse_args()
    registry_path = Path(args.registry)

    source = Path(args.canary).expanduser() / "data-otservbr-global/scripts/spells/monster"
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)

    library_areas = set(re.findall(r"^(AREA_\w+) = \{", (ROOT / "data/scripts/lib/spell_lib.lua").read_text(), re.M))
    taken_entries = set(re.findall(r"^\s{4}(\w+) = \{", Path(args.registry).read_text(), re.M))
    known_spells, taken_words = set(), set()
    for path in (ROOT / "data/scripts/spells").rglob("*.lua"):
        if out in path.parents:
            continue
        text = path.read_text(errors="replace")
        known_spells.update(name.lower() for name in re.findall(r'spell:name\("([^"]+)"\)', text))
        taken_words.update(int(number) for number in re.findall(r'spell:words\("###(\d+)"\)', text))

    # only the spells the ported monsters actually cast
    wanted = set()
    for path in (ROOT / "data/scripts/monsters/monsters/canary").rglob("*.lua"):
        wanted.update(name.lower() for name in re.findall(r'name = "([^"]+)"', path.read_text(errors="replace")))

    written, skipped, entries, areas, report = [], {}, [], [], []
    for path in sorted(source.rglob("*.lua")):
        spell = Spell(path, library_areas, taken_entries)
        if not spell.name or spell.name.lower() in known_spells or spell.name.lower() not in wanted:
            continue
        blocked = [reason for reason, pattern in BLOCKERS.items() if re.search(pattern, spell.text)]
        if blocked:
            skipped[spell.name] = blocked
            continue

        spell.read_parameters()
        spell.text, number = free_words(spell.text, taken_words)
        text = spell.self_contained() if spell.dynamic else spell.spell_file()
        if not spell.dynamic and (spell.properties or spell.area):
            if spell.area and spell.area.startswith("TABLE:"):
                rows = spell.area[len("TABLE:"):].splitlines()
                areas.append(f"local {local_area_name(spell.entry)} = createCombatArea({{\n" + ",\n".join(f"    {row}" for row in rows) + "\n})")
            entries.append(spell.registry_entry())
        (out / path.name).write_text(text)
        written.append(spell.name)
        if spell.notes:
            report.append(f"- {spell.name}: {', '.join(spell.notes)}")

    if entries:
        registry = registry_path.read_text()
        marker = "\nMonsterCombats = {"
        head, _, tail = registry.partition(marker)
        head += "\n-- ported from Canary by harness/build_canary_monster_spells.py\n" + "\n\n".join(areas) + "\n" if areas else "\n"
        body = tail.rstrip()
        assert body.endswith("}")
        body = body[:-1].rstrip() + "\n\n    -- ported from Canary by harness/build_canary_monster_spells.py\n" + "\n\n".join(entries) + "\n}\n"
        registry_path.write_text(head + marker + body)

    lines = [f"# Canary monster spell port: {len(written)} spells written to {out}", ""]
    if report:
        lines += ["## Parameters with no BlackTek equivalent", *report, ""]
    if skipped:
        lines += [f"## Left for later, needing engine work ({len(skipped)})"]
        lines += [f"- {name}: {', '.join(reasons)}" for name, reasons in sorted(skipped.items())]
    if args.report:
        Path(args.report).write_text("\n".join(lines))
    print(lines[0])
    print(f"  registry entries: {len(entries)}, self-contained: {len(written) - len(entries)}, left for later: {len(skipped)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
