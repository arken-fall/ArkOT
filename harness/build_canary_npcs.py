#!/usr/bin/env python3
"""Port the Canary npcs the map spawns and BlackTek does not define.

Canary (opentibiabr/canary, data-otservbr-global/npc) describes an npc in one
Lua file: a npcConfig table for the body (name, health, outfit, walk, voices,
shop) and, below it, a KeywordHandler dialog. BlackTek keeps the body in
data/npc/<name>.xml and the dialog in data/npc/scripts/<name>.lua, the TFS
npc system both projects inherited, so the dialog itself carries over nearly
as written while the body becomes XML:

    npcConfig.outfit          -> <look type= head= body= legs= feet= addons=>
    npcConfig.health          -> <health now= max=>
    npcConfig.walkInterval    -> walkinterval=
    flags.floorchange         -> floorchange=
    npcConfig.shop            -> module_shop with shop_buyable / shop_sellable
                                 (Canary prices items by client id, so each is
                                 resolved to its server id)
    npcConfig.voices          -> VoiceModule

A registered name may carry a spawn suffix - "A Dead Bureaucrat (1)" - while
the npc shows the plain name; the XML keeps the registered name so the map's
spawns find it.

What does not carry over is a dialog callback: Canary hands its callbacks the
npc and creature, the TFS system a creature id, so a npc that sets one keeps
its keywords and greeting and has the callback commented out, listed in the
report to be written by hand (mostly quest npcs, whose quests are not ported
yet either).

Usage:
  python3 harness/build_canary_npcs.py --canary ~/Documents/canary \\
      [--out data/npc] [--report report.md]
"""

import argparse
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from build_quest_log import Parser, Raw, Ref  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent

LOOK_KEYS = {"lookType": "type", "lookHead": "head", "lookBody": "body", "lookLegs": "legs",
             "lookFeet": "feet", "lookAddons": "addons", "lookMount": "mount", "lookTypeEx": "typeex"}


def client_to_server_ids():
    mapping = {}
    for line in (ROOT / "data/items/modern_client_ids.tsv").read_text().splitlines():
        if line and not line.startswith("#"):
            server, appearance = line.split("\t")[:2]
            mapping.setdefault(int(appearance), int(server))
    return mapping


def spawned_names(spawn_file):
    return {creature.get("name") for group in ET.parse(spawn_file).getroot() for creature in group if creature.tag == "npc"}


def registered_name(text):
    """The name the map's spawns look for, which may carry a suffix the npc does not show."""
    direct = re.search(r'createNpcType\("([^"]+)"\)', text)
    if direct:
        return direct.group(1)
    internal = re.search(r'internalNpcName\s*=\s*"([^"]+)"', text)
    return internal.group(1) if internal else None


def config_of(text):
    """Read the npcConfig assignments into one table."""
    config = {}
    parser = Parser(text)
    tokens = parser.tokens
    index = 0
    while index + 3 < len(tokens):
        if (tokens[index][1] == "npcConfig" and tokens[index + 1][1] == "." and tokens[index + 2][0] == "name"
                and tokens[index + 3][1] == "="):
            key = tokens[index + 2][1]
            parser.index = index + 4
            try:
                config[key] = parser.value()
            except Exception:
                return config
            index = parser.index
        else:
            index += 1
    return config


def number(value, fallback=0):
    return value if isinstance(value, (int, float)) else fallback


