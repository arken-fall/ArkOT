local mType = Game.createMonsterType("Orc Cult Inquisitor")
local monster = {}

monster.description = "an orc cult inquisitor"
monster.experience = 1150
monster.outfit = {
	lookType = 8,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1505
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Edron Orc Cave.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 5980
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
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
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
	{ text = "You unorcish scum will die!", yell = false },
}

monster.loot = {
	{ id = 7588, chance = 18390 },
	{ id = 2148, chance = 100000, maxCount = 221 },
	{ id = 2144, chance = 510, maxCount = 2 },
	{ id = 7439, chance = 2940 },
	{ id = 2147, chance = 4020, maxCount = 5 },
	{ id = 2378, chance = 6340 },
	{ id = 30489, chance = 17160 },
	{ id = 2788, chance = 7730, maxCount = 3 },
	{ id = 2381, chance = 9890 },
	{ id = 2428, chance = 850 },
	{ id = 10556, chance = 9890 },
	{ id = 2671, chance = 8960 },
	{ id = 11113, chance = 5410 },
	{ id = 12433, chance = 15460 },
	{ id = 12435, chance = 7730 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.46,
	{ name = "speed", interval = 2000, chance = 30, effect = CONST_ME_MAGIC_RED, target = false, duration = 6000, speed = 290 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
