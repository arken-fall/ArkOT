local mType = Game.createMonsterType("Naga Warrior")
local monster = {}

monster.description = "a naga warrior"
monster.experience = 5890
monster.outfit = {
	lookType = 1539,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2261
monster.bestiary = {
	race = "Amphibic",
	class = "Reptile",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Temple of the Moon Goddess.",
}

monster.health = 5530
monster.maxHealth = 5530
monster.race = "blood"
monster.corpse = 39225
monster.speed = 180
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
	{ text = "Fear the wrath of the wronged!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 20 },
	{ id = 2379, chance = 38810 },
	{ id = 7588, chance = 14930, maxCount = 2 },
	{ id = 41502, chance = 10600, maxCount = 3 },
	{ id = 41500, chance = 6420, maxCount = 3 },
	{ id = 2419, chance = 5520 },
	{ id = 41499, chance = 3730 },
	{ id = 2463, chance = 2990 },
	{ id = 20139, chance = 2090 },
	{ id = 2409, chance = 1940 },
	{ id = 18414, chance = 2640 },
	{ id = 2412, chance = 1490 },
	{ id = 7383, chance = 600 },
	{ id = 2476, chance = 1100 },
	{ id = 7441, chance = 300 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -120, maxDamage = -340, target = true },
	{
		name = "combat",
		interval = 2500,
		chance = 30,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -320,
		maxDamage = -430,
		effect = CONST_ME_YELLOWSMOKE,
		range = 3,
		target = true,
	},
	{ name = "nagadeathattack", interval = 3000, chance = 35, minDamage = -360, maxDamage = -415, target = true },
	{
		name = "combat",
		interval = 3500,
		chance = 35,
		type = COMBAT_LIFEDRAIN,
		minDamage = -360,
		maxDamage = -386,
		radius = 4,
		effect = CONST_ME_DRAWBLOOD,
		target = false,
	},
}

monster.defenses = {
	defense = 110,
	armor = 78,
	mitigation = 2.19,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
