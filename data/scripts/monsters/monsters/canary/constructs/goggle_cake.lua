local mType = Game.createMonsterType("Goggle Cake")
local monster = {}

monster.description = "a goggle cake"
monster.experience = 2700
monster.outfit = {
	lookType = 1740,
	lookHead = 0,
	lookBody = 10,
	lookLegs = 115,
	lookFeet = 54,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2534
monster.bestiary = {
	race = "Construct",
	class = "Construct",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Dessert Dungeons.",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "undead"
monster.corpse = 48271
monster.speed = 122
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
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Give me your sweets! They are mine to devour!", yell = false },
	{ text = "Hm? Where ... where are you now?", yell = false },
	{ text = "Hunger!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2152, chance = 80540, maxCount = 10 },
	{ id = 7759, chance = 6730, maxCount = 5 },
	{ id = 2404, chance = 5710 },
	{ id = 7590, chance = 5690 },
	{ id = 31736, chance = 3810, maxCount = 3 },
	{ id = 2146, chance = 3590, maxCount = 2 },
	{ id = 2156, chance = 2660 },
	{ id = 8870, chance = 1740 },
	{ id = 46581, chance = 1690 },
	{ id = 46704, chance = 1520 },
	{ id = 7888, chance = 1020 },
	{ id = 2328, chance = 1000 },
	{ id = 46699, chance = 780, maxCount = 15 },
	{ id = 2692, chance = 690 },
	{ id = 2687, chance = 520, maxCount = 2 },
	{ id = 7897, chance = 500 },
	{ id = 2438, chance = 400 },
	{ id = 2396, chance = 210 },
	{ id = 6394, chance = 140 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -170,
		maxDamage = -300,
		range = 7,
		shootEffect = CONST_ANI_CHERRYBOMB,
		effect = CONST_ME_STARBURST,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -120,
		maxDamage = -260,
		range = 6,
		shootEffect = CONST_ANI_CHERRYBOMB,
		effect = CONST_ME_CREAM,
		target = true,
	},
}

monster.defenses = {
	defense = 38,
	armor = 38,
	mitigation = 0.99,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 105 },
	{ type = COMBAT_FIREDAMAGE, percent = 110 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
