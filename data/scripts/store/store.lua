-- The in-game store. Coins live on the account (accounts.coins); this file
-- only describes the shelves. Items, outfits and mounts are delivered by the
-- engine; a category with an onPurchase callback delivers itself.
--
-- category:product(id, name, price, icon, description, options) where
-- options may carry item = <server item id>, count = n,
-- outfit = { male = looktype, female = looktype, addons = n }, mount = id,
-- transferable = true (priced in transferable coins), home = true (front
-- page), state = STORE_STATE_NEW, enabled = false.

STORE_STATE_NONE = 0
STORE_STATE_NEW = 1
STORE_STATE_SALE = 2
STORE_STATE_TIMED = 3

local store = StoreWindow("Arkenfall Store")
store:accountType(ACCOUNT_TYPE_NORMAL)

-- hands a list of { itemId, count } to the store inbox; stacks split at 100
local function giveToInbox(player, items)
	local inbox = player:getStoreInbox()
	if not inbox then
		return false
	end
	for _, entry in ipairs(items) do
		local itemId, count = entry[1], entry[2] or 1
		local itemType = ItemType(itemId)
		if itemType:isStackable() then
			while count > 0 do
				local batch = math.min(count, 100)
				local item = inbox:addItem(itemId, batch, -1, FLAG_NOLIMIT)
				if item then item:setStoreItem(true) end
				count = count - batch
			end
		else
			for _ = 1, count do
				local item = inbox:addItem(itemId, 1, -1, FLAG_NOLIMIT)
				if item then item:setStoreItem(true) end
			end
		end
	end
	return true
end

-- Starter kits: everything a fresh character needs for the first days
local kits = store:category("Starter Kits", "Category_Starter.png")
local kitContents = {
	[7001] = { { 2457, 1 }, { 2463, 1 }, { 2647, 1 }, { 2643, 1 }, { 2525, 1 }, { 2392, 1 }, { 1988, 1 }, { 7588, 25 }, { 2120, 1 }, { 2554, 1 } },
	[7002] = { { 2456, 1 }, { 2544, 500 }, { 2389, 50 }, { 2457, 1 }, { 2463, 1 }, { 2478, 1 }, { 2643, 1 }, { 1988, 1 }, { 7588, 25 }, { 7620, 25 }, { 2120, 1 }, { 2554, 1 } },
	[7003] = { { 2190, 1 }, { 2311, 50 }, { 2661, 1 }, { 2478, 1 }, { 2643, 1 }, { 1988, 1 }, { 7620, 50 }, { 7618, 25 }, { 2120, 1 }, { 2554, 1 } },
	[7004] = { { 2182, 1 }, { 2265, 50 }, { 2661, 1 }, { 2478, 1 }, { 2643, 1 }, { 1988, 1 }, { 7620, 50 }, { 7618, 25 }, { 2120, 1 }, { 2554, 1 } },
	[7005] = { { 2120, 1 }, { 2554, 1 }, { 2420, 1 }, { 2553, 1 }, { 2580, 1 }, { 1988, 1 } },
	[7006] = { { 2214, 2 }, { 2168, 2 }, { 2197, 2 } },
}
kits:product(7001, "Knight Starter Kit", 15, "Kit_Knight.png", "Steel helmet, plate armor and legs, leather boots, dwarven shield, fire sword, a backpack, 25 strong health potions, rope and shovel.", { home = true })
kits:product(7002, "Paladin Starter Kit", 15, "Kit_Paladin.png", "Bow, 500 arrows, 50 spears, steel helmet, plate armor, brass legs, leather boots, a backpack, 25 strong health and 25 mana potions, rope and shovel.")
kits:product(7003, "Sorcerer Starter Kit", 15, "Kit_Sorcerer.png", "Wand of vortex, 50 heavy magic missile runes, scarf, brass legs, leather boots, a backpack, 50 mana and 25 health potions, rope and shovel.")
kits:product(7004, "Druid Starter Kit", 15, "Kit_Druid.png", "Snakebite rod, 50 intense healing runes, scarf, brass legs, leather boots, a backpack, 50 mana and 25 health potions, rope and shovel.")
kits:product(7005, "Explorer's Tools", 5, "Kit_Explorer.png", "Rope, shovel, machete, pick, fishing rod and a backpack to carry them.", { home = true })
kits:product(7006, "Ring and Amulet Pack", 8, "Kit_Jewelry.png", "Two rings of healing, two life rings and two stone skin amulets.")
kits:onPurchase(function(player, productId, offerType, param)
	local contents = kitContents[productId]
	if not contents then
		return false
	end
	if not giveToInbox(player, contents) then
		return false
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your kit has been delivered to your store inbox.")
	return true
end)

