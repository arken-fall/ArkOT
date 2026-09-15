local mType = Game.createMonsterType("The Count of the Core")
local monster = {}

monster.description = "The Count Of The Core"
monster.experience = 300000
monster.outfit = {
	lookType = 1046,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"DepthWarzoneBossDeath",
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "blood"
monster.corpse = 27637
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1519,
	bossRace = RARITY_BANE,
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
	{ text = "Shluush!", yell = false },
	{ text = "Sluuurp!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 54 },
	{ id = 32735, chance = 100000, maxCount = 7 },
	{ id = 7440, chance = 100000, maxCount = 3 },
	{ id = 2197, chance = 100000 },
	{ id = 7426, chance = 100000 },
	{ id = 8473, chance = 80000, maxCount = 15 },
	{ id = 7590, chance = 60000, maxCount = 23 },
	{ id = 9970, chance = 60000, maxCount = 10 },
	{ id = 18415, chance = 60000 },
	{ id = 2187, chance = 60000 },
	{ id = 32657, chance = 60000 },
	{ id = 2145, chance = 40000 },
	{ id = 5892, chance = 40000, maxCount = 3 },
	{ id = 7633, chance = 40000 },
	{ id = 8472, chance = 20000 },
	{ id = 25172, chance = 20000 },
	{ id = 2154, chance = 20000 },
	{ id = 2392, chance = 20000 },
	{ id = 2156, chance = 20000 },
	{ id = 2155, chance = 20000 },
	{ id = 9822, chance = 20000 },
	{ id = 25377, chance = 20000 },
	{ id = 5904, chance = 40680 },
	{ id = 32656, chance = 23730 },
	{ id = 2158, chance = 22030 },
	{ id = 2149, chance = 18640 },
	{ id = 9816, chance = 16950 },
	{ id = 2147, chance = 13560 },
	{ id = 2150, chance = 11860 },
	{ id = 12410, chance = 8470 },
	{ id = 2160, chance = 6780 },
	{ id = 32655, chance = 5080 },
	{ id = 32679, chance = 5080 },
	{ id = 32676, chance = 3390 },
	{ id = 7899, chance = 3390 },
	{ id = 32680, chance = 3390 },
	{ id = 2153, chance = 3390 },
	{ id = 8878, chance = 1690 },
	{ id = 2393, chance = 1690 },
	{ id = 15454, chance = 1690 },
	{ id = 12613, chance = 1690 },
	{ id = 32685, chance = 1690 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		interval = 6000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = 0,
		maxDamage = -1500,
		range = 3,
		length = 9,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = 0,
		maxDamage = -1500,
		range = 3,
		length = 9,
		spread = 4,
		effect = CONST_ME_SMALLCLOUDS,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -1500,
		radius = 8,
		effect = CONST_ME_HITAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = 0,
		maxDamage = -1500,
		radius = 8,
		effect = CONST_ME_BLACKSMOKE,
		target = false,
	},
}

monster.defenses = {
	defense = 160,
	armor = 160,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
