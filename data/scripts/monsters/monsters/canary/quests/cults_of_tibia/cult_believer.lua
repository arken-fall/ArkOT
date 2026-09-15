local mType = Game.createMonsterType("Cult Believer")
local monster = {}

monster.description = "a cult believer"
monster.experience = 850
monster.outfit = {
	lookType = 132,
	lookHead = 98,
	lookBody = 96,
	lookLegs = 39,
	lookFeet = 38,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"CarlinVortexDeath",
}

monster.raceId = 1512
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Forbidden Temple (Carlin).",
}

monster.health = 975
monster.maxHealth = 975
monster.race = "blood"
monster.corpse = 22017
monster.speed = 130
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "Death to the unbelievers!", yell = false },
}

monster.loot = {
	{ id = 2543, chance = 90450, maxCount = 10 },
	{ id = 2148, chance = 75410, maxCount = 30 },
	{ id = 2681, chance = 15400 },
	{ id = 7591, chance = 12340, maxCount = 2 },
	{ id = 2666, chance = 5000 },
	{ id = 2455, chance = 830 },
	{ id = 2652, chance = 760 },
	{ id = 2164, chance = 700, maxCount = 2 },
	{ id = 2120, chance = 1000 },
	{ id = 2661, chance = 1000 },
	{ id = 1949, chance = 830 },
	{ id = 2145, chance = 830 },
	{ id = 2391, chance = 130 },
	{ id = 2381, chance = 830 },
	{ id = 2515, chance = 330 },
	{ id = 2477, chance = 230 },
	{ id = 2475, chance = 200 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 10, maxDamage = -250 },
}

monster.defenses = {
	defense = 50,
	armor = 30,
	mitigation = 1.18,
	{ name = "combat", interval = 4000, chance = 25, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
