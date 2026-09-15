local mType = Game.createMonsterType("Honey Elemental")
local monster = {}

monster.description = "a honey elemental"
monster.experience = 2400
monster.outfit = {
	lookType = 1733,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2551
monster.bestiary = {
	race = "Elemental",
	class = "Elemental",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Chocolate Mines",
}

monster.health = 2560
monster.maxHealth = 2560
monster.race = "undead"
monster.corpse = 48112
monster.speed = 100
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "*Squelch*", yell = false },
	{ text = "**Slurp**", yell = false },
}

monster.loot = {
	{ id = 2145, chance = 3010 },
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2149, chance = 3760, maxCount = 2 },
	{ id = 2152, chance = 85000, maxCount = 6 },
	{ id = 5902, chance = 3870 },
	{ id = 46703, chance = 1180 },
	{ id = 7891, chance = 1070 },
	{ id = 7894, chance = 756 },
	{ id = 7588, chance = 4620 },
	{ id = 2392, chance = 430 },
	{ id = 7887, chance = 540 },
	{ id = 46700, chance = 433, maxCount = 6 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -260 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -125,
		maxDamage = -235,
		radius = 4,
		effect = CONST_ME_YELLOW_RINGS,
		target = false,
	},
}

monster.defenses = {
	defense = 20,
	armor = 34,
	mitigation = 1.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
