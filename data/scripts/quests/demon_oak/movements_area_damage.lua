local areaDamage = ItemEvent()

function areaDamage.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if math.random(24) == 1 then
		doTargetCombatHealth(0, player, COMBAT_EARTHDAMAGE, -270, -310, CONST_ME_BIGPLANTS)
	end
	return true
end

areaDamage:type("stepon")
areaDamage:id(918)
areaDamage:register()
