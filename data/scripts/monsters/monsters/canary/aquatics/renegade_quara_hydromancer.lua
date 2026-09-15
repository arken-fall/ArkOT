local mType = Game.createMonsterType("Renegade Quara Hydromancer")
local monster = {}

monster.description = "a renegade quara hydromancer"
monster.experience = 1800
monster.outfit = {
	lookType = 47,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1098
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 2,
	locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6066
monster.speed = 245
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 78000, maxCount = 4 },
	{ id = 12444, chance = 20160 },
	{ id = 2178, chance = 10710 },
	{ id = 2670, chance = 7140, maxCount = 4 },
	{ id = 9970, chance = 6800, maxCount = 2 },
	{ id = 2149, chance = 6450, maxCount = 2 },
	{ id = 7590, chance = 5880, maxCount = 2 },
	{ id = 8870, chance = 5650 },
	{ id = 7591, chance = 4950, maxCount = 2 },
	{ id = 5914, chance = 3230 },
	{ id = 18415, chance = 3000 },
	{ id = 5910, chance = 2880 },
	{ id = 2168, chance = 2190 },
	{ id = 5895, chance = 1380 },
	{ id = 7632, chance = 1150 },
	{ id = 2189, chance = 1150 },
	{ id = 2155, chance = 460 },
	{ id = 2476, chance = 460 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		skill = 110,
		attack = 90,
		effect = CONST_ME_DRAWBLOOD,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 5, maxDamage = 5 },
	},
	{ name = "speed", interval = 2000, chance = 15, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000, speed = -350 },
}

monster.defenses = {
	defense = 15,
	armor = 30,
	mitigation = 1.04,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
