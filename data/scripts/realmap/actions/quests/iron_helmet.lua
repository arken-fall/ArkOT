local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position({ x = 32780 , y = 32231 , z = 8}))
	if item.itemid == 1945 then
		if tile:getItemById(387) then
			tile:getItemById(387):remove()
			item:transform(1946)
		else
			Game.createItem(387, 1, { x = 32780 , y = 32231 , z = 8})
		end
	else
		Game.createItem(387, 1, { x = 32780 , y = 32231 , z = 8})
		item:transform(1945)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(9177)
realmapEvent1:register()
