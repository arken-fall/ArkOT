local combat = Combat(MonsterCombats.Arachnophobicawavedice)

local area = createCombatArea({
	{ 1, 1, 1 },
	{ 0, 1, 0 },
	{ 0, 3, 0 },
})

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("arachnophobicawavedice")
spell:words("###467")
spell:needLearn(true)
spell:needDirection(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
