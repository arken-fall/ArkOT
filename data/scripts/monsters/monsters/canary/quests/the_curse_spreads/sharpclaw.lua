local mType = Game.createMonsterType("Sharpclaw")
local monster = {}

monster.description = "Sharpclaw"
monster.experience = 3000
monster.outfit = {
	lookType = 1031,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3300
monster.maxHealth = 3300
monster.race = "blood"
monster.corpse = 22067
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1562,
	bossRace = RARITY_ARCHFOE,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
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

monster.maxSummons = 2
monster.summons = {
	{ name = "Werebadger", chance = 20, interval = 2000, max = 2 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Never underestimate a badger!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 13600000, maxCount = 100 },
	{ id = 2148, chance = 13600000, maxCount = 100 },
	{ id = 2152, chance = 13600000, maxCount = 10 },
	{ id = 2789, chance = 13600000, maxCount = 9 },
	{ id = 24849, chance = 13600000, maxCount = 9 },
	{ id = 7762, chance = 13600000, maxCount = 9 },
	{ id = 8845, chance = 13600000, maxCount = 9 },
	{ id = 7590, chance = 13600000, maxCount = 9 },
	{ id = 2171, chance = 13600000 },
	{ id = 2214, chance = 13600000 },
	{ id = 2805, chance = 13600000, maxCount = 9 },
	{ id = 26029, chance = 13600000, maxCount = 9 },
	{ id = 24707, chance = 13600000, maxCount = 9 },
	{ id = 24711, chance = 13600000, maxCount = 9 },
	{ id = 24742, chance = 400 },
	{ id = 8910, chance = 400 },
	{ id = 8922, chance = 400 },
	{ id = 24740, chance = 250 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{
		name = "combat",
		interval = 1000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 100,
		maxDamage = 720,
		range = 7,
		shootEffect = CONST_ANI_SUDDENDEATH,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 15, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000, speed = -600 },
	{
		name = "combat",
		interval = 1000,
		chance = 14,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -100,
		maxDamage = -700,
		length = 5,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{ name = "outfit", interval = 1000, chance = 1, radius = 1, target = true, duration = 2000, monster = "Werebadger" },
	{ name = "ghastly dragon curse", interval = 2000, chance = 5, range = 1, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
