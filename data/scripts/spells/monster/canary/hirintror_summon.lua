local combat = Combat(MonsterCombats.HirintrorSummon)

local maxsummons = 2

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	local summoncount = creature:getSummons()
	if #summoncount < 2 then
		for i = 1, maxsummons - #summoncount do
			local mid = Game.createMonster("Ice Golem", creature:getPosition())
			if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, variant)
end

spell:name("hirintror summon")
spell:words("###164")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
