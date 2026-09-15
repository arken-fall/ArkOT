local mType = Game.createMonsterType("Burster Spectre")
local monster = {}

monster.description = "a burster spectre"
monster.experience = 6000
monster.outfit = {
	lookType = 1122,
	lookHead = 9,
	lookBody = 10,
	lookLegs = 86,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1726
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Haunted Tomb west of Darashia, Buried Cathedral.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "blood"
monster.corpse = 30163
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We came tooo thiiiiss wooorld to... get youuu!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 7 },
	{ id = 8472, chance = 100000, maxCount = 3 },
	{ id = 2200, chance = 15000 },
	{ id = 2177, chance = 12050 },
	{ id = 2170, chance = 15000 },
	{ id = 8922, chance = 11050 },
	{ id = 2189, chance = 11800 },
	{ id = 2201, chance = 16600 },
	{ id = 2197, chance = 8860 },
	{ id = 34304, chance = 15600 },
	{ id = 7888, chance = 16890 },
	{ id = 2176, chance = 18980 },
	{ id = 2183, chance = 17550 },
	{ id = 2198, chance = 1800 },
	{ id = 2199, chance = 2640 },
	{ id = 2171, chance = 2600 },
	{ id = 2178, chance = 1800 },
	{ id = 18412, chance = 520 },
	{ id = 10221, chance = 620 },
	{ id = 2174, chance = 720 },
	{ id = 34382, chance = 480 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2700,
		chance = 25,
		type = COMBAT_ICEDAMAGE,
		minDamage = -250,
		maxDamage = -400,
		radius = 1,
		range = 5,
		effect = CONST_ME_ICEAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 3500,
		chance = 25,
		type = COMBAT_ICEDAMAGE,
		minDamage = -300,
		maxDamage = -400,
		radius = 5,
		range = 5,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 3900,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -300,
		maxDamage = -400,
		range = 5,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{
		name = "combat",
		interval = 4400,
		chance = 27,
		type = COMBAT_ICEDAMAGE,
		minDamage = -300,
		maxDamage = -450,
		length = 4,
		spread = 2,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 5500,
		chance = 47,
		type = COMBAT_LIFEDRAIN,
		minDamage = -300,
		maxDamage = -400,
		radius = 3,
		effect = CONST_ME_BLUE_ENERGY_SPARK,
		target = false,
	},
}

monster.defenses = {
	defense = 70,
	armor = 70,
	mitigation = 2.11,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 133 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
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
