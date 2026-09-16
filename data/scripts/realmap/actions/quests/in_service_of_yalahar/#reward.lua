local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.uid == 3088) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) == 53) then
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 54)
			player:setStorageValue(Storage.InServiceofYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(9776, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari armor.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	elseif(item.uid == 3089) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) == 53) then
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 54)
			player:setStorageValue(Storage.InServiceofYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(9778, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari mask.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	elseif(item.uid == 3090) then
		if(player:getStorageValue(Storage.InServiceofYalahar.Questline) == 53) then
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 54)
			player:setStorageValue(Storage.InServiceofYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(9777, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari leg piece.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(3088, 3089, 3090)
realmapEvent1:register()
