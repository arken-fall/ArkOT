local mType = Game.createMonsterType("Lumbering Carnivor")
local monster = {}

monster.description = "a lumbering carnivor"
monster.experience = 1452
monster.outfit = {
	lookType = 1133,
	lookHead = 0,
	lookBody = 59,
	lookLegs = 67,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1721
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Carnivora's Rocks.",
}

monster.health = 2600
monster.maxHealth = 2600
monster.race = "blood"
monster.corpse = 30065
monster.speed = 200
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 4,
	color = 107,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 64770, maxCount = 3 },
	{ id = 34128, chance = 20840, maxCount = 3 },
	{ id = 2386, chance = 14620 },
	{ id = 2396, chance = 7600 },
	{ id = 2376, chance = 5500 },
	{ id = 7632, chance = 1830 },
	{ id = 2155, chance = 1680 },
	{ id = 2153, chance = 1560 },
	{ id = 7454, chance = 1530 },
	{ id = 2377, chance = 1490 },
	{ id = 2656, chance = 760 },
	{ id = 2158, chance = 990 },
	{ id = 24741, chance = 950 },
	{ id = 18415, chance = 920 },
	{ id = 8871, chance = 80 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -500 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -100,
		maxDamage = -150,
		radius = 4,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
}

monster.defenses = {
	defense = 20,
	armor = 65,
	mitigation = 1.82,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -40 },
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
