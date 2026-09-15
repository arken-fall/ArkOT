local mType = Game.createMonsterType("The Baron from Below")
local monster = {}

monster.description = "The Baron From Below"
monster.experience = 50000
monster.outfit = {
	lookType = 1045,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
	"TheBaronFromBelowThink",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27633
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1518,
	bossRace = RARITY_BANE,
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
	{ text = "Krrrk!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 58 },
	{ id = 7440, chance = 100000 },
	{ id = 2197, chance = 100000 },
	{ id = 32735, chance = 100000 },
	{ id = 2187, chance = 72920 },
	{ id = 18414, chance = 64580 },
	{ id = 8473, chance = 62500, maxCount = 18 },
	{ id = 2392, chance = 56250 },
	{ id = 8472, chance = 54170, maxCount = 18 },
	{ id = 5904, chance = 45830 },
	{ id = 7590, chance = 43750, maxCount = 18 },
	{ id = 2445, chance = 37500 },
	{ id = 25172, chance = 33330 },
	{ id = 2149, chance = 20830 },
	{ id = 5892, chance = 20830 },
	{ id = 9816, chance = 18750 },
	{ id = 9822, chance = 16670 },
	{ id = 2156, chance = 14580 },
	{ id = 12410, chance = 14580 },
	{ id = 32654, chance = 14580 },
	{ id = 2145, chance = 12500 },
	{ id = 9970, chance = 12500 },
	{ id = 2147, chance = 12500 },
	{ id = 2153, chance = 12500 },
	{ id = 32652, chance = 12500 },
	{ id = 15489, chance = 10420 },
	{ id = 2158, chance = 10420 },
	{ id = 2154, chance = 10420 },
	{ id = 9971, chance = 8330 },
	{ id = 25377, chance = 8330 },
	{ id = 2160, chance = 8330 },
	{ id = 2155, chance = 8330 },
	{ id = 2150, chance = 6250 },
	{ id = 32651, chance = 4170 },
	{ id = 7899, chance = 4170 },
	{ id = 32653, chance = 4170 },
	{ id = 24742, chance = 4170 },
	{ id = 8901, chance = 2080 },
	{ id = 32680, chance = 4170 },
	{ id = 32677, chance = 3390 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		radius = 8,
		effect = CONST_ME_HITAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		length = 8,
		spread = 5,
		effect = CONST_ME_YELLOW_RINGS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		length = 8,
		spread = 9,
		effect = CONST_ME_POFF,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 100,
		type = COMBAT_DEATHDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		radius = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		radius = 5,
		effect = CONST_ME_SMALLPLANTS,
		target = false,
	},
}

monster.defenses = {
	defense = 160,
	armor = 160,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
