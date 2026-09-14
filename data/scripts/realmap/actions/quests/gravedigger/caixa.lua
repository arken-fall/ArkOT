local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission67) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission68) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission68, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found an incantation fragment.')
		player:addItem(21250, 1)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(4663)
realmapEvent1:register()
