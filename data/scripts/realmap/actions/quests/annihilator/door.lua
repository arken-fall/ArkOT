local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.AnnihilatorDone) ~= 1 then
		if item.itemid == 5114 then
			player:teleportTo(toPosition, true)
			item:transform(item.itemid + 1)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(2214)
realmapEvent1:register()
