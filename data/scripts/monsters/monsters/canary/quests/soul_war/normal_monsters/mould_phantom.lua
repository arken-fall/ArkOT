local mType = Game.createMonsterType("Mould Phantom")
local monster = {}

monster.description = "a mould phantom"
monster.experience = 18330
monster.outfit = {
	lookType = 1298,
	lookHead = 106,
	lookBody = 60,
	lookLegs = 131,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1945
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Rotten Wasteland.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "undead"
monster.corpse = 34133
monster.speed = 240
monster.manaCost = 0

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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Everything decomposes.", yell = false },
	{ text = "I love the smell of rotten flesh.", yell = false },
	{ text = "The earth will take you back.", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 57370 },
	{ id = 9971, chance = 11840 },
	{ id = 8920, chance = 4440 },
	{ id = 2155, chance = 3800 },
	{ id = 2153, chance = 3550 },
	{ id = 37465, chance = 3490 },
	{ id = 18390, chance = 2930 },
	{ id = 2158, chance = 2440 },
	{ id = 8922, chance = 2360 },
	{ id = 37472, chance = 2200 },
	{ id = 26198, chance = 1070 },
	{ id = 26185, chance = 1040 },
	{ id = 15644, chance = 840 },
	{ id = 18453, chance = 620 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{ name = "poison chain", interval = 2000, chance = 15, minDamage = -1000, maxDamage = -1250, range = 7 },
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1100,
		maxDamage = -1350,
		radius = 4,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1030,
		maxDamage = -1350,
		range = 7,
		shootEffect = CONST_ANI_SMALLHOLY,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1100,
		maxDamage = -1300,
		radius = 4,
		range = 7,
		shootEffect = CONST_ANI_SMALLHOLY,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{ name = "extended holy chain", interval = 2000, chance = 15, minDamage = -400, maxDamage = -700, range = 7 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
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
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
