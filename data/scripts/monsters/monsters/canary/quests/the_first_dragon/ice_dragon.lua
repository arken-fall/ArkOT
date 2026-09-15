local mType = Game.createMonsterType("Ice Dragon")
local monster = {}

monster.description = "an ice dragon"
monster.experience = 2300
monster.outfit = {
	lookType = 947,
	lookHead = 0,
	lookBody = 9,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1380
monster.bestiary = {
	race = "Dragon",
	class = "Dragon",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 2,
	locations = "The First Dragon's Lair.",
}

monster.health = 2500
monster.maxHealth = 2500
monster.race = "undead"
monster.corpse = 25185
monster.speed = 106
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 5,
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
	runHealth = 350,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 350

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2148, chance = 96850, maxCount = 216 },
	{ id = 2672, chance = 80020, maxCount = 2 },
	{ id = 7839, chance = 78200, maxCount = 10 },
	{ id = 7590, chance = 40200, maxCount = 2 },
	{ id = 2146, chance = 52100 },
	{ id = 31027, chance = 18680 },
	{ id = 31028, chance = 11400 },
	{ id = 2167, chance = 49900 },
	{ id = 7902, chance = 11900 },
	{ id = 2033, chance = 21700 },
	{ id = 2183, chance = 21700 },
	{ id = 7441, chance = 43400 },
	{ id = 7888, chance = 540 },
	{ id = 2177, chance = 540 },
	{ id = 7290, chance = 1090 },
	{ id = 2492, chance = 330 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 78, attack = 50 },
	{
		name = "speed",
		interval = 2000,
		chance = 18,
		minDamage = 0,
		maxDamage = -400,
		range = 7,
		radius = 4,
		effect = CONST_ME_ICETORNADO,
		target = true,
		duration = 20000,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -50,
		maxDamage = -120,
		range = 7,
		radius = 3,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
	{
		name = "speed",
		interval = 2000,
		chance = 12,
		minDamage = 0,
		maxDamage = -400,
		length = 7,
		spread = 3,
		effect = CONST_ME_ICEATTACK,
		target = false,
		duration = 20000,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_LIFEDRAIN,
		minDamage = -150,
		maxDamage = -380,
		length = 8,
		spread = 3,
		effect = CONST_ME_POFF,
		target = false,
	},
}

monster.defenses = {
	defense = 35,
	armor = 22,
	{ name = "combat", interval = 2000, chance = 16, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
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
