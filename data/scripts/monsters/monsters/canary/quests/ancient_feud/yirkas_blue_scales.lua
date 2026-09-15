local mType = Game.createMonsterType("Yirkas Blue Scales")
local monster = {}

monster.description = "Yirkas Blue Scales"
monster.experience = 4900
monster.outfit = {
	lookType = 1196,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1982,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 31409
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = true,
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
	{ id = 35541, chance = 100000, minCount = 1, maxCount = 6 },
	{ id = 2152, chance = 100000, minCount = 1, maxCount = 17 },
	{ id = 8473, chance = 100000, minCount = 1, maxCount = 5 },
	{ id = 9971, chance = 11540 },
	{ id = 30499, chance = 8790 },
	{ id = 37432, chance = 8240 },
	{ id = 35336, chance = 6590 },
	{ id = 2155, chance = 3850 },
	{ id = 2158, chance = 3300 },
	{ id = 7894, chance = 3300 },
	{ id = 5741, chance = 3300 },
	{ id = 2393, chance = 2750 },
	{ id = 7422, chance = 2750 },
	{ id = 2454, chance = 2750 },
	{ id = 7404, chance = 2200 },
	{ id = 2179, chance = 2200 },
	{ id = 26187, chance = 2200 },
	{ id = 2472, chance = 1650 },
	{ id = 2520, chance = 1100 },
	{ id = 7440, chance = 1100 },
	{ id = 15644, chance = 1100 },
	{ id = 11355, chance = 1100 },
	{ id = 7382, chance = 550 },
	{ id = 8902, chance = 550 },
	{ id = 23539, chance = 550 },
	{ id = 37127, chance = 360 },
	{ id = 37574, chance = 360 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -100,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 15, maxDamage = 15 },
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		length = 3,
		spread = 0,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -250,
		maxDamage = -350,
		range = 3,
		radius = 3,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		radius = 4,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 78,
	armor = 78,
	{ name = "speed", interval = 2000, chance = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 350 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
