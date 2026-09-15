local mType = Game.createMonsterType("Soul-Broken Harbinger")
local monster = {}

monster.description = "a soul-broken harbinger"
monster.experience = 5800
monster.outfit = {
	lookType = 1137,
	lookHead = 85,
	lookBody = 10,
	lookLegs = 16,
	lookFeet = 83,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1734
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Court of Winter.",
}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 30137
monster.speed = 210
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
	canWalkOnEnergy = false,
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
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 12 },
	{ id = 34280, chance = 15750, maxCount = 3 },
	{ id = 34229, chance = 13700 },
	{ id = 10552, chance = 4790 },
	{ id = 2477, chance = 4450 },
	{ id = 7896, chance = 4110 },
	{ id = 7892, chance = 3770 },
	{ id = 2396, chance = 3770 },
	{ id = 8902, chance = 2400 },
	{ id = 2519, chance = 1710 },
	{ id = 2664, chance = 1710 },
	{ id = 26185, chance = 1370 },
	{ id = 2528, chance = 680 },
	{ id = 26199, chance = 680 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2100,
		chance = 40,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		range = 5,
		radius = 1,
		effect = CONST_ME_ICEAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2600,
		chance = 30,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		length = 4,
		spread = 0,
		effect = CONST_ME_GIANTICE,
		target = false,
	},
	{
		name = "combat",
		interval = 3100,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -250,
		maxDamage = -300,
		radius = 3,
		effect = CONST_ME_ICEAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 76,
	mitigation = 2.08,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 55 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
