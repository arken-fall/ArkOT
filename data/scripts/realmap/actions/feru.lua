local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(25421)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(25420)
realmapEvent1:register()
