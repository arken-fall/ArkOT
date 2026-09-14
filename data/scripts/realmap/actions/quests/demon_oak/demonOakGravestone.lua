local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.DemonOak.Done) == 2 then
		player:teleportTo(DEMON_OAK_REWARDROOM_POSITION)
		DEMON_OAK_REWARDROOM_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(9007)
realmapEvent1:register()
