local function onUse(cid, item, fromPosition, itemEx, toPosition)
    doRemoveItem(item.uid,1)
    doCreatureSay(cid,"KABOOOOOOOOOOM!",TALKTYPE_ORANGE_1)
    doSendMagicEffect(fromPosition,CONST_ME_FIREAREA)
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(8110)
realmapEvent1:register()
