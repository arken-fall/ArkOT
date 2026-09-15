local arrLarge = {
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1 },
	{ 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 },
	{ 1, 1, 0, 0, 0, 0, 3, 0, 0, 0, 0, 1, 1 },
	{ 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1 },
	{ 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1 },
	{ 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
}

local arrMedium = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 0, 0, 3, 0, 0, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local arrSmall = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 0, 3, 0, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local combatSmallRing = Combat()
combatSmallRing:setDamageType(Combat.DamageType.Fire)
combatSmallRing:setImpactEffect(CONST_ME_HITBYFIRE)
combatSmallRing:setArea(createCombatArea(arrSmall))

local combatMediumRing = Combat()
combatMediumRing:setDamageType(Combat.DamageType.Fire)
combatMediumRing:setImpactEffect(CONST_ME_HITBYFIRE)
combatMediumRing:setArea(createCombatArea(arrMedium))

local combatLargeRing = Combat()
combatLargeRing:setDamageType(Combat.DamageType.Fire)
combatLargeRing:setImpactEffect(CONST_ME_HITBYFIRE)
combatLargeRing:setArea(createCombatArea(arrLarge))

local spell = Spell(SPELL_INSTANT)

local combats = { combatSmallRing, combatMediumRing, combatLargeRing }

function spell.onCastSpell(creature, variant)
	local randomCombat = combats[math.random(#combats)]
	return randomCombat:execute(creature, variant)
end

spell:name("timira fire ring")
spell:words("###6029")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
