local mType = Game.createMonsterType("Shrieking Cry-Stal")
local monster = {}

monster.description = "a shrieking cry-stal"
monster.experience = 13560
monster.outfit = {
	lookType = 1560,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2278
monster.bestiary = {
	race = "Construct",
	class = "Construct",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Crystal Enigma",
}

monster.health = 20650
monster.maxHealth = 20650
monster.race = "energy"
monster.corpse = 39331
monster.speed = 207
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
	{ text = "La-la-la..AAAHHHH!!!", yell = false },
	{ text = "SCREEECH...", yell = true },
}

monster.loot = {
	{ id = 2160, chance = 23440, minCount = 1, maxCount = 2 },
	{ id = 8472, chance = 20760 },
	{ id = 41482, chance = 12560, minCount = 1, maxCount = 2 },
	{ id = 2145, chance = 6020, minCount = 1, maxCount = 3 },
	{ id = 9809, chance = 5580 },
	{ id = 18421, chance = 4290 },
	{ id = 7886, chance = 4290 },
	{ id = 2200, chance = 2270 },
	{ id = 2153, chance = 1250 },
	{ id = 2179, chance = 600 },
	{ id = 2155, chance = 420 },
	{ id = 2123, chance = 210 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 5000, chance = 47, type = COMBAT_ENERGYDAMAGE, minDamage = -650, maxDamage = -900, range = 6, shootEffect = CONST_ANI_ENERGYBALL },
	{
		name = "combat",
		interval = 3500,
		chance = 30,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -500,
		maxDamage = -700,
		radius = 6,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{ name = "energy chain", interval = 2000, chance = 20, minDamage = -425, maxDamage = -550, range = 3, target = true },
	{
		name = "combat",
		interval = 3000,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -700,
		maxDamage = -1000,
		length = 5,
		spread = 2,
		effect = CONST_ME_SOUND_PURPLE,
		target = false,
	},
	{ name = "fear", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 110,
	armor = 95,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
