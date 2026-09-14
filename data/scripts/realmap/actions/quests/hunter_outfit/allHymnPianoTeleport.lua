
local function onUse(cid, item, fromPosition, itemEx, toPosition)
doTeleportThing(cid, {x = 32401, y = 32794, z = 9})

return TRUE
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(33216)
realmapEvent1:register()
