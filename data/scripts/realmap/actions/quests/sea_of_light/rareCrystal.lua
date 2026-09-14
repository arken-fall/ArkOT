local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4224 then
		return false
	end

	if player:getStorageValue(Storage.SeaOfLightQuest.Questline) ~= 7 then
		return false
	end

	player:setStorageValue(Storage.SeaOfLightQuest.Questline, 8)
	player:setStorageValue(Storage.SeaOfLightQuest.Mission3, 2)
	local destination = Position(32017, 31730, 8)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	item:remove()
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(10614)
realmapEvent1:register()
