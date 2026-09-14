local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7481 then
		return false
	end

	if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) ~= 8 then
		return false
	end

	player:getPosition():sendMagicEffect(CONST_ME_SOUND_GREEN)
	player:say('Your innocent whistle will fool them all...', TALKTYPE_MONSTER_SAY)
	toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
	item:transform(item.itemid + 1)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7482)
realmapEvent1:register()
