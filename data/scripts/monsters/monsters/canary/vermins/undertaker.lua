local mType = Game.createMonsterType("Undertaker")
local monster = {}

monster.description = "an undertaker"
monster.experience = 13543
monster.outfit = {
	lookType = 1551,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2269
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Monster Graveyard",
}

monster.health = 20100
monster.maxHealth = 20100
monster.race = "venom"
monster.corpse = 39295
monster.speed = 205
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
	{ text = "Hizzzzz!", yell = false },
}

monster.loot = {
	{ id = 8472, chance = 30660, minCount = 1, maxCount = 3 },
	{ id = 41468, chance = 25740 },
	{ id = 2160, chance = 15100, minCount = 1, maxCount = 3 },
	{ id = 5879, chance = 3520 },
	{ id = 7886, chance = 3390 },
	{ id = 18413, chance = 1840 },
	{ id = 7383, chance = 1650 },
	{ id = 7885, chance = 1640 },
	{ id = 2185, chance = 1400 },
	{ id = 31701, chance = 1240 },
	{ id = 8922, chance = 960 },
	{ id = 2153, chance = 850 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1200 },
	{
		name = "combat",
		interval = 4500,
		chance = 47,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -800,
		maxDamage = -1150,
		radius = 4,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 3650,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -600,
		maxDamage = -950,
		radius = 2,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
	{ name = "undertaker square explosion", interval = 3000, chance = 25, minDamage = -775, maxDamage = -900, range = 4, target = true },
	{
		name = "combat",
		interval = 5000,
		chance = 40,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1500,
		maxDamage = -2000,
		range = 1,
		radius = 1,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{ name = "root wave", interval = 2000, chance = 5, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 77,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
