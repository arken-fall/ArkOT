local mType = Game.createMonsterType("Brain Squid")
local monster = {}

monster.description = "a brain squid"
monster.experience = 17672
monster.outfit = {
	lookType = 1059,
	lookHead = 17,
	lookBody = 41,
	lookLegs = 77,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1653
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Secret Library (energy section).",
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "undead"
monster.corpse = 28582
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ text = "tzzzz tzzzzz tzzzzz", yell = false },
	{ text = "tzuuuumme tzuuummmmee", yell = false },
}

monster.loot = {
	{ id = 18414, chance = 900, maxCount = 4 },
	{ id = 2152, chance = 100000, maxCount = 12 },
	{ id = 33441, chance = 900, maxCount = 4 },
	{ id = 26172, chance = 1200, maxCount = 4 },
	{ id = 26179, chance = 1200, maxCount = 4 },
	{ id = 26191, chance = 1200, maxCount = 4 },
	{ id = 26201, chance = 1200, maxCount = 4 },
	{ id = 26166, chance = 1200, maxCount = 4 },
	{ id = 26175, chance = 1200, maxCount = 4 },
	{ id = 33439, chance = 1200, maxCount = 3 },
	{ id = 2147, chance = 1200, maxCount = 4 },
	{ id = 2153, chance = 1200, maxCount = 4 },
	{ id = 18418, chance = 1200, maxCount = 4 },
	{ id = 18419, chance = 1200, maxCount = 4 },
	{ id = 26029, chance = 1200, maxCount = 4 },
	{ id = 10580, chance = 1200, maxCount = 4 },
	{ id = 18390, chance = 800 },
	{ id = 7901, chance = 950 },
	{ id = 7889, chance = 850 },
	{ id = 2164, chance = 1300 },
	{ id = 23565, chance = 1200, maxCount = 4 },
	{ id = 26200, chance = 560 },
	{ id = 26198, chance = 560 },
	{ id = 26199, chance = 560 },
	{ id = 26189, chance = 560 },
	{ id = 26185, chance = 560 },
	{ id = 26187, chance = 560 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -470,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -505,
		radius = 3,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
