local spell = Spell(SPELL_INSTANT)

local aLarge = {
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 0, 0, 3, 0, 0, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
}

local combatLargeRing = Combat()
combatLargeRing:setDamageType(Combat.DamageType.Death)
combatLargeRing:setImpactEffect(CONST_ME_BLACKSMOKE)
combatLargeRing:setArea(createCombatArea(aLarge))

local combats = { combatLargeRing }

function spell.onCastSpell(creature, variant)
	local randomCombat = combats[math.random(#combats)]
	return randomCombat:execute(creature, variant)
end

spell:name("largeblackring")
spell:words("###large_black_ring")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
