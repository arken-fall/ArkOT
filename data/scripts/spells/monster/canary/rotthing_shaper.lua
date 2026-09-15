local combat1 = Combat()
combat1:setDamageType(Combat.DamageType.Earth)
combat1:setImpactEffect(CONST_ME_SMALLPLANTS)
combat1:setMinMaxFormula(0, 700, 900, 0)

local combat2 = Combat()
combat2:setDamageType(Combat.DamageType.Physical)
combat2:setImpactEffect(CONST_ME_FIREATTACK)
combat2:setMinMaxFormula(0, 800, 1000, 0)

local arr = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 1, 0, 2, 0, 0, 0, 1, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

arr1 = {
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0 },
	{ 0, 1, 0, 1, 2, 0, 0, 1, 0, 1, 0 },
	{ 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

local area = createCombatArea(arr)
combat1:setArea(createCombatArea(arr))
combat2:setArea(createCombatArea(arr1))

local spell = Spell(SPELL_INSTANT)

local combats = { combat1, combat2 }

function spell.onCastSpell(creature, variant)
	for _, combat in pairs(combats) do
		combat:execute(creature, variant)
	end
	return true
end

spell:name("rotthingshaper")
spell:words("#773373")
spell:needLearn(true)
spell:register()
