local mType = Game.createMonsterType("Girtablilu Warrior")
local monster = {}

monster.description = "a girtablilu warrior"
monster.experience = 5800
monster.outfit = {
	lookType = 1407,
	lookHead = 114,
	lookBody = 39,
	lookLegs = 113,
	lookFeet = 114,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2099
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Ruins of Nuur.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 36800
monster.speed = 180
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
	{ id = 2152, chance = 70000, maxCount = 25 },
	{ id = 8473, chance = 15360, maxCount = 4 },
	{ id = 9971, chance = 14130, maxCount = 2 },
	{ id = 18415, chance = 6420, maxCount = 3 },
	{ id = 18420, chance = 5830, maxCount = 3 },
	{ id = 39402, chance = 4650, maxCount = 1 },
	{ id = 18419, chance = 4530, maxCount = 3 },
	{ id = 39259, chance = 4240 },
	{ id = 2155, chance = 4060 },
	{ id = 2153, chance = 3410 },
	{ id = 18413, chance = 2880, maxCount = 3 },
	{ id = 2416, chance = 2830 },
	{ id = 7387, chance = 2590 },
	{ id = 18414, chance = 2470 },
	{ id = 2154, chance = 2350 },
	{ id = 2396, chance = 2240 },
	{ id = 7899, chance = 2180 },
	{ id = 2438, chance = 2120 },
	{ id = 7430, chance = 2000 },
	{ id = 2430, chance = 2000 },
	{ id = 3962, chance = 1940 },
	{ id = 18421, chance = 1710 },
	{ id = 2158, chance = 1530 },
	{ id = 2156, chance = 1530 },
	{ id = 2656, chance = 1060 },
	{ id = 8871, chance = 1060 },
	{ id = 24741, chance = 820 },
	{ id = 7897, chance = 650 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -500,
		maxDamage = -650,
		radius = 4,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -200,
		maxDamage = -450,
		range = 5,
		shootEffect = CONST_ANI_POISONARROW,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -200,
		maxDamage = -400,
		length = 3,
		spread = 2,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
}

monster.defenses = {
	defense = 76,
	armor = 76,
	mitigation = 2.22,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