-- Supplies: small bundles at small prices, delivered by the engine
local supplies = store:category("Supplies", "Category_Supplies.png")
local supplyList = {
	{ 8001, "50 Health Potions", 3, 7618, 50, "Fifty health potions, delivered to your store inbox.", true },
	{ 8002, "50 Mana Potions", 3, 7620, 50, "Fifty mana potions, delivered to your store inbox.", true },
	{ 8003, "50 Strong Health Potions", 6, 7588, 50, "Fifty strong health potions, delivered to your store inbox." },
	{ 8004, "50 Strong Mana Potions", 6, 7589, 50, "Fifty strong mana potions, delivered to your store inbox." },
	{ 8005, "50 Great Health Potions", 9, 7591, 50, "Fifty great health potions, delivered to your store inbox." },
	{ 8006, "50 Great Mana Potions", 8, 7590, 50, "Fifty great mana potions, delivered to your store inbox." },
	{ 8007, "50 Great Spirit Potions", 9, 8472, 50, "Fifty great spirit potions, delivered to your store inbox." },
	{ 8008, "100 Arrows", 1, 2544, 100, "A hundred arrows." },
	{ 8009, "100 Bolts", 1, 2543, 100, "A hundred bolts." },
	{ 8010, "25 Royal Spears", 4, 7378, 25, "Twenty-five royal spears." },
	{ 8011, "100 Heavy Magic Missile Runes", 6, 2311, 100, "A hundred heavy magic missile runes." },
	{ 8012, "100 Great Fireball Runes", 6, 2304, 100, "A hundred great fireball runes." },
	{ 8013, "100 Intense Healing Runes", 5, 2265, 100, "A hundred intense healing runes." },
	{ 8014, "50 Ultimate Healing Runes", 8, 2273, 50, "Fifty ultimate healing runes." },
	{ 8015, "50 Sudden Death Runes", 12, 2268, 50, "Fifty sudden death runes." },
	{ 8016, "Backpack", 1, 1988, 1, "A plain backpack." },
	{ 8017, "100 Ham", 1, 2671, 100, "A hundred ham, so nobody hunts hungry." },
}
for _, entry in ipairs(supplyList) do
	local id, name, price, itemId, count, description, home = table.unpack(entry)
	supplies:product(id, name, price, "", description, { item = itemId, count = count, home = home == true })
end

-- Premium time
local premium = store:category("Premium Time", "Category_Premium.png")
premium:product(1001, "30 Days of Premium Time", 250, "Premium_30.png", "Thirty days of premium time for every character on the account.", { home = true })
premium:product(1002, "90 Days of Premium Time", 700, "Premium_90.png", "Ninety days of premium time for every character on the account.")
premium:product(1003, "180 Days of Premium Time", 1300, "Premium_180.png", "Half a year of premium time for every character on the account.", { state = STORE_STATE_NEW })
premium:onPurchase(function(player, productId, offerType, param)
	local days = ({ [1001] = 30, [1002] = 90, [1003] = 180 })[productId]
	if not days then
		return false
	end
	local from = math.max(os.time(), player:getPremiumEndsAt())
	player:setPremiumEndsAt(from + days * 86400)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your account gained %d days of premium time.", days))
	return true
end)

