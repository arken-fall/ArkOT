local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerPos, destination = player:getPosition()
	if item.itemid == 19598 then
		player:setStorageValue(Storage.AdventurersGuild.MagicDoor, 1)
		destination = Position(32292, 32293, 7)

	else

		if player:getStorageValue(Storage.AdventurersGuild.MagicDoor) == 1 then
			player:setStorageValue(Storage.AdventurersGuild.MagicDoor, -1)
			destination = Position(32199, 32309, 7)

		elseif playerPos.x == 32293 then
			destination = Position(32297, 32293, 7)

		else
			destination = Position(32292, 32293, 7)
		end
	end

	player:teleportTo(destination)
	playerPos:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(19598, 19599)
realmapEvent1:register()
