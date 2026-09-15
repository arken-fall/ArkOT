local mType = Game.createMonsterType("Memory of a Vampire")
local monster = {}

monster.description = "a memory of a vampire"
monster.experience = 1550
monster.outfit = {
	lookType = 68,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3650
monster.maxHealth = 3650
monster.race = "blood"
monster.corpse = 6006
monster.speed = 119
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 30,
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
}

monster.loot = {
	{ id = 2127, chance = 230 },
	{ id = 2144, chance = 1800 },
	{ id = 2148, chance = 90230, maxCount = 60 },
	{ id = 2172, chance = 220 },
	{ id = 2383, chance = 1000 },
	{ id = 2396, chance = 420 },
	{ id = 2412, chance = 1560 },
	{ id = 2479, chance = 420 },
	{ id = 2534, chance = 230 },
	{ id = 2747, chance = 1910 },
	{ id = 39827, chance = 1500 },
	{ id = 7588, chance = 1500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -150 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_LIFEDRAIN,
		minDamage = -50,
		maxDamage = -100,
		range = 1,
		effect = CONST_ME_SMALLCLOUDS,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 15, range = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 60000, speed = -400 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 1.2,
	{ name = "outfit", interval = 4000, chance = 10, effect = CONST_ME_GROUNDSHAKER, target = false, duration = 5000, monster = "bat" },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000, speed = 300 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 15, maxDamage = 25, target = false },
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
