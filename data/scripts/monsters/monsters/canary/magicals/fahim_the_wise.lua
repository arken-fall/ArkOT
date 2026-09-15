local mType = Game.createMonsterType("Fahim the Wise")
local monster = {}

monster.description = "Fahim the Wise"
monster.experience = 1500
monster.outfit = {
	lookType = 104,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6033
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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

monster.maxSummons = 3
monster.summons = {
	{ name = "blue djinn", chance = 10, interval = 2000, max = 3 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You should know better than to be an enemy of the Marid", yell = false },
}

monster.loot = {
	{ id = 5912, chance = 99990, maxCount = 4 },
	{ id = 12426, chance = 99990 },
	{ id = 2148, chance = 95240, maxCount = 118 },
	{ id = 12442, chance = 66670 },
	{ id = 7378, chance = 57140, maxCount = 3 },
	{ id = 11227, chance = 47620 },
	{ id = 7589, chance = 42860, maxCount = 3 },
	{ id = 2677, chance = 40480, maxCount = 22 },
	{ id = 2663, chance = 33330 },
	{ id = 2146, chance = 14290, maxCount = 2 },
	{ id = 7732, chance = 7140 },
	{ id = 7900, chance = 4760 },
	{ id = 2158, chance = 2380 },
	{ id = 2063, chance = 580 },
	{ id = 2070, chance = 480 },
	{ id = 2442, chance = 380 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -130 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		range = 7,
		shootEffect = CONST_ANI_ENERGYBALL,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -30,
		maxDamage = -90,
		range = 7,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 15, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 1500, speed = -650 },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 6000 },
	{ name = "outfit", interval = 2000, chance = 1, range = 7, effect = CONST_ME_MAGIC_BLUE, target = false, duration = 4000, monster = "rabbit" },
	{ name = "djinn electrify", interval = 2000, chance = 15, range = 5, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -30,
		maxDamage = -90,
		radius = 3,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 20,
	armor = 20,
	mitigation = 1.29,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 80, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 1 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
