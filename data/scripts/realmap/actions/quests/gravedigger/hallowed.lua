local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4634 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission19) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission20) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission20, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The flames roar and eat the bone hungrily. The Dark Lord is satisfied with your gift')
		item:remove()
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(21406)
realmapEvent1:register()
