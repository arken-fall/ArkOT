local mType = Game.createMonsterType("Sopping Corpus")
local monster = {}

monster.description = "a sopping corpus"
monster.experience = 22465
monster.outfit = {
	lookType = 1659,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2397
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Jaded Roots.",
}

monster.health = 33400
monster.maxHealth = 33400
monster.race = "undead"
monster.corpse = 43836
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 0,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 0
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "*Lessshhh!*", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 42860 },
	{ id = 26029, chance = 42860, minCount = 2, maxCount = 3 },
	{ id = 7385, chance = 14290 },
	{ id = 8473, chance = 14290, maxCount = 2 },
	{ id = 44039, chance = 13133, maxCount = 1 },
	{ id = 2127, chance = 8558, maxCount = 1 },
	{ id = 8910, chance = 8380, maxCount = 1 },
	{ id = 2153, chance = 5084, maxCount = 1 },
	{ id = 2158, chance = 9808, maxCount = 1 },
	{ id = 7383, chance = 6964, maxCount = 1 },
	{ id = 8889, chance = 7270, maxCount = 1 },
	{ id = 26187, chance = 3073, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1600 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -1300,
		maxDamage = -1600,
		length = 8,
		spread = 3,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -1200,
		maxDamage = -1500,
		effect = CONST_ME_BIG_SCRATCH,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -1400,
		maxDamage = -1600,
		radius = 5,
		effect = CONST_ME_GROUNDSHAKER,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1200,
		maxDamage = -1500,
		length = 8,
		spread = 3,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
	{ name = "largepoisonring", interval = 2000, chance = 10, minDamage = -1000, maxDamage = -1200, target = false },
}

monster.defenses = {
	defense = 112,
	armor = 112,
	mitigation = 3.25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
