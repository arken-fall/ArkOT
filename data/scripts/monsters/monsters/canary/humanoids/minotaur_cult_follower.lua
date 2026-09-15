local mType = Game.createMonsterType("Minotaur Cult Follower")
local monster = {}

monster.description = "a minotaur cult follower"
monster.experience = 950
monster.outfit = {
	lookType = 25,
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

monster.raceId = 1508
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

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 5969
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	{ text = "We will rule!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 150 },
	{ id = 23575, chance = 22480 },
	{ id = 10556, chance = 14720 },
	{ id = 2510, chance = 20020 },
	{ id = 7591, chance = 11840 },
	{ id = 2147, chance = 3690, maxCount = 2 },
	{ id = 9970, chance = 3170, maxCount = 2 },
	{ id = 2154, chance = 280 },
	{ id = 2152, chance = 65250, maxCount = 3 },
	{ id = 2510, chance = 20710 },
	{ id = 2149, chance = 3410, maxCount = 2 },
	{ id = 2150, chance = 2950, maxCount = 2 },
	{ id = 5911, chance = 810 },
	{ id = 2671, chance = 59410 },
	{ id = 2172, chance = 15140 },
	{ id = 23546, chance = 12670 },
	{ id = 2214, chance = 3190 },
	{ id = 23545, chance = 1810 },
	{ id = 2475, chance = 570 },
	{ id = 2156, chance = 170 },
	{ id = 2666, chance = 8020 },
	{ id = 5878, chance = 11530 },
	{ id = 12428, chance = 14550, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -240 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -110,
		maxDamage = -210,
		radius = 3,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
}

monster.defenses = {
	defense = 25,
	armor = 32,
	mitigation = 1.24,
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
