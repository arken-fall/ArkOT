local combat = Combat(MonsterCombats.OmrafirSummon)

local maxsummons = 4

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	local summoncount = creature:getSummons()
	if #summoncount < 4 then
		for i = 1, maxsummons - #summoncount do
			local mid = Game.createMonster("Flame Of Omrafir", { x = creature:getPosition().x + math.random(-2, 2), y = creature:getPosition().y + math.random(-2, 2), z = creature:getPosition().z })
			if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, variant)
end

spell:name("omrafir summon")
spell:words("###317")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
