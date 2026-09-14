local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.BigfootBurden.GrindstoneStatus) == 1 or player:getStorageValue(Storage.BigfootBurden.MissionGrindstoneHunt) ~= 1 then
		return false
	end

	toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
	item:transform(18335)

	if math.random(15) ~= 15 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You had no luck this time.')
		return true
	end

	player:setStorageValue(Storage.BigfootBurden.GrindstoneStatus, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your skill allowed you to grab a whetstone before the stone sinks into lava.')
	player:addItem(18337, 1)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(18336)
realmapEvent1:register()
