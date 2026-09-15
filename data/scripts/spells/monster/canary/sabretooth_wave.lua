local combat = Combat(MonsterCombats.SabretoothWave)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("sabretooth wave")
spell:words("###6028")
spell:needLearn(true)
spell:cooldown("2000")
spell:needDirection(true)
spell:isSelfTarget(true)
spell:register()
