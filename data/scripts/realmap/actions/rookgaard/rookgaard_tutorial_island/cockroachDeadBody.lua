local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local owner = item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
	if owner ~= nil and Player(owner) and player.uid ~= owner then
		return
	end

	if player:getStorageValue(Storage.RookgaardTutorialIsland.cockroachBodyMsgStorage) ~= 1 then
		player:sendTutorial(9)
		player:setStorageValue(Storage.RookgaardTutorialIsland.cockroachBodyMsgStorage, 1)
	end
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:id(8593)
realmapEvent1:register()
