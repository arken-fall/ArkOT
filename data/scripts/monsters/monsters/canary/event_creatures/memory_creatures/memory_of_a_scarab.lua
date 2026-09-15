local mType = Game.createMonsterType("Memory of a Scarab")
local monster = {}

monster.description = "a memory of a scarab"
monster.experience = 1590
monster.outfit = {
	lookType = 79,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3620
monster.maxHealth = 3620
monster.race = "venom"
monster.corpse = 6021
monster.speed = 109
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
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
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 2
monster.summons = {
	{ name = "Larva", chance = 10, interval = 2000, max = 3 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2135, chance = 3410 },
	{ id = 2148, chance = 50000, maxCount = 155 },
	{ id = 2149, chance = 4810, maxCount = 3 },
	{ id = 2150, chance = 5000, maxCount = 4 },
	{ id = 2159, chance = 7692, maxCount = 2 },
	{ id = 2162, chance = 11480 },
	{ id = 2463, chance = 10300 },
	{ id = 39827, chance = 1500 },
	{ id = 7588, chance = 660 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -130,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 56, maxDamage = 56 },
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -15,
		maxDamage = -145,
		range = 7,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "speed",
		interval = 2000,
		chance = 15,
		range = 7,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = false,
		duration = 25000,
		speed = -700,
	},
	{
		name = "condition",
		type = CONDITION_POISON,
		interval = 2000,
		chance = 30,
		minDamage = -70,
		maxDamage = -150,
		radius = 5,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.1,
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 380 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
	{ type = "bleed", condition = false },
}

mType:register(monster)
