local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3018 then
		if player:getStorageValue(Storage.ExplorerSociety.QuestLine) == 60 then
			player:setStorageValue(Storage.ExplorerSociety.QuestLine, 61)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(7281)
realmapEvent1:register()
