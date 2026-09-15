local mType = Game.createMonsterType("Cave Chimera")
local monster = {}

monster.description = "a cave chimera"
monster.experience = 6800
monster.outfit = {
	lookType = 1406,
	lookHead = 60,
	lookBody = 77,
	lookLegs = 64,
	lookFeet = 70,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2096
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Dwelling of the Forgotten",
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 36768
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
	staticAttackChance = 70,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 3,
	color = 100,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 24 },
	{ id = 8472, chance = 25220, maxCount = 2 },
	{ id = 8473, chance = 20000, maxCount = 4 },
	{ id = 9971, chance = 19130, maxCount = 2 },
	{ id = 18414, chance = 6090, maxCount = 3 },
	{ id = 2153, chance = 6960, maxCount = 1 },
	{ id = 39225, chance = 4350 },
	{ id = 39224, chance = 3480 },
	{ id = 7632, chance = 1740 },
	{ id = 2154, chance = 2660 },
	{ id = 7888, chance = 2480 },
	{ id = 26185, chance = 1720 },
	{ id = 7896, chance = 1540 },
	{ id = 2179, chance = 1430 },
	{ id = 24741, chance = 970 },
	{ id = 30499, chance = 970 },
	{ id = 15644, chance = 850 },
	{ id = 18453, chance = 180 },
	{ id = 8855, chance = 100 },
	{ id = 7438, chance = 80 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -600,
		maxDamage = -700,
		range = 4,
		radius = 3,
		shootEffect = CONST_ANI_HOLY,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 60,
		type = COMBAT_ICEDAMAGE,
		minDamage = -560,
		maxDamage = -650,
		radius = 4,
		effect = CONST_ME_BLUE_ENERGY_SPARK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_ICEDAMAGE,
		minDamage = -750,
		maxDamage = -850,
		range = 4,
		shootEffect = CONST_ANI_ICE,
		target = true,
	},
}

monster.defenses = {
	defense = 60,
	armor = 60,
	mitigation = 1.88,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
