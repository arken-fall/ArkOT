#!/usr/bin/env python3
"""Port the quest scripts Canary's map expects.

A quest on this map is mostly furniture: the lever that opens the demon helmet
room, the tile that drops the wall behind it, the chest that pays out once.
Canary writes each as a revscript of its own - an Action for a lever, a
MoveEvent for a tile - and registers it against the unique id, action id or
position the map gives that piece. The map is Canary's now, so those ids are
the ones under the player's feet, and the 10.98 pack's own quest scripts point
at furniture that is no longer there.

BlackTek folds actions and movements into one ItemEvent, hooked by name, so a
script carries over by renaming its type and its handler; the body, which is
the quest itself, is left as Canary wrote it:

    Action()                 -> ItemEvent() typed "use"
    MoveEvent():type("stepin")  -> ItemEvent():type("stepon")
    event.onStepIn / onStepOut  -> event.onStepOn / onStepOff

What does not carry over is Canary's own boss lever, its key value store and
the zones it builds in Lua: a script calling into those is left for a hand port
and listed in the report, whole, rather than written out half working.

Usage:
  python3 harness/build_canary_quests.py --canary ~/Documents/canary \\
      [--out data/scripts/quests] [--report report.md]
"""

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_quest_log import Parser  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent

# Lua's own string, table and math methods: BlackTek does not register them, it inherits them
STDLIB = {"lower", "upper", "format", "gsub", "find", "sub", "rep", "len", "byte", "char", "match", "gmatch",
          "split", "splitTrimmed", "insert", "remove", "concat", "sort", "trim", "titleCase", "reverse", "unpack"}
HANDLERS = {"onStepIn": "onStepOn", "onStepOut": "onStepOff"}
HOOKS = {"stepin": "stepon", "stepout": "stepoff"}


def known_methods():
    """Every method a script may call: what the engine registers, plus what BlackTek's own Lua defines."""
    methods = set(re.findall(r'registerMethod\("[A-Za-z]+",\s*"(\w+)"',
                             (ROOT / "src/luascript.cpp").read_text(errors="replace")))
    for path in (ROOT / "data").rglob("*.lua"):
        text = path.read_text(errors="replace")
        methods.update(re.findall(r"function \w+[:.](\w+)\(", text))
        methods.update(re.findall(r"^\s*(\w+)\s*=\s*function", text, re.M))
    return methods | STDLIB


def canary_only(canary):
    """The names Canary's own libs give a script, and BlackTek has nothing behind.

    A quest script is written against its server's libs as much as its engine:
    BossLever builds a boss room's lever, SoulWarQuest holds that quest's own
    numbers. Where BlackTek defines the same name the script is at home; where
    only Canary does, the script has nothing to call and waits for a hand port.
    """
    ours = set()
    for path in (ROOT / "data").rglob("*.lua"):
        text = path.read_text(errors="replace")
        ours.update(re.findall(r"^(\w+)\s*=", text, re.M))
        ours.update(re.findall(r"^function (\w+)[.:(]", text, re.M))

    # its libs, and the handful of files at its data root that name its constants
    sources = [path for folder in ("data-otservbr-global/lib", "data/libs", "data-otservbr-global/scripts/lib")
               for path in (canary / folder).rglob("*.lua")]
    sources += sorted((canary / "data").glob("*.lua"))

    theirs = set()
    for path in sources:
        text = path.read_text(errors="replace")
        theirs.update(re.findall(r"^(\w+)\s*=", text, re.M))
        theirs.update(re.findall(r"^function (\w+)[.:(]", text, re.M))
    # a lib may extend one of Lua's own tables; that table is there either way
    return theirs - ours - {"string", "table", "math", "os", "io"}


def converted(text):
    """Canary's revscript in BlackTek's item event shape."""
    # an Action is a use hook here, and says so on its own line the way BlackTek's scripts do
    text = re.sub(r"^(\s*)((?:local )?(\w+)) = Action\(\)\s*$", r'\1\2 = ItemEvent()\n\1\3:type("use")',
                  text, flags=re.M)
    text = re.sub(r"\bMoveEvent\(\)", "ItemEvent()", text)
    text = re.sub(r':type\("(\w+)"\)', lambda hook: f':type("{HOOKS.get(hook.group(1), hook.group(1))}")', text)
    for canary, blacktek in HANDLERS.items():
        text = re.sub(rf"\.{canary}\b", f".{blacktek}", text)
    return text


