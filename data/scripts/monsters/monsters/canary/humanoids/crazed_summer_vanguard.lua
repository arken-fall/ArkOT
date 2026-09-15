local mType = Game.createMonsterType("Crazed Summer Vanguard")
local monster = {}

monster.description = "a crazed summer vanguard"
monster.experience = 5000
monster.outfit = {
	lookType = 1137,
	lookHead = 114,
	lookBody = 93,
	lookLegs = 3,
	lookFeet = 83,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1732
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Court of Summer, Dream Labyrinth.",
}

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 30077
monster.speed = 195
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
	{ text = "I see colours, all colours! Or are these just illusions?", yell = false },
	{ text = "La di da di doo!!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 85000, maxCount = 13 },
	{ id = 12421, chance = 30000, maxCount = 2 },
	{ id = 34229, chance = 8600 },
	{ id = 8872, chance = 9500 },
	{ id = 2377, chance = 7400 },
	{ id = 7732, chance = 8600 },
	{ id = 2419, chance = 6800 },
	{ id = 2403, chance = 6600 },
	{ id = 2201, chance = 7150 },
	{ id = 7890, chance = 5500 },
	{ id = 2191, chance = 4800 },
	{ id = 8921, chance = 4800 },
	{ id = 7891, chance = 2900 },
	{ id = 34219, chance = 900 },
	{ id = 7443, chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{
		name = "combat",
		interval = 2500,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		length = 3,
		spread = 0,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		radius = 1,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 3500,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -250,
		maxDamage = -300,
		range = 7,
		shootEffect = CONST_ANI_FIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 20,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -300,
		radius = 3,
		effect = CONST_ME_EXPLOSIONHIT,
		target = true,
	},
	{ name = "sparks chain", interval = 4500, chance = 20, minDamage = -100, maxDamage = -250, range = 3, target = true },
}

monster.defenses = {
	defense = 20,
	armor = 77,
	mitigation = 2.05,
}

monster.reflects = {
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
