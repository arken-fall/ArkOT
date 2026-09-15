local mType = Game.createMonsterType("Rage Squid")
local monster = {}

monster.description = "a rage squid"
monster.experience = 16300
monster.outfit = {
	lookType = 1059,
	lookHead = 94,
	lookBody = 78,
	lookLegs = 79,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1668
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Secret Library (fire section).",
}

monster.health = 17000
monster.maxHealth = 17000
monster.race = "undead"
monster.corpse = 28782
monster.speed = 215
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ id = 33441, chance = 10000 },
	{ id = 8472, chance = 10000, maxCount = 3 },
	{ id = 2795, chance = 10000, maxCount = 6 },
	{ id = 2150, chance = 90000, maxCount = 5 },
	{ id = 23565, chance = 3000 },
	{ id = 10580, chance = 4900 },
	{ id = 2152, chance = 100000, maxCount = 6 },
	{ id = 8473, chance = 10000, maxCount = 3 },
	{ id = 9970, chance = 90000, maxCount = 5 },
	{ id = 2149, chance = 90000, maxCount = 5 },
	{ id = 2156, chance = 9800, maxCount = 5 },
	{ id = 2176, chance = 66000, maxCount = 5 },
	{ id = 1982, chance = 6333 },
	{ id = 7590, chance = 10000, maxCount = 3 },
	{ id = 6500, chance = 4300 },
	{ id = 33439, chance = 10000 },
	{ id = 2147, chance = 90000, maxCount = 5 },
	{ id = 2151, chance = 8990 },
	{ id = 2164, chance = 4990 },
	{ id = 2462, chance = 6990 },
	{ id = 7382, chance = 400 },
	{ id = 7393, chance = 390 },
	{ id = 2393, chance = 250 },
	{ id = 2520, chance = 250 },
	{ id = 2472, chance = 150 },
	{ id = 2171, chance = 350 },
	{ id = 18409, chance = 300 },
	{ id = 2432, chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -280,
		range = 7,
		shootEffect = CONST_ANI_FLAMMINGARROW,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -380,
		range = 7,
		shootEffect = CONST_ANI_FIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -175,
		maxDamage = -200,
		length = 5,
		spread = 0,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -475,
		radius = 3,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -475,
		radius = 2,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
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