def accepted_hooks():
    """The handlers BlackTek's compat layer accepts on each kind of event object."""
    text = (ROOT / "data/lib/compat/compat.lua").read_text(errors="replace")
    hooks = {}
    for body, name in re.findall(r"local function \w+NewIndex\(self, key, value\)(.*?)rawgetmetatable\(\"(\w+)\"\)",
                                 text, flags=re.S):
        hooks[name] = set(re.findall(r'key == "(\w+)"', body))
    return hooks


def table_functions():
    """The functions on the plain tables the engine hands Lua, e.g. configManager.getNumber."""
    engine = (ROOT / "src/luascript.cpp").read_text(errors="replace")
    tables = {}
    for name, body in re.findall(r"const luaL_Reg LuaScriptInterface::lua(\w+)Table\[\] = \{(.*?)\};", engine, re.S):
        table = name[0].lower() + name[1:]
        tables[table] = set(re.findall(r'\{"(\w+)"', body))
    return tables


def storage_names():
    """Every Storage.<name> path the server defines, flattened the way a script writes it."""
    def walk(table, prefix):
        for key, value in table.items():
            path = f"{prefix}.{key}"
            yield path
            if isinstance(value, dict):
                yield from walk(value, path)

    found = set()
    text = (ROOT / "data/lib/realmap/051-storages.lua").read_text(errors="replace")
    for table in ("Storage", "GlobalStorage"):
        found.update(walk(Parser(text).find_assignment(table), table))

    # the Canary side writes one assignment per group rather than one table
    text = (ROOT / "data/lib/canary/storages.lua").read_text(errors="replace")
    for assignment in re.finditer(r"^Storage\.(\w+) = ", text, flags=re.M):
        name = assignment.group(1)
        found.add(f"Storage.{name}")
        group = Parser(text[assignment.end():])
        value = group.value()
        if isinstance(value, dict):
            found.update(walk(value, f"Storage.{name}"))
    return found


def code_only(text):
    """The script with its comments and string literals blanked, so only code is read."""
    text = re.sub(r"--\[(=*)\[.*?\]\1\]", " ", text, flags=re.S)
    text = re.sub(r"--[^\n]*", " ", text)
    return re.sub(r'"[^"\n]*"|\'[^\'\n]*\'', '""', text)


def unported(text, methods, elsewhere, hooks, storages, tables):
    """What a converted script still reaches for that nothing here defines."""
    code = code_only(text)
    missing = {f":{name}()" for name in re.findall(r"[a-zA-Z_)\]\"]\s*:(\w+)\(", code) if name not in methods}
    missing |= {name for name in re.findall(r"(?<![\w.:])([A-Za-z_]\w*)\s*[.:(\[]", code) if name in elsewhere}

    # BlackTek's combat is built from setters, so a Combat raised Canary's way belongs to the spell port
    if "Combat()" in code and ":setParameter(" in code:
        missing.add("a Combat built with setParameter")

    # an event object only answers to the handlers the compat layer names
    for name, kind in re.findall(r"(?:local )?(\w+) = (\w+Event)\(", code):
        known = hooks.get(kind)
        if known:
            written = set(re.findall(rf"(?:function {name}\.|{name}\.(?=\w+ =))(on\w+)", code))
            missing |= {f"{kind}.{hook}" for hook in written - known}

    missing |= {path for path in re.findall(r"\b(?:Global)?Storage(?:\.\w+)+", code) if path not in storages}

    # a table the engine hands Lua only carries the functions it was given
    for table, function in re.findall(r"\b(\w+)\.(\w+)\(", code):
        if table in tables and function not in tables[table]:
            missing.add(f"{table}.{function}()")
    return sorted(missing)


