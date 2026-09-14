local wallPositions = {
	Position(32186, 31626, 8),
	Position(32187, 31626, 8),
	Position(32188, 31626, 8),
	Position(32189, 31626, 8)
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wallItem
	for i = 1, #wallPositions do
		wallItem = Tile(wallPositions[i]):getItemById(1498)
		if wallItem then
			wallItem:getPosition():sendMagicEffect(CONST_ME_POFF)
			wallItem:remove()
		end
	end

	item:remove()
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(4210)
realmapEvent1:register()
