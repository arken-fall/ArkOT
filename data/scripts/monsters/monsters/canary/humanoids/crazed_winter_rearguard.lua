local mType = Game.createMonsterType("Crazed Winter Rearguard")
local monster = {}

monster.description = "a crazed winter rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 47,
	lookBody = 7,
	lookLegs = 0,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1731
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

monster.health = 5200
monster.maxHealth = 5200
monster.race = "blood"
monster.corpse = 30127
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
}

monster.loot = {
	{ id = 2152, chance = 86000, maxCount = 5 },
	{ id = 18420, chance = 2000 },
	{ id = 2156, chance = 330 },
	{ id = 2396, chance = 17200 },
	{ id = 8473, chance = 16850 },
	{ id = 8472, chance = 15780 },
	{ id = 34280, chance = 9000, maxCount = 2 },
	{ id = 2177, chance = 7900 },
	{ id = 34229, chance = 8750 },
	{ id = 12421, chance = 7600 },
	{ id = 7902, chance = 6000 },
	{ id = 2186, chance = 5400 },
	{ id = 7759, chance = 4700, maxCount = 7 },
	{ id = 8911, chance = 2360 },
	{ id = 7888, chance = 2930 },
	{ id = 2183, chance = 2660 },
	{ id = 7897, chance = 1930 },
	{ id = 18419, chance = 2100 },
	{ id = 2198, chance = 1260 },
	{ id = 2158, chance = 330 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2500,
		chance = 20,
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
		chance = 25,
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
		chance = 25,
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
	armor = 76,
	mitigation = 2.11,
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
