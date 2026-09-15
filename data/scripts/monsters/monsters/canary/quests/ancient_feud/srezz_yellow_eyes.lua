local mType = Game.createMonsterType("Srezz Yellow Eyes")
local monster = {}

monster.description = "Srezz Yellow Eyes"
monster.experience = 4800
monster.outfit = {
	lookType = 220,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1983,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "venom"
monster.corpse = 6061
monster.speed = 117
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
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
	{ id = 2152, chance = 100000, minCount = 1, maxCount = 17 },
	{ id = 8473, chance = 100000, minCount = 1, maxCount = 5 },
	{ id = 10611, chance = 25560, minCount = 1, maxCount = 3 },
	{ id = 7440, chance = 17780 },
	{ id = 9971, chance = 16110 },
	{ id = 18413, chance = 10560 },
	{ id = 7633, chance = 10560 },
	{ id = 2144, chance = 10000 },
	{ id = 2153, chance = 8330 },
	{ id = 2155, chance = 7220 },
	{ id = 2158, chance = 6670 },
	{ id = 30499, chance = 5560 },
	{ id = 11230, chance = 5000 },
	{ id = 7896, chance = 4440 },
	{ id = 37433, chance = 3890 },
	{ id = 5741, chance = 3330 },
	{ id = 7897, chance = 2780 },
	{ id = 2454, chance = 2220 },
	{ id = 26187, chance = 1670 },
	{ id = 2393, chance = 1110 },
	{ id = 7382, chance = 560 },
	{ id = 2157, chance = 560 },
	{ id = 37574, chance = 360 },
	{ id = 37127, chance = 360 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{
		name = "combat",
		type = COMBAT_EARTHDAMAGE,
		interval = 2000,
		chance = 20,
		minDamage = -400,
		maxDamage = -500,
		range = 5,
		radius = 3,
		spread = 3,
		target = true,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_YELLOW_RINGS,
	},
	{ name = "lleech waveT", interval = 2000, chance = 30, minDamage = -200, maxDamage = -300 },
	{
		name = "combat",
		type = COMBAT_LIFEDRAIN,
		interval = 2000,
		chance = 30,
		minDamage = -200,
		maxDamage = -300,
		length = 5,
		spread = 3,
		effect = CONST_ME_DRAWBLOOD,
	},
	{
		name = "combat",
		type = COMBAT_LIFEDRAIN,
		interval = 2000,
		chance = 70,
		minDamage = -200,
		maxDamage = -350,
		radius = 4,
		target = false,
		effect = CONST_ME_DRAWBLOOD,
	},
}

monster.defenses = {
	defense = 35,
	armor = 35,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 340 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
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
