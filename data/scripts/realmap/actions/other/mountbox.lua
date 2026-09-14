 function onUse(cid, item, fromPosition, itemEx, toPosition) 
    local mountid = math.random(43,103) -- you have to change 32 for your highest mount id 
    doPlayerAddMount(cid, mountid) --add the mount 
    doSendMagicEffect(getCreaturePosition(cid), CONST_ME_FIREWORK_RED) --effect on player 
    doRemoveItem(item.uid, 1) -- remove the item 
    return TRUE 
end 

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(11402)
realmapEvent1:register()
