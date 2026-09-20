-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local fruits = {2673, 2674, 2675, 2676, 2677, 2678, 2679, 2680, 2681, 2682, 2684, 2685, 5097, 8839, 8840, 8841}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray(fruits, target.itemid) and player:removeItem(2006, 1, 0) then
		target:remove(1)
		player:addItem(2006, target.itemid == 2678 and 14 or 21)
		return true
	end
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(5865)
realmapEvent1:register()
