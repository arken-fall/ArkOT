local mType = Game.createMonsterType("Icecold Book")
local monster = {}

monster.description = "an icecold book"
monster.experience = 12750
monster.outfit = {
	lookType = 1061,
	lookHead = 87,
	lookBody = 85,
	lookLegs = 79,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1664
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Secret Library (ice section).",
}

monster.health = 21000
monster.maxHealth = 21000
monster.race = "ink"
monster.corpse = 28774
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
	canWalkOnFire = false,
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
	{ id = 2152, chance = 100000, maxCount = 8 },
	{ id = 33440, chance = 100000, maxCount = 3 },
	{ id = 2145, chance = 100000, maxCount = 8 },
	{ id = 2146, chance = 100000, maxCount = 8 },
	{ id = 33438, chance = 100000, maxCount = 8 },
	{ id = 8473, chance = 100000, maxCount = 8 },
	{ id = 26029, chance = 100000, maxCount = 8 },
	{ id = 7387, chance = 100000 },
	{ id = 10578, chance = 100000, maxCount = 8 },
	{ id = 7902, chance = 350 },
	{ id = 2396, chance = 250 },
	{ id = 33437, chance = 100000, maxCount = 8 },
	{ id = 2445, chance = 250 },
	{ id = 7896, chance = 250 },
	{ id = 7897, chance = 250 },
	{ id = 7892, chance = 350 },
	{ id = 2479, chance = 1000 },
	{ id = 7437, chance = 300 },
	{ id = 7441, chance = 100000 },
	{ id = 18412, chance = 150 },
	{ id = 8878, chance = 250 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 1000,
		chance = 10,
		type = COMBAT_ICEDAMAGE,
		minDamage = -700,
		maxDamage = -850,
		range = 7,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 10,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -380,
		range = 7,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -350,
		maxDamage = -980,
		length = 5,
		spread = 0,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 12,
		type = COMBAT_ICEDAMAGE,
		minDamage = -230,
		maxDamage = -880,
		range = 7,
		radius = 3,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
