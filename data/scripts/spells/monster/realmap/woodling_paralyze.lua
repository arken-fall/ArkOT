-- the woodling's paralysing beam, ported from the real-map pack
local combat = Combat()
combat:setImpactEffect(CONST_ME_LOSEENERGY)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 3000)
condition:setFormula(-0.05, 0, -0.1, 0)

local area = createCombatArea({
	{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0},
})
combat:setArea(area)
combat:addCondition(condition)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("woodling paralyze")
spell:words("###375")
spell:needDirection(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
