local function doTransformSmallSnakeHead(fromId, toId)
	local tile = Position(32034, 32272, 8):getTile()
	if tile then
		local thing = tile:getItemById(fromId)
		if thing then
			thing:transform(toId)
		end
	end
end

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		doTransformSmallSnakeHead(5058, 5057)
	else
		doTransformSmallSnakeHead(5057, 5058)
	end
	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(50081)
realmapEvent1:register()
