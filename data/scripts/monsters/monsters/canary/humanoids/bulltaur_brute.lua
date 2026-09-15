local mType = Game.createMonsterType("Bulltaur Brute")
local monster = {}

monster.description = "a Bulltaur Brute"
monster.experience = 4700
monster.outfit = {
	lookType = 1717,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6560
monster.maxHealth = 6560
monster.race = "blood"
monster.corpse = 44709
monster.speed = 170
monster.manaCost = 0

monster.raceId = 2447
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Bulltaurs Lair",
}

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	{ text = "It's hammer time!", yell = false },
	{ text = "I'll do some downsizing!", yell = false },
	{ text = "This will be a smash hit!!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 53709, maxCount = 33 },
	{ id = 44810, chance = 16095 },
	{ id = 44812, chance = 13883 },
	{ id = 9970, chance = 10239, maxCount = 3 },
	{ id = 44811, chance = 9718 },
	{ id = 23546, chance = 2950 },
	{ id = 2213, chance = 2516 },
	{ id = 2164, chance = 1432 },
	{ id = 2153, chance = 1258 },
	{ id = 2158, chance = 954 },
	{ id = 2157, chance = 824 },
	{ id = 2434, chance = 694 },
	{ id = 36427, chance = 607 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -170, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -450,
		maxDamage = -600,
		range = 3,
		radius = 1,
		target = true,
		effect = CONST_ME_SLASH,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		range = 3,
		radius = 1,
		target = true,
		effect = CONST_ME_MORTAREA,
	},
}

monster.defenses = {
	defense = 100,
	armor = 78,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
