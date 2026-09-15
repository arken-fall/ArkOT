local mType = Game.createMonsterType("Putrid Mummy")
local monster = {}

monster.description = "a putrid mummy"
monster.experience = 900
monster.outfit = {
	lookType = 976,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1415
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Caverna Exanima.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "undead"
monster.corpse = 6004
monster.speed = 85
monster.manaCost = 0

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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We will make you one of us!", yell = false },
	{ text = "Come to mummy!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 60870, maxCount = 62 },
	{ id = 13472, chance = 3840 },
	{ id = 2144, chance = 1280 },
	{ id = 31705, chance = 13550 },
	{ id = 31704, chance = 8950 },
	{ id = 2155, chance = 3070 },
	{ id = 31700, chance = 1100 },
	{ id = 2159, chance = 8180, maxCount = 3 },
	{ id = 2411, chance = 1530 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -100,
		maxDamage = -150,
		range = 1,
		shootEffect = CONST_ANI_EARTH,
		effect = CONST_ME_CARNIPHILA,
		target = true,
	},
	{
		name = "speed",
		interval = 2000,
		chance = 15,
		range = 7,
		shootEffect = CONST_ANI_DEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
		duration = 10000,
		speed = -226,
	},
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
