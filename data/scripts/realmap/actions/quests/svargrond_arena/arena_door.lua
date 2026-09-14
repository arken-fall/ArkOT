local storages = {
	[26100] = Storage.SvargrondArena.Greenhorn,
	[27100] = Storage.SvargrondArena.Scrapper,
	[28100] = Storage.SvargrondArena.Warlord
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Cannot use opened door
	if item.itemid == 5133 then
		return false
	end

	if player:getStorageValue(Storage.SvargrondArena.Arena) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
		return true
	end

	-- Doors to rewards
	local cStorage = storages[item.actionid]
	if cStorage then
		if player:getStorageValue(cStorage) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s locked.')
			return true
		end

		item:transform(item.itemid + 1)
		player:teleportTo(toPosition, true)

	-- Arena entrance doors
	else
		if player:getStorageValue(Storage.SvargrondArena.Pit) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
			return true
		end

		item:transform(item.itemid + 1)
		player:teleportTo(toPosition, true)
	end

	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(13100, 26100, 27100, 28100)
realmapEvent1:register()
