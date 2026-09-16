#!/usr/bin/env python3
"""Port the storage keys Canary's npcs and quests ask for by name.

A storage key is a number a player carries: a quest step, a door, a ticket.
Canary keeps its numbering in one table (data-otservbr-global/lib/core/storages.lua)
and every npc line reads a name out of it - Storage.Quest.U8_0.BarbarianTest.Questline
is quest step 8 for one player - so a ported npc has no dialog at all until the
same names exist here.

ArkOT already numbers 53 of its own quests in data/lib/realmap/051-storages.lua,
the 10.98 pack's own scheme, and those win: this writes only the names that
table does not have, so nothing already played on changes number under a player
who is mid-quest. The overlap is reported instead of merged.

Usage:
  python3 harness/build_canary_storages.py --canary ~/Documents/canary \\
      [--out data/lib/canary/storages.lua]
"""

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def table_body(text, name):
    """The lines inside `<name> = {` up to the closing brace at its own indent."""
    opening = re.search(rf"^(\t*){re.escape(name)} = \{{\s*$", text, flags=re.M)
    if not opening:
        return []
    indent = opening.group(1)
    lines = text[opening.end():].splitlines()
    closing = next((index for index, line in enumerate(lines) if line == indent + "},"
                    or line == indent + "}"), len(lines))
    return lines[:closing]


def entries(body, indent):
    """Split a table body into its own entries, each kept as written."""
    found, current, name = [], [], None
    for line in body:
        match = re.match(rf"^{indent}(\w+) = ", line)
        if match:
            if name:
                found.append((name, current))
            name, current = match.group(1), [line]
        elif name:
            current.append(line)
    if name:
        found.append((name, current))
    return found


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--canary", required=True)
    parser.add_argument("--out", default=str(ROOT / "data/lib/canary/storages.lua"))
    args = parser.parse_args()

    canary = (Path(args.canary).expanduser() / "data-otservbr-global/lib/core/storages.lua").read_text()
    ours = (ROOT / "data/lib/realmap/051-storages.lua").read_text()

    known = {name for name, _ in entries(table_body(ours, "Storage"), "\t")}
    written, skipped = [], []
    for name, lines in entries(table_body(canary, "Storage"), "\t"):
        (skipped if name in known else written).append((name, lines))

    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    text = ["-- Canary's own storage numbering, the names its npcs and quests read.",
            "-- ArkOT's table in realmap/051-storages.lua is the one that wins: a quest",
            "-- the 10.98 pack already numbers keeps that number and is not written here.",
            ""]
    for name, lines in written:
        # one tab less, and the comma that ended the entry goes: these are
        # assignments now, and a group's own last line may be a comment
        dedented = [line[1:] for line in lines]
        closing = max((index for index, line in enumerate(dedented) if line in ("},", "}")), default=0)
        dedented[closing] = dedented[closing].rstrip(",") if closing else dedented[0].rstrip().rstrip(",")
        body = "\n".join(dedented).rstrip()
        text.append(re.sub(r"^\w+ = ", f"Storage.{name} = ", body, count=1))
        text.append("")
    out.write_text("\n".join(text))

    print(f"# {len(written)} storage groups written to {out}")
    print(f"  left to ArkOT's own numbering: {', '.join(name for name, _ in skipped)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
