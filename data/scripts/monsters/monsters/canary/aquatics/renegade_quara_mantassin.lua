local mType = Game.createMonsterType("Renegade Quara Mantassin")
local monster = {}

monster.description = "a renegade quara mantassin"
monster.experience = 1000
monster.outfit = {
	lookType = 72,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1099
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

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 6064
monster.speed = 295
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
	{ id = 12445, chance = 14490 },
	{ id = 2178, chance = 10370 },
	{ id = 2670, chance = 3950, maxCount = 3 },
	{ id = 2146, chance = 3540, maxCount = 3 },
	{ id = 2165, chance = 3290 },
	{ id = 2396, chance = 2060 },
	{ id = 18413, chance = 1890 },
	{ id = 2479, chance = 1320 },
	{ id = 2377, chance = 820 },
	{ id = 5895, chance = 740 },
	{ id = 2656, chance = 660 },
	{ id = 2167, chance = 580 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 40, attack = 55, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 15,
	armor = 16,
	mitigation = 0.7,
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
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
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
