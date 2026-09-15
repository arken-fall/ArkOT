local mType = Game.createMonsterType("Ink Blob")
local monster = {}

monster.description = "an ink blob"
monster.experience = 14450
monster.outfit = {
	lookType = 1064,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1658
monster.bestiary = {
	race = "Slime",
	class = "Slime",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Secret Library (earth, fire and ice sections)",
}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "ink"
monster.corpse = 28601
monster.speed = 190
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
	canPushCreatures = false,
	staticAttackChance = 85,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 85
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
	{ id = 2152, chance = 120000, maxCount = 4 },
	{ id = 18437, chance = 1200, maxCount = 14 },
	{ id = 33439, chance = 1200, maxCount = 4 },
	{ id = 10557, chance = 1200, maxCount = 4 },
	{ id = 2145, chance = 1200, maxCount = 4 },
	{ id = 9970, chance = 1200, maxCount = 4 },
	{ id = 7633, chance = 900, maxCount = 4 },
	{ id = 2158, chance = 950, maxCount = 4 },
	{ id = 7886, chance = 850, maxCount = 4 },
	{ id = 7903, chance = 980, maxCount = 4 },
	{ id = 2200, chance = 1200, maxCount = 4 },
	{ id = 10219, chance = 1200, maxCount = 4 },
	{ id = 8912, chance = 790, maxCount = 4 },
	{ id = 2197, chance = 1200, maxCount = 4 },
	{ id = 7885, chance = 650, maxCount = 4 },
	{ id = 7884, chance = 550, maxCount = 4 },
	{ id = 11339, chance = 1200, maxCount = 4 },
	{ id = 7887, chance = 1200, maxCount = 4 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		skill = 45,
		attack = 40,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 280, maxDamage = 280 },
	},
	{
		name = "condition",
		type = CONDITION_POISON,
		interval = 2000,
		chance = 13,
		minDamage = -400,
		maxDamage = -580,
		radius = 4,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 11,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -285,
		maxDamage = -480,
		radius = 3,
		shootEffect = CONST_ANI_ENVENOMEDARROW,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -260,
		maxDamage = -505,
		range = 7,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 15,
	armor = 70,
	mitigation = 2.02,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 20, maxDamage = 30, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -8 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
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
