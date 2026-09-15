local mType = Game.createMonsterType("Oozing Carcass")
local monster = {}

monster.description = "an oozing carcass"
monster.experience = 20980
monster.outfit = {
	lookType = 1626,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2377
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Putrefactory.",
}

monster.health = 27500
monster.maxHealth = 27500
monster.race = "undead"
monster.corpse = 43579
monster.speed = 215
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
	canPushCreatures = false,
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
	level = 4,
	color = 143,
}

monster.loot = {
	{ id = 2160, chance = 9000, maxCount = 1 },
	{ id = 2149, chance = 12859, maxCount = 1 },
	{ id = 2156, chance = 9808, maxCount = 1 },
	{ id = 2436, chance = 12316, maxCount = 1 },
	{ id = 2541, chance = 6752, maxCount = 1 },
	{ id = 2154, chance = 8634, maxCount = 1 },
	{ id = 44039, chance = 13133, maxCount = 1 },
	{ id = 44036, chance = 6964, maxCount = 1 },
	{ id = 8473, chance = 10285, maxCount = 2 },
	{ id = 7416, chance = 12270, maxCount = 1 },
	{ id = 8901, chance = 5084, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -1500,
		maxDamage = -1600,
		radius = 5,
		effect = CONST_ME_BLACKSMOKE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1400,
		maxDamage = -1500,
		radius = 5,
		effect = CONST_ME_ICEAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1400,
		maxDamage = -1550,
		length = 8,
		spread = 5,
		effect = CONST_ME_ICEAREA,
		target = false,
	},
	{ name = "largedeathring", interval = 2000, chance = 20, minDamage = -850, maxDamage = -1400, target = false },
	{ name = "energy chain", interval = 3000, chance = 20, minDamage = -1050, maxDamage = -1400, target = false },
}

monster.defenses = {
	defense = 102,
	armor = 102,
	mitigation = 3.1,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
