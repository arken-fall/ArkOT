local bridgePosition = Position(32851, 32309, 11)
local relocatePosition = Position(32852, 32310, 11)
local dirtIds = { 4797, 4799 }

local drawbridge = ItemEvent()

function drawbridge.onStepOn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tile = Tile(bridgePosition)
	local lavaItem = tile:getItemById(21477)
	if lavaItem then
		lavaItem:transform(1771)
		local dirtItem
		for i = 1, #dirtIds do
			dirtItem = tile:getItemById(dirtIds[i])
			if dirtItem then
				dirtItem:remove()
			end
		end
	end
	return true
end

drawbridge:type("stepon")
drawbridge:aid(4002)
drawbridge:register()

drawbridge = ItemEvent()

function drawbridge.onStepOff(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tile = Tile(bridgePosition)
	local bridgeItem = tile:getItemById(1771)
	if bridgeItem then
		tile:relocateTo(relocatePosition)
		bridgeItem:transform(21477)

		for i = 1, #dirtIds do
			Game.createItem(dirtIds[i], 1, bridgePosition)
		end
	end
	return true
end

drawbridge:type("stepoff")
drawbridge:aid(4002)
drawbridge:register()
