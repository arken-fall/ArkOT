local mType = Game.createMonsterType("Mycobiontic Beetle")
local monster = {}

monster.description = "a mycobiontic beetle"
monster.experience = 21175
monster.outfit = {
	lookType = 1620,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2375
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Jaded roots",
}

monster.health = 30200
monster.maxHealth = 30200
monster.race = "undead"
monster.corpse = 43555
monster.speed = 230
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	targetDistance = 0,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 0
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
	{ id = 2160, chance = 15540 },
	{ id = 8473, chance = 43253, maxCount = 5 },
	{ id = 2409, chance = 32253 },
	{ id = 7902, chance = 21920 },
	{ id = 2146, chance = 34560, maxCount = 3 },
	{ id = 44039, chance = 25920, maxCount = 1 },
	{ id = 2159, chance = 22920, maxCount = 3 },
	{ id = 20109, chance = 22920, maxCount = 1 },
	{ id = 44037, chance = 22920, maxCount = 1 },
	{ id = 2153, chance = 18920 },
	{ id = 2158, chance = 15920 },
	{ id = 2147, chance = 24560, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1600 },
	{
		name = "combat",
		interval = 2500,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1100,
		maxDamage = -1400,
		radius = 5,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{
		name = "combat",
		intervall = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1200,
		maxDamage = -1600,
		length = 8,
		spread = 3,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -1400,
		maxDamage = -1700,
		radius = 5,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1200,
		maxDamage = -1400,
		radius = 5,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{ name = "largepoisonring", interval = 2000, chance = 10, minDamage = -900, maxDamage = -1300 },
}

monster.defenses = {
	defense = 116,
	armor = 116,
	mitigation = 2.92,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 60 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
