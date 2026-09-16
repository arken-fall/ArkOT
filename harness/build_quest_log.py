#!/usr/bin/env python3
"""Generate data/quests/<quest>.toml quest log entries from Canary's catalog.

Canary (opentibiabr/canary, data-otservbr-global) describes its quest log in
lib/core/quests/catalog/NNN_<quest>.lua against its own storage table, which
it renumbered and nested under Storage.Quest.U<version>. ArkOT's real-map
pack scripts and NPCs still use the older flat table in
data/lib/realmap/051-storages.lua, so every mission storage is resolved to the
pack's number by name. A mission whose storage the pack does not have is left
out and listed in the report: nothing in ArkOT would ever set it yet.

The report also lists, per mission, the values ArkOT's own scripts write to
that storage which no Canary state describes; those are the steps where the
pack's script and Canary's disagree and need a look before trusting the log.

The pack predates Canary's restructuring, and otservbr-global's 2019 quest
log (data/lib/core/quests.lua, e.g. commit eb7b07d7bb) still names the pack's
storages. Given with --legacy-log, a quest is taken from whichever of the two
logs resolves more of its missions against the pack; Canary decides which
quests exist.

Usage:
  python3 harness/build_quest_log.py --canary ~/Documents/canary \\
      [--legacy-log otservbr-quests.lua] [--quest 016_the_ancient_tombs ...] \\
      [--out data/quests] [--report quest_log_report.md]
"""

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# pack storage tables whose names differ from Canary's (Canary name -> pack name)
ROOT_ALIASES = {
    "TheQueenOfTheBanshees": "QueenOfBansheesQuest",
    "BigfootsBurden": "BigfootBurden",
    "AFathersBurden": "FathersBurdenQuest",
    "HotCuisineQuest": "HotCuisineQuest",
    "SeaOfLight": "SeaOfLightQuest",
    "SecretService": "secretService",
    "TheHiddenCityOfBeregar": "hiddenCityOfBeregar",
    "TheInquisition": "TheInquisition",
    "ThePostmanMissions": "postman",
    "TheThievesGuild": "thievesGuild",
    "TheTravellingTrader": "TravellingTrader",
    "TheWhiteRavenMonastery": "WhiteRavenMonasteryQuest",
    "TheDjinnWar": "DjinnWar",
}


class Ref:
    """A dotted name the parser could not evaluate, e.g. Storage.Quest.U7_4.X.Y."""

    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return f"Ref({self.name})"


class Raw:
    """Source text kept verbatim (functions, arithmetic)."""

    def __init__(self, text):
        self.text = text


TOKEN = re.compile(r"""
    (?P<space>\s+)
  | (?P<longcomment>--\[(?P<eq1>=*)\[.*?\](?P=eq1)\])
  | (?P<comment>--[^\n]*)
  | (?P<longstring>\[(?P<eq2>=*)\[.*?\](?P=eq2)\])
  | (?P<string>"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*')
  | (?P<number>0[xX][0-9a-fA-F]+|\d+(?:\.\d+)?(?:[eE][-+]?\d+)?)
  | (?P<name>[A-Za-z_][A-Za-z0-9_]*)
  | (?P<op>\.\.\.|\.\.|==|~=|<=|>=|[{}\[\]=,;.()+\-*/%#<>:^])
""", re.S | re.X)


def tokenize(text):
    tokens = []
    position = 0
    while position < len(text):
        match = TOKEN.match(text, position)
        if not match:
            raise ValueError(f"cannot tokenize at {text[position:position + 40]!r}")
        kind = match.lastgroup
        if kind in ("eq1", "eq2"):
            kind = "longcomment" if match.group("longcomment") else "longstring"
        if kind not in ("space", "comment", "longcomment"):
            tokens.append((kind, match.group(0), match.start()))
        position = match.end()
    return tokens


def unquote(literal):
    body = literal[1:-1]
    body = re.sub(r"\\z\s*", "", body)
    escapes = {"n": "\n", "t": "\t", '"': '"', "'": "'", "\\": "\\"}
    return re.sub(r"\\(.)", lambda m: escapes.get(m.group(1), m.group(1)), body)


