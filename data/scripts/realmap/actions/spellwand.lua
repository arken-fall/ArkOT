local outfits = {"rat", "green frog", "chicken"} --possible outfits
local duration = 45 --duration of the outfit in seconds
local breakchance = 1 --chance of losing the wand
local function onUse(cid, item, fromPosition, itemEx, toPosition)
    if math.random(100) <= breakchance then
        doSummonCreature("Mad Sheep",toPosition)
        doRemoveItem(item.uid,1)
        return TRUE
    end
    if isPlayer(itemEx.uid) == TRUE then
        doSetMonsterOutfit(itemEx.uid,outfits[math.random(#outfits)],duration*1000)
        doSendMagicEffect(toPosition,CONST_ME_MAGIC_BLUE)
        return TRUE
    end
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7735)
realmapEvent1:allowFarUse(true)
realmapEvent1:register()
