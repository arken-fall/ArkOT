local mType = Game.createMonsterType("Blemished Spawn")
local monster = {}

monster.description = "a blemished spawn"
monster.experience = 5300
monster.outfit = {
	lookType = 1401,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2093
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Antrum of the Fallen.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 36701
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 80
monster.runHealth = 0

monster.light = {
	level = 3,
	color = 66,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 25 },
	{ id = 2181, chance = 26530 },
	{ id = 39216, chance = 9690, maxCount = 1 },
	{ id = 18419, chance = 8420, maxCount = 3 },
	{ id = 18414, chance = 7380, maxCount = 3 },
	{ id = 2183, chance = 5550 },
	{ id = 18413, chance = 6300, maxCount = 3 },
	{ id = 2430, chance = 4750 },
	{ id = 7430, chance = 3950 },
	{ id = 2153, chance = 4660 },
	{ id = 2154, chance = 4560 },
	{ id = 8920, chance = 4190 },
	{ id = 8911, chance = 5320 },
	{ id = 39215, chance = 4840 },
	{ id = 10219, chance = 4000 },
	{ id = 8912, chance = 4610 },
	{ id = 7387, chance = 3950 },
	{ id = 7632, chance = 3570 },
	{ id = 2396, chance = 3950 },
	{ id = 2401, chance = 3760 },
	{ id = 2189, chance = 3620 },
	{ id = 39217, chance = 3530 },
	{ id = 24741, chance = 1360 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -300,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 340, maxDamage = 340 },
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -510,
		maxDamage = -610,
		range = 7,
		radius = 3,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -700,
		maxDamage = -750,
		radius = 4,
		effect = CONST_ME_HITBYPOISON,
		target = false,
	},
}

monster.defenses = {
	defense = 61,
	armor = 61,
	mitigation = 1.6,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 225, maxDamage = 380, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
