-- RETIRED 2026-09-20: every id this script claimed is already claimed by a script
-- written for this map, which registers first and therefore wins. It has never
-- run here. Disabled by the leading '#', not deleted, so the 10.98 pack's
-- version of this furniture stays readable.
--
---- string of mending id "22542"-----
local ITEMS = {
    [24716] = { -----Broken Ring Id "13877" Ring of ending "22516"
        {"enchanted werewolf amulet", 99.99} ----- 1.97 es la probabilidad de crear el item
	},
	[24718] = { -----Broken Ring Id "13877" Ring of ending "22516"
        {"enchanted werewolf helmet", 99.99}
		
    }
}
 
local function onUse(cid, item, fromPosition, itemEx, toPosition)
    local cadena = ITEMS[itemEx.itemid]
    if cadena == nil then
        return false
    end
 
    local iEx = Item(itemEx.uid)
    local random, chance = math.random() * 100, 0
 
    for i = 1, #cadena do
        chance = chance + cadena[i][2]
        if random <= chance then
            iEx:transform(cadena[i][1])
            iEx:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
            Item(item.uid):remove(1)
            return true
        end
    end
 
    iEx:getPosition():sendMagicEffect(CONST_ME_BLOCKHIT)
    Item(item.uid):remove(1)
	iEx:remove()
	doCreatureSay(cid, "90% chance, the item was broken.", TALKTYPE_ORANGE_1)
    return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(24739)
realmapEvent1:register()
