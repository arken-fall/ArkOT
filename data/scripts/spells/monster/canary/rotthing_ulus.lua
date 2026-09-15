local spell = Spell(SPELL_INSTANT)

local combat = Combat(MonsterCombats.Rotthligulus)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("rotthligulus")
spell:words("###rotth_ulus")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
