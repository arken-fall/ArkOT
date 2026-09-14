local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return false
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(1002)
realmapEvent1:register()
