local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 10612 then
		return false
	end

	if player:getStorageValue(Storage.SeaOfLightQuest.Questline) ~= 8 then
		return false
	end

	player:say('You carefully put the mirror crystal into the astronomers\'s device.', TALKTYPE_MONSTER_SAY)
	player:getStorageValue(Storage.SeaOfLightQuest.Questline, 9)
	player:setStorageValue(Storage.SeaOfLightQuest.Mission3, 3)
	item:transform(10616)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(10615)
realmapEvent1:register()
