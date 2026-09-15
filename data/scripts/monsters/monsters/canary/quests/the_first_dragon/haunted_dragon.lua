local mType = Game.createMonsterType("Haunted Dragon")
local monster = {}

monster.description = "a haunted dragon"
monster.experience = 6500
monster.outfit = {
	lookType = 231,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1376
monster.bestiary = {
	class = "Dragon",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 2,
	locations = "The First Dragons Lair, fourth floor.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "undead"
monster.corpse = 6305
monster.speed = 140
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
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
	{ id = 2144, chance = 22780, maxCount = 2 },
	{ id = 2146, chance = 28370, maxCount = 2 },
	{ id = 2148, chance = 35500, maxCount = 100 },
	{ id = 2148, chance = 55500, maxCount = 98 },
	{ id = 2152, chance = 52000, maxCount = 5 },
	{ id = 2177, chance = 2500 },
	{ id = 5925, chance = 14180 },
	{ id = 6300, chance = 1150 },
	{ id = 6500, chance = 12460 },
	{ id = 7368, chance = 26650, maxCount = 5 },
	{ id = 7402, chance = 860 },
	{ id = 7430, chance = 4000 },
	{ id = 7590, chance = 21490 },
	{ id = 7591, chance = 21200 },
	{ id = 8889, chance = 290 },
	{ id = 9971, chance = 570 },
	{ id = 11233, chance = 33380 },
	{ id = 11355, chance = 860 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{
		name = "combat",
		interval = 2000,
		chance = 5,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -300,
		maxDamage = -400,
		range = 7,
		radius = 4,
		effect = CONST_ME_HITAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -125,
		maxDamage = -600,
		range = 7,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_SMALLCLOUDS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 5,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -100,
		maxDamage = -390,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = 0,
		maxDamage = -180,
		range = 7,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -150,
		maxDamage = -690,
		length = 8,
		spread = 3,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -300,
		maxDamage = -700,
		length = 8,
		spread = 3,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -200,
		radius = 3,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
	{ name = "undead dragon curse", interval = 2000, chance = 10, target = false },
}

monster.defenses = {
	defense = 40,
	armor = 58,
	mitigation = 1.6,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
