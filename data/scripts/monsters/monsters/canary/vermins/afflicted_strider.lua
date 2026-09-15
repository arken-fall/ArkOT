local mType = Game.createMonsterType("Afflicted Strider")
local monster = {}

monster.description = "an afflicted strider"
monster.experience = 5700
monster.outfit = {
	lookType = 1403,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2094
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Antrum of the Fallen.",
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 36719
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
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
	{ id = 2152, chance = 70000, maxCount = 16 },
	{ id = 39227, chance = 10940, maxCount = 3 },
	{ id = 2427, chance = 9410 },
	{ id = 7449, chance = 8940 },
	{ id = 2153, chance = 6940, maxCount = 1 },
	{ id = 18414, chance = 5410 },
	{ id = 2485, chance = 5060 },
	{ id = 18415, chance = 6820 },
	{ id = 8872, chance = 3760 },
	{ id = 39226, chance = 4820 },
	{ id = 2476, chance = 4590 },
	{ id = 8870, chance = 3060 },
	{ id = 7899, chance = 2470 },
	{ id = 2409, chance = 2240 },
	{ id = 2420, chance = 3760 },
	{ id = 2413, chance = 1060 },
	{ id = 8871, chance = 2240 },
	{ id = 2396, chance = 2240 },
	{ id = 7413, chance = 1880 },
	{ id = 7407, chance = 1410 },
	{ id = 7386, chance = 1530 },
	{ id = 2430, chance = 1290 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -550,
		maxDamage = -650,
		range = 3,
		shootEffect = CONST_ANI_POISON,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -650,
		maxDamage = -800,
		radius = 5,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
}

monster.defenses = {
	defense = 68,
	armor = 68,
	mitigation = 1.88,
	{ name = "speed", interval = 2000, chance = 25, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 450 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
