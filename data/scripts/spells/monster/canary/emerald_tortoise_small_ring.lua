local combat = Combat(MonsterCombats.EmeraldTortoiseSmallRing)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("emerald tortoise small ring")
spell:words("###6024")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
