local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3015 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 54 then
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 55)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 3016 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 55 then
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 56)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7242)
realmapEvent1:register()
