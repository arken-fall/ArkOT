local mType = Game.createMonsterType("Angry Demon")
local monster = {}

monster.description = "an angry demon"
monster.experience = 6000
monster.outfit = {
	lookType = 35,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "fire"
monster.corpse = 5995
monster.speed = 128
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 1
monster.summons = {
	{ name = "fire elemental", chance = 10, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your soul will be mine!", yell = false },
	{ text = "CHAMEK ATH UTHUL ARAK!", yell = true },
	{ text = "I SMELL FEEEEAAAAAR!", yell = true },
	{ text = "Your resistance is futile!", yell = false },
	{ text = "MUHAHAHA", yell = true },
}

monster.loot = {
	{ id = 1982, chance = 1180 },
	{ id = 2148, chance = 60000, maxCount = 100 },
	{ id = 2152, chance = 60000, maxCount = 6 },
	{ id = 2149, chance = 9690, maxCount = 5 },
	{ id = 2150, chance = 7250, maxCount = 5 },
	{ id = 2147, chance = 7430, maxCount = 5 },
	{ id = 9970, chance = 7470, maxCount = 5 },
	{ id = 2156, chance = 2220 },
	{ id = 6500, chance = 14630 },
	{ id = 2151, chance = 3430 },
	{ id = 2164, chance = 1890 },
	{ id = 2165, chance = 2170 },
	{ id = 2171, chance = 680 },
	{ id = 2176, chance = 2854 },
	{ id = 2179, chance = 1050 },
	{ id = 2214, chance = 1990 },
	{ id = 2393, chance = 1980 },
	{ id = 2396, chance = 1550 },
	{ id = 2418, chance = 1440 },
	{ id = 2432, chance = 4030 },
	{ id = 2462, chance = 1180 },
	{ id = 2470, chance = 440 },
	{ id = 2472, chance = 130 },
	{ id = 2514, chance = 480 },
	{ id = 2520, chance = 740 },
	{ id = 2795, chance = 19660, maxCount = 6 },
	{ id = 5954, chance = 14920 },
	{ id = 7368, chance = 12550, maxCount = 10 },
	{ id = 7382, chance = 70 },
	{ id = 7393, chance = 90 },
	{ id = 7590, chance = 22220, maxCount = 3 },
	{ id = 8473, chance = 19540, maxCount = 3 },
	{ id = 8472, chance = 18510, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 500, minDamage = 0, maxDamage = -500 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = 30, maxDamage = -120, range = 7, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -150,
		maxDamage = -250,
		range = 7,
		radius = 7,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{ name = "firefield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_LIFEDRAIN,
		minDamage = -300,
		maxDamage = -480,
		length = 8,
		spread = 0,
		effect = CONST_ME_PURPLEENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -210,
		maxDamage = -300,
		range = 1,
		shootEffect = CONST_ANI_ENERGY,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 15, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000, speed = -700 },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -12 },
	{ type = COMBAT_HOLYDAMAGE, percent = -12 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
