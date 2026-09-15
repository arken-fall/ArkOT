local combat = Combat(MonsterCombats.Quaracrossdeath)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("quaracrossdeath")
spell:words("###quara_cross_death")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
