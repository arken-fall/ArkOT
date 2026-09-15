local mType = Game.createMonsterType("True Frost Flower Asura")
local monster = {}

monster.description = "a true frost flower asura"
monster.experience = 7069
monster.outfit = {
	lookType = 1068,
	lookHead = 9,
	lookBody = 0,
	lookLegs = 86,
	lookFeet = 9,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1622
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Asura Palace, Asura Vaults",
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 28667
monster.speed = 150
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
	targetDistance = 3,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 3
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
	{ id = 2160, chance = 7380, maxCount = 1 },
	{ id = 2152, chance = 100000, maxCount = 8 },
	{ id = 6558, chance = 19790 },
	{ id = 7591, chance = 21030, maxCount = 2 },
	{ id = 2145, chance = 11900, maxCount = 2 },
	{ id = 2149, chance = 16000, maxCount = 2 },
	{ id = 2146, chance = 10970, maxCount = 2 },
	{ id = 2147, chance = 8000, maxCount = 2 },
	{ id = 9970, chance = 8510, maxCount = 2 },
	{ id = 2158, chance = 1160 },
	{ id = 6500, chance = 15280 },
	{ id = 24630, chance = 12080 },
	{ id = 24637, chance = 920 },
	{ id = 24631, chance = 10510 },
	{ id = 2134, chance = 9640 },
	{ id = 5944, chance = 18670 },
	{ id = 8902, chance = 940 },
	{ id = 7759, chance = 9640, maxCount = 3 },
	{ id = 2656, chance = 1540 },
	{ id = 31758, chance = 4000, maxCount = 3 },
	{ id = 7368, chance = 9640, maxCount = 5 },
	{ id = 3967, chance = 3590 },
	{ id = 9971, chance = 2380 },
	{ id = 2144, chance = 10360, maxCount = 2 },
	{ id = 2154, chance = 4510 },
	{ id = 2143, chance = 8620, maxCount = 2 },
	{ id = 8911, chance = 3180 },
	{ id = 2170, chance = 2260 },
	{ id = 7404, chance = 730 },
	{ id = 8889, chance = 730 },
	{ id = 2183, chance = 1030 },
	{ id = 2124, chance = 820 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = -75,
		maxDamage = -550,
		condition = { type = CONDITION_FREEZING, interval = 4000, minDamage = 400, maxDamage = 400 },
	},
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -75, maxDamage = -300, range = 7, target = false },
	{
		name = "combat",
		interval = 1000,
		chance = 10,
		type = COMBAT_ICEDAMAGE,
		minDamage = -600,
		maxDamage = -820,
		length = 8,
		spread = 0,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -130,
		maxDamage = -330,
		length = 8,
		spread = 0,
		effect = CONST_ME_PURPLEENERGY,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 15, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000, speed = -100 },
}

monster.defenses = {
	defense = 55,
	armor = 72,
	mitigation = 2.11,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
