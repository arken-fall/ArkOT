local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(24810)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(24809)
realmapEvent1:register()
