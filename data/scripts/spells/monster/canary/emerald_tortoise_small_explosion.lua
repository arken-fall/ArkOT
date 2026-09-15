local combat = Combat(MonsterCombats.EmeraldTortoiseSmallExplosion)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("emerald tortoise small explosion")
spell:words("###6025")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
