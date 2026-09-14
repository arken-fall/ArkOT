local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FountainOfLife) == 1 then
		return false
	end

	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())
	player:addAchievement('Fountain of Life')
	player:setStorageValue(Storage.FountainOfLife, 1)
	player:say('You feel very refreshed and relaxed.', TALKTYPE_MONSTER_SAY)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:aid(8815)
realmapEvent1:register()
