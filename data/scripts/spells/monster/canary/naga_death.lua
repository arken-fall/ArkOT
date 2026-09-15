local combat = Combat(MonsterCombats.Nagadeathattack)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("nagadeathattack")
spell:words("###490")
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()
