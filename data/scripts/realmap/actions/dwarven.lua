local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 32584, y = 31398, z = 8} -- where to tp to 33672, 31884, 5
if(getPlayerStorageValue(cid, 12607) == 6) then
	doTeleportThing(cid,p)
	doSendMagicEffect(p,10)
	
	else 
	
	doCreatureSay(cid, "You need to do missions before.", TALKTYPE_ORANGE_1)
return true
end

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(61221)
realmapEvent1:register()
