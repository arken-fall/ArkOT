local mType = Game.createMonsterType("Varnished Diremaw")
local monster = {}

monster.description = "a varnished diremaw"
monster.experience = 5900
monster.outfit = {
	lookType = 1397,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2090
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Dwelling of the Forgotten.",
}

monster.health = 9000
monster.maxHealth = 9000
monster.race = "blood"
monster.corpse = 36688
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 3,
	color = 71,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 18 },
	{ id = 2181, chance = 30090 },
	{ id = 2127, chance = 18580, maxCount = 1 },
	{ id = 18417, chance = 8850, maxCount = 3 },
	{ id = 2156, chance = 10620, maxCount = 1 },
	{ id = 18416, chance = 6190, maxCount = 3 },
	{ id = 2145, chance = 9730, maxCount = 6 },
	{ id = 39219, chance = 13270, maxCount = 4 },
	{ id = 18414, chance = 9730, maxCount = 3 },
	{ id = 18419, chance = 5310 },
	{ id = 39218, chance = 2650 },
	{ id = 2155, chance = 6190, maxCount = 1 },
	{ id = 2149, chance = 9730, maxCount = 5 },
	{ id = 18415, chance = 11500, maxCount = 3 },
	{ id = 2183, chance = 6190 },
	{ id = 7387, chance = 2650 },
	{ id = 8920, chance = 2650 },
	{ id = 8912, chance = 7080 },
	{ id = 7892, chance = 2650 },
	{ id = 8901, chance = 1770 },
	{ id = 24741, chance = 1640 },
	{ id = 2664, chance = 2650 },
	{ id = 7407, chance = 1370 },
	{ id = 7896, chance = 880 },
	{ id = 2519, chance = 880 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_ICEDAMAGE,
		minDamage = -700,
		maxDamage = -750,
		radius = 4,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -730,
		maxDamage = -750,
		radius = 3,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_ICEDAMAGE,
		minDamage = -800,
		maxDamage = -850,
		range = 4,
		shootEffect = CONST_ANI_ICE,
		target = true,
	},
}

monster.defenses = {
	defense = 5,
	armor = 50,
	mitigation = 1.6,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
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
