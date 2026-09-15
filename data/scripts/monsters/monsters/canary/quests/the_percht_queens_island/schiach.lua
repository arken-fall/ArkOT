local mType = Game.createMonsterType("Schiach")
local monster = {}

monster.description = "a schiach"
monster.experience = 580
monster.outfit = {
	lookType = 1162,
	lookHead = 0,
	lookBody = 10,
	lookLegs = 38,
	lookFeet = 57,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1741
monster.bestiary = {
	race = "Fey",
	class = "Fey",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 2,
	locations = "Percht Island",
}

monster.health = 600
monster.maxHealth = 600
monster.race = "blood"
monster.corpse = 30298
monster.speed = 140
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
	runHealth = 50,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 50

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Krik Krik!", yell = false },
	{ text = "Psh psh psh!!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 50 },
	{ id = 34387, chance = 11070 },
	{ id = 34388, chance = 3960 },
	{ id = 34522, chance = 2920 },
	{ id = 7896, chance = 1180 },
	{ id = 7897, chance = 630 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 70,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -125,
		range = 7,
		shootEffect = CONST_ANI_SNOWBALL,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_ICEDAMAGE,
		minDamage = -90,
		maxDamage = -250,
		length = 3,
		spread = 0,
		effect = CONST_ME_GIANTICE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -250,
		radius = 3,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -250,
		radius = 4,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -250,
		length = 3,
		spread = 0,
		effect = CONST_ME_FIREATTACK,
		target = false,
	},
}

monster.defenses = {
	defense = 43,
	armor = 43,
	mitigation = 0.78,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
