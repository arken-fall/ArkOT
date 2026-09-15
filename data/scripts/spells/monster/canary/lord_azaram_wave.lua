local combatSmall = Combat()
combatSmall:setDamageType(Combat.DamageType.Earth)
combatSmall:setImpactEffect(CONST_ME_HITBYPOISON)

local combatLarge = Combat()
combatLarge:setDamageType(Combat.DamageType.Earth)
combatLarge:setImpactEffect(CONST_ME_HITBYPOISON)

local areaSmall = {
	{ 0, 0, 0, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 3, 0, 0 },
}

local areaLarge = {
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 3, 0, 0, 0 },
}

combatSmall:setArea(createCombatArea(areaSmall))
combatLarge:setArea(createCombatArea(areaLarge))

local spell = Spell(SPELL_INSTANT)

local combats = { combatSmall, combatLarge }

function spell.onCastSpell(creature, variant)
	local randomCombat = combats[math.random(#combats)]
	return randomCombat:execute(creature, variant)
end

spell:name("lord azaram wave")
spell:words("###6031")
spell:needLearn(true)
spell:cooldown("2000")
spell:needDirection(true)
spell:isSelfTarget(true)
spell:register()
