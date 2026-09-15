local combat = Combat(MonsterCombats.Targetfirering)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("targetfirering")
spell:words("###480")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:cooldown("2000")
spell:register()