-- Useful things
local useful = store:category("Useful Things", "Category_Useful.png")
useful:product(2001, "5 Prey Wildcards", 50, "Prey_Wildcards_5.png", "Five prey wildcards to reroll a prey slot or pick a creature outright.", { home = true })
useful:product(2002, "20 Prey Wildcards", 180, "Prey_Wildcards_20.png", "Twenty prey wildcards to reroll a prey slot or pick a creature outright.")
useful:product(2003, "Temple Teleport", 15, "Temple_Teleport.png", "Whisks your character straight to its home temple.")
useful:onPurchase(function(player, productId, offerType, param)
	if productId == 2001 or productId == 2002 then
		local amount = productId == 2001 and 5 or 20
		player:addPreyWildcards(amount)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You received %d prey wildcards.", amount))
		return true
	elseif productId == 2003 then
		if player:isPzLocked() or player:getCondition(CONDITION_INFIGHT) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot leave a fight that way.")
			return false
		end
		player:teleportTo(player:getTown():getTemplePosition())
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	return false
end)

-- Blessings
local blessings = store:category("Blessings", "Category_Blessings.png")
blessings:product(3001, "Twist of Fate", 60, "Bless_Twist.png", "Protects you from the loss of blessings on a death in player fights.")
blessings:product(3002, "All Seven Blessings", 250, "Bless_All.png", "Every blessing at once: the five of the temples, the Blood of the Mountain and the Heart of the Mountain.", { home = true })
blessings:canPurchase(function(player, productId)
	if productId == 3001 and player:hasBlessing(1) then
		return false, "You already have the Twist of Fate."
	end
	return true
end)
blessings:onPurchase(function(player, productId, offerType, param)
	if productId == 3001 then
		player:addBlessing(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received the Twist of Fate.")
		return true
	elseif productId == 3002 then
		for blessing = 1, 8 do
			player:addBlessing(blessing)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received all blessings.")
		return true
	end
	return false
end)

-- Consumables: the big bundles, delivered to the store inbox by the engine
local consumables = store:category("Consumables", "Category_Consumables.png")
local consumableList = {
	{ 4001, "100 Ultimate Health Potions", 30, 8473, 100, "A hundred ultimate health potions, delivered to your store inbox." },
	{ 4002, "100 Ultimate Mana Potions", 30, 26029, 100, "A hundred ultimate mana potions, delivered to your store inbox." },
	{ 4003, "100 Ultimate Spirit Potions", 30, 26030, 100, "A hundred ultimate spirit potions, delivered to your store inbox." },
	{ 4004, "100 Supreme Health Potions", 40, 26031, 100, "A hundred supreme health potions, delivered to your store inbox." },
	{ 4005, "100 Sudden Death Runes", 22, 2268, 100, "A hundred sudden death runes, delivered to your store inbox." },
	{ 4006, "100 Avalanche Runes", 16, 2274, 100, "A hundred avalanche runes, delivered to your store inbox." },
}
for _, entry in ipairs(consumableList) do
	local id, name, price, itemId, count, description = table.unpack(entry)
	consumables:product(id, name, price, "", description, { item = itemId, count = count })
end

-- Outfits and mounts: the engine adds them to the character
local outfits = store:category("Outfits", "Category_Outfits.png")
outfits:product(5001, "Rift Warrior Outfit", 120, "", "The rift warrior outfit with both addons.", { outfit = { male = 846, female = 845, addons = 3 }, home = true })
outfits:product(5002, "Winter Warden Outfit", 120, "", "The winter warden outfit with both addons.", { outfit = { male = 853, female = 852, addons = 3 } })
outfits:product(5003, "Arena Champion Outfit", 120, "", "The arena champion outfit with both addons.", { outfit = { male = 884, female = 885, addons = 3 } })

local mounts = store:category("Mounts", "Category_Mounts.png")
mounts:product(6001, "Racing Bird", 90, "", "A swift bird that never tires.", { mount = 1, home = true })
mounts:product(6002, "War Bear", 90, "", "A bear bred for the battlefield.", { mount = 2 })
mounts:product(6003, "Midnight Panther", 90, "", "A silent hunter of the night.", { mount = 4 })

store:register()
