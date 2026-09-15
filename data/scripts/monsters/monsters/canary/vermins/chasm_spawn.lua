local mType = Game.createMonsterType("Chasm Spawn")
local monster = {}

monster.description = "a chasm spawn"
monster.experience = 3600
monster.outfit = {
	lookType = 1037,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1546
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Warzone 4",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 27563
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canWalkOnFire = false,
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
	{ id = 2148, chance = 10000, maxCount = 78 },
	{ id = 2791, chance = 27200, maxCount = 5 },
	{ id = 32633, chance = 33390 },
	{ id = 32634, chance = 24710 },
	{ id = 32635, chance = 64890 },
	{ id = 7761, chance = 11040, maxCount = 3 },
	{ id = 7762, chance = 8170, maxCount = 3 },
	{ id = 2789, chance = 19680, maxCount = 5 },
	{ id = 2790, chance = 15140 },
	{ id = 18413, chance = 7850 },
	{ id = 18415, chance = 7850 },
	{ id = 18414, chance = 4690 },
	{ id = 18393, chance = 610 },
	{ id = 32682, chance = 850 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -5,
		maxDamage = -16,
		range = 7,
		shootEffect = CONST_ANI_POISON,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -30,
		maxDamage = -60,
		range = 7,
		shootEffect = CONST_ANI_DEATH,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -70,
		maxDamage = -160,
		range = 3,
		length = 3,
		spread = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{ name = "explosion rune", interval = 2000, chance = 15, minDamage = -50, maxDamage = -170, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_MANADRAIN, minDamage = -40, maxDamage = -60, range = 7, target = false },
	{ name = "stone shower rune", interval = 2000, chance = 10, minDamage = -70, maxDamage = -140, range = 7, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -70,
		maxDamage = -140,
		length = 3,
		spread = 3,
		effect = CONST_ME_PLANTATTACK,
		target = false,
	},
}

monster.defenses = {
	defense = 5,
	armor = 74,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
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
