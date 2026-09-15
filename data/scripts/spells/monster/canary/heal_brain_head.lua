local spell = Spell(SPELL_INSTANT)
local brainHeadPosition = Position(31954, 32325, 10)

function spell.onCastSpell(creature, variant)
	local tile = Tile(brainHeadPosition)
	local origin = creature:getPosition()
	if not tile then
		return false
	end

	origin:sendDistanceEffect(brainHeadPosition, CONST_ANI_HOLY)
	brainHeadPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	if tile:getTopCreature() and tile:getTopCreature():isMonster() then
		if tile:getTopCreature():getName():lower() == "brain head" then
			tile:getTopCreature():addHealth(math.random(300, 500))
		end
	end
	return true
end

spell:name("heal brain head")
spell:words("###6051")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(false)
spell:needLearn(true)
spell:register()
