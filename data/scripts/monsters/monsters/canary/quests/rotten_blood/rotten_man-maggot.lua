local mType = Game.createMonsterType("Rotten Man-Maggot")
local monster = {}

monster.description = "a rotten man-maggot"
monster.experience = 22625
monster.outfit = {
	lookType = 1655,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2393
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Putrefactory.",
}

monster.health = 31100
monster.maxHealth = 31100
monster.race = "undead"
monster.corpse = 43820
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	convinceable = true,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 0,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 0
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
	{ id = 2160, chance = 10340, maxCount = 1 },
	{ id = 2150, chance = 7364, maxCount = 2 },
	{ id = 44039, chance = 11619, maxCount = 1 },
	{ id = 6300, chance = 12591, maxCount = 1 },
	{ id = 2664, chance = 14371, maxCount = 1 },
	{ id = 2156, chance = 5155, maxCount = 1 },
	{ id = 2154, chance = 9564, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -1100,
		maxDamage = -1400,
		radius = 5,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1300,
		maxDamage = -1800,
		radius = 5,
		effect = CONST_ME_GHOSTLY_BITE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1200,
		maxDamage = -1700,
		length = 8,
		spread = 5,
		effect = CONST_ME_ICEAREA,
		target = false,
	},
	{ name = "largeicering", interval = 2000, chance = 15, minDamage = -800, maxDamage = -1200, target = false },
}

monster.defenses = {
	defense = 110,
	armor = 110,
	mitigation = 2.75,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 55 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 40 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
