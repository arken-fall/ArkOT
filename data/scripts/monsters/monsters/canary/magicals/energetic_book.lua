local mType = Game.createMonsterType("Energetic Book")
local monster = {}

monster.description = "an energetic book"
monster.experience = 12034
monster.outfit = {
	lookType = 1061,
	lookHead = 15,
	lookBody = 91,
	lookLegs = 85,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1665
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Secret Library (energy section).",
}

monster.health = 18500
monster.maxHealth = 18500
monster.race = "ink"
monster.corpse = 28778
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	{ text = "Flood the room with curious energy!", yell = false },
	{ text = "zup zup zup zuuuuup!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 28 },
	{ id = 33440, chance = 900, maxCount = 8 },
	{ id = 33441, chance = 900, maxCount = 7 },
	{ id = 8473, chance = 10000, maxCount = 7 },
	{ id = 26029, chance = 10000, maxCount = 7 },
	{ id = 26179, chance = 900, maxCount = 7 },
	{ id = 33437, chance = 800, maxCount = 7 },
	{ id = 7889, chance = 500 },
	{ id = 7893, chance = 500 },
	{ id = 7901, chance = 500 },
	{ id = 2164, chance = 500 },
	{ id = 11355, chance = 350 },
	{ id = 18390, chance = 350 },
	{ id = 7407, chance = 550 },
	{ id = 7895, chance = 350 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 14,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -680,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -505,
		radius = 3,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 1500,
		chance = 30,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = -700,
		length = 8,
		spread = 0,
		effect = CONST_ME_STUN,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
