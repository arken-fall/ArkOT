local doorPosition = Position(32177, 32148, 11)
local relocatePosition = Position(32178, 32148, 11)

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1946 then
		local doorItem = Tile(doorPosition):getItemById(5108)
		if doorItem then
			doorItem:transform(5109)
			doorItem:setActionId(1002)
			item:transform(1945)
		end
	else
		local tile = Tile(doorPosition)
		local doorItem = tile:getItemById(5109)
		if doorItem then
			tile:relocateTo(relocatePosition, true)

			doorItem:transform(5108)
			doorItem:setActionId(1001)
			item:transform(1946)
		end
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5637)
-- The map gives this lever no action id, so the aid above never matches and
-- the quest simply did nothing. Registering the katana room lever's tile as
-- well makes it work without a map edit; the aid stays so that setting it
-- later also works, and nothing else on the map uses 5637.
realmapEvent1:position(Position(32182, 32145, 11))
realmapEvent1:register()
