local mType = Game.createMonsterType("Arachnophobica")
local monster = {}

monster.description = "an arachnophobica"
monster.experience = 4700
monster.outfit = {
	lookType = 1135,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1729
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Buried Cathedral, Haunted Cellar, Court of Summer, Court of Winter, Dream Labyrinth.",
}

monster.health = 5000
monster.maxHealth = 5000
monster.race = "blood"
monster.corpse = 30073
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	{ text = "Tip tap tip tap!", yell = false },
	{ text = "Zip zip zip!!!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 14 },
	{ id = 8472, chance = 100000, maxCount = 3 },
	{ id = 11223, chance = 15000 },
	{ id = 2167, chance = 12050 },
	{ id = 2170, chance = 15000 },
	{ id = 2207, chance = 11050 },
	{ id = 8859, chance = 11800 },
	{ id = 2178, chance = 17800 },
	{ id = 2189, chance = 17800 },
	{ id = 7890, chance = 8900 },
	{ id = 2198, chance = 8100, maxCount = 2 },
	{ id = 26200, chance = 10590 },
	{ id = 10219, chance = 7500 },
	{ id = 5879, chance = 6500 },
	{ id = 2168, chance = 5560 },
	{ id = 2176, chance = 7800 },
	{ id = 8910, chance = 7120 },
	{ id = 26185, chance = 1000 },
	{ id = 2214, chance = 9120 },
	{ id = 2161, chance = 8110 },
	{ id = 2208, chance = 7220 },
	{ id = 2166, chance = 6080 },
	{ id = 6300, chance = 7502 },
	{ id = 2199, chance = 7550 },
	{ id = 2171, chance = 7650 },
	{ id = 26199, chance = 10590 },
	{ id = 2174, chance = 2640 },
	{ id = 2197, chance = 2600 },
	{ id = 15403, chance = 1800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{ name = "arachnophobicawavedice", interval = 2000, chance = 20, minDamage = -250, maxDamage = -350, target = false },
	{ name = "arachnophobicawaveenergy", interval = 2000, chance = 20, minDamage = -250, maxDamage = -350, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -250,
		maxDamage = -350,
		radius = 4,
		effect = CONST_ME_BLOCKHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		range = 7,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_SMALLCLOUDS,
		target = false,
	},
}

monster.defenses = {
	defense = 0,
	armor = 70,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
