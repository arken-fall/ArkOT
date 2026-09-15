local mType = Game.createMonsterType("Izcandar the Banished")
local monster = {}

monster.description = "Izcandar the Banished"
monster.experience = 55000
monster.outfit = {
	lookType = 1137,
	lookHead = 19,
	lookBody = 95,
	lookLegs = 76,
	lookFeet = 38,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1699,
	bossRace = RARITY_NEMESIS,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 6068
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"izcandarThink",
}

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
	{ id = 26185, chance = 6250 },
	{ id = 26187, chance = 16670 },
	{ id = 26187, chance = 3130 },
	{ id = 26198, chance = 33330 },
	{ id = 26198, chance = 9380 },
	{ id = 26199, chance = 12500 },
	{ id = 26200, chance = 9380 },
	{ id = 2156, chance = 33330 },
	{ id = 2453, chance = 3130 },
	{ id = 7439, chance = 18750 },
	{ id = 2158, chance = 50000 },
	{ id = 7443, chance = 25000 },
	{ id = 7427, chance = 9380 },
	{ id = 2160, chance = 33330, maxCount = 3 },
	{ id = 26191, chance = 100000 },
	{ id = 26191, chance = 93750 },
	{ id = 34283, chance = 3130 },
	{ id = 7633, chance = 33330 },
	{ id = 9971, chance = 33330 },
	{ id = 25377, chance = 71880 },
	{ id = 2155, chance = 21880, maxCount = 2 },
	{ id = 5892, chance = 33330 },
	{ id = 34168, chance = 3130 },
	{ id = 34169, chance = 3130 },
	{ id = 5904, chance = 16670 },
	{ id = 7440, chance = 9380 },
	{ id = 26165, chance = 93750 },
	{ id = 2114, chance = 93750 },
	{ id = 2152, chance = 100000, maxCount = 9 },
	{ id = 34371, chance = 16670 },
	{ id = 2123, chance = 12500 },
	{ id = 31758, chance = 50000, maxCount = 199 },
	{ id = 25172, chance = 100000, maxCount = 2 },
	{ id = 2436, chance = 6250 },
	{ id = 5809, chance = 16670 },
	{ id = 34151, chance = 3130 },
	{ id = 26031, chance = 66670, maxCount = 14 },
	{ id = 26029, chance = 56250, maxCount = 20 },
	{ id = 26030, chance = 66670, maxCount = 5 },
	{ id = 2153, chance = 3130 },
	{ id = 34152, chance = 6250 },
	{ id = 2154, chance = 34380, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{
		name = "combat",
		interval = 3600,
		chance = 17,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -1500,
		length = 5,
		spread = 2,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 4100,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -2000,
		length = 8,
		spread = 0,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 4700,
		chance = 17,
		type = COMBAT_ICEDAMAGE,
		minDamage = -500,
		maxDamage = -1500,
		length = 5,
		spread = 2,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 3100,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -500,
		maxDamage = -2000,
		length = 8,
		spread = 0,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 15, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000, speed = -700 },
}

monster.defenses = {
	defense = 60,
	armor = 60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
