local mType = Game.createMonsterType("The Scourge of Oblivion")
local monster = {}

monster.description = "The Scourge Of Oblivion"
monster.experience = 75000
monster.outfit = {
	lookType = 875,
	lookHead = 79,
	lookBody = 3,
	lookLegs = 4,
	lookFeet = 2,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"SecretLibraryBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1642,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 800000
monster.maxHealth = 800000
monster.race = "venom"
monster.corpse = 23561
monster.speed = 225
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
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

monster.maxSummons = 8
monster.summons = {
	{ name = "Charger", chance = 15, interval = 1000, max = 3 },
	{ name = "Spark of Destruction", chance = 15, interval = 1000, max = 5 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The Scourge Of Oblivion prepares a devestating attack!", yell = false },
	{ text = "The Scourge Of Oblivion activates its reflective shields!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 15 },
	{ id = 2160, chance = 100000, maxCount = 7 },
	{ id = 18415, chance = 100000, maxCount = 3 },
	{ id = 18414, chance = 100000, maxCount = 3 },
	{ id = 26172, chance = 100000 },
	{ id = 26176, chance = 100000 },
	{ id = 2127, chance = 100000 },
	{ id = 31758, chance = 66666, maxCount = 100 },
	{ id = 2150, chance = 66666, maxCount = 12 },
	{ id = 25172, chance = 66666, maxCount = 12 },
	{ id = 7440, chance = 66666, maxCount = 10 },
	{ id = 26029, chance = 66666, maxCount = 6 },
	{ id = 34282, chance = 66666 },
	{ id = 2156, chance = 66666 },
	{ id = 2147, chance = 33333, maxCount = 12 },
	{ id = 7443, chance = 33333, maxCount = 10 },
	{ id = 25377, chance = 33333, maxCount = 8 },
	{ id = 26031, chance = 33333, maxCount = 6 },
	{ id = 18413, chance = 33333, maxCount = 3 },
	{ id = 34283, chance = 33333 },
	{ id = 2155, chance = 33333 },
	{ id = 26198, chance = 33333 },
	{ id = 5892, chance = 33333 },
	{ id = 5904, chance = 33333 },
	{ id = 2123, chance = 33333 },
	{ id = 26030, chance = 15000, maxCount = 20 },
	{ id = 2145, chance = 15000, maxCount = 12 },
	{ id = 2149, chance = 15000, maxCount = 12 },
	{ id = 25382, chance = 5000 },
	{ id = 7632, chance = 5000 },
	{ id = 2453, chance = 5000 },
	{ id = 8889, chance = 5000 },
	{ id = 7427, chance = 5000 },
	{ id = 5480, chance = 5000 },
	{ id = 2114, chance = 5000 },
	{ id = 26165, chance = 5000 },
	{ id = 26191, chance = 5000 },
	{ id = 33634, chance = 500, unique = true },
	{ id = 8932, chance = 500, unique = true },
	{ id = 26174, chance = 100000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 250, attack = 350 },
	{
		name = "combat",
		interval = 1000,
		chance = 7,
		type = COMBAT_MANADRAIN,
		minDamage = -900,
		maxDamage = -1500,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_POFF,
		target = false,
	},
	{ name = "drunk", interval = 2000, chance = 20, radius = 5, effect = CONST_ME_SMALLCLOUDS, target = false, duration = 9000 },
	{ name = "strength", interval = 1000, chance = 9, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "energy strike", interval = 2000, chance = 30, minDamage = -2000, maxDamage = -2700, range = 1, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 8,
		type = COMBAT_FIREDAMAGE,
		minDamage = -1550,
		maxDamage = -2550,
		range = 7,
		radius = 7,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -1075,
		maxDamage = -2405,
		range = 7,
		shootEffect = CONST_ANI_ENERGYBALL,
		effect = CONST_ME_ENERGYHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 20,
		type = COMBAT_LIFEDRAIN,
		minDamage = -600,
		maxDamage = -1500,
		radius = 8,
		effect = CONST_ME_LOSEENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -750,
		maxDamage = -1200,
		length = 8,
		spread = 0,
		effect = CONST_ME_PURPLEENERGY,
		target = false,
	},
	{ name = "choking fear drown", interval = 2000, chance = 20, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -450,
		maxDamage = -1400,
		radius = 4,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 10,
		type = COMBAT_MANADRAIN,
		minDamage = -800,
		maxDamage = -2300,
		radius = 8,
		effect = CONST_ME_MAGIC_GREEN,
		target = false,
	},
	{ name = "speed", interval = 1000, chance = 12, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 60000, speed = -800 },
	{ name = "strength", interval = 1000, chance = 8, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{
		name = "combat",
		interval = 1000,
		chance = 34,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -700,
		range = 7,
		radius = 7,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -300,
		maxDamage = -950,
		length = 8,
		spread = 0,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
}

monster.defenses = {
	defense = 160,
	armor = 160,
	{ name = "combat", interval = 6000, chance = 25, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 5000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 8, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 1901 },
	{ name = "invisible", interval = 1000, chance = 4, effect = CONST_ME_MAGIC_BLUE },
	{ name = "invisible", interval = 1000, chance = 17, effect = CONST_ME_MAGIC_BLUE },
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
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
