local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseRope(player, item, fromPosition, target, toPosition, isHotkey)
		or onUseShovel(player, item, fromPosition, target, toPosition, isHotkey)
		or onUsePick(player, item, fromPosition, target, toPosition, isHotkey)
		or onUseMachete(player, item, fromPosition, target, toPosition, isHotkey)
		or onUseCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
		or onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
		or onUseScythe(player, item, fromPosition, target, toPosition, isHotkey)
		or onUseKitchenKnife(player, item, fromPosition, target, toPosition, isHotkey)
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(10511, 10513, 10515)
realmapEvent1:register()
