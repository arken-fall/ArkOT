local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	addEvent(function(cid)
		local creature = Creature(cid)
		if not creature then
			return
		end
		Game.createMonster("Energy Pulse", creature:getPosition(), true, true)
		creature:say("The fully charged generator explodes in a blast!", TALKTYPE_MONSTER_YELL)
		creature:remove()
		return true
	end, 14000, creature:getId())
	return true
end

spell:name("glooth-generator summon")
spell:words("###402")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
