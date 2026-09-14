local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission02) ~= 1 then
		return true
	end

	Game.createItem(2346, 1, fromPosition)
	player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 2)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a tear of daraman.")
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5390)
realmapEvent1:register()
