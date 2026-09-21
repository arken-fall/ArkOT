local annihilatorReward = {1990, 2400, 2431, 2494}

-- Chests this script owns by item id but the map never identified. Registering
-- a tile position elsewhere would not reach them: the event lookup takes item
-- id before position, so questChest:id(1740) wins and a position-registered
-- script never runs. Keyed here instead, where that ownership already is.
--
-- Rookgaard's bear room chest holds a copper key whose action id is what the
-- door answers to. The chest already contains one; this hands it over once per
-- player rather than leaving it to be emptied repeatedly.
local chestsByTile = {
	["32150:32112:12"] = {storage = 33531, itemId = 2089, actionId = 4601},
}

local questChest = ItemEvent()

questChest.onUse = function(player, item, fromPosition, target, toPosition, isHotkey)
	local position = item:getPosition()
	local byTile = chestsByTile[string.format("%d:%d:%d", position.x, position.y, position.z)]
	if byTile then
		if player:getStorageValue(byTile.storage) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
			return true
		end

		local itemType = ItemType(byTile.itemId)
		if player:getFreeCapacity() < itemType:getWeight() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. itemType:getName() .. ", but it is too heavy.")
			return true
		end

		local reward = player:addItem(byTile.itemId, 1)
		if not reward then
			player:sendCancelMessage("You have no room to take it.")
			return true
		end

		if byTile.actionId then
			reward:setActionId(byTile.actionId)
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. itemType:getArticle() .. " " .. itemType:getName() .. ".")
		player:setStorageValue(byTile.storage, 1)
		return true
	end

	if item.uid <= 1250 or item.uid >= 30000 then
		return false
	end

	local itemType = ItemType(item.uid)
	if itemType:getId() == 0 then
		return false
	end

	local itemWeight = itemType:getWeight()
	local playerCap = player:getFreeCapacity()
	local formatWeight = string.format('%.2f', itemWeight / 100)
	if table.contains(annihilatorReward, item.uid) then
		if player:getStorageValue(PlayerStorageKeys.annihilatorReward) == -1 then
			if playerCap >= itemWeight then
				if item.uid == 1990 then
					player:addItem(1990, 1):addItem(2326, 1)
				else
					player:addItem(item.uid, 1)
				end
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a ' .. itemType:getName() .. '.')
				player:setStorageValue(PlayerStorageKeys.annihilatorReward, 1)
				player:addAchievement("Annihilator")
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a ' .. itemType:getName() .. ' weighing ' .. formatWeight .. ' oz. It\'s too heavy.')
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
		end
	elseif player:getStorageValue(item.uid) == -1 then
		if playerCap >= itemWeight then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a ' .. itemType:getName() .. '.')
			player:addItem(item.uid, 1)
			player:setStorageValue(item.uid, 1)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a ' .. itemType:getName() .. ' weighing ' .. formatWeight .. ' oz. It\'s too heavy.')
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
	end
	return true
end

questChest:id(1740)
for id = 1747, 1749 do questChest:id(id) end
questChest:register()
