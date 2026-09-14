local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 57 then
		player:setStorageValue(Storage.ExplorerSociety.QuestLine, 58)
		Game.createItem(7314, 1, player:getPosition())
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(3017)
realmapEvent1:register()
