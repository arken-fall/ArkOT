local combat = Combat()

combat:setDamageType(Combat.DamageType.Ice)
combat:setImpactEffect(CONST_ME_WATERSPLASH)
combat:setArea(createCombatArea({
	{ 0, 1, 0 },
	{ 1, 3, 1 },
	{ 0, 1, 0 },
}))

local combat2 = Combat()
combat2:setDamageType(Combat.DamageType.Ice)
combat2:setImpactEffect(CONST_ME_WATERSPLASH)
combat2:setArea(createCombatArea({
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 0, 1, 1 },
	{ 1, 0, 2, 0, 1 },
	{ 1, 1, 0, 1, 1 },
	{ 0, 1, 1, 1, 0 },
}))

local combat3 = Combat()
combat3:setDamageType(Combat.DamageType.Ice)
combat3:setImpactEffect(CONST_ME_WATERSPLASH)
combat3:setArea(createCombatArea({
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 1, 1, 0, 0, 0, 1, 1, 0 },
	{ 1, 1, 0, 0, 0, 0, 0, 1, 1 },
	{ 1, 1, 0, 0, 2, 0, 0, 1, 1 },
	{ 1, 1, 0, 0, 0, 0, 0, 1, 1 },
	{ 0, 1, 1, 0, 0, 0, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 1, 1, 0, 0, 0 },
}))

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	addEvent(runSpell, 1000, creature:getId(), combat, variant)
	addEvent(runSpell, 2000, creature:getId(), combat2, variant)
	addEvent(runSpell, 3000, creature:getId(), combat3, variant)
	return true
end

function runSpell(cid, combat, variant)
	local creature = Creature(cid)
	if creature then
		combat:execute(creature, variant)
	end
end

spell:name("foamsplash")
spell:words("###491")
spell:blockWalls(true)
spell:needDirection(false)
spell:needLearn(true)
spell:register()
