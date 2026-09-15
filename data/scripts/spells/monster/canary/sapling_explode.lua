local combat = Combat(MonsterCombats.SaplingExplode)

function removeSapling(cid)
	local creature = Creature(cid)
	if not creature then
		return false
	end
	creature:remove()
end

local spell = Spell(SPELL_INSTANT)

function spell.onCastSpell(creature, variant)
	addEvent(removeSapling, 1, creature.uid)
	return combat:execute(creature, variant)
end

spell:name("sapling explode")
spell:words("###6004")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
