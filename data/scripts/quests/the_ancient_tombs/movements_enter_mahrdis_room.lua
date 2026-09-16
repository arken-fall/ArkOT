local movements_enter_mahrdis_room = ItemEvent()

function movements_enter_mahrdis_room.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(33190, 32947, 15)
	if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.MahrdisTreasure) ~= 1 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.MahrdisTreasure) <= 1 then
			player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.MahrdisTreasure, 2)
		end
	end

	return true
end

movements_enter_mahrdis_room:type("stepon")
movements_enter_mahrdis_room:uid(40084)
movements_enter_mahrdis_room:register()
