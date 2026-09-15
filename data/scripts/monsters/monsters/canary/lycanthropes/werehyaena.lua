local mType = Game.createMonsterType("Werehyaena")
local monster = {}

monster.description = "a werehyaena"
monster.experience = 2200
monster.outfit = {
	lookType = 1300,
	lookHead = 57,
	lookBody = 77,
	lookLegs = 1,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1963
monster.bestiary = {
	race = "Lycanthrope",
	class = "Lycanthrope",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Darashia Wyrm Hills only during night, Hyaena Lairs.",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "blood"
monster.corpse = 33821
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	runHealth = 30,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 30

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Snarl!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 7591, chance = 49970, maxCount = 3 },
	{ id = 2666, chance = 19070 },
	{ id = 2386, chance = 16810 },
	{ id = 2403, chance = 16620 },
	{ id = 37275, chance = 12670 },
	{ id = 2381, chance = 11480 },
	{ id = 18420, chance = 9540 },
	{ id = 7762, chance = 5760, maxCount = 5 },
	{ id = 20093, chance = 5670 },
	{ id = 2156, chance = 5590 },
	{ id = 2154, chance = 5420 },
	{ id = 2404, chance = 4700 },
	{ id = 18421, chance = 4580 },
	{ id = 20092, chance = 4280 },
	{ id = 37276, chance = 750 },
	{ id = 37541, chance = 190 },
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2 * 1000, minDamage = 0, maxDamage = -300 },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2 * 1000, chance = 17, minDamage = -175, maxDamage = -255, radius = 3, effect = CONST_ME_HITBYPOISON },
	{
		name = "combat",
		type = COMBAT_DEATHDAMAGE,
		interval = 2 * 1000,
		chance = 15,
		minDamage = -330,
		maxDamage = -370,
		target = true,
		range = 5,
		radius = 1,
		shootEffect = CONST_ANI_LARGEROCK,
		effect = CONST_ME_MORTAREA,
	},
	{
		name = "combat",
		type = COMBAT_DEATHDAMAGE,
		interval = 2 * 1000,
		chance = 13,
		minDamage = -225,
		maxDamage = -275,
		length = 3,
		spread = 0,
		effect = CONST_ME_MORTAREA,
	},
}

monster.defenses = {
	defense = 0,
	armor = 36,
	mitigation = 0.88,
	{ name = "speed", chance = 15, interval = 2 * 1000, speed = 200, duration = 5 * 1000, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
