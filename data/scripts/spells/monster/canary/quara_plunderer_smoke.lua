local combat = Combat(MonsterCombats.Quarasmokedeath)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("quarasmokedeath")
spell:words("###quara_smoke_death")
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
