local mType = Game.createMonsterType("Poisonous Carnisylvan")
local monster = {}

monster.description = "a poisonous carnisylvan"
monster.experience = 4400
monster.outfit = {
	lookType = 1418,
	lookHead = 23,
	lookBody = 98,
	lookLegs = 22,
	lookFeet = 61,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2108
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Forest of Life.",
}

monster.health = 8000
monster.maxHealth = 8000
monster.race = "blood"
monster.corpse = 36890
monster.speed = 105
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
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 1
monster.summons = {
	{ name = "Carnisylvan Sapling", chance = 70, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 17 },
	{ id = 39243, chance = 12040, maxCount = 2 },
	{ id = 18397, chance = 8640, maxCount = 1 },
	{ id = 39242, chance = 8640, maxCount = 4 },
	{ id = 2127, chance = 4970 },
	{ id = 8472, chance = 6810, maxCount = 5 },
	{ id = 2427, chance = 4970 },
	{ id = 26198, chance = 4970 },
	{ id = 2181, chance = 7330 },
	{ id = 8910, chance = 6280 },
	{ id = 7387, chance = 4710 },
	{ id = 2795, chance = 3140 },
	{ id = 2430, chance = 5760 },
	{ id = 8920, chance = 4710 },
	{ id = 10219, chance = 2880 },
	{ id = 7632, chance = 2090 },
	{ id = 30499, chance = 790 },
	{ id = 39244, chance = 520 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -350,
		maxDamage = -520,
		radius = 4,
		range = 5,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -350,
		maxDamage = -450,
		range = 5,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 37,
	armor = 37,
	mitigation = 1.13,
	{ name = "speed", interval = 2000, chance = 8, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000, speed = 250 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
