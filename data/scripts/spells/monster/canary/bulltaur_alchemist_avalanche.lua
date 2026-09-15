local combat = Combat(MonsterCombats.BulltaurAvalanche)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("bulltaur avalanche")
spell:words("###7000")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()
