local mType = Game.createMonsterType("Werefox")
local monster = {}

monster.description = "a werefox"
monster.experience = 1600
monster.outfit = {
	lookType = 1030,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1549
monster.bestiary = {
	race = "Lycanthrope",
	class = "Lycanthrope",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Were-beasts cave south-west of Edron and in the Last Sanctum east of Cormaya.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 27521
monster.speed = 140
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 1
monster.summons = {
	{ name = "fox", chance = 10, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Yelp!", yell = false },
	{ text = "Grrrrrr", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 405000, maxCount = 200 },
	{ id = 2152, chance = 4050, maxCount = 2 },
	{ id = 32527, chance = 4050, maxCount = 2 },
	{ id = 32528, chance = 4050, maxCount = 2 },
	{ id = 7589, chance = 4050, maxCount = 2 },
	{ id = 7590, chance = 4050, maxCount = 2 },
	{ id = 7620, chance = 4050, maxCount = 2 },
	{ id = 7761, chance = 4050, maxCount = 2 },
	{ id = 2127, chance = 4050, maxCount = 2 },
	{ id = 2186, chance = 500 },
	{ id = 2805, chance = 500, maxCount = 2 },
	{ id = 7368, chance = 300, maxCount = 5 },
	{ id = 2171, chance = 130 },
	{ id = 2214, chance = 200 },
	{ id = 24716, chance = 50 },
	{ id = 32730, chance = 30 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -100,
		maxDamage = -200,
		shootEffect = CONST_ANI_GREENSTAR,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -225,
		range = 7,
		radius = 4,
		effect = CONST_ME_MAGIC_RED,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 14,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -100,
		maxDamage = -700,
		length = 5,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 145, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
