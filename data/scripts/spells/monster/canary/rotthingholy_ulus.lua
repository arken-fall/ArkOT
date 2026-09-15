local spell = Spell(SPELL_INSTANT)

local combat = Combat(MonsterCombats.Rotthligholyulus)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("rotthligholyulus")
spell:words("###rotth_holy_ulus")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
