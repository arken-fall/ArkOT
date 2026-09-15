local mType = Game.createMonsterType("Nibblemaw")
local monster = {}

monster.description = "a nibblemaw"
monster.experience = 2700
monster.outfit = {
	lookType = 1737,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 94,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {}

monster.raceId = 2531
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Chocolate Mines.",
}

monster.health = 2900
monster.maxHealth = 2900
monster.race = "candy"
monster.corpse = 48259
monster.speed = 118
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ text = "*chomp* Mmmoh! *chomp*", yell = false },
	{ text = "Mwaaahgod! Overmwaaaaah", yell = false },
	{ text = "*gurgle*", yell = false },
	{ text = "Mmmwahmwahmwhah, mwaaah!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2152, chance = 75000, maxCount = 6 },
	{ id = 2154, chance = 6000 },
	{ id = 46705, chance = 1090 },
	{ id = 46700, chance = 940, maxCount = 64 },
	{ id = 46581, chance = 4590, maxCount = 2 },
	{ id = 2682, chance = 1550 },
	{ id = 8840, chance = 1240, maxCount = 2 },
	{ id = 7404, chance = 400 },
	{ id = 18420, chance = 3400 },
	{ id = 22532, chance = 10430 },
	{ id = 22533, chance = 7700 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -70,
		maxDamage = -150,
		range = 6,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -20, maxDamage = -250, length = 5, spread = 5, effect = CONST_ME_SIRUP },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -60,
		maxDamage = -250,
		radius = 4,
		effect = CONST_ME_STONES,
		target = false,
	},
}

monster.defenses = {
	defense = 30,
	armor = 48,
	mitigation = 1.1,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 250, maxDamage = 225, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
