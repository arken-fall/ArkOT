local walls = {
	{position = Position(33148, 32867, 9), relocatePosition = Position(33148, 32869, 9)},
	{position = Position(33148, 32868, 9), relocatePosition = Position(33148, 32869, 9)},
	{position = Position(33149, 32867, 9), relocatePosition = Position(33149, 32869, 9)},
	{position = Position(33149, 32868, 9), relocatePosition = Position(33149, 32869, 9)}
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local wallItem
		for i = 1, #walls do
			wallItem = Tile(walls[i].position):getItemById(1498)
			if wallItem then
				wallItem:remove()
			end
		end

		item:transform(1946)
	else
		local wall
		for i = 1, #walls do
			wall = walls[i]
			Tile(wall.position):relocateTo(wall.relocatePosition)
			Game.createItem(1498, 1, wall.position)
		end

		item:transform(1945)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5633)
realmapEvent1:register()
