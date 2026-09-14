local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local repairedCount = player:getStorageValue(Storage.BigfootBurden.RepairedCrystalCount)
	if repairedCount == 5 or player:getStorageValue(Storage.BigfootBurden.MissionCrystalKeeper) ~= 1 then
		return false
	end

	if target.itemid == 18307 then
		player:setStorageValue(Storage.BigfootBurden.RepairedCrystalCount, repairedCount + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have repaired a damaged crystal.')
		target:transform(18311)
		toPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	elseif isInArray({18308, 18309, 18310, 18311}, target.itemid) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is not the crystal you\'re looking for!')
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(18219)
realmapEvent1:register()
