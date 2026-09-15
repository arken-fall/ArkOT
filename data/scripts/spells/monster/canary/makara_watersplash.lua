local combat = Combat(MonsterCombats.Makarawatersplash)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("makarawatersplash")
spell:words("###489")
spell:blockWalls(true)
spell:needDirection(true)
spell:needLearn(true)
spell:register()
