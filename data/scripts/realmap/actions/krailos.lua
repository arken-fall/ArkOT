local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 33658, y = 31660, z = 8} -- where to tp to 33672, 31884, 5
if(getPlayerStorageValue(cid, 10050) < 80) then
	doTeleportThing(cid,p)
	doSendMagicEffect(p,10)
	end
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(19079)
realmapEvent1:register()