class Parser:
    """Just enough Lua to read data tables: literals, dotted names, `..`, functions."""

    BLOCK_OPEN = {"function", "if", "do", "while", "for"}

    def __init__(self, text):
        self.text = text
        self.tokens = tokenize(text)
        self.index = 0

    def peek(self, offset=0):
        at = self.index + offset
        return self.tokens[at] if at < len(self.tokens) else (None, None, len(self.text))

    def take(self, expected=None):
        token = self.peek()
        if expected is not None and token[1] != expected:
            raise ValueError(f"expected {expected!r}, got {token[1]!r} at {self.text[token[2]:token[2] + 60]!r}")
        self.index += 1
        return token

    def find_assignment(self, name):
        for at, token in enumerate(self.tokens):
            if token[1] == name and at + 2 < len(self.tokens) and self.tokens[at + 1][1] == "=" and self.tokens[at + 2][1] == "{":
                self.index = at + 2
                return self.table()
        raise ValueError(f"no table assigned to {name}")

    def function(self):
        start = self.peek()[2]
        depth = 0
        while True:
            kind, value, _ = self.take()
            if kind == "name" and value in self.BLOCK_OPEN:
                # `for`/`while` carry their own `do`; count the block once
                if value in ("for", "while"):
                    self.skip_to_do()
                depth += 1
            elif kind == "name" and value == "repeat":
                depth += 1
            elif kind == "name" and value in ("end", "until"):
                depth -= 1
                if depth == 0:
                    return Raw(self.text[start:self.tokens[self.index - 1][2] + len(value)])

    def skip_to_do(self):
        while self.peek()[1] != "do":
            self.take()
        self.take("do")

    def value(self):
        kind, token, _ = self.peek()
        if token == "{":
            result = self.table()
        elif token == "function":
            return self.function()
        elif kind in ("string", "longstring"):
            self.take()
            result = unquote(token) if kind == "string" else re.sub(r"^\[=*\[\n?|\]=*\]$", "", token)
        elif kind == "number":
            self.take()
            result = int(token, 0) if re.fullmatch(r"0[xX][0-9a-fA-F]+|\d+", token) else float(token)
        elif token in ("true", "false", "nil"):
            self.take()
            result = {"true": True, "false": False, "nil": None}[token]
        elif token == "-" and self.peek(1)[0] == "number":
            self.take()
            result = -self.value()
        elif kind == "name":
            start = self.peek()[2]
            parts = [self.take()[1]]
            while ((self.peek()[1] in (".", ":") and self.peek(1)[0] == "name")
                   or (self.peek()[1] == "[" and self.peek(1)[0] == "number" and self.peek(2)[1] == "]")):
                if self.take()[1] == "[":
                    parts.append(self.take()[1])
                    self.take("]")
                else:
                    parts.append(self.take()[1])
            result = self.call(start) if self.opens_arguments() else Ref(".".join(parts))
        else:
            raise ValueError(f"unexpected {token!r}")
        return self.continuation(result)

    def opens_arguments(self):
        # Lua lets a call drop its parentheses around one string or table argument
        return self.peek()[1] in ("(", "{") or self.peek()[0] in ("string", "longstring")

    def call(self, start):
        """A call inside a data table is kept as written: `kv.scoped("quest"):scoped("soul-war")` is code, not a value."""
        end = self.arguments()
        # a call may be called again on what it returned, as far as the chain runs
        while self.peek()[1] in (".", ":") and self.peek(1)[0] == "name":
            self.take()
            self.take()
            if not self.opens_arguments():
                break
            end = self.arguments()
        return Raw(self.text[start:end])

    def arguments(self):
        """Take one call's arguments, and answer where they end."""
        opener = self.peek()[1]
        if opener not in ("(", "{"):
            _, token, at = self.take()
            return at + len(token)

        closer = ")" if opener == "(" else "}"
        depth = 0
        while True:
            _, token, at = self.take()
            if token == opener:
                depth += 1
            elif token == closer:
                depth -= 1
                if depth == 0:
                    return at + len(token)

    def continuation(self, result):
        # string concatenation and simple arithmetic keep the parse moving
        while self.peek()[1] in ("..", "+", "-", "*", "/"):
            operator = self.take()[1]
            right = self.value()
            if operator == ".." and isinstance(result, str) and isinstance(right, str):
                result = result + right
            else:
                result = Raw(f"{result} {operator} {right}")
        return result

    def table(self):
        self.take("{")
        array, fields = [], {}
        while self.peek()[1] != "}":
            if self.peek()[1] == "[":
                self.take("[")
                key = self.value()
                self.take("]")
                self.take("=")
                fields[key] = self.value()
            elif self.peek()[0] == "name" and self.peek(1)[1] == "=":
                key = self.take()[1]
                self.take("=")
                fields[key] = self.value()
            else:
                array.append(self.value())
            if self.peek()[1] in (",", ";"):
                self.take()
        self.take("}")
        for position, item in enumerate(array, 1):
            fields.setdefault(position, item)
        return fields


def flatten(table, prefix=""):
    flat = {}
    for key, value in table.items():
        path = f"{prefix}.{key}" if prefix else str(key)
        if isinstance(value, dict):
            flat.update(flatten(value, path))
        elif isinstance(value, int):
            flat[path] = value
    return flat


