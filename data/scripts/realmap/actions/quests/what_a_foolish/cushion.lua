local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4202 then
		return false
	end

	if player:getStorageValue(Storage.WhatAFoolishQuest.Questline) ~= 17
			or player:getStorageValue(Storage.WhatAFoolishQuest.WhoopeeCushion) == 1 then
		return false
	end

	player:setStorageValue(Storage.WhatAFoolishQuest.WhoopeeCushion, 1)
	player:say('*chuckles maniacally*', TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:say('Woooosh!', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	item:remove()
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7485)
realmapEvent1:register()
