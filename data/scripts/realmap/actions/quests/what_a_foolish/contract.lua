local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7492 then
		return false
	end

	if player:getStorageValue(Storage.WhatAFoolishQuest.Contract) ~= 1 then
		return false
	end

	player:say('You sign the contract', TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	item:remove()
	target:transform(7491)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7490)
realmapEvent1:register()
