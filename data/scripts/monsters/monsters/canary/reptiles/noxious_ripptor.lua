local mType = Game.createMonsterType("Noxious Ripptor")
local monster = {}

monster.description = "a noxious ripptor"
monster.experience = 13190
monster.outfit = {
	lookType = 1558,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2276
monster.bestiary = {
	race = "Reptile",
	class = "Reptile",
	toKill = 5000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 100,
	stars = 5,
	occurrence = 1,
	locations = "Crystal Enigma",
}

monster.health = 22700
monster.maxHealth = 22700
monster.race = "blood"
monster.corpse = 39323
monster.speed = 180
monster.manaCost = 0
monster.maxSummons = 0

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
	{ text = "Krccchht!", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 26770, minCount = 1, maxCount = 2 },
	{ id = 41479, chance = 12850 },
	{ id = 8473, chance = 10570, minCount = 1, maxCount = 2 },
	{ id = 41477, chance = 8280, minCount = 1, maxCount = 2 },
	{ id = 2409, chance = 1440 },
	{ id = 10219, chance = 1360 },
	{ id = 18411, chance = 1290 },
	{ id = 7885, chance = 750 },
	{ id = 31702, chance = 450 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1350 },
	{
		name = "combat",
		interval = 2500,
		chance = 40,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1100,
		maxDamage = -1700,
		range = 1,
		radius = 1,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{ name = "noxious ripptor wave", interval = 4500, chance = 30, minDamage = -450, maxDamage = -750 },
}

monster.defenses = {
	defense = 110,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
