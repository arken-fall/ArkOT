local combat1 = Combat()
combat1:setDamageType(Combat.DamageType.Holy)
combat1:setImpactEffect(CONST_ME_HOLYDAMAGE)
combat1:setMinMaxFormula(0, 700, 900, 0)

local combat2 = Combat()
combat2:setDamageType(Combat.DamageType.Physical)
combat2:setImpactEffect(CONST_ME_GROUNDSHAKER)
combat2:setMinMaxFormula(0, 800, 1200, 0)

local arr = {
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 1, 0, 0 },
	{ 0, 0, 3, 0, 0 },
}

arr1 = {
	{ 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 1, 1, 1, 1, 1, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 1, 1, 1, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 3, 0, 0, 0 },
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

spell:name("rotthingwave")
spell:words("#776373")
spell:needLearn(true)
spell:needDirection(true)
spell:register()
