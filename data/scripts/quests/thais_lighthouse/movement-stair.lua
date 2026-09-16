local stairPosition = { x = 32225, y = 32282, z = 9 }

local stair = ItemEvent()
stair:type("stepon")

function stair.onStepOn(creature, item, position, fromPosition)
	-- Create stairs
	if item.uid == 25010 then
		local stairsItem = Tile(stairPosition):getItemById(429)
		if stairsItem then
			stairsItem:transform(7767)
		end
		item:transform(430)
	end
	return true
end

stair:uid(25010)
stair:register()

stair = ItemEvent()
stair:type("stepoff")

function stair.onStepOff(creature, item, position, fromPosition)
	local stairsItem = Tile(stairPosition):getItemById(7767)
	if stairsItem then
		stairsItem:transform(429)
	end

	item:transform(431)
	return true
end

stair:uid(25010)
stair:register()
