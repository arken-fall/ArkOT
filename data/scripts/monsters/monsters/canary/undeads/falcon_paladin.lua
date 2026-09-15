local mType = Game.createMonsterType("Falcon Paladin")
local monster = {}

monster.description = "a falcon paladin"
monster.experience = 6900
monster.outfit = {
	lookType = 1071,
	lookHead = 57,
	lookBody = 96,
	lookLegs = 38,
	lookFeet = 105,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1647
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Falcon Bastion.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 28861
monster.speed = 110
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
	{ text = "Uuunngh!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 90000, maxCount = 5 },
	{ id = 2145, chance = 41000, maxCount = 2 },
	{ id = 8472, chance = 41000, maxCount = 2 },
	{ id = 2149, chance = 40000, maxCount = 2 },
	{ id = 2150, chance = 40000, maxCount = 3 },
	{ id = 7368, chance = 25700, maxCount = 10 },
	{ id = 2147, chance = 20700, maxCount = 2 },
	{ id = 9970, chance = 20100, maxCount = 2 },
	{ id = 7365, chance = 14000, maxCount = 15 },
	{ id = 2156, chance = 7500, maxCount = 3 },
	{ id = 2155, chance = 4880 },
	{ id = 2153, chance = 4180 },
	{ id = 7633, chance = 2260 },
	{ id = 33664, chance = 1120 },
	{ id = 33665, chance = 730 },
	{ id = 2466, chance = 310 },
	{ id = 2514, chance = 310 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -400,
		maxDamage = -550,
		range = 5,
		shootEffect = CONST_ANI_ROYALSPEAR,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = 500,
		range = 5,
		shootEffect = CONST_ANI_BOLT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -350,
		maxDamage = -450,
		range = 7,
		radius = 2,
		shootEffect = CONST_ANI_POWERBOLT,
		effect = CONST_ME_ENERGYHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -250,
		maxDamage = -350,
		length = 5,
		spread = 0,
		effect = CONST_ME_PURPLEENERGY,
		target = false,
	},
}

monster.defenses = {
	defense = 50,
	armor = 82,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
