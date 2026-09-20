-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local MusicEffect = {
	
	[3957] = CONST_ME_SOUND_YELLOW, --Cornucopia
	
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	
	item:getPosition():sendMagicEffect(MusicEffect[item.itemid])
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(3957)
realmapEvent1:register()
