local mType = Game.createMonsterType("Feral Werecrocodile")
local monster = {}

monster.description = "a feral werecrocodile"
monster.experience = 5430
monster.outfit = {
	lookType = 1647,
	lookHead = 116,
	lookBody = 95,
	lookLegs = 19,
	lookFeet = 21,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2389
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

monster.health = 6400
monster.maxHealth = 6400
monster.race = "blood"
monster.corpse = 43767
monster.speed = 110
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
	{ id = 2152, chance = 100000, maxCount = 21 },
	{ id = 43922, chance = 10800 },
	{ id = 2391, chance = 5000 },
	{ id = 2671, chance = 5500, maxCount = 2 },
	{ id = 24739, chance = 3000 },
	{ id = 2153, chance = 1370 },
	{ id = 18415, chance = 2800 },
	{ id = 15644, chance = 680 },
	{ id = 7884, chance = 2190 },
	{ id = 43927, chance = 1820 },
	{ id = 43930, chance = 680 },
	{ id = 8880, chance = 230 },
	{ id = 44105, chance = 200 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -50, maxDamage = -485 },
	{
		name = "combat",
		interval = 3400,
		chance = 33,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -300,
		maxDamage = -450,
		length = 7,
		spread = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2700,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -300,
		maxDamage = -450,
		radius = 3,
		effect = CONST_ME_MORTAREA,
		shootEffect = CONST_ANI_DEATH,
		range = 4,
		target = true,
	},
	{
		name = "combat",
		interval = 3300,
		chance = 30,
		type = COMBAT_LIFEDRAIN,
		minDamage = -175,
		maxDamage = -350,
		radius = 1,
		effect = CONST_ME_MAGIC_RED,
		range = 1,
		target = true,
	},
	{ name = "werecrocodile fire ring", interval = 4100, chance = 25, minDamage = -275, maxDamage = -350, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 82,
	mitigation = 2.28,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 60 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