def load_storages(path):
    text = Path(path).read_text(errors="replace")
    return flatten(Parser(text).find_assignment("Storage"))


def canary_relative(name):
    """Storage.Quest.U7_4.TheAncientTombs.DefaultStart -> TheAncientTombs.DefaultStart"""
    name = re.sub(r"^Storage\.", "", name)
    return re.sub(r"^Quest\.U\d+_\d+\.", "", name)


def load_canary_storages(path):
    """The Canary numbering the server itself carries, one assignment per group."""
    text = Path(path).read_text(errors="replace")
    found = {}
    for assignment in re.finditer(r"^Storage\.(\w+) = ", text, flags=re.M):
        name = assignment.group(1)
        value = Parser(text[assignment.end():]).value()
        if isinstance(value, dict):
            found.update({f"{name}.{key}": number for key, number in flatten(value).items()})
        elif isinstance(value, int):
            found[name] = value
    return found


def resolve(name, canary, pack, pack_folded, ported):
    """Canary storage reference -> (storage name, number) or None.

    A quest the port brought over writes Canary's own numbers, so the log has to
    watch those same numbers or it will never see the quest start. Where the
    server kept its own numbering for a quest the 10.98 pack already had, the
    name is resolved against that table instead, as before.
    """
    own = re.sub(r"^Storage\.", "", name)
    if own in ported:
        return own, ported[own]

    relative = canary_relative(name)
    candidates = [relative]
    root, _, leaf = relative.partition(".")
    if root in ROOT_ALIASES:
        candidates.append(f"{ROOT_ALIASES[root]}.{leaf}")
    for candidate in candidates:
        if candidate in pack:
            return candidate, pack[candidate]
        folded = pack_folded.get(candidate.lower())
        if folded:
            return folded, pack[folded]
    return None


def toml_string(text):
    text = text.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
    return f'"{text}"'


WRITE = re.compile(r"setStorageValue\(\s*Storage\.([A-Za-z0-9_.]+)\s*,\s*(-?\d+)\s*\)")


def storage_writes(sources):
    """Every literal value ArkOT's own scripts write, by storage name.

    Read in one pass over the scripts rather than once per storage: the server
    now carries thousands of them, and the quest log asks about hundreds.
    """
    written = {}
    for text in sources:
        for name, value in WRITE.findall(text):
            written.setdefault(name, set()).add(int(value))
    return written


def lower_keys(table):
    """The 2019 log spells its keys in lower case (storageid, endvalue)."""
    return {key.lower() if isinstance(key, str) else key: value for key, value in table.items()}


def normalise(quest):
    quest = lower_keys(quest)
    missions = quest.get("missions", {})
    quest["missions"] = {number: lower_keys(mission) for number, mission in missions.items() if isinstance(mission, dict)}
    return quest


def resolved_missions(quest, canary, pack, pack_folded, ported):
    return sum(1 for mission in quest["missions"].values()
               if isinstance(mission.get("storageid"), Ref) and resolve(mission["storageid"].name, canary, pack, pack_folded, ported))


def title_key(name):
    return re.sub(r"[^a-z0-9]", "", name.lower())


