local upFloorIds = {23668}
local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if isInArray(upFloorIds, item.itemid) == true then
		fromPosition.x = fromPosition.x + 1
		fromPosition.z = fromPosition.z - 2
	end
	player:teleportTo(fromPosition, false)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(23668)
realmapEvent1:register()
