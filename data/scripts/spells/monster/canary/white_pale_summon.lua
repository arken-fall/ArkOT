local combat = Combat(MonsterCombats.WhitePaleSummon)

local maxsummons = 2

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	local summoncount = creature:getSummons()
	if #summoncount < 2 then
		for i = 1, maxsummons - #summoncount do
			local mid = Game.createMonster("Carrion Worm", creature:getPosition())
			if not mid then
				return
			end
			mid:setMaster(creature)
		end
	end
	return combat:execute(creature, variant)
end

spell:name("white pale summon")
spell:words("###351")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
