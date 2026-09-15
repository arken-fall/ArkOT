local mType = Game.createMonsterType("True Midnight Asura")
local monster = {}

monster.description = "a true midnight asura"
monster.experience = 7313
monster.outfit = {
	lookType = 1068,
	lookHead = 0,
	lookBody = 76,
	lookLegs = 53,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1621
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Asura Palace, Asura Vaults.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 28617
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2153, chance = 1390 },
	{ id = 2160, chance = 5760, maxCount = 1 },
	{ id = 31758, chance = 4090, maxCount = 3 },
	{ id = 2152, chance = 100000, maxCount = 8 },
	{ id = 7368, chance = 9210, maxCount = 5 },
	{ id = 2144, chance = 9870, maxCount = 2 },
	{ id = 6558, chance = 20540 },
	{ id = 6500, chance = 10730 },
	{ id = 2145, chance = 15630, maxCount = 2 },
	{ id = 2149, chance = 7750, maxCount = 2 },
	{ id = 2147, chance = 7830, maxCount = 2 },
	{ id = 2146, chance = 12690, maxCount = 2 },
	{ id = 9970, chance = 8120, maxCount = 2 },
	{ id = 7591, chance = 19960, maxCount = 2 },
	{ id = 2143, chance = 8170, maxCount = 2 },
	{ id = 7404, chance = 980 },
	{ id = 2158, chance = 1020 },
	{ id = 2656, chance = 900 },
	{ id = 9971, chance = 900 },
	{ id = 24630, chance = 12440 },
	{ id = 2185, chance = 3610 },
	{ id = 24637, chance = 1820 },
	{ id = 24631, chance = 12790 },
	{ id = 8889, chance = 930 },
	{ id = 2134, chance = 10060 },
	{ id = 2170, chance = 2020 },
	{ id = 5944, chance = 10020 },
	{ id = 8902, chance = 900 },
	{ id = 3967, chance = 2290 },
	{ id = 8910, chance = 990 },
	{ id = 2154, chance = 900 },
	{ id = 2124, chance = 930 },
	{ id = 7762, chance = 1441, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -500,
		maxDamage = -650,
		range = 5,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -280, range = 7, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -240,
		length = 8,
		spread = 0,
		effect = CONST_ME_PURPLEENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -500,
		maxDamage = -700,
		length = 8,
		spread = 0,
		effect = CONST_ME_BLACKSMOKE,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 15, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000, speed = -100 },
}

monster.defenses = {
	defense = 55,
	armor = 75,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
