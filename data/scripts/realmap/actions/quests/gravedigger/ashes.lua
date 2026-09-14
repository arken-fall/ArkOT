local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4638 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission28) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission29) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission29, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The ashes swirl with a life of their own, mixing with the sparks of the altar.')
		item:remove(1)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(21446)
realmapEvent1:register()