def build_quest(quest, source, canary, pack, pack_folded, ported, written):
    report = {"file": source, "name": quest.get("name"), "kept": [], "dropped": [], "disagree": [], "dynamic": []}

    start = quest.get("startstorageid")
    start_resolved = resolve(start.name, canary, pack, pack_folded, ported) if isinstance(start, Ref) else None
    if not start_resolved:
        report["dropped"].append(f"start storage {getattr(start, 'name', start)}")
        return None, report

    key = re.sub(r"[^A-Za-z0-9]", "", quest["name"].title())
    lines = [f"[{key}]", f"name = {toml_string(quest['name'])}",
             f"startstorage = {start_resolved[1]} # {start_resolved[0]}",
             f"startvalue = {int(quest.get('startstoragevalue', 1))}", "missions = ["]

    missions = quest.get("missions", {})
    described_by_storage, open_ended = {}, set()
    for number in sorted(k for k in missions if isinstance(k, int)):
        mission = missions[number]
        storage = mission.get("storageid")
        resolved = resolve(storage.name, canary, pack, pack_folded, ported) if isinstance(storage, Ref) else None
        if not resolved:
            report["dropped"].append(f"{mission.get('name')} ({getattr(storage, 'name', storage)})")
            continue

        start_value = int(mission.get("startvalue", 0))
        end_value = int(mission.get("endvalue", start_value))
        ignore_end = bool(mission.get("ignoreendvalue", False))
        fields = [f"name = {toml_string(mission['name'])}", f"storage = {resolved[1]}",
                  f"start = {start_value}", "end = " + str(end_value), f"ignoreend = {'true' if ignore_end else 'false'}"]

        description = mission.get("description")
        states = mission.get("states")
        if isinstance(description, str):
            fields.append(f"description = {toml_string(description)}")
        elif isinstance(states, dict) and states:
            entries = [f"{{id = {state}, description = {toml_string(text)}}}"
                       for state, text in sorted(states.items()) if isinstance(state, int) and isinstance(text, str)]
            fields.append("states = [ " + ", ".join(entries) + " ]")
        else:
            # computed descriptions (kill counters and the like) fall back to the storage value
            fields.append(f"description = {toml_string(mission['name'] + ': |STATE|')}")
            report["dynamic"].append(mission["name"])

        lines.append(f"    {{{', '.join(fields)}}}, # {resolved[0]}")
        report["kept"].append(mission["name"])

        # questlines share one storage across missions, so the spans are pooled per
        # storage - kept as spans, since a counter mission's end runs to 999999
        described_by_storage.setdefault(resolved[0], []).append((start_value, end_value))
        if ignore_end:
            open_ended.add(resolved[0])

    for storage, spans in described_by_storage.items():
        lowest = min(start for start, _ in spans)
        highest = max(end for _, end in spans)
        ceiling = highest if storage in open_ended else None
        unknown = sorted(value for value in written.get(storage, ())
                         if value > 0 and not any(start <= value <= end for start, end in spans)
                         and not (ceiling is not None and value > ceiling))
        if unknown:
            report["disagree"].append(f"{storage}: ArkOT writes {unknown}, the log covers {lowest}..{highest}")

    if not report["kept"]:
        return None, report

    lines.append("]")
    return "\n".join(lines) + "\n", report


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--canary", required=True)
    parser.add_argument("--legacy-log", default=None, help="otservbr-global 2019 data/lib/core/quests.lua")
    parser.add_argument("--quest", action="append", help="catalog stem, e.g. 016_the_ancient_tombs (default: all)")
    parser.add_argument("--pack-storages", default=str(ROOT / "data/lib/realmap/051-storages.lua"))
    parser.add_argument("--canary-storages", default=str(ROOT / "data/lib/canary/storages.lua"))
    parser.add_argument("--out", default=str(ROOT / "data/quests"))
    parser.add_argument("--report", default=None)
    args = parser.parse_args()

    datapack = Path(args.canary).expanduser() / "data-otservbr-global"
    canary = load_storages(datapack / "lib/core/storages.lua")
    pack = load_storages(args.pack_storages)
    pack_folded = {name.lower(): name for name in pack}
    ported = load_canary_storages(args.canary_storages)

    sources = []
    for folder in ("data/scripts", "data/npc", "data/lib", "data/actions", "data/movements", "data/creaturescripts"):
        for path in (ROOT / folder).rglob("*.lua"):
            sources.append(path.read_text(errors="replace"))
    written = storage_writes(sources)

    catalog = sorted((datapack / "lib/core/quests/catalog").glob("[0-9][0-9][0-9]_*.lua"))
    if args.quest:
        catalog = [path for path in catalog if path.stem in args.quest]

    legacy = {}
    if args.legacy_log:
        table = Parser(Path(args.legacy_log).read_text(errors="replace")).find_assignment("Quests")
        for number in sorted(key for key in table if isinstance(key, int)):
            quest = normalise(table[number])
            legacy[title_key(quest["name"])] = quest

    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    reports = []
    for path in catalog:
        quest = normalise(Parser(path.read_text(errors="replace")).find_assignment("quest"))
        source = f"Canary {path.name}"
        older = legacy.get(title_key(quest["name"]))
        if older and resolved_missions(older, canary, pack, pack_folded, ported) > resolved_missions(quest, canary, pack, pack_folded, ported):
            quest, source = older, "otservbr-global 2019 quests.lua"
        toml, report = build_quest(quest, source, canary, pack, pack_folded, ported, written)
        reports.append(report)
        if toml:
            (out / f"{path.stem[4:]}.toml").write_text(f"# generated by harness/build_quest_log.py from {source}\n" + toml)

    lines = ["# Quest log generation report", ""]
    for report in reports:
        state = "written" if report["kept"] else "skipped"
        lines.append(f"## {report['name']} ({report['file']}): {state}, {len(report['kept'])} missions")
        for title, entries in (("Left out (storage not in the pack)", report["dropped"]),
                               ("Values ArkOT writes that Canary does not describe", report["disagree"]),
                               ("Computed descriptions shown as |STATE|", report["dynamic"])):
            if entries:
                lines.append(f"- {title}:")
                lines.extend(f"  - {entry}" for entry in entries)
        lines.append("")
    text = "\n".join(lines)
    if args.report:
        Path(args.report).write_text(text)
    print(f"{sum(1 for r in reports if r['kept'])} of {len(reports)} quests written to {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
