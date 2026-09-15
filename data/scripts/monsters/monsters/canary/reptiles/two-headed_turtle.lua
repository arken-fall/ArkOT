local mType = Game.createMonsterType("Two-Headed Turtle")
local monster = {}

monster.description = "a two-headed turtle"
monster.experience = 2930
monster.outfit = {
	lookType = 1535,
}

monster.raceId = 2258
monster.bestiary = {
	race = "Reptile",
	class = "Reptile",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Great Pearl Fan Reef",
}

monster.health = 5010
monster.maxHealth = 5010
monster.race = "blood"
monster.corpse = 39212
monster.speed = 170
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Krk! Krk!", yell = false },
	{ text = "BONK!", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 8 },
	{ id = 7591, chance = 15701 },
	{ id = 41497, chance = 8700 },
	{ id = 7589, chance = 13373 },
	{ id = 41498, chance = 11000 },
	{ id = 2230, chance = 6388 },
	{ id = 7892, chance = 4650 },
	{ id = 7632, chance = 3582 },
	{ id = 41496, chance = 3582 },
	{ id = 30498, chance = 2600 },
	{ id = 2134, chance = 2507 },
	{ id = 7901, chance = 2110 },
	{ id = 2477, chance = 2000 },
	{ id = 30499, chance = 2090 },
	{ id = 2127, chance = 1373 },
	{ id = 7887, chance = 1373 },
	{ id = 2157, chance = 1313 },
	{ id = 8900, chance = 1300 },
	{ id = 2654, chance = 1015 },
	{ id = 11339, chance = 657 },
	{ id = 36427, chance = 418 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300 },
	{
		name = "combat",
		interval = 2500,
		chance = 35,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		radius = 4,
		target = false,
		effect = CONST_ME_ENERGYHIT,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -300,
		radius = 3,
		target = true,
		effect = CONST_ME_GHOSTLY_BITE,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 45,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		range = 1,
		radius = 1,
		target = true,
		effect = CONST_ME_EXPLOSIONAREA,
	},
}

monster.defenses = {
	defense = 72,
	armor = 72,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
