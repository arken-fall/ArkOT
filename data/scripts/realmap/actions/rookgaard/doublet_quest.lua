local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.QuestChests.DoubletQuest) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The loose board is empty.')
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a doublet.')
		player:addItem(2485, 1)
		player:setStorageValue(Storage.QuestChests.DoubletQuest, 1)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(5639)
realmapEvent1:register()
