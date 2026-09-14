local config = {
	[1945] = {position = {Position(32623, 32188, 9), Position(32623, 32189, 9)}},
	[1946] = {position = {Position(32623, 32189, 9), Position(32623, 32188, 9)}}
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end


	local oven = Tile(useItem.position[1]):getTopTopItem()
	if oven and isInArray({1786, 1787}, oven.itemid) then
		oven:moveTo(useItem.position[2])
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(3400)
realmapEvent1:register()
