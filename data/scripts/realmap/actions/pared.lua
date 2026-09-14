local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 32677, y = 31609, z = 8} -- where to tp to 33672, 31884, 5

	doTeleportThing(cid,p)
	doSendMagicEffect(p,10)
	
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(19075)
realmapEvent1:register()
