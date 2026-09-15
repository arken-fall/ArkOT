local mType = Game.createMonsterType("Lavaworm")
local monster = {}

monster.description = "a lavaworm"
monster.experience = 6500
monster.outfit = {
	lookType = 1394,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2088
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Grotto of the Lost.",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "fire"
monster.corpse = 36679
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 3,
	color = 205,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 24 },
	{ id = 9971, chance = 18430, maxCount = 2 },
	{ id = 18414, chance = 15630, maxCount = 3 },
	{ id = 39206, chance = 20310, maxCount = 3 },
	{ id = 2153, chance = 6750 },
	{ id = 39207, chance = 4230 },
	{ id = 2155, chance = 4130 },
	{ id = 31701, chance = 3120 },
	{ id = 8910, chance = 2920 },
	{ id = 39208, chance = 2620 },
	{ id = 18413, chance = 2520 },
	{ id = 2475, chance = 1560 },
	{ id = 8922, chance = 1560 },
	{ id = 2497, chance = 1560 },
	{ id = 2479, chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{
		name = "combat",
		interval = 2750,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -600,
		maxDamage = -760,
		range = 5,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 60,
		type = COMBAT_FIREDAMAGE,
		minDamage = -700,
		maxDamage = -780,
		radius = 4,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2750,
		chance = 30,
		type = COMBAT_FIREDAMAGE,
		minDamage = -550,
		maxDamage = -700,
		range = 5,
		radius = 3,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_EXPLOSIONHIT,
		target = true,
	},
}

monster.defenses = {
	defense = 60,
	armor = 60,
	mitigation = 1.6,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
