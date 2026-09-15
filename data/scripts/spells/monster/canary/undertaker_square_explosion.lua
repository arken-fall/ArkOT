local combat = Combat(MonsterCombats.UndertakerSquareExplosion)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("undertaker square explosion")
spell:words("###6018")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needTarget(true)
spell:register()
