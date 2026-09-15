local combat = Combat(MonsterCombats.Quaraseamonster)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("quaraseamonster")
spell:words("###quara_sea_monster")
spell:needLearn(true)
spell:isSelfTarget(false)
spell:register()
