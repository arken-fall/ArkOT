local combat = Combat(MonsterCombats.ManaLeechmy)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("mana leechMY")
spell:words("###502")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(false)
spell:register()
