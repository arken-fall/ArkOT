local mType = Game.createMonsterType("Bashmu")
local monster = {}

monster.description = "a bashmu"
monster.experience = 5000
monster.outfit = {
	lookType = 1408,
	lookHead = 0,
	lookBody = 50,
	lookLegs = 42,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2100
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Salt Caves.",
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "blood"
monster.corpse = 36804
monster.speed = 200
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
	canWalkOnFire = true,
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
	{ id = 2152, chance = 69350, maxCount = 24 },
	{ id = 2427, chance = 9160 },
	{ id = 39260, chance = 5320 },
	{ id = 39258, chance = 4950 },
	{ id = 10219, chance = 4280 },
	{ id = 8472, chance = 3840, maxCount = 4 },
	{ id = 18415, chance = 3470, maxCount = 3 },
	{ id = 18413, chance = 2950, maxCount = 3 },
	{ id = 2145, chance = 2950, maxCount = 6 },
	{ id = 2153, chance = 2730 },
	{ id = 39257, chance = 2070 },
	{ id = 31736, chance = 1770 },
	{ id = 7887, chance = 1770 },
	{ id = 7888, chance = 960 },
	{ id = 7454, chance = 810 },
	{ id = 26200, chance = 660 },
	{ id = 7407, chance = 590 },
	{ id = 7890, chance = 520 },
	{ id = 26198, chance = 440 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -400,
		maxDamage = -800,
		length = 4,
		spread = 0,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		range = 3,
		radius = 3,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -400,
		maxDamage = -800,
		range = 7,
		shootEffect = CONST_ANI_EARTHARROW,
		target = true,
	},
}

monster.defenses = {
	defense = 72,
	armor = 72,
	mitigation = 2.16,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 340 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
