local combat = Combat(MonsterCombats.ThornSummon)

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	local creaturePos = creature:getPosition()
	local mid = Game.createMonster("thorn minion", Position(creaturePos.x + math.random(-3, 3), creaturePos.y + math.random(-3, 3), creaturePos.z), true, false)
	if not mid then
		return
	end
	return combat:execute(creature, variant)
end

spell:name("thorn summon")
spell:words("###442")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
