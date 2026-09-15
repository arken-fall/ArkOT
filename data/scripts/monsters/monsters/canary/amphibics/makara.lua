local mType = Game.createMonsterType("Makara")
local monster = {}

monster.description = "a makara"
monster.experience = 5720
monster.outfit = {
	lookType = 1565,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2262
monster.bestiary = {
	race = "Amphibic",
	class = "Amphibic",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Temple of the Moon Goddess.",
}

monster.health = 5050
monster.maxHealth = 5050
monster.race = "blood"
monster.corpse = 39366
monster.speed = 175
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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
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
	{ text = "waddle waddle", yell = false },
	{ text = "Nihahaha!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 18 },
	{ id = 41490, chance = 10160 },
	{ id = 41489, chance = 7420, maxCount = 2 },
	{ id = 2666, chance = 7030, maxCount = 2 },
	{ id = 18419, chance = 4300 },
	{ id = 2154, chance = 4100 },
	{ id = 31736, chance = 3320, maxCount = 2 },
	{ id = 2145, chance = 2340, maxCount = 3 },
	{ id = 2158, chance = 2150 },
	{ id = 18415, chance = 1950 },
	{ id = 18421, chance = 1170 },
	{ id = 35319, chance = 200 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -145, maxDamage = -390, target = true },
	{
		name = "combat",
		interval = 2500,
		chance = 25,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -305,
		maxDamage = -390,
		radius = 3,
		effect = CONST_ME_STONES,
		shootEffect = CONST_ANI_EARTH,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -305,
		maxDamage = -390,
		radius = 5,
		effect = CONST_ME_STONES,
		shootEffect = CONST_ANI_EARTH,
		target = true,
	},
	{
		name = "combat",
		interval = 3500,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -360,
		maxDamage = -390,
		range = 7,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{ name = "makarawatersplash", interval = 4000, chance = 25, minDamage = -380, maxDamage = -455, target = false },
}

monster.defenses = {
	defense = 74,
	armor = 74,
	mitigation = 1.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 25 },
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
