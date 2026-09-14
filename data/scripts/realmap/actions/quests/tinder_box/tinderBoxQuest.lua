-- <action uniqueid="6000" script="quests/tinderBoxQuest.lua"/>

local config = {
	storage = 12450,
	hours = 20,
	item_id = 22728,
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(config.storage) >= os.time() then
		return player:sendCancelMessage("The pile of bones is empty.")
	end

	player:addItem(config.item_id, 1)
	player:setStorageValue(config.storage, os.time() + config.hours * 3600)

	return player:sendTextMessage(MESSAGE_INFO_DESCR, "You have found a tinder box.")
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(21137)
realmapEvent1:register()
