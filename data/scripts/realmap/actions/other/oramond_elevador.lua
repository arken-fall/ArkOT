local action_id = {
	[22840] = {x = 33638, y = 31903, z = 5},
	[22841] = {x = 33638, y = 31903, z = 6},
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local action = action_id[item:getActionId()]
	
	if action then
		player:teleportTo(action, true)
	end

	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(23422, 23429)
realmapEvent1:aid(22840, 22841)
realmapEvent1:register()
