local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 5745 then
		return false
	end

	--if player:getStorageValue(Storage.OutfitQuest.firstOrientalAddon) ~= 1 or player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 150 or 146, 1) then
	--	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The door seems to be sealed against unwanted intruders.')
	--	return true
	--end

	item:transform(item.itemid + 1)
	player:teleportTo(toPosition, true)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(50161)
realmapEvent1:register()
