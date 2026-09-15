local mType = Game.createMonsterType("Frost Flower Asura")
local monster = {}

monster.description = "a frost flower asura"
monster.experience = 4200
monster.outfit = {
	lookType = 150,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 86,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1619
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Asura Palace.",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 28807
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
	staticAttackChance = 80,
	targetDistance = 3,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 3
monster.staticAttackChance = 80
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
	{ id = 2148, chance = 70980, maxCount = 100 },
	{ id = 2152, chance = 80500, maxCount = 6 },
	{ id = 2656, chance = 680 },
	{ id = 7368, chance = 6640, maxCount = 5 },
	{ id = 2144, chance = 5320, maxCount = 1 },
	{ id = 2124, chance = 250 },
	{ id = 6558, chance = 19650 },
	{ id = 6500, chance = 15850 },
	{ id = 2145, chance = 8200, maxCount = 1 },
	{ id = 2149, chance = 3970, maxCount = 1 },
	{ id = 2147, chance = 4560, maxCount = 1 },
	{ id = 2146, chance = 7600, maxCount = 3 },
	{ id = 9970, chance = 4770, maxCount = 1 },
	{ id = 7591, chance = 12080, maxCount = 2 },
	{ id = 2143, chance = 7480 },
	{ id = 7404, chance = 550 },
	{ id = 2158, chance = 300 },
	{ id = 9971, chance = 380 },
	{ id = 24630, chance = 19650 },
	{ id = 24637, chance = 340 },
	{ id = 24631, chance = 17280 },
	{ id = 8889, chance = 250 },
	{ id = 2134, chance = 5790 },
	{ id = 2170, chance = 1100 },
	{ id = 5944, chance = 19520 },
	{ id = 8902, chance = 420 },
	{ id = 3967, chance = 3380 },
	{ id = 2154, chance = 1820 },
	{ id = 2183, chance = 19520 },
	{ id = 8911, chance = 19520 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -130, maxDamage = -440 },
	{
		name = "combat",
		interval = 1300,
		chance = 14,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -200,
		maxDamage = -230,
		length = 8,
		spread = 0,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 9,
		type = COMBAT_ICEDAMAGE,
		minDamage = -250,
		maxDamage = -250,
		range = 7,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
}

monster.defenses = {
	defense = 30,
	armor = 56,
	mitigation = 1.62,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 90, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
