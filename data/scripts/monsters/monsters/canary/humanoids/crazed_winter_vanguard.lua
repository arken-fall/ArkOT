local mType = Game.createMonsterType("Crazed Winter Vanguard")
local monster = {}

monster.description = "a crazed winter vanguard"
monster.experience = 5400
monster.outfit = {
	lookType = 1137,
	lookHead = 8,
	lookBody = 67,
	lookLegs = 8,
	lookFeet = 1,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1730
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Court of Winter, Dream Labyrinth.",
}

monster.health = 5800
monster.maxHealth = 5800
monster.race = "blood"
monster.corpse = 30122
monster.speed = 190
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
	canWalkOnPoison = false,
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
	{ text = "Nobody will ever escape from this place, muwahaha!!!", yell = false },
	{ text = "These voices… they never stop!", yell = false },
	{ text = " I am getting crazy here...Wa wa wahhh!!!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 85000, maxCount = 13 },
	{ id = 34280, chance = 13000 },
	{ id = 7760, chance = 13300 },
	{ id = 12430, chance = 10100 },
	{ id = 8473, chance = 9300 },
	{ id = 34229, chance = 8500 },
	{ id = 31050, chance = 6900 },
	{ id = 8911, chance = 6000 },
	{ id = 7888, chance = 5000 },
	{ id = 2396, chance = 6250 },
	{ id = 7897, chance = 2500 },
	{ id = 2198, chance = 720 },
	{ id = 2158, chance = 200 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2500,
		chance = 30,
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
		interval = 3000,
		chance = 20,
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
		interval = 3500,
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
	defense = 20,
	armor = 77,
	mitigation = 2.16,
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
