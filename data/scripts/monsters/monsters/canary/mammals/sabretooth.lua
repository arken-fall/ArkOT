local mType = Game.createMonsterType("Sabretooth")
local monster = {}

monster.description = "a sabretooth"
monster.experience = 11931
monster.outfit = {
	lookType = 1549,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2267
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Sparkling Pools",
}

monster.health = 17300
monster.maxHealth = 17300
monster.race = "blood"
monster.corpse = 39287
monster.speed = 225
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
}

monster.loot = {
	{ id = 41466, chance = 23640 },
	{ id = 2160, chance = 23350, minCount = 1, maxCount = 2 },
	{ id = 2198, chance = 5010 },
	{ id = 2187, chance = 4720 },
	{ id = 2201, chance = 3850 },
	{ id = 7899, chance = 3820 },
	{ id = 10219, chance = 2730 },
	{ id = 2392, chance = 2650 },
	{ id = 2191, chance = 2330 },
	{ id = 23540, chance = 2260 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100 },
	{ name = "sabretooth wave", interval = 5000, chance = 35, minDamage = -600, maxDamage = -1000 },
	{
		name = "combat",
		interval = 3500,
		chance = 30,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -800,
		maxDamage = -1500,
		range = 1,
		effect = CONST_ME_BIG_SCRATCH,
		target = true,
	},
	{ name = "combat", interval = 2700, chance = 35, type = COMBAT_FIREDAMAGE, minDamage = -900, maxDamage = -1350, range = 1, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 63,
	mitigation = 1.62,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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

RegisterPrimalPackBeast(monster)
