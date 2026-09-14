local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 32725, y = 31487, z = 15} -- 32694, 31495, 11
if Player(cid):getStorageValue(Storage.hiddenCityOfBeregar.RoyalRescue) == 4 then
	doTeleportThing(cid,p)
	
	doSendMagicEffect(p,10)
	else doCreatureSay(cid, "You need talk with Tehlim first.", TALKTYPE_ORANGE_1)
return true
end

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(42150)
realmapEvent1:register()
