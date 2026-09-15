local mType = Game.createMonsterType("Hazardous Phantom")
local monster = {}

monster.description = "a hazardous phantom"
monster.experience = 66000
monster.outfit = {
	lookType = 1298,
	lookHead = 114,
	lookBody = 80,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 70000
monster.maxHealth = 70000
monster.race = "undead"
monster.corpse = 34125
monster.speed = 100
monster.manaCost = 0

monster.events = {
	"HazardousPhantomDeath",
}

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
	{ id = 2160, chance = 97640, maxCount = 4 },
	{ id = 8473, chance = 77950, maxCount = 5 },
	{ id = 9971, chance = 23620 },
	{ id = 2183, chance = 10240 },
	{ id = 2155, chance = 7090 },
	{ id = 2153, chance = 5510 },
	{ id = 30499, chance = 4720 },
	{ id = 37471, chance = 4720 },
	{ id = 37464, chance = 3940 },
	{ id = 2158, chance = 3150 },
	{ id = 8911, chance = 2360 },
	{ id = 7897, chance = 2360 },
	{ id = 7633, chance = 1570 },
	{ id = 18409, chance = 790 },
	{ id = 26198, chance = 790 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100 },
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1050,
		maxDamage = -1400,
		range = 7,
		radius = 3,
		shootEffect = CONST_ANI_POISONARROW,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -900,
		maxDamage = -1250,
		length = 6,
		spread = 4,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1050,
		maxDamage = -1100,
		radius = 3,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1050,
		maxDamage = -1300,
		range = 7,
		radius = 4,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{ name = "ice chain", interval = 2000, chance = 15, minDamage = -1300, maxDamage = -1500, range = 7 },
	{ name = "soulwars fear", interval = 2000, chance = 2, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 4.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
