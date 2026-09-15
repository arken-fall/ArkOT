local summons = {
	[1] = { name = "Werewolf" },
}

local combat = Combat(MonsterCombats.FeroxaSummon)

local maxsummons = 10

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	creature:say("RISE MY SERVANTS! RISE!!", TALKTYPE_MONSTER_SAY)

	local summoncount = creature:getSummons()
	local creaturePos = creature:getPosition()
	if #summoncount < 10 then
		for i = 1, maxsummons do
			local mid = Game.createMonster(summons[math.random(#summons)].name, Position(creaturePos.x + math.random(-3, 3), creaturePos.y + math.random(-3, 3), creaturePos.z))
			if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, variant)
end

spell:name("feroxa summon")
spell:words("###422")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
