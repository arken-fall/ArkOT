local destructionSummonDelay = false

local combat = Combat(MonsterCombats.DestructionSummon)

local function removeDelay()
	destructionSummonDelay = false
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	if destructionSummonDelay == false then
		if destructionSummon < 3 then
			Game.createMonster("Disruption", { x = creature:getPosition().x + math.random(-1, 1), y = creature:getPosition().y + math.random(-1, 1), z = creature:getPosition().z }, false, true)
			destructionSummon = destructionSummon + 1

			destructionSummonDelay = true
			addEvent(removeDelay, 15000)
		end
	end

	return combat:execute(creature, variant)
end

spell:name("destruction summon")
spell:words("###418")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
