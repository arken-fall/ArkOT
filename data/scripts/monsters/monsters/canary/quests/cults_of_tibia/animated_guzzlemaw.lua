local mType = Game.createMonsterType("Animated Guzzlemaw")
local monster = {}

monster.description = "an animated guzzlemaw"
monster.experience = 5500
monster.outfit = {
	lookType = 584,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "blood"
monster.corpse = 20151
monster.speed = 135
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2152, chance = 100000, maxCount = 7 },
	{ id = 2219, chance = 10700 },
	{ id = 2225, chance = 10500 },
	{ id = 2226, chance = 9500 },
	{ id = 2229, chance = 10400 },
	{ id = 2230, chance = 9200 },
	{ id = 2231, chance = 4500 },
	{ id = 2240, chance = 10110 },
	{ id = 2377, chance = 2700 },
	{ id = 2667, chance = 7000, maxCount = 3 },
	{ id = 2671, chance = 10000 },
	{ id = 5880, chance = 3000 },
	{ id = 5895, chance = 5000 },
	{ id = 5925, chance = 5700 },
	{ id = 7404, chance = 1000 },
	{ id = 7407, chance = 2000 },
	{ id = 7418, chance = 380 },
	{ id = 7590, chance = 17000, maxCount = 3 },
	{ id = 7591, chance = 18500, maxCount = 2 },
	{ id = 11306, chance = 1200 },
	{ id = 18414, chance = 3000 },
	{ id = 18417, chance = 12000, maxCount = 2 },
	{ id = 18420, chance = 7600 },
	{ id = 18554, chance = 12000 },
	{ id = 22396, chance = 4920 },
	{ id = 22532, chance = 15000 },
	{ id = 22533, chance = 14000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -499 },
	{
		name = "condition",
		type = CONDITION_BLEEDING,
		interval = 2000,
		chance = 10,
		minDamage = -500,
		maxDamage = -1000,
		radius = 3,
		effect = CONST_ME_DRAWBLOOD,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -900,
		length = 8,
		spread = 0,
		effect = CONST_ME_EXPLOSIONAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -500,
		radius = 2,
		shootEffect = CONST_ANI_LARGEROCK,
		effect = CONST_ME_STONES,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 15, radius = 6, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000, speed = -800 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = 0,
		maxDamage = -800,
		length = 8,
		spread = 0,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
}

monster.defenses = {
	defense = 50,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 250, maxDamage = 425, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
