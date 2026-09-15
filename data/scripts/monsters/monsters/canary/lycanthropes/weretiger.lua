local mType = Game.createMonsterType("Weretiger")
local monster = {}

monster.description = "a weretiger"
monster.experience = 3920
monster.outfit = {
	lookType = 1646,
	lookHead = 97,
	lookBody = 114,
	lookLegs = 113,
	lookFeet = 94,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 2386
monster.bestiary = {
	race = "Lycanthrope",
	class = "Lycanthrope",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Murky Caverns",
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 43669
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 20,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2152, chance = 100000, maxCount = 13 },
	{ id = 43923, chance = 10800 },
	{ id = 7432, chance = 6230 },
	{ id = 2666, chance = 5500, maxCount = 4 },
	{ id = 18414, chance = 3370 },
	{ id = 24739, chance = 2550 },
	{ id = 2158, chance = 1200 },
	{ id = 2476, chance = 3000 },
	{ id = 7436, chance = 1430 },
	{ id = 30499, chance = 1770 },
	{ id = 7890, chance = 1770 },
	{ id = 43925, chance = 510 },
	{ id = 44104, chance = 610 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -50, maxDamage = -625 },
	{ name = "energy chain", interval = 3300, chance = 20, minDamage = -175, maxDamage = -375, range = 3, target = true },
	{
		name = "combat",
		interval = 3300,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -375,
		length = 5,
		spread = 2,
		effect = CONST_ME_BLUE_ENERGY_SPARK,
		target = false,
	},
	{
		name = "combat",
		interval = 2700,
		chance = 37,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -175,
		maxDamage = -325,
		radius = 1,
		effect = CONST_ME_BIG_SCRATCH,
		range = 1,
		target = true,
	},
}

monster.defenses = {
	defense = 30,
	armor = 76,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
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
