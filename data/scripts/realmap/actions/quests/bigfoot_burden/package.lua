local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid - 1)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(18313)
realmapEvent1:register()
