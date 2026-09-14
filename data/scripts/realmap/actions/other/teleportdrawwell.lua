local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getActionId() ~= 1000 then
		return false
	end

	fromPosition.z = fromPosition.z + 1
	player:teleportTo(fromPosition)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(1369)
realmapEvent1:register()
