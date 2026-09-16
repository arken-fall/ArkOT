local mazoranFire = ItemEvent()

function mazoranFire.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	doTargetCombatHealth(0, player, COMBAT_FIREDAMAGE, -1000, -1000, CONST_ME_HITBYFIRE)
	return true
end

mazoranFire:type("stepon")
mazoranFire:aid(34200)
mazoranFire:register()
