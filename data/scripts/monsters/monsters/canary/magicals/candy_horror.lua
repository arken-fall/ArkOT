local mType = Game.createMonsterType("Candy Horror")
local monster = {}

monster.description = "a candy horror"
monster.experience = 3000
monster.outfit = {
	lookType = 1739,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {}

monster.raceId = 2535
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Chocolate Mines.",
}

monster.health = 3100
monster.maxHealth = 3100
monster.race = "chocolate"
monster.corpse = 48267
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We will devour you ...", yell = false },
	{ text = "Wait for us, little treat ...", yell = false },
	{ text = "*Horrraa!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 30 },
	{ id = 2152, chance = 82000, maxCount = 6 },
	{ id = 7632, chance = 6510 },
	{ id = 2680, chance = 1400, maxCount = 2 },
	{ id = 46700, chance = 440, maxCount = 11 },
	{ id = 46581, chance = 2490, maxCount = 2 },
	{ id = 2153, chance = 1550 },
	{ id = 46702, chance = 1250 },
	{ id = 26191, chance = 5550 },
	{ id = 8840, chance = 1240, maxCount = 2 },
	{ id = 7419, chance = 502 },
	{ id = 2188, chance = 1840 },
	{ id = 2529, chance = 2830 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -120,
		maxDamage = -300,
		range = 6,
		radius = 3,
		effect = CONST_ME_CAKE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -120,
		maxDamage = -350,
		radius = 6,
		effect = CONST_ME_CACAO,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -120,
		maxDamage = -350,
		effect = CONST_ME_BIG_SCRATCH,
		target = false,
	},
}

monster.defenses = {
	defense = 24,
	armor = 43,
	mitigation = 1.21,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
