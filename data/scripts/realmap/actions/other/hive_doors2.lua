local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = player:getPosition()
	if position.x == toPosition.x then
		return false
	end

	toPosition.x = position.x > toPosition.x and toPosition.x - 1 or toPosition.x + 1
	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(14767, 14768, 14769, 14770, 14771)
realmapEvent1:register()
