local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12503 then
		return false
	end

	if math.random(100) <= 15 then
		if player:getStorageValue(Storage.thievesGuild.Mission02) == 1 then
			player:addItem(8760, 1)
			player:setStorageValue(Storage.thievesGuild.Mission02, 2)
		end
	else
		item:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your lock pick broke.")
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(8717)
realmapEvent1:register()
