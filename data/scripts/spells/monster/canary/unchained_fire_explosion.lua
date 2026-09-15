local combat = Combat(MonsterCombats.UnchainedFireExplosion)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("unchained fire explosion")
spell:words("###6033")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
