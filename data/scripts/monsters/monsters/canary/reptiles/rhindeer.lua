local mType = Game.createMonsterType("Rhindeer")
local monster = {}

monster.description = "a rhindeer"
monster.experience = 5600
monster.outfit = {
	lookType = 1606,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2342
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Ingol",
}

monster.health = 8650
monster.maxHealth = 8650
monster.race = "blood"
monster.corpse = 42230
monster.speed = 160
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 200,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 200

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Harrumph!!", yell = false },
	{ text = "Destroy!", yell = false },
	{ text = "Snort!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 72260, maxCount = 30 },
	{ id = 18417, chance = 11550, maxCount = 4 },
	{ id = 42464, chance = 6020 },
	{ id = 31736, chance = 4940, maxCount = 2 },
	{ id = 7590, chance = 2670, maxCount = 4 },
	{ id = 7413, chance = 2470 },
	{ id = 2154, chance = 1880 },
	{ id = 2476, chance = 1380 },
	{ id = 2153, chance = 1200 },
	{ id = 26199, chance = 890 },
	{ id = 2452, chance = 300 },
	{ id = 2514, chance = 400 },
	{ id = 2169, chance = 690 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -471 },
	{ name = "combat", interval = 2000, chance = 20, minDamage = -265, maxDamage = -415, range = 3, radius = 4, effect = CONST_ME_EXPLOSIONHIT, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -325,
		maxDamage = -400,
		range = 7,
		shootEffect = CONST_ANI_POISONARROW,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -265,
		maxDamage = -411,
		range = 1,
		radius = 4,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		range = 2,
		effect = CONST_ME_GROUNDSHAKER,
		target = true,
	},
}

monster.defenses = {
	defense = 50,
	armor = 68,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
