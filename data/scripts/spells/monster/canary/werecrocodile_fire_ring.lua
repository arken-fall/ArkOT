local combat = Combat(MonsterCombats.WerecrocodileFireRing)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("werecrocodile fire ring")
spell:words("###6052")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
