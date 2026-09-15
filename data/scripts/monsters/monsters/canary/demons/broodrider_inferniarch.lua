local mType = Game.createMonsterType("Broodrider Inferniarch")
local monster = {}

monster.description = "a broodrider inferniarch"
monster.experience = 7400
monster.outfit = {
	lookType = 1796,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2603
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 2500,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Azzilon Castle.",
}

monster.health = 9600
monster.maxHealth = 9600
monster.race = "fire"
monster.corpse = 50006
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Mah...Hun Hur...!", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 5000, maxCount = 25 },
	{ id = 18436, chance = 900, maxCount = 5 },
	{ id = 48030, chance = 1000 },
	{ id = 18418, chance = 300 },
	{ id = 24849, chance = 1500, maxCount = 3 },
	{ id = 7894, chance = 800 },
	{ id = 5803, chance = 300 },
	{ id = 2547, chance = 1000, maxCount = 5 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -167, maxDamage = -374 },
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -402,
		maxDamage = -426,
		range = 1,
		effect = CONST_ME_BITE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -219,
		maxDamage = -261,
		range = 4,
		shootEffect = CONST_ANI_BOLT,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -472,
		range = 4,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 15,
	armor = 70,
	mitigation = 2.05,
}

monster.elements = {
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
