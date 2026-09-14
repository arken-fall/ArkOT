local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4637 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission27) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission28) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission28, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The flame wavers as it engulfs the chalk. Strange ashes appear beside it.')
		Game.createItem(21446, 1, Position(32983, 32376, 11))
		item:remove(1)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(21247)
realmapEvent1:register()
