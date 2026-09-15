local mType = Game.createMonsterType("Pixie")
local monster = {}

monster.description = "a pixie"
monster.experience = 700
monster.outfit = {
	lookType = 982,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1438
monster.bestiary = {
	race = "Fey",
	class = "Fey",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Feyrist.",
}

monster.health = 770
monster.maxHealth = 770
monster.race = "blood"
monster.corpse = 25811
monster.speed = 120
monster.manaCost = 450

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
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 20

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Glamour, glitter, glistering things! Do you have any of those?", yell = false },
	{ text = "Sweet dreams!", yell = false },
	{ text = "You might be a threat! I'm sorry but I can't allow you to linger here.", yell = false },
	{ text = "Let's try a step or two!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 30000, maxCount = 90 },
	{ id = 31701, chance = 492 },
	{ id = 31702, chance = 92 },
	{ id = 31703, chance = 92 },
	{ id = 2162, chance = 492 },
	{ id = 2796, chance = 492 },
	{ id = 7762, chance = 492, maxCount = 2 },
	{ id = 9970, chance = 592, maxCount = 2 },
	{ id = 31736, chance = 719, maxCount = 3 },
	{ id = 31699, chance = 719 },
	{ id = 2800, chance = 719 },
	{ id = 31734, chance = 10000, maxCount = 5 },
	{ id = 2744, chance = 30100 },
	{ id = 7589, chance = 6800 },
	{ id = 31694, chance = 5155 },
	{ id = 7590, chance = 591 },
	{ id = 31698, chance = 5800 },
	{ id = 31695, chance = 3400, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -85,
		maxDamage = -135,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYHIT,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 7000, speed = -440 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = 0,
		maxDamage = -100,
		range = 4,
		shootEffect = CONST_ANI_LEAFSTAR,
		target = false,
	},
	{ name = "pixie skill reducer", interval = 2000, chance = 20, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 50,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 40, maxDamage = 75, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 60 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 60 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
