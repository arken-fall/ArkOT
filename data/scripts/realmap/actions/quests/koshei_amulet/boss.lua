local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 8272 then
		return false
	end

	if player:getStorageValue(Storage.SweetyCyclops.AmuletStatus) == 2 and player:getStorageValue(Storage.KosheiTheDeathless.RewardDoor) ~= 1 then
		player:removeItem(8266, 1)
		player:setStorageValue(Storage.KosheiTheDeathless.RewardDoor, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		player:say("At last.. I have it back, my precious amulet. I am glad you didn't use it! I allow you to ...ahh... enter door ...ahh", TALKTYPE_MONSTER_SAY, false, player, toPosition)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(8266)
realmapEvent1:register()
