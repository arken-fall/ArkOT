local function onUse(cid, item, fromPosition, itemEx, toPosition)
		fromPosition.z = fromPosition.z - 1
		doTeleportThing(cid, fromPosition, FALSE)
	return TRUE
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(22949)
realmapEvent1:register()
