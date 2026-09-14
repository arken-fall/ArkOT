local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(2566)
realmapEvent1:register()
