local mType = Game.createMonsterType("Rootthing Bug Tracker")
local monster = {}

monster.description = "a rootthing bug tracker"
monster.experience = 9650
monster.outfit = {
	lookType = 1763,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2538
monster.bestiary = {
	race = "Plant",
	class = "Plant",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Podzilla Stalk",
}

monster.health = 12500
monster.maxHealth = 12500
monster.race = "venom"
monster.corpse = 48406
monster.speed = 195
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
	canPushCreatures = false,
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
	{ text = "Ktsktskts!", yell = false },
	{ text = "BRRRRN!!!", yell = true },
	{ text = "FRRRRR!!!", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 74620, maxCount = 44 },
	{ id = 2149, chance = 6180 },
	{ id = 46915, chance = 4840 },
	{ id = 46914, chance = 4510 },
	{ id = 8912, chance = 3170 },
	{ id = 2664, chance = 1170 },
	{ id = 2155, chance = 1170 },
	{ id = 2470, chance = 170 },
	{ id = 8855, chance = 170 },
	{ id = 45681, chance = 110 },
	{ id = 45682, chance = 110 },
	{ id = 45686, chance = 110 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "rotthligholyulus", interval = 2000, chance = 14, minDamage = -630, maxDamage = -840 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -530,
		maxDamage = -720,
		radius = 4,
		effect = CONST_ME_EXPLOSIONHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -460,
		maxDamage = -740,
		range = 6,
		radius = 2,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{ name = "podzillaphyschain", interval = 2000, chance = 16 },
	{ name = "rotthligexplo", interval = 2000, chance = 18, minDamage = -400, maxDamage = -625 },
}

monster.defenses = {
	defense = 92,
	armor = 92,
	mitigation = 2.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
