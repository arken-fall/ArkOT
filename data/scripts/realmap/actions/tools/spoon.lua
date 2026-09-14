local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(2565)
realmapEvent1:register()
