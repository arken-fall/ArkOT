local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4640 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission31) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission32) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission32, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Reading the parchment, you identify three human tallow candles and pocket them.')
		player:addItem(21248, 3)
		item:remove(1)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(21448)
realmapEvent1:register()
