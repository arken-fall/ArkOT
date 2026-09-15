local mType = Game.createMonsterType("Weakened Frazzlemaw")
local monster = {}

monster.description = "a weakened frazzlemaw"
monster.experience = 1000
monster.outfit = {
	lookType = 594,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ThreatenedDreamsNightmareMonstersDeath",
}

monster.raceId = 1442
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Feyrist.",
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 20233
monster.speed = 150
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
	{ text = "Mwaaahgod! Overmwaaaaah! *gurgle*", yell = false },
	{ text = "Mwaaaahnducate youuuuuu *gurgle*, mwaaah!", yell = false },
	{ text = "MMMWAHMWAHMWAHMWAAAAH!", yell = true },
	{ text = "Mmmwhamwhamwhah, mwaaah!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2152, chance = 60000, maxCount = 1 },
	{ id = 2225, chance = 5000 },
	{ id = 2229, chance = 12680 },
	{ id = 2230, chance = 10000 },
	{ id = 2231, chance = 5500 },
	{ id = 2667, chance = 6750, maxCount = 3 },
	{ id = 2671, chance = 6000, maxCount = 2 },
	{ id = 5880, chance = 3000 },
	{ id = 5895, chance = 5000 },
	{ id = 7418, chance = 350 },
	{ id = 7590, chance = 10000, maxCount = 3 },
	{ id = 7591, chance = 10000, maxCount = 2 },
	{ id = 11306, chance = 300 },
	{ id = 22396, chance = 1200 },
	{ id = 22532, chance = 12000 },
	{ id = 22533, chance = 10500 },
	{ id = 31697, chance = 15000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{
		name = "condition",
		type = CONDITION_BLEEDING,
		interval = 2000,
		chance = 10,
		minDamage = -80,
		maxDamage = -200,
		radius = 3,
		effect = CONST_ME_DRAWBLOOD,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -200,
		length = 5,
		spread = 0,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -100,
		radius = 2,
		shootEffect = CONST_ANI_LARGEROCK,
		effect = CONST_ME_STONES,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 15, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000, speed = -600 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_MANADRAIN,
		minDamage = -80,
		maxDamage = -50,
		radius = 4,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
}

monster.defenses = {
	defense = 30,
	armor = 45,
	mitigation = 1.37,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 80, maxDamage = 225, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
