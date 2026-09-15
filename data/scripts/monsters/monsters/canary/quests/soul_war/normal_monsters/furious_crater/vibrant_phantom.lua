local mType = Game.createMonsterType("Vibrant Phantom")
local monster = {}

monster.description = "a vibrant phantom"
monster.experience = 19700
monster.outfit = {
	lookType = 1298,
	lookHead = 85,
	lookBody = 85,
	lookLegs = 88,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1929
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Furious Crater.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 27000
monster.maxHealth = 27000
monster.race = "undead"
monster.corpse = 33813
monster.speed = 230
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
	{ text = "All this beautiful lightning.", yell = false },
	{ text = "Feel the vibration!", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 66670 },
	{ id = 8473, chance = 27960, maxCount = 5 },
	{ id = 2181, chance = 13980 },
	{ id = 2153, chance = 8600 },
	{ id = 37467, chance = 6450 },
	{ id = 7632, chance = 6450 },
	{ id = 9971, chance = 4300 },
	{ id = 18413, chance = 4300 },
	{ id = 37468, chance = 3230 },
	{ id = 8912, chance = 3230 },
	{ id = 2158, chance = 3230 },
	{ id = 2183, chance = 3230 },
	{ id = 8910, chance = 2150 },
	{ id = 18414, chance = 1080 },
	{ id = 26185, chance = 1080 },
	{ id = 2155, chance = 1080 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "extended energy chain", interval = 2000, chance = 15, minDamage = -500, maxDamage = -600, range = 7 },
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -800,
		maxDamage = -1200,
		range = 7,
		radius = 4,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -1000,
		maxDamage = -1200,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1050,
		maxDamage = -1300,
		range = 7,
		shootEffect = CONST_ANI_SMALLHOLY,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{ name = "extended holy chain", interval = 2000, chance = 15, minDamage = -1030, maxDamage = -1250, range = 7 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
