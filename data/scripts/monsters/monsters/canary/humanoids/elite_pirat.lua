local mType = Game.createMonsterType("Elite Pirat")
local monster = {}

monster.description = "an elite pirat"
monster.experience = 18000
monster.outfit = {
	lookType = 534,
	lookHead = 79,
	lookBody = 79,
	lookLegs = 94,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "blood"
monster.corpse = 17446
monster.speed = 100
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = true,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 120 },
	{ id = 8472, chance = 100000, maxCount = 2 },
	{ id = 38469, chance = 10000 },
	{ id = 7886, chance = 4761 },
	{ id = 7886, chance = 4761 },
	{ id = 20092, chance = 5000 },
	{ id = 20093, chance = 5000 },
	{ id = 20097, chance = 16666 },
	{ id = 20098, chance = 3846 },
	{ id = 38491, chance = 11111 },
	{ id = 20100, chance = 14285 },
	{ id = 20101, chance = 14285 },
	{ id = 7893, chance = 1612 },
	{ id = 7891, chance = 3225 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 400, maxDamage = -210 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 80,
		maxDamage = -110,
		range = 7,
		shootEffect = CONST_ANI_WHIRLWINDCLUB,
		target = false,
	},
}

monster.defenses = {
	defense = 15,
	armor = 15,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
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
