local mType = Game.createMonsterType("Goldhanded Cultist")
local monster = {}

monster.description = "a goldhanded cultist"
monster.experience = 2000
monster.outfit = {
	lookType = 132,
	lookHead = 114,
	lookBody = 79,
	lookLegs = 62,
	lookFeet = 94,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1481
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 1,
	locations = "Museum of Tibian Arts.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 4240
monster.speed = 150
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Money, money, money!", yell = false },
	{ text = "You can't ever be rich enough!", yell = false },
}

monster.loot = {
	{ id = 2004, chance = 4290 },
	{ id = 31050, chance = 11430 },
	{ id = 2148, chance = 41430, maxCount = 235 },
	{ id = 31692, chance = 20000 },
	{ id = 2155, chance = 5710 },
	{ id = 9971, chance = 2860 },
	{ id = 24850, chance = 11430 },
	{ id = 2154, chance = 5710 },
	{ id = 1997, chance = 1430 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{
		name = "combat",
		interval = 3000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = 0,
		maxDamage = -150,
		radius = 5,
		effect = CONST_ME_DRAWBLOOD,
		target = false,
	},
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 0, maxDamage = -200, effect = CONST_ME_LOSEENERGY, target = true },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = 0,
		maxDamage = -250,
		range = 5,
		radius = 2,
		effect = CONST_ME_DRAWBLOOD,
		target = true,
	},
}

monster.defenses = {
	defense = 20,
	armor = 30,
	mitigation = 0.78,
	{ name = "speed", interval = 2000, chance = 30, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000, speed = 290 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 17 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
