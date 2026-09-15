local combat = Combat(MonsterCombats.Quarawatersplash)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("quarawatersplash")
spell:words("###quara_water_splash")
spell:needLearn(true)
spell:isSelfTarget(false)
spell:register()