class Npc:
    def __init__(self, path, items, report):
        self.path = path
        self.items = items
        self.report = report
        self.text = path.read_text(errors="replace")
        self.name = registered_name(self.text)
        self.config = config_of(self.text)
        self.notes = []

    @property
    def file_stem(self):
        return self.name

    def shop_lines(self):
        """Canary lists one shop entry per item, with buy and sell prices on it."""
        buyable, sellable = [], []
        shop = self.config.get("shop")
        if not isinstance(shop, dict):
            return buyable, sellable
        for key in sorted(k for k in shop if isinstance(k, int)):
            entry = shop[key]
            if not isinstance(entry, dict):
                continue
            client_id = entry.get("clientId")
            server_id = self.items.get(client_id) if isinstance(client_id, int) else None
            name = entry.get("itemName")
            if server_id is None or not isinstance(name, str):
                self.notes.append(f"shop item without a BlackTek id: {name or client_id}")
                continue
            if isinstance(entry.get("buy"), int):
                buyable.append(f"{name},{server_id},{entry['buy']}")
            if isinstance(entry.get("sell"), int):
                sellable.append(f"{name},{server_id},{entry['sell']}")
        return buyable, sellable

    def xml(self):
        outfit = self.config.get("outfit") if isinstance(self.config.get("outfit"), dict) else {}
        look = " ".join(f'{attribute}="{int(outfit[key])}"' for key, attribute in LOOK_KEYS.items()
                        if isinstance(outfit.get(key), (int, float)) and outfit[key])
        health = int(number(self.config.get("health"), 100)) or 100
        walk = int(number(self.config.get("walkInterval"), 2000))
        flags = self.config.get("flags") if isinstance(self.config.get("flags"), dict) else {}
        floorchange = 1 if flags.get("floorchange") else 0

        lines = ['<?xml version="1.0" encoding="UTF-8"?>',
                 f'<npc name="{self.name}" script="{self.file_stem}.lua" walkinterval="{walk}" floorchange="{floorchange}">',
                 f'\t<health now="{health}" max="{health}" />']
        if look:
            lines.append(f"\t<look {look} />")

        buyable, sellable = self.shop_lines()
        if buyable or sellable:
            lines.append("\t<parameters>")
            lines.append('\t\t<parameter key="module_shop" value="1" />')
            if buyable:
                lines.append(f'\t\t<parameter key="shop_buyable" value="{";".join(buyable)}" />')
            if sellable:
                lines.append(f'\t\t<parameter key="shop_sellable" value="{";".join(sellable)}" />')
            lines.append("\t</parameters>")
        lines.append("</npc>")
        return "\n".join(lines) + "\n"

    def voices(self):
        voices = self.config.get("voices")
        if not isinstance(voices, dict):
            return []
        said = []
        for key in sorted(k for k in voices if isinstance(k, int)):
            entry = voices[key]
            if isinstance(entry, dict) and isinstance(entry.get("text"), str):
                text = entry["text"].replace("\\", "\\\\").replace("'", "\\'")
                said.append(f"\t{{text = '{text}'}}")
        return said

    def dialog_start(self):
        """The first keyword, or the top level statement that holds it.

        A npc that hands its travel keywords to a helper writes the first
        addKeyword inside that helper, so the slice opens at the helper's own
        line - the nearest line at or above it that begins in the first column -
        or the dialog would start on a block with no head and never parse.
        """
        keyword = self.text.find("keywordHandler:addKeyword")
        if keyword < 0:
            return -1
        lines = self.text.splitlines(keepends=True)
        offsets, offset = [], 0
        for line in lines:
            offsets.append(offset)
            offset += len(line)
        found = max(index for index, start in enumerate(offsets) if start <= keyword)
        for index in range(found, -1, -1):
            if lines[index].strip() and not lines[index][0].isspace():
                return offsets[index]
        return offsets[found]

    def dialog(self):
        """Everything from the first keyword to the npc's registration, as Canary wrote it."""
        start = self.dialog_start()
        if start < 0:
            return ""
        end = self.text.find("npcHandler:addModule(FocusModule")
        if end < 0:
            end = self.text.find("npcType:register")
        body = self.text[start:end if end > start else len(self.text)]
        # a callback takes different arguments here, so it waits for a hand port
        def comment(match):
            self.notes.append("callback commented out: " + match.group(0).splitlines()[0].strip())
            return "\n".join("-- " + line for line in match.group(0).splitlines())
        # only the functions the npc hands to setCallback: a travel or greeting
        # helper of the npc's own takes its own arguments and carries over as written
        callbacks = set(re.findall(r"^npcHandler:setCallback\([^,]+,\s*(\w+)\s*\)", body, flags=re.M))
        if callbacks:
            body = re.sub(rf"^local function (?:{'|'.join(sorted(callbacks))})\(.*?^end\b", comment,
                          body, flags=re.M | re.S)
        body = re.sub(r"^npcHandler:setCallback\(.*?\)\s*$", comment, body, flags=re.M)
        # npcConfig and npcType belong to Canary's side of the split: the body is XML here
        body = re.sub(r"^npcConfig\.\w+ = \{.*?^\}\s*$\n?", "", body, flags=re.M | re.S)
        body = re.sub(r"^npcConfig\.\w+ = .*$\n?", "", body, flags=re.M)
        body = re.sub(r"^npcType\.\w+ = function\b[^\n]*\bend\s*$\n?", "", body, flags=re.M)
        body = re.sub(r"^npcType\.\w+ = function\b.*?^end\b\n?", "", body, flags=re.M | re.S)
        body = re.sub(r"^npcType[:.]\w+\(.*?\)\s*$\n?", "", body, flags=re.M)
        return body.strip()

    def script(self):
        lines = ["local keywordHandler = KeywordHandler:new()",
                 "local npcHandler = NpcHandler:new(keywordHandler)",
                 "NpcSystem.parseParameters(npcHandler)",
                 "",
                 "function onCreatureAppear(cid)\t\t\tnpcHandler:onCreatureAppear(cid)\t\t\tend",
                 "function onCreatureDisappear(cid)\t\tnpcHandler:onCreatureDisappear(cid)\t\t\tend",
                 "function onCreatureSay(cid, type, msg)\t\tnpcHandler:onCreatureSay(cid, type, msg)\t\tend",
                 "function onThink()\t\tnpcHandler:onThink()\t\tend",
                 ""]
        said = self.voices()
        if said:
            lines += ["local voices = {", ",\n".join(said), "}", "npcHandler:addModule(VoiceModule:new(voices))", ""]
        dialog = self.dialog()
        if dialog:
            lines += [dialog, ""]
        lines += ["npcHandler:addModule(FocusModule:new())", ""]
        return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--canary", required=True)
    parser.add_argument("--out", default=str(ROOT / "data/npc"))
    parser.add_argument("--spawns", default=str(ROOT / "data/world/canary-spawn.xml"))
    parser.add_argument("--report", default=None)
    args = parser.parse_args()

    source = Path(args.canary).expanduser() / "data-otservbr-global/npc"
    out = Path(args.out)
    (out / "scripts").mkdir(parents=True, exist_ok=True)
    items = client_to_server_ids()

    # what ArkOT already defines, wherever this run happens to write
    known = {path.stem.lower() for path in (ROOT / "data/npc").glob("*.xml")}
    wanted = {name for name in spawned_names(args.spawns) if name.lower() not in known}

    written, report = [], []
    for path in sorted(source.rglob("*.lua")):
        text = path.read_text(errors="replace")
        name = registered_name(text)
        if not name or name not in wanted:
            continue
        npc = Npc(path, items, report)
        (out / f"{npc.file_stem}.xml").write_text(npc.xml())
        (out / "scripts" / f"{npc.file_stem}.lua").write_text(npc.script())
        written.append(name)
        for note in npc.notes:
            report.append(f"- {name}: {note}")

    missing = sorted(wanted - set(written))
    lines = [f"# Canary npc port: {len(written)} npcs written to {out}", ""]
    if missing:
        lines += [f"## Spawned but not found in Canary's npc folder ({len(missing)})", *[f"- {name}" for name in missing], ""]
    if report:
        lines += ["## Left to write by hand", *sorted(set(report))]
    if args.report:
        Path(args.report).write_text("\n".join(lines))
    print(lines[0])
    print(f"  still missing: {len(missing)}, notes: {len(set(report))}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
