local mType = Game.createMonsterType("Usurper Archer")
local monster = {}

monster.description = "an usurper archer"
monster.experience = 6800
monster.outfit = {
	lookType = 1316,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 76,
	lookFeet = 95,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1973
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Bounac, the Order of the Lion settlement.",
}

monster.health = 7300
monster.maxHealth = 7300
monster.race = "blood"
monster.corpse = 33981
monster.speed = 125
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
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
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 8473, chance = 75135, maxCount = 3 },
	{ id = 2666, chance = 47703 },
	{ id = 37484, chance = 14595 },
	{ id = 37485, chance = 10135 },
	{ id = 2144, chance = 8784 },
	{ id = 2475, chance = 8784 },
	{ id = 23546, chance = 8514 },
	{ id = 2134, chance = 7838 },
	{ id = 2403, chance = 7703 },
	{ id = 37483, chance = 6892 },
	{ id = 7632, chance = 5676 },
	{ id = 30499, chance = 4189 },
	{ id = 2143, chance = 3514 },
	{ id = 7892, chance = 2432 },
	{ id = 2476, chance = 1892 },
	{ id = 30498, chance = 1757 },
	{ id = 7404, chance = 1622 },
	{ id = 15644, chance = 946 },
	{ id = 2127, chance = 811 },
	{ id = 2664, chance = 405 },
	{ id = 7438, chance = 270 },
}

monster.attacks = {
	{
		name = "combat",
		interval = 2000,
		chance = 100,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -430,
		range = 7,
		shootEffect = CONST_ANI_BURSTARROW,
		target = true,
	},
	{
		name = "combat",
		interval = 6000,
		chance = 12,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -160,
		maxDamage = -485,
		range = 7,
		shootEffect = CONST_ANI_SMALLHOLY,
		target = true,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -160,
		maxDamage = -545,
		range = 7,
		effect = CONST_ME_MORTAREA,
		shootEffect = CONST_ANI_SUDDENDEATH,
		target = true,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 10,
		type = COMBAT_ICEDAMAGE,
		minDamage = -150,
		maxDamage = -425,
		radius = 3,
		effect = CONST_ME_ICEAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 50,
	armor = 82,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
