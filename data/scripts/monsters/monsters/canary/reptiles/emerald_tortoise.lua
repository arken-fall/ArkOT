local mType = Game.createMonsterType("Emerald Tortoise")
local monster = {}

monster.description = "an emerald tortoise"
monster.experience = 12129
monster.outfit = {
	lookType = 1550,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2268
monster.bestiary = {
	race = "Reptile",
	class = "Reptile",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Sparkling Pools",
}

monster.health = 22300
monster.maxHealth = 22300
monster.race = "blood"
monster.corpse = 39291
monster.speed = 179
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
	{ text = "Shllpp...", yell = false },
}

monster.loot = {
	{ id = 41467, chance = 28590 },
	{ id = 2160, chance = 15520, minCount = 1, maxCount = 3 },
	{ id = 8472, chance = 13360, minCount = 1, maxCount = 2 },
	{ id = 18413, chance = 4030 },
	{ id = 18421, chance = 3950 },
	{ id = 2153, chance = 3950 },
	{ id = 18420, chance = 3350 },
	{ id = 2154, chance = 3320 },
	{ id = 2143, chance = 3240 },
	{ id = 18415, chance = 2900 },
	{ id = 2155, chance = 2870 },
	{ id = 5022, chance = 2640, minCount = 1, maxCount = 2 },
	{ id = 7633, chance = 2420 },
	{ id = 2156, chance = 2420 },
	{ id = 2144, chance = 2160, minCount = 1, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1250 },
	{ name = "energy chain", interval = 5000, chance = 37, minDamage = -750, maxDamage = -1000, range = 3, target = true },
	{
		name = "combat",
		interval = 2700,
		chance = 35,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -500,
		maxDamage = -600,
		range = 5,
		shootEffect = CONST_ANI_ENERGY,
		target = true,
	},
	{ name = "emerald tortoise large ring", interval = 3500, chance = 35, minDamage = -550, maxDamage = -1000 },
	{ name = "emerald tortoise small ring", interval = 4500, chance = 20, minDamage = -550, maxDamage = -700 },
	{ name = "emerald tortoise small explosion", interval = 3800, chance = 30, minDamage = -400, maxDamage = -600 },
	{
		name = "combat",
		interval = 4100,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -450,
		maxDamage = -750,
		radius = 3,
		effect = CONST_ME_BLUE_ENERGY_SPARK,
		target = false,
	},
}

monster.defenses = {
	defense = 110,
	armor = 97,
	mitigation = 2.57,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
