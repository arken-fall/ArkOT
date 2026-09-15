local mType = Game.createMonsterType("Energuardian of Tales")
local monster = {}

monster.description = "an energuardian of tales"
monster.experience = 11361
monster.outfit = {
	lookType = 1063,
	lookHead = 86,
	lookBody = 85,
	lookLegs = 82,
	lookFeet = 93,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1666
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "The Secret Library (energy section).",
}

monster.health = 14000
monster.maxHealth = 14000
monster.race = "undead"
monster.corpse = 28873
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canWalkOnFire = false,
	canWalkOnPoison = false,
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
	{ text = "Die, enervating mortal!", yell = false },
	{ text = "Let the energy flow!", yell = false },
}

monster.loot = {
	{ id = 33440, chance = 10000, maxCount = 5 },
	{ id = 33441, chance = 10000, maxCount = 5 },
	{ id = 2150, chance = 10000, maxCount = 5 },
	{ id = 7838, chance = 10000, maxCount = 5 },
	{ id = 7895, chance = 250 },
	{ id = 8901, chance = 350 },
	{ id = 8473, chance = 10000, maxCount = 5 },
	{ id = 26029, chance = 10000, maxCount = 5 },
	{ id = 8920, chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -10, maxDamage = -550 },
	{
		name = "combat",
		interval = 1000,
		chance = 13,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -100,
		maxDamage = -555,
		radius = 3,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 77,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = -12 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
