local mType = Game.createMonsterType("Venerable Girtablilu")
local monster = {}

monster.description = "a venerable girtablilu"
monster.experience = 5300
monster.outfit = {
	lookType = 1407,
	lookHead = 38,
	lookBody = 58,
	lookLegs = 114,
	lookFeet = 2,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2098
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Ruins of Nuur",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 36963
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 70
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
	{ id = 2152, chance = 70000, maxCount = 19 },
	{ id = 9971, chance = 15920, maxCount = 2 },
	{ id = 2145, chance = 5360, maxCount = 6 },
	{ id = 18419, chance = 5210, maxCount = 3 },
	{ id = 39259, chance = 5210, maxCount = 1 },
	{ id = 2156, chance = 4910, maxCount = 1 },
	{ id = 39403, chance = 4760, maxCount = 1 },
	{ id = 2153, chance = 4170, maxCount = 1 },
	{ id = 8911, chance = 3570 },
	{ id = 2189, chance = 2680 },
	{ id = 18413, chance = 2530 },
	{ id = 18420, chance = 2530 },
	{ id = 18414, chance = 2530 },
	{ id = 2154, chance = 2530 },
	{ id = 8910, chance = 2080 },
	{ id = 8922, chance = 2080 },
	{ id = 2158, chance = 1930 },
	{ id = 26185, chance = 1930 },
	{ id = 18421, chance = 1640 },
	{ id = 18415, chance = 1640 },
	{ id = 18390, chance = 1340 },
	{ id = 2664, chance = 1340 },
	{ id = 2185, chance = 1040 },
	{ id = 8912, chance = 1040 },
	{ id = 2188, chance = 1040 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 2750,
		chance = 30,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -200,
		maxDamage = -500,
		range = 7,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -200,
		maxDamage = -400,
		length = 4,
		spread = 0,
		effect = CONST_ME_HITBYPOISON,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -200,
		maxDamage = -400,
		radius = 3,
		effect = CONST_ME_HITBYPOISON,
		target = false,
	},
	{ name = "girtablilu poison wave", interval = 2000, chance = 30, minDamage = -200, maxDamage = -400 },
}

monster.defenses = {
	defense = 80,
	armor = 80,
	mitigation = 2.16,
	{ name = "speed", interval = 1000, chance = 10, effect = CONST_ME_POFF, target = false, duration = 4000, speed = 160 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
