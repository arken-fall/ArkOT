local mType = Game.createMonsterType("Ancient Lion Knight")
local monster = {}

monster.description = "an ancient lion knight"
monster.experience = 8100
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 78,
	lookLegs = 76,
	lookFeet = 76,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 9100
monster.maxHealth = 9100
monster.race = "blood"
monster.corpse = 28621
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
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
	{ id = 2220, chance = 53750 },
	{ id = 2245, chance = 8300 },
	{ id = 2226, chance = 9500 },
	{ id = 2521, chance = 2000 },
	{ id = 2671, chance = 53750 },
	{ id = 2237, chance = 47500 },
	{ id = 2229, chance = 28750 },
	{ id = 2403, chance = 25000 },
	{ id = 12409, chance = 23750 },
	{ id = 2489, chance = 18750 },
	{ id = 30489, chance = 12500 },
	{ id = 2404, chance = 8750 },
	{ id = 2463, chance = 7500 },
	{ id = 2526, chance = 7500 },
	{ id = 2231, chance = 5000 },
	{ id = 2654, chance = 5000 },
	{ id = 20093, chance = 3750 },
	{ id = 2525, chance = 1250 },
	{ id = 37480, chance = 35 },
	{ id = 37481, chance = 35 },
	{ id = 37478, chance = 35 },
	{ id = 37479, chance = 35 },
	{ id = 37570, chance = 35 },
	{ id = 37569, chance = 35 },
	{ id = 37474, chance = 35 },
	{ id = 37477, chance = 35 },
	{ id = 37476, chance = 35 },
	{ id = 37482, chance = 35 },
	{ id = 37475, chance = 35 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -750, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 6000,
		chance = 30,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -450,
		maxDamage = -750,
		length = 8,
		spread = 0,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2750,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -800,
		range = 7,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2500,
		chance = 22,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		radius = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 3300,
		chance = 24,
		type = COMBAT_ICEDAMAGE,
		minDamage = -250,
		maxDamage = -350,
		length = 4,
		spread = 0,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -500,
		radius = 4,
		effect = CONST_ME_BIGCLOUDS,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 0,
	{ name = "speed", interval = 1000, chance = 10, effect = CONST_ME_POFF, target = false, duration = 4000, speed = 160 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
