local combat = Combat(MonsterCombats.MantosaurusRing)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("mantosaurus ring")
spell:words("###6020")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needTarget(true)
spell:register()
