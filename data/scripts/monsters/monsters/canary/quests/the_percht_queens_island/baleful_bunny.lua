local mType = Game.createMonsterType("Baleful Bunny")
local monster = {}

monster.description = "a baleful bunny"
monster.experience = 450
monster.outfit = {
	lookType = 1157,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1742
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 2,
	locations = "Percht Island",
}

monster.health = 500
monster.maxHealth = 500
monster.race = "blood"
monster.corpse = 30308
monster.speed = 170
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
	canWalkOnPoison = true,
	isPreyExclusive = true,
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
	{ text = "Borborygmus... borborygmus...", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000 },
	{ id = 7887, chance = 8480 },
	{ id = 2182, chance = 7420 },
	{ id = 31734, chance = 7120, maxCount = 2 },
	{ id = 7889, chance = 6820 },
	{ id = 2161, chance = 5760 },
	{ id = 10219, chance = 2730 },
	{ id = 34398, chance = 450 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 1,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -100,
		maxDamage = -150,
		radius = 4,
		effect = CONST_ME_POFF,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 1,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -150,
		radius = 1,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 111,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -150,
		radius = 4,
		effect = CONST_ME_DRAWBLOOD,
		target = true,
	},
}

monster.defenses = {
	defense = 35,
	armor = 35,
	mitigation = 0.78,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
