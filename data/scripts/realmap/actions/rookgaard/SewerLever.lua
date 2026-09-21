local config = {
	bridgePositions = {
		{position = Position(32099, 32205, 8), groundId = 9022, itemId = 4645},
		{position = Position(32100, 32205, 8), groundId = 4616},
		{position = Position(32101, 32205, 8), groundId = 9022, itemId = 4647}
	},
	leverPositions = {
		Position(32098, 32204, 8),
		Position(32104, 32204, 8)
	},
	relocatePosition = Position(32102, 32205, 8),
	relocateMonsterPosition = Position(32103, 32205, 8),
	bridgeId = 5770
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local leverLeft, lever = item.itemid == 1945
	for i = 1, #config.leverPositions do
		lever = Tile(config.leverPositions[i]):getItemById(leverLeft and 1945 or 1946)
		if lever then
			lever:transform(leverLeft and 1946 or 1945)
		end
	end

	local tile, tmpItem, bridge
	if leverLeft then
		for i = 1, #config.bridgePositions do
			bridge = config.bridgePositions[i]
			tile = Tile(bridge.position)

			tmpItem = tile:getGround()
			if tmpItem then
				tmpItem:transform(config.bridgeId)
			end

			if bridge.itemId then
				tmpItem = tile:getItemById(bridge.itemId)
				if tmpItem then
					tmpItem:remove()
				end
			end
		end
	else
		for i = 1, #config.bridgePositions do
			bridge = config.bridgePositions[i]
			tile = Tile(bridge.position)

			tile:relocateTo(config.relocatePosition, true, config.relocateMonsterPosition)
			tile:getGround():transform(bridge.groundId)

			-- the middle tile is open water and configures no itemId; asking for
			-- a nil one used to create a nameless item here, because createItem
			-- falls back to a lookup by name and nil reads as the empty string
			if bridge.itemId then
				Game.createItem(bridge.itemId, 1, bridge.position)
			end
		end

	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(50239)
realmapEvent1:register()
