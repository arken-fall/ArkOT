local mType = Game.createMonsterType("Morshabaal")
local monster = {}

monster.description = "Morshabaal"
monster.experience = 3000000
monster.outfit = {
	lookType = 1468,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1000000
monster.maxHealth = 1000000
monster.race = "blood"
monster.corpse = 37704
monster.speed = 530
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2118,
	bossRace = RARITY_NEMESIS,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Revenge for my little brother!", yell = false },
	{ text = "You are starting to annoy me!", yell = false },
	{ text = "I will restore our family honor!", yell = false },
}

monster.summons = {}

monster.loot = {
	{ id = 2160, chance = 60000, maxCount = 35 },
	{ id = 2152, chance = 100000, maxCount = 69 },
	{ id = 26029, chance = 40000, maxCount = 100 },
	{ id = 8473, chance = 30000, maxCount = 100 },
	{ id = 26030, chance = 30000, maxCount = 100 },
	{ id = 40117, chance = 100000 },
	{ id = 37129, chance = 100000 },
	{ id = 37128, chance = 100000 },
	{ id = 36319, chance = 40000 },
	{ id = 34276, chance = 20000 },
	{ id = 35319, chance = 20000 },
	{ id = 39959, chance = 10000 },
	{ id = 34282, chance = 10000 },
	{ id = 15515, chance = 10000 },
	{ id = 39960, chance = 6666 },
	{ id = 39956, chance = 6666 },
	{ id = 39957, chance = 6666 },
	{ id = 39955, chance = 6666 },
	{ id = 39958, chance = 6666 },
	{ id = 34275, chance = 6666 },
	{ id = 2421, chance = 6666 },
}

monster.attacks = {
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -5500,
		length = 8,
		spread = 0,
		effect = CONST_ME_WHITE_ENERGY_SPARK,
	},
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -4000, maxDamage = -30000, effect = CONST_ME_ICEATTACK },
	{ name = "melee", interval = 2000, chance = 100, skill = 200, attack = 250 },
	{
		name = "combat",
		interval = 1000,
		chance = 7,
		type = COMBAT_MANADRAIN,
		minDamage = -100,
		maxDamage = -1000,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_POFF,
		target = false,
	},
	{ name = "drunk", interval = 1000, chance = 7, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "strength", interval = 1000, chance = 9, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_ENERGYAREA, target = false },
	{
		name = "combat",
		interval = 1000,
		chance = 13,
		type = COMBAT_LIFEDRAIN,
		minDamage = -400,
		maxDamage = -700,
		radius = 8,
		effect = CONST_ME_LOSEENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 10,
		type = COMBAT_MANADRAIN,
		minDamage = -400,
		maxDamage = -700,
		radius = 8,
		effect = CONST_ME_MAGIC_GREEN,
		target = false,
	},
	{ name = "speed", interval = 1000, chance = 12, radius = 6, effect = CONST_ME_POISONAREA, target = false, duration = 60000, speed = -1900 },
	{ name = "strength", interval = 1000, chance = 8, radius = 5, effect = CONST_ME_HITAREA, target = false },
	{ name = "outfit", interval = 1000, chance = 2, radius = 8, effect = CONST_ME_LOSEENERGY, target = false, duration = 5000, monster = "demon" },
	{ name = "outfit", interval = 1000, chance = 2, radius = 8, effect = CONST_ME_LOSEENERGY, target = false, duration = 5000, item = 2174 },
	{
		name = "combat",
		interval = 1000,
		chance = 34,
		type = COMBAT_FIREDAMAGE,
		minDamage = -100,
		maxDamage = -900,
		range = 7,
		radius = 7,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -500,
		maxDamage = -850,
		length = 8,
		spread = 0,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
}

monster.defenses = {
	defense = 160,
	armor = 160,
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_HEALING, minDamage = 5000, maxDamage = 10000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 8, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 1901 },
	{ name = "invisible", interval = 1000, chance = 4, effect = CONST_ME_MAGIC_BLUE },
	{ name = "invisible", interval = 1000, chance = 17, effect = CONST_ME_MAGIC_BLUE },
	{ name = "outfit", interval = 1000, chance = 2, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 7000, item = 2046 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
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
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
