local mType = Game.createMonsterType("Paladin's Apparition")
local monster = {}

monster.description = "a paladin's apparition"
monster.experience = 28600
monster.outfit = {
	lookType = 129,
	lookHead = 57,
	lookBody = 42,
	lookLegs = 114,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1948
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
monster.corpse = 111
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
	{ text = "I could be your evil twin!", yell = false },
	{ text = "I'll take your place when you are gone.", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 81310 },
	{ id = 2475, chance = 6850 },
	{ id = 2158, chance = 6230 },
	{ id = 8472, chance = 4980 },
	{ id = 2153, chance = 4670 },
	{ id = 7902, chance = 4670 },
	{ id = 7888, chance = 4670 },
	{ id = 2155, chance = 4670 },
	{ id = 2664, chance = 3120 },
	{ id = 5741, chance = 1870 },
	{ id = 2197, chance = 1560 },
	{ id = 26198, chance = 1250 },
	{ id = 26185, chance = 1250 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -850 },
	{
		name = "combat",
		interval = 4000,
		chance = 26,
		type = COMBAT_ICEDAMAGE,
		minDamage = -840,
		maxDamage = -1000,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_BIGCLOUDS,
		target = true,
	},
	{ name = "ice chain", interval = 5000, chance = 20, minDamage = -1050, maxDamage = -1300, range = 7 },
	{
		name = "combat",
		interval = 9500,
		chance = 52,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1050,
		maxDamage = -1300,
		range = 7,
		shootEffect = CONST_ANI_HOLY,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 22,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1200,
		maxDamage = -1400,
		radius = 4,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 23,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -900,
		maxDamage = -1350,
		radius = 4,
		shootEffect = CONST_ANI_EXPLOSION,
		range = 7,
		effect = CONST_ME_EXPLOSIONHIT,
		target = true,
	},
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -11 },
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
