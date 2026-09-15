local mType = Game.createMonsterType("Werecrocodile")
local monster = {}

monster.description = "a werecrocodile"
monster.experience = 4140
monster.outfit = {
	lookType = 1647,
	lookHead = 95,
	lookBody = 117,
	lookLegs = 4,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2388
monster.bestiary = {
	race = "Lycanthrope",
	class = "Lycanthrope",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Murky Caverns",
}

monster.health = 5280
monster.maxHealth = 5280
monster.race = "blood"
monster.corpse = 43754
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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

monster.voices = {}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2152, chance = 100000, maxCount = 13 },
	{ id = 43922, chance = 10800 },
	{ id = 2409, chance = 5910 },
	{ id = 3982, chance = 8530 },
	{ id = 2666, chance = 5500, maxCount = 4 },
	{ id = 9970, chance = 9120, maxCount = 4 },
	{ id = 24739, chance = 3000 },
	{ id = 2156, chance = 5120 },
	{ id = 18415, chance = 2800 },
	{ id = 7428, chance = 500 },
	{ id = 7454, chance = 2190 },
	{ id = 43927, chance = 1770 },
	{ id = 44105, chance = 200 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -575 },
	{
		name = "combat",
		interval = 2700,
		chance = 37,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -175,
		maxDamage = -325,
		radius = 1,
		effect = CONST_ME_BIG_SCRATCH,
		range = 1,
		target = true,
	},
	{
		name = "combat",
		interval = 3300,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -200,
		maxDamage = -375,
		length = 6,
		spread = 3,
		effect = CONST_ME_BLACKSMOKE,
		target = false,
	},
	{
		name = "combat",
		interval = 3700,
		chance = 25,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -250,
		maxDamage = -400,
		radius = 2,
		range = 4,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 30,
	armor = 82,
	mitigation = 2.28,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
