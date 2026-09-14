local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 8176 then
		return false
	end

	if player:getStorageValue(Storage.TibiaTales.ultimateBoozeQuest) == 1 then
		player:setStorageValue(Storage.TibiaTales.ultimateBoozeQuest, 2)
	end
	player:removeItem(7496, 1)
	player:addItem(7495, 1)
	player:say("GULP, GULP, GULP", TALKTYPE_MONSTER_SAY, false, 0, toPosition)
	toPosition:sendMagicEffect(CONST_ME_SOUND_YELLOW)
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7496)
realmapEvent1:register()
