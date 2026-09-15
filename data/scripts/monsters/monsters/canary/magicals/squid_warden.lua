local mType = Game.createMonsterType("Squid Warden")
local monster = {}

monster.description = "a squid warden"
monster.experience = 15300
monster.outfit = {
	lookType = 1059,
	lookHead = 9,
	lookBody = 21,
	lookLegs = 3,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1669
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

monster.health = 16500
monster.maxHealth = 16500
monster.race = "undead"
monster.corpse = 28786
monster.speed = 215
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
	{ id = 2152, chance = 11000, maxCount = 57 },
	{ id = 33441, chance = 800, maxCount = 4 },
	{ id = 2146, chance = 900, maxCount = 4 },
	{ id = 10578, chance = 11000, maxCount = 4 },
	{ id = 7441, chance = 20000 },
	{ id = 33439, chance = 20000 },
	{ id = 8473, chance = 10003, maxCount = 4 },
	{ id = 26029, chance = 10003, maxCount = 4 },
	{ id = 2396, chance = 500 },
	{ id = 7902, chance = 400 },
	{ id = 10580, chance = 10001, maxCount = 4 },
	{ id = 7449, chance = 300 },
	{ id = 7897, chance = 150 },
	{ id = 7896, chance = 150 },
	{ id = 23565, chance = 10002, maxCount = 4 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -200,
		range = 7,
		shootEffect = CONST_ANI_ICE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ICEDAMAGE,
		minDamage = -200,
		maxDamage = -680,
		range = 7,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ICEDAMAGE,
		minDamage = -200,
		maxDamage = -375,
		length = 3,
		spread = 2,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_ICEDAMAGE,
		minDamage = -230,
		maxDamage = -480,
		range = 7,
		radius = 3,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICETORNADO,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 78,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
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
