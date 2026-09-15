local mType = Game.createMonsterType("Sorcerer's Apparition")
local monster = {}

monster.description = "a sorcerer's apparition"
monster.experience = 28600
monster.outfit = {
	lookType = 138,
	lookHead = 95,
	lookBody = 114,
	lookLegs = 52,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1949
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Mirrored Nightmare.",
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 6081
monster.speed = 235
monster.manaCost = 0

monster.events = {
	"MirroredNightmareBossAccess",
}

monster.changeTarget = {
	interval = 4000,
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
	{ text = "I'll take your place when you are gone.", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 79040 },
	{ id = 7590, chance = 62450, maxCount = 3 },
	{ id = 2158, chance = 5240 },
	{ id = 26189, chance = 4370 },
	{ id = 8922, chance = 4370 },
	{ id = 26187, chance = 3490 },
	{ id = 26185, chance = 3060 },
	{ id = 2153, chance = 2620 },
	{ id = 7888, chance = 2620 },
	{ id = 18409, chance = 2180 },
	{ id = 18390, chance = 1750 },
	{ id = 8920, chance = 1310 },
	{ id = 2197, chance = 1310 },
	{ id = 23539, chance = 440 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		interval = 4000,
		chance = 26,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1080,
		maxDamage = -1300,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_BIGCLOUDS,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1100,
		maxDamage = -1300,
		radius = 3,
		effect = CONST_ME_BIGCLOUDS,
		target = false,
	},
	{
		name = "combat",
		interval = 5000,
		chance = 34,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1100,
		maxDamage = -1300,
		range = 7,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_BIGCLOUDS,
		target = true,
	},
	{ name = "ice chain", interval = 9500, chance = 52, minDamage = -1100, maxDamage = -1300, range = 7 },
	{
		name = "combat",
		interval = 3000,
		chance = 14,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1100,
		maxDamage = -1250,
		range = 7,
		shootEffect = CONST_ANI_HOLY,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 19,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1250,
		maxDamage = -1400,
		radius = 4,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.74,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
