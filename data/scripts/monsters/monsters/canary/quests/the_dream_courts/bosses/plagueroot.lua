local mType = Game.createMonsterType("Plagueroot")
local monster = {}

monster.description = "Plagueroot"
monster.experience = 55000
monster.outfit = {
	lookType = 1121,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "venom"
monster.corpse = 30022
monster.speed = 85
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"facelessHealth",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1695,
	bossRace = RARITY_NEMESIS,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 25172, chance = 100000, maxCount = 3 },
	{ id = 26165, chance = 100000 },
	{ id = 5892, chance = 100000 },
	{ id = 2114, chance = 100000 },
	{ id = 26191, chance = 100000 },
	{ id = 31758, chance = 80000, maxCount = 184 },
	{ id = 26029, chance = 80000, maxCount = 22 },
	{ id = 26031, chance = 60000, maxCount = 13 },
	{ id = 25377, chance = 60000, maxCount = 3 },
	{ id = 2156, chance = 60000 },
	{ id = 7440, chance = 40000, maxCount = 13 },
	{ id = 34277, chance = 40000 },
	{ id = 7443, chance = 20000 },
	{ id = 26030, chance = 20000 },
	{ id = 7439, chance = 20000 },
	{ id = 9971, chance = 20000 },
	{ id = 2153, chance = 20000 },
	{ id = 34371, chance = 20000 },
	{ id = 2158, chance = 20000 },
	{ id = 7633, chance = 20000 },
	{ id = 34309, chance = 20000 },
	{ id = 2436, chance = 20000 },
	{ id = 2152, chance = 100000 },
	{ id = 25172, chance = 95920, maxCount = 5 },
	{ id = 2114, chance = 93880 },
	{ id = 26165, chance = 91840 },
	{ id = 26191, chance = 87760 },
	{ id = 25377, chance = 61220 },
	{ id = 26030, chance = 59180, maxCount = 20 },
	{ id = 26029, chance = 57140, maxCount = 20 },
	{ id = 31758, chance = 48980 },
	{ id = 26031, chance = 46940, maxCount = 20 },
	{ id = 2154, chance = 40820, maxCount = 2 },
	{ id = 5892, chance = 38780 },
	{ id = 2160, chance = 26530, maxCount = 3 },
	{ id = 7440, chance = 22450 },
	{ id = 9971, chance = 22450 },
	{ id = 7443, chance = 20410 },
	{ id = 7439, chance = 16329 },
	{ id = 2436, chance = 16329 },
	{ id = 34371, chance = 16329 },
	{ id = 26198, chance = 14290 },
	{ id = 2158, chance = 12240 },
	{ id = 2155, chance = 12240 },
	{ id = 26185, chance = 10200 },
	{ id = 2153, chance = 8160, maxCount = 2 },
	{ id = 26199, chance = 8160 },
	{ id = 26200, chance = 8160 },
	{ id = 26187, chance = 8160 },
	{ id = 26189, chance = 6120 },
	{ id = 7427, chance = 6120 },
	{ id = 34309, chance = 6120 },
	{ id = 5904, chance = 6120 },
	{ id = 34147, chance = 4080 },
	{ id = 34282, chance = 4080 },
	{ id = 5809, chance = 4080 },
	{ id = 34148, chance = 4080 },
	{ id = 34372, chance = 2040 },
	{ id = 2123, chance = 2040 },
	{ id = 7414, chance = 2040 },
	{ id = 2453, chance = 3130 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 210, attack = -560 },
	{
		name = "condition",
		type = CONDITION_FIRE,
		interval = 1000,
		chance = 7,
		minDamage = -200,
		maxDamage = -1000,
		range = 2,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_BLOCKHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 7,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -350,
		maxDamage = -1050,
		radius = 6,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 50,
		type = COMBAT_FIREDAMAGE,
		minDamage = -20,
		maxDamage = -100,
		radius = 5,
		effect = CONST_ME_BLOCKHIT,
		target = false,
	},
	{ name = "firefield", interval = 1000, chance = 4, radius = 8, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{
		name = "combat",
		interval = 1000,
		chance = 34,
		type = COMBAT_FIREDAMAGE,
		minDamage = -350,
		maxDamage = -650,
		range = 7,
		radius = 7,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 13,
		type = COMBAT_FIREDAMAGE,
		minDamage = -250,
		maxDamage = -600,
		length = 8,
		spread = 0,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 10,
		type = COMBAT_FIREDAMAGE,
		minDamage = -350,
		maxDamage = -600,
		length = 8,
		spread = 0,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 1000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 200, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 10, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000, speed = 1800 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 1 },
	{ type = COMBAT_EARTHDAMAGE, percent = 120 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
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
