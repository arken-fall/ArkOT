local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.QuestChests.BananaPalm) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The banana palm is empty.')
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a banana.')
		player:addItem(2676, 1)
		player:setStorageValue(Storage.QuestChests.BananaPalm, 1)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5641)
realmapEvent1:register()
