local mType = Game.createMonsterType("Guard Captain Quaid")
local monster = {}

monster.description = "Guard Captain Quaid"
monster.experience = 28000
monster.outfit = {
	lookType = 1217,
	lookHead = 38,
	lookBody = 20,
	lookLegs = 21,
	lookFeet = 2,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1791,
	bossRace = RARITY_BANE,
}

monster.health = 55000
monster.maxHealth = 55000
monster.race = "blood"
monster.corpse = 31654
monster.speed = 92
monster.manaCost = 0

monster.events = {
	"UglyMonsterSpawn",
	"UglyMonsterCleanup",
	"grave_danger_death",
}

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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
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
	{ id = 2152, chance = 100000, maxCount = 20 },
	{ id = 31734, chance = 73000, maxCount = 2 },
	{ id = 2399, chance = 65000, maxCount = 6 },
	{ id = 3965, chance = 62000 },
	{ id = 9971, chance = 48000 },
	{ id = 2158, chance = 31000 },
	{ id = 2154, chance = 31000 },
	{ id = 18415, chance = 8600 },
	{ id = 7632, chance = 28000 },
	{ id = 5741, chance = 7500 },
	{ id = 26198, chance = 7200 },
	{ id = 35655, chance = 11000 },
	{ id = 34561, chance = 115 },
	{ id = 34564, chance = 120 },
	{ id = 34560, chance = 50 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -580 },
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -500,
		maxDamage = -620,
		radius = 4,
		shootEffect = CONST_ANI_EARTH,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -450,
		maxDamage = -700,
		shootEffect = CONST_ANI_THROWINGKNIFE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 14,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -350,
		maxDamage = -550,
		length = 5,
		spread = 0,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -400,
		maxDamage = -550,
		radius = 1,
		shootEffect = CONST_ANI_BURSTARROW,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -480,
		length = 5,
		spread = 0,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -450,
		radius = 3,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
}

monster.defenses = {
	defense = 86,
	armor = 86,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
