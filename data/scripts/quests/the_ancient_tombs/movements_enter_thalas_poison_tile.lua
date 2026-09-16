local condition = Condition(CONDITION_POISON, CONDITIONID_COMBAT)
condition:setParameter(CONDITION_PARAM_DELAYED, true)
condition:setParameter(CONDITION_PARAM_MINVALUE, 20)
condition:setParameter(CONDITION_PARAM_MAXVALUE, 70)
condition:setParameter(CONDITION_PARAM_STARTVALUE, 50)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 6000)
condition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

local enterThalasPoisonTile = ItemEvent()

function enterThalasPoisonTile.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
	player:addCondition(condition)
	item:transform(420)
	return true
end

enterThalasPoisonTile:type("stepon")
enterThalasPoisonTile:uid(50136)
enterThalasPoisonTile:register()
