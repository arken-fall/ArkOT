local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4995 and target.uid == 3000 and player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 5 then
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 6)
		player:addItem(4848, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(4856)
realmapEvent1:register()
