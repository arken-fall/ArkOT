local mType = Game.createMonsterType("Mega Dragon")
local monster = {}

monster.description = "a mega dragon"
monster.experience = 7810
monster.outfit = {
	lookType = 1712,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2459
monster.bestiary = {
	race = "Dragon",
	class = "Dragon",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 5,
	occurrence = 0,
	locations = "Nimmersatt's Breeding Ground",
}

monster.health = 7920
monster.maxHealth = 7920
monster.race = "blood"
monster.corpse = 44663
monster.speed = 170
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
	{ text = "Just Look at me!", yell = false },
	{ text = "I'll stare you down", yell = false },
	{ text = "Let me have a look", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 50780, minCount = 1, maxCount = 48 },
	{ id = 44817, chance = 8670 },
	{ id = 2156, chance = 10090 },
	{ id = 44818, chance = 4720 },
	{ id = 31051, chance = 4460 },
	{ id = 31736, chance = 4430, minCount = 1, maxCount = 2 },
	{ id = 2158, chance = 6790 },
	{ id = 44819, chance = 1850 },
	{ id = 2153, chance = 1470 },
	{ id = 7402, chance = 130 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{
		name = "combat",
		interval = 2500,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -250,
		maxDamage = -350,
		range = 2,
		effect = CONST_ME_BIG_SCRATCH,
		target = true,
	},
	{
		name = "combat",
		interval = 2500,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -250,
		maxDamage = -300,
		length = 8,
		spread = 4,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2500,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 5,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = -350,
		radius = 4,
		effect = CONST_ME_POFF,
		target = true,
	},
	{ name = "death chain", interval = 2500, chance = 15, minDamage = -200, maxDamage = -350, range = 7 },
}

monster.defenses = {
	defense = 76,
	armor = 76,
	mitigation = 1.96,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
