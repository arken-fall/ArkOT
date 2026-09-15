local combat = Combat(MonsterCombats.BreachBroodReducer)

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, -15)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("breach brood reducer")
spell:words("###446")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:isSelfTarget("5")
spell:register()
