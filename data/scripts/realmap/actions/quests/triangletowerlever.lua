local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position({x = 32566, y = 32119, z = 7}))
	if item.itemid == 1945 then
		if tile:getItemById(1025) then
			tile:getItemById(1025):remove()
			item:transform(1946)
		else
			Game.createItem(1025, 1, {x = 32566, y = 32119, z = 7})
		end
	else
		Game.createItem(1025, 1, {x = 32566, y = 32119, z = 7})
		item:transform(1945)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(50023)
realmapEvent1:register()
