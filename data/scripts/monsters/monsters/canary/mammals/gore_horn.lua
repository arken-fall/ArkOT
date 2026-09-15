local mType = Game.createMonsterType("Gore Horn")
local monster = {}

monster.description = "a gore horn"
monster.experience = 12595
monster.outfit = {
	lookType = 1548,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2266
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Sparkling Pools",
}

monster.health = 20620
monster.maxHealth = 20620
monster.race = "blood"
monster.corpse = 39283
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
	{ text = "Rraaaaa!", yell = false },
}

monster.loot = {
	{ id = 41465, chance = 36040 },
	{ id = 2160, chance = 30050 },
	{ id = 2231, chance = 5270 },
	{ id = 2213, chance = 3590 },
	{ id = 23540, chance = 3100 },
	{ id = 2477, chance = 2330 },
	{ id = 7387, chance = 2060 },
	{ id = 2485, chance = 1390 },
	{ id = 2444, chance = 1070 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000 },
	{
		name = "combat",
		interval = 3500,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -450,
		maxDamage = -750,
		length = 7,
		spread = 0,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 4100,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -500,
		maxDamage = -900,
		radius = 7,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2700,
		chance = 35,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -500,
		maxDamage = -850,
		range = 1,
		shootEffect = CONST_ANI_ENERGY,
		target = true,
	},
	{ name = "root", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 2.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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

RegisterPrimalPackBeast(monster)
