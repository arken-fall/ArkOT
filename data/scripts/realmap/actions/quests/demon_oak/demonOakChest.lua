local chests = {
	[9008] = {itemid = 2495, count = 1},
	[9009] = {itemid = 8905, count = 1},
	[9010] = {itemid = 16111, count = 1},
	[9011] = {itemid = 16112, count = 1}
}

local function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if chests[item.uid] then
		if player:getStorageValue(Storage.DemonOak.Done) ~= 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s empty.')
			return true
		end

		local chest = chests[item.uid]
		local itemType = ItemType(chest.itemid)
		if itemType then
			local article = itemType:getArticle()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found ' .. (#article > 0 and article .. ' ' or '') .. itemType:getName() .. '.')
		end

		player:addItem(chest.itemid, chest.count)
		player:setStorageValue(Storage.DemonOak.Done, 3)
	end

	return true
end

-- registrations generated from the pack XML by harness/build_itemevents.py
local realmapEvent1 = ItemEvent()
realmapEvent1:type("use")
realmapEvent1.onUse = onUse
realmapEvent1:uid(9008, 9009, 9010, 9011)
realmapEvent1:register()
