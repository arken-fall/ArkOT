local function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	item:transform(item.itemid == 1945 and 1946 or 1945)

	if item.itemid ~= 1945 then
		return true
	end

	local stoneItem = Tile(Position(32826, 32274, 11)):getItemById(1285)
	if stoneItem then
		stoneItem:remove()
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(3304)
realmapEvent1:register()
