local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
	item:transform(math.random(7588, 7589))
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(6558)
realmapEvent1:register()
