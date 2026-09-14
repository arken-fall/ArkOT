-- the seacrest serpent's death wave, ported from the real-map pack
local combat = Combat()
combat:setDamageType(Combat.DamageType.Death)
combat:setImpactEffect(CONST_ME_WATERSPLASH)
combat:setArea(createCombatArea({
	{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0},
}))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("seacrest serpent wave")
spell:words("###373")
spell:needDirection(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
