local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission53) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission54) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission54, 1)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission55, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Somebody left a card. It says: Looking for the scroll? Come find me. Take the stairs next to the students. Dorm.')
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(4662)
realmapEvent1:register()
