local mType = Game.createMonsterType("The Duke of the Depths")
local monster = {}

monster.description = "The Duke Of The Depths"
monster.experience = 300000
monster.outfit = {
	lookType = 1047,
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
monster.corpse = 27641
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
}

monster.bosstiary = {
	bossRaceId = 1520,
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
	{ text = "SzzzSzzz!", yell = false },
	{ text = "Chhhhhh!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 63 },
	{ id = 7440, chance = 100000 },
	{ id = 2197, chance = 100000 },
	{ id = 32735, chance = 100000 },
	{ id = 2187, chance = 75000 },
	{ id = 7590, chance = 64580, maxCount = 18 },
	{ id = 18413, chance = 60420 },
	{ id = 2432, chance = 58330 },
	{ id = 8473, chance = 52080, maxCount = 18 },
	{ id = 2392, chance = 52080 },
	{ id = 8472, chance = 45830, maxCount = 18 },
	{ id = 12410, chance = 37500 },
	{ id = 32650, chance = 27080 },
	{ id = 2150, chance = 25000 },
	{ id = 2145, chance = 20830 },
	{ id = 9822, chance = 20830 },
	{ id = 2155, chance = 18750 },
	{ id = 9816, chance = 18750 },
	{ id = 25172, chance = 16670 },
	{ id = 32649, chance = 16670 },
	{ id = 2154, chance = 16670 },
	{ id = 2158, chance = 16670 },
	{ id = 2147, chance = 14580 },
	{ id = 7632, chance = 14580 },
	{ id = 5904, chance = 14580 },
	{ id = 5892, chance = 12500 },
	{ id = 2156, chance = 12500 },
	{ id = 9970, chance = 10420 },
	{ id = 2149, chance = 10420 },
	{ id = 18411, chance = 10420 },
	{ id = 25377, chance = 10420 },
	{ id = 2160, chance = 6250 },
	{ id = 32679, chance = 4170 },
	{ id = 8878, chance = 4170 },
	{ id = 32680, chance = 4170 },
	{ id = 7884, chance = 2080 },
	{ id = 2153, chance = 2080 },
	{ id = 32678, chance = 3390 },
	{ id = 48235, chance = 3390 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		range = 3,
		length = 6,
		spread = 8,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		range = 3,
		length = 9,
		spread = 4,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -135,
		maxDamage = -1000,
		radius = 2,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -1000,
		radius = 8,
		effect = CONST_ME_HITAREA,
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
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.heals = {
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
}

mType:register(monster)
