local combat = Combat(MonsterCombats.MedusaParalyze)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.45, 0, -0.5, 0)
combat:addCondition(condition)

combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("medusa paralyze")
spell:words("###152")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
