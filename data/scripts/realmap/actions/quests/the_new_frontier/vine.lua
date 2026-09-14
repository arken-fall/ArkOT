local config = {
	[3153] = Position(33022, 31536, 6),
	[3154] = Position(33020, 31536, 4)
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.uid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(3153, 3154)
realmapEvent1:register()
