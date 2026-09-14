local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.QuestChests.HoneyFlower) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The honeyflower patch is empty.')
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a honey flower.')
		player:addItem(2103, 1)
		player:setStorageValue(Storage.QuestChests.HoneyFlower, 1)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5640)
realmapEvent1:register()
