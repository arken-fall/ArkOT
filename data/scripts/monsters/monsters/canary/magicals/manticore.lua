local mType = Game.createMonsterType("Manticore")
local monster = {}

monster.description = "a manticore"
monster.experience = 5100
monster.outfit = {
	lookType = 1189,
	lookHead = 116,
	lookBody = 97,
	lookLegs = 113,
	lookFeet = 20,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1816
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Kilmaresh.",
}

monster.health = 6700
monster.maxHealth = 6700
monster.race = "blood"
monster.corpse = 31390
monster.speed = 150
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
	{ text = "I'm spotting my next meal", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 35430, chance = 10250 },
	{ id = 35431, chance = 7390 },
	{ id = 2149, chance = 5880 },
	{ id = 18421, chance = 5710 },
	{ id = 7840, chance = 4870, maxCount = 9 },
	{ id = 31051, chance = 4370 },
	{ id = 31736, chance = 3700, maxCount = 3 },
	{ id = 7899, chance = 3190 },
	{ id = 2153, chance = 3030 },
	{ id = 7891, chance = 2860 },
	{ id = 7900, chance = 2020 },
	{ id = 2191, chance = 1680 },
	{ id = 8921, chance = 1180 },
	{ id = 31758, chance = 1010, maxCount = 3 },
	{ id = 18409, chance = 1010 },
	{ id = 7894, chance = 340 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_FIREDAMAGE,
		minDamage = -300,
		maxDamage = -450,
		length = 8,
		spread = 3,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -400,
		radius = 3,
		shootEffect = CONST_ANI_ENVENOMEDARROW,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_FIREDAMAGE,
		minDamage = -450,
		maxDamage = -550,
		range = 4,
		shootEffect = CONST_ANI_BURSTARROW,
		target = true,
	},
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
