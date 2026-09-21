-- Rookgaard's quest containers, keyed by the tile they stand on.
--
-- These boxes and corpses carry no action id and no unique id on this map, so
-- the generic quest system (system.lua, aid 2000 + uid) never sees them: a
-- player could loot them forever, or find them empty. Item events can register
-- against a tile position as well as an id, which is what this uses -- the map
-- needs no edit, and the reward is defined here rather than left lying in a
-- container anyone can empty.
--
-- Position is the last thing the event lookup tries, after unique id, action
-- id, item id and category. That is fine for everything here, because nothing
-- claims these item ids -- with one exception: the chest at 32150, 32112, 12 is
-- item 1740, which quests.lua registers globally, so it is handled there
-- instead and deliberately not listed below.
--
-- Rewards marked (stated) came from the owner's own notes. Rewards marked
-- (split) are a distribution across several containers that the notes gave as
-- one list; the totals match, which container holds which part is a choice.

local STORAGE_BASE = 33500 -- reserved block, see docs/features/rookgaard-quest-ids.md

local treasures = {
	-- Hidden treasure -- (stated) Dagger
	[Position(32102, 32235, 8)] = {
		storage = STORAGE_BASE + 30,
		items = {{id = 2379}},
	},

	-- Katana Room, key corpse -- (stated) Key 4603. Keys are copper keys whose
	-- action id is the number the door answers to, not an item id of their own.
	[Position(32176, 32132, 9)] = {
		storage = STORAGE_BASE + 10,
		items = {{id = 2089, actionId = 4603}},
	},

	-- Katana Room, reward corpse -- (stated) Katana, Viking Helmet
	[Position(32174, 32149, 11)] = {
		storage = STORAGE_BASE + 11,
		items = {{id = 2412}, {id = 2473}},
	},

	-- Dragon Corpse -- (stated) Bag containing Copper Shield and Legion Helmet
	[Position(32179, 32224, 9)] = {
		storage = STORAGE_BASE + 40,
		container = 1987,
		items = {{id = 2530}, {id = 2480}},
	},

	-- Mino Hell -- (stated) Carlin Sword, 4 Poison Arrows, 10 Arrows, Fishing
	-- Rod across three boxes; (split) which box holds which.
	[Position(32130, 32066, 12)] = {
		storage = STORAGE_BASE + 20,
		items = {{id = 2395}},
	},
	[Position(32128, 32066, 12)] = {
		storage = STORAGE_BASE + 21,
		items = {{id = 2545, count = 4}, {id = 2544, count = 10}},
	},
	[Position(32124, 32064, 12)] = {
		storage = STORAGE_BASE + 22,
		items = {{id = 2580}},
	},
}

-- Position keys cannot be looked up directly -- two Position values describing
-- the same tile are different tables -- so they are flattened to a string once
-- at load rather than compared one by one on every use.
local byTile = {}
for position, treasure in pairs(treasures) do
	byTile[string.format("%d:%d:%d", position.x, position.y, position.z)] = treasure
end

local function describe(itemType, count)
	if count > 1 then
		return count .. " " .. itemType:getPluralName()
	end

	local article = itemType:getArticle()
	if article ~= "" then
		return article .. " " .. itemType:getName()
	end

	return itemType:getName()
end

-- Weight is checked before anything is created, so a player who cannot carry
-- the reward is told so and keeps the chance to come back for it.
local function totalWeight(treasure)
	local weight = 0
	for _, entry in ipairs(treasure.items) do
		weight = weight + ItemType(entry.id):getWeight(entry.count or 1)
	end

	if treasure.container then
		weight = weight + ItemType(treasure.container):getWeight()
	end

	return weight
end

local function grant(player, treasure)
	local names = {}
	local bag

	if treasure.container then
		bag = player:addItem(treasure.container, 1)
		if not bag then
			return nil
		end
	end

	for _, entry in ipairs(treasure.items) do
		local count = entry.count or 1
		local item

		if bag then
			item = bag:addItem(entry.id, count)
		else
			item = player:addItem(entry.id, count)
		end

		if not item then
			return nil
		end

		-- A key's action id is what makes it open its door; without it the
		-- player gets a copper key that fits nothing.
		if entry.actionId then
			item:setActionId(entry.actionId)
		end

		names[#names + 1] = describe(ItemType(entry.id), count)
	end

	if bag then
		return describe(ItemType(treasure.container), 1) .. " containing " .. table.concat(names, " and ")
	end

	return table.concat(names, " and ")
end

local treasure = ItemEvent()
treasure:type("use")

function treasure.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = item:getPosition()
	local found = byTile[string.format("%d:%d:%d", position.x, position.y, position.z)]
	if not found then
		return false
	end

	if player:getStorageValue(found.storage) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. ItemType(item:getId()):getName() .. " is empty.")
		return true
	end

	local weight = totalWeight(found)
	if player:getFreeCapacity() < weight then
		player:sendCancelMessage(string.format("You have found a treasure weighing %.2f oz. You have no capacity.", weight / 100))
		return true
	end

	local result = grant(player, found)
	if not result then
		player:sendCancelMessage("You have found a treasure, but you have no room to take it.")
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. result .. ".")
	player:setStorageValue(found.storage, 1)
	return true
end

for position in pairs(treasures) do
	treasure:position(position)
end

treasure:register()
