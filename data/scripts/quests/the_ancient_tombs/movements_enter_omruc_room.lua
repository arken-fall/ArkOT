local movements_enter_omruc_room = ItemEvent()

function movements_enter_omruc_room.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(33207, 33002, 14)
	if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.DefaultStart) ~= 1 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		if player:getStorageValue(Storage.Quest.U7_4.TheAncientTombs.OmrucsTreasure) <= 1 then
			player:setStorageValue(Storage.Quest.U7_4.TheAncientTombs.OmrucsTreasure, 2)
		end
	end

	return true
end

movements_enter_omruc_room:type("stepon")
movements_enter_omruc_room:uid(40087)
movements_enter_omruc_room:register()
