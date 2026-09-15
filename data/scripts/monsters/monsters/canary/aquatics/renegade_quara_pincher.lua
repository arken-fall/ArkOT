local mType = Game.createMonsterType("Renegade Quara Pincher")
local monster = {}

monster.description = "a renegade quara pincher"
monster.experience = 2200
monster.outfit = {
	lookType = 77,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1100
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 2,
	locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 6063
monster.speed = 198
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 80000, maxCount = 5 },
	{ id = 12446, chance = 18800, maxCount = 1 },
	{ id = 7590, chance = 9720, maxCount = 2 },
	{ id = 7591, chance = 9010, maxCount = 2 },
	{ id = 2147, chance = 9010, maxCount = 2 },
	{ id = 2145, chance = 7060, maxCount = 2 },
	{ id = 2178, chance = 6140 },
	{ id = 2156, chance = 5120 },
	{ id = 2670, chance = 4810, maxCount = 5 },
	{ id = 15649, chance = 3790, maxCount = 5 },
	{ id = 7632, chance = 1430 },
	{ id = 2475, chance = 1430 },
	{ id = 5895, chance = 920 },
	{ id = 2487, chance = 611 },
	{ id = 2169, chance = 410 },
	{ id = 2151, chance = 310 },
	{ id = 7897, chance = 200 },
	{ id = 13305, chance = 100 },
	{ id = 12613, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 60, effect = CONST_ME_DRAWBLOOD },
	{ name = "speed", interval = 2000, chance = 20, range = 1, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000, speed = -300 },
}

monster.defenses = {
	defense = 50,
	armor = 85,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
