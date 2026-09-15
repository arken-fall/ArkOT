local combat = Combat(MonsterCombats.Quararaidershoot)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("quararaidershoot")
spell:words("###raider_shoot")
spell:needLearn(true)
spell:needTarget(true)
spell:register()
