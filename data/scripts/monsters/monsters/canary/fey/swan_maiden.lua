local mType = Game.createMonsterType("Swan Maiden")
local monster = {}

monster.description = "a swan maiden"
monster.experience = 700
monster.outfit = {
	lookType = 138,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 114,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1437
monster.bestiary = {
	race = "Fey",
	class = "Fey",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 1,
	locations = "Feyrist Meadows",
}

monster.health = 800
monster.maxHealth = 800
monster.race = "blood"
monster.corpse = 25831
monster.speed = 117
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 20

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Nightmarish monster! This dream is not meant for you!", yell = false },
	{ text = "You won't steal my robe! Back off!", yell = false },
	{ text = "You are not allowed to lay eyes on me in this shape!", yell = false },
	{ text = "Are you stalking me? You will bitterly regret this!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 30000, maxCount = 112 },
	{ id = 7761, chance = 492, maxCount = 2 },
	{ id = 2796, chance = 492, maxCount = 2 },
	{ id = 2143, chance = 492, maxCount = 2 },
	{ id = 24850, chance = 492, maxCount = 2 },
	{ id = 7589, chance = 6800 },
	{ id = 2423, chance = 5155 },
	{ id = 7590, chance = 591 },
	{ id = 31699, chance = 5800 },
	{ id = 7387, chance = 3400 },
	{ id = 30498, chance = 3400 },
	{ id = 9927, chance = 3400 },
	{ id = 2803, chance = 3400 },
	{ id = 2134, chance = 3400 },
	{ id = 8874, chance = 3400 },
	{ id = 31694, chance = 3400 },
	{ id = 2195, chance = 50 },
	{ id = 31701, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -215 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -60,
		maxDamage = -115,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 11,
		type = COMBAT_MANADRAIN,
		minDamage = -82,
		maxDamage = -215,
		range = 7,
		shootEffect = CONST_ANI_HOLY,
		effect = CONST_ME_HOLYAREA,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 11, radius = 6, effect = CONST_ME_PIXIE_EXPLOSION, target = false, duration = 5000, speed = -450 },
}

monster.defenses = {
	defense = 54,
	armor = 54,
	mitigation = 1.18,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 85, maxDamage = 105, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
