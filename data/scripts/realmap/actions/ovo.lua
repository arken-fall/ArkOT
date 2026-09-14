local function onUse(cid, item, fromPosition, itemEx, toPosition)
local p = {x = 33672, y = 31884, z = 5} -- where to tp to 33672, 31884, 5
	doCreatureSay(cid, "This metal egg seems to be locked by a strange mechanism. The time for it to reveal its contents has not yet come.", TALKTYPE_ORANGE_1)

end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(25395)
realmapEvent1:register()
