local annihilatorReward = {1990, 2400, 2431, 2494}

-- Chests this script owns by item id but the map never identified. Registering
-- a tile position elsewhere would not reach them: the event lookup takes item
-- id before position, so questChest:id(1740) wins and a position-registered
-- script never runs. Keyed here instead, where that ownership already is.
--
-- Rookgaard's bear room chest holds a copper key whose action id is what the
-- door answers to. The chest already contains one; this hands it over once per
-- player rather than leaving it to be emptied repeatedly.
--
-- Each entry lists what the chest gives. Counts are for stackables; actionId is
-- for keys, where the action id is the number the door answers to and the key
-- opens nothing without it.
--
-- Which Bear Room chest holds which reward is a choice: the quest's four
-- rewards were given as one list and there are three empty chests behind the
-- locked door, so the arrows and the gold share the last one. Moving them
-- between chests is just moving lines.
local chestsByTile = {
	-- Bear Room, behind the door the copper key opens
	["32141:32097:11"] = {storage = 33500, items = {{id = 2464}}},                          -- chain armor
	["32144:32096:11"] = {storage = 33501, items = {{id = 2460}}},                          -- brass helmet
	["32146:32097:11"] = {storage = 33502, items = {{id = 2544, count = 12},                -- 12 arrows
	                                                {id = 2148, count = 40}}},              -- 40 gold
	-- the chest that holds the key to that door
	["32150:32112:12"] = {storage = 33531, items = {{id = 2089, actionId = 4601}}},          -- copper key
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

		-- Weighed before anything is created, so a player who cannot carry the
		-- reward keeps the chance to come back for it rather than losing it.
		local weight = 0
		for _, entry in ipairs(byTile.items) do
			weight = weight + ItemType(entry.id):getWeight(entry.count or 1)
		end

		if player:getFreeCapacity() < weight then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have found a treasure weighing %.2f oz. It is too heavy.", weight / 100))
			return true
		end

		local names = {}
		for _, entry in ipairs(byTile.items) do
			local count = entry.count or 1
			local reward = player:addItem(entry.id, count)
			if not reward then
				player:sendCancelMessage("You have no room to take it.")
				return true
			end

			-- A key's action id is what makes it fit its door.
			if entry.actionId then
				reward:setActionId(entry.actionId)
			end

			local itemType = ItemType(entry.id)
			if count > 1 then
				names[#names + 1] = count .. " " .. itemType:getPluralName()
			elseif itemType:getArticle() ~= "" then
				names[#names + 1] = itemType:getArticle() .. " " .. itemType:getName()
			else
				names[#names + 1] = itemType:getName()
			end
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. table.concat(names, " and ") .. ".")
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
