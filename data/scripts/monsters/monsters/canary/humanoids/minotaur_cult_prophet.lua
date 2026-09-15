local mType = Game.createMonsterType("Minotaur Cult Prophet")
local monster = {}

monster.description = "a minotaur cult prophet"
monster.experience = 1100
monster.outfit = {
	lookType = 23,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MinotaurCultTaskDeath",
}

monster.raceId = 1509
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Minotaurs Cult Cave",
}

monster.health = 1700
monster.maxHealth = 1700
monster.race = "blood"
monster.corpse = 5981
monster.speed = 120
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Bow to the power of the iron bull!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 150 },
	{ id = 23575, chance = 18570 },
	{ id = 2186, chance = 8480 },
	{ id = 10556, chance = 15450 },
	{ id = 7591, chance = 7070 },
	{ id = 7590, chance = 16810 },
	{ id = 9971, chance = 1120 },
	{ id = 2147, chance = 7160 },
	{ id = 9970, chance = 7650 },
	{ id = 2154, chance = 490 },
	{ id = 2152, chance = 67040, maxCount = 3 },
	{ id = 2149, chance = 11160 },
	{ id = 2145, chance = 2900, maxCount = 2 },
	{ id = 2150, chance = 6680, maxCount = 2 },
	{ id = 5911, chance = 630 },
	{ id = 2214, chance = 6730 },
	{ id = 2156, chance = 390 },
	{ id = 2666, chance = 8040 },
	{ id = 2671, chance = 60140 },
	{ id = 5878, chance = 14230 },
	{ id = 12428, chance = 18270, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -350,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -350,
		range = 7,
		radius = 1,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 15,
	armor = 28,
	mitigation = 1.1,
	{ name = "Minotaur Cult Prophet Mass Healing", interval = 2000, chance = 20, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
