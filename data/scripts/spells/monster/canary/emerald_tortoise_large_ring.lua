local combat = Combat(MonsterCombats.EmeraldTortoiseLargeRing)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("emerald tortoise large ring")
spell:words("###6023")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
