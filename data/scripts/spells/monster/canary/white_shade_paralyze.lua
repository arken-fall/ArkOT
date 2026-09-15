local combat = Combat(MonsterCombats.WhiteShadeParalyze)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.3, 0, -0.45, 0)
combat:addCondition(condition)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("white shade paralyze")
spell:words("###266")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
