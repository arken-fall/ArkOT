local mType = Game.createMonsterType("The Fear Feaster")
local monster = {}

monster.description = "The Fear Feaster"
monster.experience = 30000
monster.outfit = {
	lookType = 1276,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"FeasterOfSoulsBossDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 32737
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
	chance = 0,
}

monster.bosstiary = {
	bossRaceId = 1873,
	bossRace = RARITY_ARCHFOE,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
monster.runHealth = 1

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2160, chance = 96080, maxCount = 2 },
	{ id = 36427, chance = 52940, maxCount = 2 },
	{ id = 36429, chance = 52940, maxCount = 2 },
	{ id = 26029, chance = 43140, maxCount = 6 },
	{ id = 26031, chance = 29410, maxCount = 6 },
	{ id = 36430, chance = 27450 },
	{ id = 7439, chance = 23530, maxCount = 10 },
	{ id = 26030, chance = 23530, maxCount = 6 },
	{ id = 7443, chance = 19610, maxCount = 10 },
	{ id = 7440, chance = 19610, maxCount = 10 },
	{ id = 47306, chance = 19610, maxCount = 10 },
	{ id = 36367, chance = 13730, maxCount = 2 },
	{ id = 36431, chance = 13730 },
	{ id = 36284, chance = 11760 },
	{ id = 36428, chance = 11760 },
	{ id = 36432, chance = 7840 },
	{ id = 36286, chance = 7840 },
	{ id = 36287, chance = 5880 },
	{ id = 36320, chance = 5880 },
	{ id = 36319, chance = 3920 },
	{ id = 36325, chance = 1960 },
	{ id = 36288, chance = 1500 },
	{ id = 36322, chance = 150 },
	{ id = 36324, chance = 150 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 600,
		maxDamage = -1050,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 4, maxDamage = 4 },
	},
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_LIFEDRAIN, minDamage = -900, maxDamage = -1400, effect = CONST_ME_MAGIC_RED, target = true },
	{
		name = "combat",
		interval = 1000,
		chance = 40,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -1000,
		maxDamage = -1750,
		radius = 2,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_HITBYPOISON,
		target = false,
	},
	{ name = "drunk", interval = 1000, chance = 70, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "strength", interval = 1000, chance = 60, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = 0,
		maxDamage = -900,
		length = 5,
		spread = 3,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 34,
		type = COMBAT_FIREDAMAGE,
		minDamage = -600,
		maxDamage = -1200,
		range = 7,
		radius = 7,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{ name = "speed", interval = 3000, chance = 40, effect = CONST_ME_MAGIC_RED, target = true, duration = 20000, speed = -700 },
}

monster.defenses = {
	defense = 170,
	armor = 160,
	{ name = "speed", interval = 10000, chance = 40, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000, speed = 510 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
