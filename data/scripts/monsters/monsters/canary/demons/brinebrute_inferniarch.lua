local mType = Game.createMonsterType("Brinebrute Inferniarch")
local monster = {}

monster.description = "a brinebrute inferniarch"
monster.experience = 20300
monster.outfit = {
	lookType = 1794,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2601
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 2500,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Azzilon Castle Catacombs.",
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "fire"
monster.corpse = 49998
monster.speed = 160
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
	{ text = "Garrr...Garrr!", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 5000, maxCount = 40 },
	{ id = 39151, chance = 1500 },
	{ id = 18415, chance = 900, maxCount = 2 },
	{ id = 18418, chance = 300 },
	{ id = 8473, chance = 1500, maxCount = 3 },
	{ id = 48073, chance = 800 },
	{ id = 2497, chance = 800 },
	{ id = 8472, chance = 1500, maxCount = 5 },
	{ id = 18413, chance = 300, maxCount = 2 },
	{ id = 18416, chance = 300 },
	{ id = 2197, chance = 500 },
	{ id = 2179, chance = 200 },
	{ id = 2520, chance = 150 },
	{ id = 48028, chance = 2000 },
	{ id = 2146, chance = 1500, maxCount = 4 },
	{ id = 18414, chance = 1500, maxCount = 2 },
	{ id = 18417, chance = 300 },
	{ id = 2164, chance = 900 },
	{ id = 2214, chance = 900 },
	{ id = 2393, chance = 300 },
	{ id = 7382, chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -520, maxDamage = -600 },
}

monster.defenses = {
	defense = 15,
	armor = 80,
	mitigation = 2.45,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
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
