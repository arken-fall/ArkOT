#!/usr/bin/env python3
"""Port the Canary lib functions its quest scripts call, where BlackTek can run them.

A Canary quest script leans on its server's own function library as much as on
the engine: a boss death that pays every player who damaged it calls
onDeathForDamagingPlayers, a room that must be empty before the lever works
calls roomIsOccupied. Those are plain Lua over APIs BlackTek also has, so they
carry over as written and the scripts that call them stop being unportable.

What does not carry over is anything reaching for a Canary-only engine feature -
its key value store, its boss lever, the zones it builds in Lua - so a function
is taken only when every method it calls is one BlackTek registers, and every
function it calls is itself taken. The rest are listed in the report.

Usage:
  python3 harness/build_canary_functions.py --canary ~/Documents/canary \\
      [--out data/lib/canary/functions.lua] [--report report.md]
"""

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_canary_quests import known_methods, code_only  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent

# Lua's own globals and keywords: neither is a name the server has to provide
LUA = {"math", "string", "table", "os", "io", "type", "pairs", "ipairs", "next", "tonumber", "tostring", "print",
       "error", "assert", "select", "pcall", "unpack", "rawget", "rawset", "setmetatable", "getmetatable", "self"}
KEYWORDS = {"and", "or", "not", "if", "then", "else", "elseif", "end", "for", "do", "while", "repeat", "until",
            "return", "break", "local", "function", "in", "nil", "true", "false"}


def definitions(canary):
    """Every function Canary's libs define at the top level, with the source that defines it."""
    found = {}
    folders = ("data/libs", "data-otservbr-global/lib")
    for folder in folders:
        for path in sorted((canary / folder).rglob("*.lua")):
            text = path.read_text(errors="replace")
            for match in re.finditer(r"^function ([A-Za-z_]\w*)(?:[.:](\w+))?\(.*?^end\s*$", text, flags=re.M | re.S):
                name = match.group(1)
                found.setdefault(name, []).append(match.group(0))
            for match in re.finditer(r"^([A-Za-z_]\w*) = \{\s*\}\s*$", text, flags=re.M):
                found.setdefault(match.group(1), []).insert(0, match.group(0))
    return found


def calls(body):
    """The methods and the free functions a body reaches for, less the names it binds itself."""
    code = code_only(body)
    methods = set(re.findall(r"[a-zA-Z_)\]\"]\s*:(\w+)\(", code))
    called = set(re.findall(r"(?<![\w.:])([A-Za-z_]\w*)\s*\(", code))

    own = set(re.findall(r"^function [\w.:]+\(([^)]*)\)", code, flags=re.M))
    own |= set(re.findall(r"\bfunction\s*\(([^)]*)\)", code))
    own = {name.strip() for group in own for name in group.split(",")}
    own |= {name.strip() for group in re.findall(r"\blocal\s+([\w\s,]+?)\s*=", code) for name in group.split(",")}
    own |= set(re.findall(r"\blocal function (\w+)", code))
    return methods, called - LUA - KEYWORDS - own


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--canary", required=True)
    parser.add_argument("--wanted", action="append", help="function to port (default: the ones quest scripts call)")
    parser.add_argument("--out", default=str(ROOT / "data/lib/canary/functions.lua"))
    parser.add_argument("--report", default=None)
    args = parser.parse_args()

    canary = Path(args.canary).expanduser()
    library = definitions(canary)
    methods = known_methods()
    # what this server already provides: the engine's own globals, and its Lua
    engine = (ROOT / "src/luascript.cpp").read_text(errors="replace")
    ours = set(re.findall(r'lua_register\(luaState, "(\w+)"', engine))
    ours |= set(re.findall(r'register(?:Class|Table|GlobalVariable|GlobalBoolean|GlobalMethod)\("(\w+)"', engine))
    ours |= {enum.rsplit(":", 1)[-1] for enum in re.findall(r"registerEnum\(([\w:]+)\)", engine)}
    out = Path(args.out)
    for path in (ROOT / "data").rglob("*.lua"):
        if path == out:                 # what a previous run wrote is not what the server already had
            continue
        text = path.read_text(errors="replace")
        ours.update(re.findall(r"^(\w+)\s*=", text, re.M))
        ours.update(re.findall(r"^function (\w+)[.:(]", text, re.M))

    wanted = set(args.wanted or [])
    if not wanted:
        # a quest script may call a function or just hand it to addEvent, so any
        # mention of a name the library defines counts as asking for it
        for path in (canary / "data-otservbr-global/scripts/quests").rglob("*.lua"):
            code = code_only(path.read_text(errors="replace"))
            mentioned = set(re.findall(r"(?<![\w.:])([A-Za-z_]\w*)", code))
            wanted |= {name for name in mentioned if name in library and name not in ours}

    # a function is taken only once everything it calls is taken, so the set is
    # grown until it stops changing, and what never resolves is reported
    taken, refused = {}, {}
    pending = set(wanted)
    while pending:
        settled = False
        for name in sorted(pending):
            bodies = library[name]
            missing_methods, missing_names = set(), set()
            for body in bodies:
                used_methods, used_names = calls(body)
                missing_methods |= {method for method in used_methods if method not in methods}
                missing_names |= {other for other in used_names
                                  if other != name and other not in ours and other not in taken}
            unresolvable = {other for other in missing_names if other not in library}
            if missing_methods or unresolvable:
                refused[name] = sorted(f":{method}()" for method in missing_methods) + sorted(unresolvable)
                pending.discard(name)
                settled = True
                break
            if not missing_names:
                taken[name] = bodies
                pending.discard(name)
                settled = True
                break
            pending |= {other for other in missing_names if other in library}
        if not settled:
            # what is left only waits on something else in the same cycle, so the
            # cycle is taken whole or not at all - and it is only taken if every
            # method in it resolves, which the loop above already checked
            for name in sorted(pending):
                taken[name] = library[name]
            break

    out.parent.mkdir(parents=True, exist_ok=True)
    lines = ["-- The functions Canary's quest scripts call, as Canary writes them.",
             "-- Only what runs on BlackTek's own API is here; see harness/build_canary_functions.py.",
             ""]
    for name in sorted(taken):
        lines += [body.rstrip() + "\n" for body in taken[name]]
    out.write_text("\n".join(lines))

    report = [f"# Canary function port: {len(taken)} functions written to {out}", "",
              "## Taken", *[f"- {name}" for name in sorted(taken)], ""]
    if refused:
        report += [f"## Left behind ({len(refused)})",
                   *[f"- {name}: needs {', '.join(reasons)}" for name, reasons in sorted(refused.items())], ""]
    if args.report:
        Path(args.report).write_text("\n".join(report))
    print(report[0])
    print(f"  left behind: {len(refused)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
