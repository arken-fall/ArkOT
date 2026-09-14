local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.WrathoftheEmperor.InterdimensionalPotion) == 1 then
		return true
	end

	player:setStorageValue(Storage.WrathoftheEmperor.InterdimensionalPotion, 1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	item:remove()
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(12328)
realmapEvent1:register()
