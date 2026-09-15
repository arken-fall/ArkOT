local combat = Combat(MonsterCombats.TyrnElectrify)

local condition = Condition(CONDITION_ENERGY)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(30, 10000, -25)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("tyrn electrify")
spell:words("###343")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()
