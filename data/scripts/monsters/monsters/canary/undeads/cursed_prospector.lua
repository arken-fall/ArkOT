local mType = Game.createMonsterType("Cursed Prospector")
local monster = {}

monster.description = "a cursed prospector"
monster.experience = 5250
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 19,
	lookLegs = 0,
	lookFeet = 38,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1880
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Barren Drift.",
}

monster.health = 3900
monster.maxHealth = 3900
monster.race = "undead"
monster.corpse = 32610
monster.speed = 210
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
	targetDistance = 3,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 3
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
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 7838, chance = 17700, maxCount = 10 },
	{ id = 8472, chance = 15190, maxCount = 2 },
	{ id = 36388, chance = 11520 },
	{ id = 36387, chance = 5680 },
	{ id = 2127, chance = 1340 },
	{ id = 7893, chance = 1340 },
	{ id = 36428, chance = 1000 },
	{ id = 7898, chance = 1000 },
	{ id = 2198, chance = 1000 },
	{ id = 7895, chance = 830 },
	{ id = 10221, chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 1700,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -550,
		radius = 3,
		shootEffect = CONST_ANI_ENVENOMEDARROW,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
	{
		name = "combat",
		interval = 1700,
		chance = 25,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -150,
		maxDamage = -550,
		length = 4,
		spread = 0,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 1700,
		chance = 35,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -150,
		maxDamage = -550,
		radius = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 1700,
		chance = 35,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -250,
		maxDamage = -550,
		radius = 3,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -400,
		maxDamage = -550,
		range = 4,
		radius = 4,
		effect = CONST_ME_ENERGYAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 40,
	armor = 85,
	mitigation = 2.4,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
