local mType = Game.createMonsterType("True Dawnfire Asura")
local monster = {}

monster.description = "a true dawnfire asura"
monster.experience = 7475
monster.outfit = {
	lookType = 1068,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 79,
	lookFeet = 121,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1620
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

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 28664
monster.speed = 180
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
	{ id = 2152, chance = 100000, maxCount = 8 },
	{ id = 2160, chance = 4670, maxCount = 1 },
	{ id = 6558, chance = 30110 },
	{ id = 7590, chance = 16560, maxCount = 2 },
	{ id = 2150, chance = 6810, maxCount = 2 },
	{ id = 2145, chance = 7500, maxCount = 2 },
	{ id = 2149, chance = 18010, maxCount = 2 },
	{ id = 7760, chance = 9440, maxCount = 3 },
	{ id = 2147, chance = 11890, maxCount = 2 },
	{ id = 9970, chance = 8560, maxCount = 2 },
	{ id = 31758, chance = 4050, maxCount = 3 },
	{ id = 2158, chance = 1300 },
	{ id = 2156, chance = 3800 },
	{ id = 6300, chance = 1100 },
	{ id = 6500, chance = 22110 },
	{ id = 8871, chance = 2200 },
	{ id = 24630, chance = 11400 },
	{ id = 7899, chance = 1980 },
	{ id = 2194, chance = 2820 },
	{ id = 2663, chance = 3170 },
	{ id = 24637, chance = 2110 },
	{ id = 24631, chance = 11460 },
	{ id = 5911, chance = 3070 },
	{ id = 2133, chance = 2330 },
	{ id = 5944, chance = 20140 },
	{ id = 8902, chance = 620 },
	{ id = 2187, chance = 1440 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -700,
		condition = { type = CONDITION_FIRE, interval = 4000, minDamage = 500, maxDamage = 500 },
	},
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -300, range = 7, target = false },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -450,
		maxDamage = -830,
		length = 1,
		spread = 0,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -550,
		maxDamage = -750,
		radius = 4,
		effect = CONST_ME_BLACKSMOKE,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 15, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000, speed = -200 },
}

monster.defenses = {
	defense = 55,
	armor = 77,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
