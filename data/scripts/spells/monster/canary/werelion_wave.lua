local combat = Combat(MonsterCombats.WerelionWave)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("werelion wave")
spell:words("###473")
spell:needLearn(true)
spell:needDirection(true)
spell:cooldown("2000")
spell:register()
