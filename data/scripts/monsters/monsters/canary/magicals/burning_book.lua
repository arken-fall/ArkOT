local mType = Game.createMonsterType("Burning Book")
local monster = {}

monster.description = "a burning book"
monster.experience = 13200
monster.outfit = {
	lookType = 1061,
	lookHead = 79,
	lookBody = 113,
	lookLegs = 78,
	lookFeet = 112,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1663
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Secret Library (fire section).",
}

monster.health = 18000
monster.maxHealth = 18000
monster.race = "ink"
monster.corpse = 28754
monster.speed = 220
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
	{ id = 2152, chance = 89960, maxCount = 28 },
	{ id = 33440, chance = 3000, maxCount = 7 },
	{ id = 6500, chance = 3000, maxCount = 5 },
	{ id = 6558, chance = 3000, maxCount = 3 },
	{ id = 2150, chance = 2000, maxCount = 4 },
	{ id = 2419, chance = 3000 },
	{ id = 33437, chance = 2000, maxCount = 2 },
	{ id = 7899, chance = 2000 },
	{ id = 2515, chance = 1500 },
	{ id = 5944, chance = 3000, maxCount = 4 },
	{ id = 2185, chance = 3000 },
	{ id = 7900, chance = 1500 },
	{ id = 6300, chance = 1200 },
	{ id = 2165, chance = 1800 },
	{ id = 7451, chance = 8990 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -700 },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -780,
		range = 7,
		shootEffect = CONST_ANI_FLAMMINGARROW,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 1500,
		chance = 12,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -500,
		maxDamage = -900,
		radius = 3,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -400,
		maxDamage = -850,
		length = 5,
		spread = 0,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_FIREDAMAGE,
		minDamage = -400,
		maxDamage = -775,
		radius = 3,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
}

monster.defenses = {
	defense = 33,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
