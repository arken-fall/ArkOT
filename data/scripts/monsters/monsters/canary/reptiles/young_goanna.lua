local mType = Game.createMonsterType("Young Goanna")
local monster = {}

monster.description = "a young goanna"
monster.experience = 6100
monster.outfit = {
	lookType = 1196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1817
monster.bestiary = {
	race = "Reptile",
	class = "Reptile",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt.",
}

monster.health = 6200
monster.maxHealth = 6200
monster.race = "blood"
monster.corpse = 31409
monster.speed = 190
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
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 10

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 18437, chance = 70400, maxCount = 35 },
	{ id = 2182, chance = 10620 },
	{ id = 35542, chance = 10030 },
	{ id = 18413, chance = 9110 },
	{ id = 2181, chance = 8940 },
	{ id = 35541, chance = 8260 },
	{ id = 7761, chance = 4890 },
	{ id = 31734, chance = 4550, maxCount = 3 },
	{ id = 31736, chance = 4050, maxCount = 3 },
	{ id = 24849, chance = 4050 },
	{ id = 35543, chance = 3880 },
	{ id = 2153, chance = 3540 },
	{ id = 2409, chance = 3370 },
	{ id = 8912, chance = 3370 },
	{ id = 18415, chance = 2950 },
	{ id = 35479, chance = 2610 },
	{ id = 2154, chance = 2530 },
	{ id = 2170, chance = 2280 },
	{ id = 7887, chance = 1430 },
	{ id = 2158, chance = 1180 },
	{ id = 7903, chance = 1100 },
	{ id = 18418, chance = 1010 },
	{ id = 10219, chance = 840 },
	{ id = 35436, chance = 670 },
	{ id = 35336, chance = 590 },
	{ id = 31702, chance = 170 },
	{ id = 24741, chance = 80 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -500,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 200, maxDamage = 200 },
	},
	{
		name = "combat",
		interval = 2500,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -490,
		range = 3,
		shootEffect = CONST_ANI_EARTH,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		radius = 1,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{
		name = "combat",
		interval = 3500,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -490,
		lenght = 8,
		spread = 0,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 420 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
