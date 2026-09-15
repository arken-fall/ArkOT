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

local function clientItem(appearance)
	local itemId = Game.getItemIdByClientId(appearance)
	return itemId ~= nil and itemId > 0 and itemId or nil
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

-- Consumables: delivered to the store inbox by the engine
local consumables = store:category("Consumables", "Category_Consumables.png")
local consumableList = {
	{ 4001, "Ultimate Health Potion", 40, 23375, 100, "One hundred ultimate health potions, delivered to your store inbox." },
	{ 4002, "Great Mana Potion", 30, 23373, 100, "One hundred great mana potions, delivered to your store inbox." },
	{ 4003, "Ultimate Spirit Potion", 40, 23374, 100, "One hundred ultimate spirit potions, delivered to your store inbox." },
	{ 4004, "Sudden Death Rune", 60, 3155, 100, "One hundred sudden death runes, delivered to your store inbox." },
	{ 4005, "Avalanche Rune", 40, 3161, 100, "One hundred avalanche runes, delivered to your store inbox." },
	{ 4006, "Stamina Extension", 20, 3722, 1, "A stamina extension that restores two hours of stamina when used." },
}
for _, entry in ipairs(consumableList) do
	local id, name, price, appearance, count, description = table.unpack(entry)
	local itemId = clientItem(appearance)
	if itemId then
		consumables:product(id, name, price, "", description, { item = itemId, count = count, home = id == 4001 })
	end
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
