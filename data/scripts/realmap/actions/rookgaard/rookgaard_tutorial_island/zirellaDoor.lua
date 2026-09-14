local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local player= player
	if item.itemid == 6898 then
		if player:getStorageValue(Storage.RookgaardTutorialIsland.ZirellaNpcGreetStorage) > 7 then
			item:transform(item.itemid + 1)
			player:teleportTo(toPosition, true)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
		end
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(50085)
realmapEvent1:register()
