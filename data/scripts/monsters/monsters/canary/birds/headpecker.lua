local mType = Game.createMonsterType("Headpecker")
local monster = {}

monster.description = "a headpecker"
monster.experience = 12026
monster.outfit = {
	lookType = 1557,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2275
monster.bestiary = {
	race = "Bird",
	class = "Bird",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Crystal Enigma",
}

monster.health = 16300
monster.maxHealth = 16300
monster.race = "blood"
monster.corpse = 39319
monster.speed = 217
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 70,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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
}

monster.loot = {
	{ id = 2160, chance = 35160 },
	{ id = 41475, chance = 11360 },
	{ id = 41476, chance = 7620, minCount = 1, maxCount = 5 },
	{ id = 7432, chance = 5560 },
	{ id = 2684, chance = 4950, minCount = 1, maxCount = 3 },
	{ id = 2403, chance = 4260 },
	{ id = 2383, chance = 4040 },
	{ id = 2391, chance = 2290 },
	{ id = 7413, chance = 1720 },
	{ id = 2158, chance = 1560 },
	{ id = 8920, chance = 980 },
	{ id = 9971, chance = 910 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{
		name = "combat",
		interval = 2500,
		chance = 37,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -700,
		maxDamage = -1100,
		range = 1,
		effect = CONST_ME_BLACKSMOKE,
		target = true,
	},
	{
		name = "combat",
		interval = 4200,
		chance = 35,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -700,
		maxDamage = -1050,
		length = 4,
		spread = 3,
		effect = CONST_ME_SLASH,
		target = false,
	},
	{ name = "headpecker explosion", interval = 3500, chance = 35, minDamage = -700, maxDamage = -850 },
}

monster.defenses = {
	defense = 100,
	armor = 68,
	mitigation = 2.05,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
