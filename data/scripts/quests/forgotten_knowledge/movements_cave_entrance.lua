local caveEntrance = ItemEvent()

function caveEntrance.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end
	local pos = item:getPosition()
	if pos.z == 5 then
		player:teleportTo(Position(33515, 31103, 8))
	elseif pos.z == 8 then
		player:teleportTo(Position(33334, 31151, 5))
	end
	player:setDirection(SOUTH)
	return true
end

caveEntrance:type("stepon")
caveEntrance:id(23735)
caveEntrance:register()
