-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
local items = { 
	[0] = {id = 2152, count = 3, chance = 100},
	[1] = {id = 2013, count = 1, chance = 80}, 
	[2] = {id = 13539, count = 1, chance = 25}, 
} 

local function onUse(cid, item, fromPosition, itemEx, toPosition)
	if itemEx.itemid == 2700 or itemEx.itemid == 21428 then 
		doRemoveItem(item.uid, 1)
		for i = 0, #items do 
			if (items[i].chance > math.random(1, 100)) then 
				doPlayerAddItem(cid, items[i].id, items[i].count) 
				doSendMagicEffect(toPosition, CONST_ME_EXPLOSIONAREA)
			end
		end
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(13941)
realmapEvent1:register()
