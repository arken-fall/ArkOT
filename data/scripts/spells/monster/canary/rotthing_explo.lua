local spell = Spell(SPELL_INSTANT)

local combat = Combat(MonsterCombats.Rotthligexplo)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("rotthligexplo")
spell:words("###rotth_explo")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
