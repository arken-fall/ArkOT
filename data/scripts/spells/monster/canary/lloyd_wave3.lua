local combat = Combat(MonsterCombats.LloydWave3)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("lloyd wave3")
spell:words("###434")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:isSelfTarget(true)
spell:register()
