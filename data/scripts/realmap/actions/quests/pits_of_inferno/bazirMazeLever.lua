local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local portal = Tile(Position(32816, 32345, 13)):getItemById(1387)
	if not portal then
		local item = Game.createItem(1387, 1, Position(32816, 32345, 13))
		if item:isTeleport() then
			item:setDestination(Position(32767, 32366, 15))
		end
	else
		portal:remove()
	end
	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(50105)
realmapEvent1:register()
