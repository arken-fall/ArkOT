local combat = Combat(MonsterCombats.TheWelterParalyze)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.7, 0, -0.9, 0)
combat:addCondition(condition)

combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("the welter paralyze")
spell:words("###339")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
