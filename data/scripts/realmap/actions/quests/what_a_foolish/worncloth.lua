local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4204 then
		return false
	end

	if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) ~= 34
			or player:getStorageValue(Storage.WhatAFoolishQuest.OldWornCloth) == 1 then
		return false
	end

	player:setStorageValue(Storage.WhatAFoolishQuest.OldWornCloth, 1)
	player:say('Amazing! That was quite fast!', TALKTYPE_MONSTER_SAY)
	toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
	item:transform(7501)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7500)
realmapEvent1:register()
