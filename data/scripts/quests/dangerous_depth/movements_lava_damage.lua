local lavaDamage = ItemEvent()

function lavaDamage.onStepOn(creature, position, fromPosition, toPosition)
	if creature and (creature:isPlayer() or creature:getMaster()) then
		doTargetCombatHealth(0, creature, COMBAT_FIREDAMAGE, -500, -500, CONST_ME_HITBYFIRE)
	end
	return true
end

lavaDamage:type("stepon")
lavaDamage:id(22675)
lavaDamage:register()
