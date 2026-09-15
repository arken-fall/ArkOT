local combat = Combat(MonsterCombats.Nagadeath)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("nagadeath")
spell:words("###488")
spell:blockWalls(true)
spell:needDirection(true)
spell:needLearn(true)
spell:register()
