local combat = Combat(MonsterCombats.FrazzlemawParalyze)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.6, 0, -0.8, 0)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("frazzlemaw paralyze")
spell:words("###356")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
