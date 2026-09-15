local combat = Combat(MonsterCombats.NighthunterWave)

AREA_WAVE = {
	{ 0, 0, 0, 0, 0 },
	{ 1, 1, 1, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 3, 0, 0 },
}

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("nighthunter wave")
spell:words("###6016")
spell:needLearn(true)
spell:cooldown("2000")
spell:needDirection(true)
spell:isSelfTarget(true)
spell:register()
