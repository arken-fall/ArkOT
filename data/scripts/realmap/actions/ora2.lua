local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 33665, y = 31922, z = 7} -- where to tp to
if(getPlayerStorageValue(cid, 10050) == 17) then
	doTeleportThing(cid,p)
	doSendMagicEffect(p,10)
return true
end

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(19024)
realmapEvent1:register()
