local config = {
	[12501] = Position(32336, 31813, 6), -- to the room
	[12502] = Position(32337, 31815, 7) -- outside the room
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)

	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(12501, 12502)
realmapEvent1:register()
