local mType = Game.createMonsterType("Turbulent Elemental")
local monster = {}

monster.description = "a turbulent elemental"
monster.experience = 19360
monster.outfit = {
	lookType = 1314,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1940
monster.bestiary = {
	race = "Elemental",
	class = "Elemental",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Ebb and Flow.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 33905
monster.speed = 180
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
	canPushCreatures = false,
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
	{ id = 2160, chance = 74880 },
	{ id = 9971, chance = 22270 },
	{ id = 8473, chance = 17300, maxCount = 4 },
	{ id = 10219, chance = 6160 },
	{ id = 2158, chance = 4980 },
	{ id = 8912, chance = 4270 },
	{ id = 8911, chance = 3320 },
	{ id = 2153, chance = 3080 },
	{ id = 7888, chance = 2840 },
	{ id = 7897, chance = 1900 },
	{ id = 24741, chance = 1420 },
	{ id = 2664, chance = 950 },
	{ id = 8878, chance = 710 },
	{ id = 23536, chance = 710 },
	{ id = 2197, chance = 470 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -900,
		maxDamage = -1350,
		range = 7,
		shootEffect = CONST_ANI_SNOWBALL,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -700,
		maxDamage = -1000,
		range = 7,
		shootEffect = CONST_ANI_HUNTINGSPEAR,
		effect = CONST_ME_DRAWBLOOD,
		target = true,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 24,
		type = COMBAT_ICEDAMAGE,
		minDamage = -950,
		maxDamage = -1260,
		radius = 4,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 17,
		type = COMBAT_ICEDAMAGE,
		minDamage = -950,
		maxDamage = -1260,
		radius = 4,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -950,
		maxDamage = -1100,
		length = 5,
		radius = 2,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
	{ name = "soulwars fear", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	mitigation = 2.72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