def registrations(text):
    """What a script registers itself against, so a clash with another script can be seen."""
    found = set()
    for call, arguments in re.findall(r":(uid|aid|id)\(([^)]*)\)", text):
        found.update(f"{call} {number}" for number in re.findall(r"\b\d+\b", arguments))
    for x, y, z in re.findall(r"position\(\s*\{\s*x\s*=\s*(\d+),\s*y\s*=\s*(\d+),\s*z\s*=\s*(\d+)", text):
        found.add(f"position {x},{y},{z}")

    # a quest with one entry per reward registers the whole table at once, keyed by the
    # id itself: for uniqueId in pairs(rewards) do event:uid(uniqueId) end
    for key, table, call in re.findall(r"for\s+(\w+)\s*,?\s*\w*\s+in\s+pairs\((\w+)\)\s*do\s+\w+:(uid|aid|id)\(\1\)",
                                       text):
        try:
            entries = Parser(text).find_assignment(table)
        except ValueError:
            continue
        found.update(f"{call} {name}" for name in entries if isinstance(name, int))
    return found


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--canary", required=True)
    parser.add_argument("--out", default=str(ROOT / "data/scripts/quests"))
    parser.add_argument("--report", default=None)
    parser.add_argument("--disable-superseded", action="store_true",
                        help="rename the pack scripts the port covers whole to #<name>.lua")
    args = parser.parse_args()

    source = Path(args.canary).expanduser() / "data-otservbr-global/scripts/quests"
    out = Path(args.out)
    methods, elsewhere = known_methods(), canary_only(Path(args.canary).expanduser())
    hooks, storages, tables = accepted_hooks(), storage_names(), table_functions()

    written, skipped, quests = 0, {}, set()
    taken = {}
    for path in sorted(source.rglob("*.lua")):
        quest = path.relative_to(source).parts[0]
        text = converted(path.read_text(errors="replace"))
        missing = unported(text, methods, elsewhere, hooks, storages, tables)
        if missing:
            skipped.setdefault(quest, []).append(f"{path.relative_to(source)}: {', '.join(missing)}")
            continue
        target = out / path.relative_to(source)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(text)
        for entry in registrations(text):
            taken.setdefault(entry, []).append(str(path.relative_to(source)))
        written += 1
        quests.add(quest)

    # The pack's own quest scripts register against the 10.98 map's furniture. Where
    # both claim the same id the server runs both, and the port is the one written
    # for this map, so a pack script the port covers whole is disabled the way
    # BlackTek disables a script: a # in front of its name.
    clashes, superseded = [], []
    for path in sorted((ROOT / "data/scripts/realmap").rglob("*.lua")):
        if path.name.startswith("#"):       # already disabled, so it claims nothing
            continue
        own = registrations(path.read_text(errors="replace"))
        shared = own & set(taken)
        if not shared:
            continue
        if shared == own and not path.name.startswith("#"):
            superseded.append(path)
            if args.disable_superseded:
                path.rename(path.with_name("#" + path.name))
        else:
            clashes += [f"{entry}: {path.relative_to(ROOT)} and {taken[entry][0]}" for entry in shared]

    lines = [f"# Canary quest port: {written} scripts across {len(quests)} quests written to {out}", ""]
    if skipped:
        lines += [f"## Left for a hand port: {sum(len(v) for v in skipped.values())} scripts "
                  f"in {len(skipped)} quests (they call into Canary's boss lever, key value store or zones)", ""]
        for quest in sorted(skipped):
            lines.append(f"### {quest}")
            lines += [f"- {entry}" for entry in skipped[quest]]
            lines.append("")
    if superseded:
        state = "disabled" if args.disable_superseded else "still enabled, pass --disable-superseded"
        lines += [f"## Pack scripts the port covers whole ({len(superseded)}, {state})",
                  *[f"- {path.relative_to(ROOT)}" for path in superseded], ""]
    if clashes:
        lines += [f"## Registered by both the pack and the port, the pack script also covering its own ids ({len(clashes)})",
                  *[f"- {clash}" for clash in sorted(clashes)], ""]
    if args.report:
        Path(args.report).write_text("\n".join(lines))
    print(lines[0])
    print(f"  hand port: {sum(len(v) for v in skipped.values())} scripts, "
          f"pack scripts superseded: {len(superseded)}, ids left shared: {len(clashes)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
