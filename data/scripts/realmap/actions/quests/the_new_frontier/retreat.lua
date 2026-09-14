local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local destination = Position(33170, 31247, 11)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_POFF)
	player:setStorageValue(Storage.TheNewFrontier.Questline, 23)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(3156)
realmapEvent1:register()
