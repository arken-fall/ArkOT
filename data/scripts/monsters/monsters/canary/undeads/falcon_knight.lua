local mType = Game.createMonsterType("Falcon Knight")
local monster = {}

monster.description = "a falcon knight"
monster.experience = 6300
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1646
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Falcon Bastion.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 28621
monster.speed = 110
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
	{ text = "Mmmhaarrrgh!", yell = false },
}

monster.loot = {
	{ id = 2671, chance = 70080, maxCount = 8 },
	{ id = 5944, chance = 35000 },
	{ id = 7590, chance = 33000, maxCount = 3 },
	{ id = 7591, chance = 33000, maxCount = 3 },
	{ id = 6558, chance = 30000, maxCount = 4 },
	{ id = 2150, chance = 24950, maxCount = 3 },
	{ id = 7368, chance = 24670, maxCount = 10 },
	{ id = 2145, chance = 15700, maxCount = 3 },
	{ id = 2147, chance = 15333, maxCount = 3 },
	{ id = 2149, chance = 15110, maxCount = 3 },
	{ id = 7365, chance = 14480, maxCount = 15 },
	{ id = 9970, chance = 4580, maxCount = 3 },
	{ id = 7413, chance = 3000 },
	{ id = 7633, chance = 3000 },
	{ id = 7452, chance = 2200 },
	{ id = 2476, chance = 1980 },
	{ id = 33665, chance = 1250 },
	{ id = 2454, chance = 1230 },
	{ id = 2153, chance = 1060 },
	{ id = 33664, chance = 990 },
	{ id = 2155, chance = 880 },
	{ id = 2466, chance = 840 },
	{ id = 2514, chance = 620 },
	{ id = 2452, chance = 460 },
	{ id = 2578, chance = 370 },
	{ id = 2136, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		radius = 2,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 14,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -290,
		maxDamage = -360,
		length = 5,
		spread = 0,
		effect = CONST_ME_BLOCKHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 86,
	armor = 86,
	mitigation = 2.37,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
