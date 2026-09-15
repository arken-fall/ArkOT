local mType = Game.createMonsterType("Hulking Prehemoth")
local monster = {}

monster.description = "a hulking prehemoth"
monster.experience = 12690
monster.outfit = {
	lookType = 1553,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2271
monster.bestiary = {
	race = "Giant",
	class = "Giant",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Sparkling Pools",
}

monster.health = 20700
monster.maxHealth = 20700
monster.race = "blood"
monster.corpse = 39303
monster.speed = 191
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "SMAASH!", yell = true },
}

monster.loot = {
	{ id = 2160, chance = 28240 },
	{ id = 41470, chance = 19870 },
	{ id = 41471, chance = 16149, minCount = 1, maxCount = 2 },
	{ id = 8473, chance = 16120 },
	{ id = 7432, chance = 7050 },
	{ id = 2391, chance = 4660 },
	{ id = 2454, chance = 3040 },
	{ id = 2485, chance = 2880 },
	{ id = 2134, chance = 1160 },
	{ id = 2127, chance = 780 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1250 },
	{
		name = "combat",
		interval = 3500,
		chance = 38,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -850,
		maxDamage = -1700,
		range = 4,
		shootEffect = CONST_ANI_LARGEROCK,
		target = true,
	},
	{
		name = "combat",
		interval = 4100,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -600,
		maxDamage = -1200,
		radius = 5,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 84,
	armor = 84,
	mitigation = 2.51,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = -30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
