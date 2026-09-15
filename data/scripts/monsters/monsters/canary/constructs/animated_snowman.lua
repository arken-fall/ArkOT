local mType = Game.createMonsterType("Animated Snowman")
local monster = {}

monster.description = "an animated snowman"
monster.experience = 400
monster.outfit = {
	lookType = 1159,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1751
monster.bestiary = {
	race = "Construct",
	class = "Construct",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 2,
	locations = "Percht Island.",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "venom"
monster.corpse = 30335
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 50 },
	{ id = 34535, chance = 91770 },
	{ id = 7839, chance = 7310 },
	{ id = 2396, chance = 4750 },
	{ id = 7902, chance = 4570 },
	{ id = 2111, chance = 4000, maxCount = 5 },
	{ id = 2183, chance = 3470 },
	{ id = 7902, chance = 250 },
	{ id = 7888, chance = 3290 },
	{ id = 2186, chance = 1830 },
	{ id = 7896, chance = 1100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -20 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -10,
		maxDamage = -40,
		range = 7,
		radius = 2,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYHIT,
		target = true,
	},
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 0.78,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
