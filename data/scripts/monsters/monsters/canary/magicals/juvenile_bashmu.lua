local mType = Game.createMonsterType("Juvenile Bashmu")
local monster = {}

monster.description = "a juvenile bashmu"
monster.experience = 4500
monster.outfit = {
	lookType = 1408,
	lookHead = 0,
	lookBody = 112,
	lookLegs = 3,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2101
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Salt Caves",
}

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 36967
monster.speed = 195
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	level = 1,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 19 },
	{ id = 8472, chance = 14700, maxCount = 4 },
	{ id = 8473, chance = 1300, maxCount = 4 },
	{ id = 18413, chance = 6160, maxCount = 3 },
	{ id = 39258, chance = 5840, maxCount = 3 },
	{ id = 39260, chance = 4620, maxCount = 2 },
	{ id = 18415, chance = 3666 },
	{ id = 18419, chance = 3340 },
	{ id = 2156, chance = 2390, maxCount = 1 },
	{ id = 2153, chance = 2340, maxCount = 1 },
	{ id = 7895, chance = 2230 },
	{ id = 7387, chance = 2180 },
	{ id = 7889, chance = 2180 },
	{ id = 39257, chance = 2120 },
	{ id = 2154, chance = 2070 },
	{ id = 2391, chance = 1540 },
	{ id = 18414, chance = 1490 },
	{ id = 7430, chance = 1430 },
	{ id = 7426, chance = 1270 },
	{ id = 7893, chance = 1270 },
	{ id = 2155, chance = 1220 },
	{ id = 11355, chance = 1110 },
	{ id = 20108, chance = 1010 },
	{ id = 2436, chance = 960 },
	{ id = 2445, chance = 800 },
	{ id = 7427, chance = 530 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -300,
		maxDamage = -400,
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
		maxDamage = -500,
		range = 7,
		shootEffect = CONST_ANI_EARTHARROW,
		target = true,
	},
}

monster.defenses = {
	defense = 75,
	armor = 75,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
