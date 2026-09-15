local mType = Game.createMonsterType("Cave Spider")
local monster = {}

monster.description = "cave spider"
monster.experience = 2000
monster.outfit = {
	lookType = 38,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 1800
monster.maxHealth = 1800
monster.race = "venom"
monster.corpse = 27707
monster.speed = 60
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
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 2
monster.summons = {
	{ name = "Poison Spider", chance = 10, interval = 2000, max = 2 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2148, chance = 99990, maxCount = 76 },
	{ id = 7588, chance = 50000 },
	{ id = 2145, chance = 50000, maxCount = 3 },
	{ id = 2144, chance = 16670 },
	{ id = 5879, chance = 16670 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -300,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 160, maxDamage = 160 },
	},
	{ name = "poisonfield", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_POISON, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -40,
		maxDamage = -70,
		range = 7,
		radius = 1,
		shootEffect = CONST_ANI_POISON,
		target = true,
	},
}

monster.defenses = {
	defense = 0,
	armor = 30,
	mitigation = 1.04,
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 390 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
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
