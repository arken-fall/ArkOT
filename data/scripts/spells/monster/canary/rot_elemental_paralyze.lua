local combat = Combat(MonsterCombats.RotElementalParalyze)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.45, 0, -0.65, 0)
combat:addCondition(condition)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("rot elemental paralyze")
spell:words("###367")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
