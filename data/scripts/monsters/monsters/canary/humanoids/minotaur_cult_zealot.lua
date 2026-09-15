local mType = Game.createMonsterType("Minotaur Cult Zealot")
local monster = {}

monster.description = "a minotaur cult zealot"
monster.experience = 1350
monster.outfit = {
	lookType = 29,
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

monster.raceId = 1510
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

monster.health = 1800
monster.maxHealth = 1800
monster.race = "blood"
monster.corpse = 5983
monster.speed = 125
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
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 150 },
	{ id = 2182, chance = 11670 },
	{ id = 7425, chance = 5360 },
	{ id = 10556, chance = 9200 },
	{ id = 12429, chance = 16230 },
	{ id = 7589, chance = 10660, maxCount = 3 },
	{ id = 2147, chance = 2030, maxCount = 2 },
	{ id = 9970, chance = 2680, maxCount = 2 },
	{ id = 2154, chance = 220 },
	{ id = 2152, chance = 39350, maxCount = 3 },
	{ id = 2149, chance = 2540, maxCount = 2 },
	{ id = 2146, chance = 2170, maxCount = 2 },
	{ id = 2145, chance = 2900, maxCount = 2 },
	{ id = 2150, chance = 2610, maxCount = 2 },
	{ id = 5911, chance = 2460 },
	{ id = 2156, chance = 70 },
	{ id = 5878, chance = 4780 },
	{ id = 12428, chance = 2320, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -340 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -90,
		maxDamage = -320,
		range = 7,
		shootEffect = CONST_ANI_WHIRLWINDAXE,
		target = true,
	},
}

monster.defenses = {
	defense = 30,
	armor = 35,
	mitigation = 1.37,
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
