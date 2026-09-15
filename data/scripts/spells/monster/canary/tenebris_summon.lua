local combat = Combat(MonsterCombats.TenebrisSummon)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	local mid = Game.createMonster("shadow fiend", Position(math.random(32906, 32918), math.random(31594, 31604), 14))
	if not mid then
		return
	end
	mid:say("The shadow fiend revives!", TALKTYPE_MONSTER_SAY)
	return combat:execute(creature, variant)
end

spell:name("tenebris summon")
spell:words("###429")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
