local mType = Game.createMonsterType("Pirat Artillerist")
local monster = {}

monster.description = "a pirat artillerist"
monster.experience = 2800
monster.outfit = {
	lookType = 1346,
	lookHead = 126,
	lookBody = 94,
	lookLegs = 86,
	lookFeet = 94,
	lookAddons = 2,
	lookMount = 0,
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "blood"
monster.corpse = 35372
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = true,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 50

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
	{ name = "melee", interval = 2000, chance = 100, minDamage = 450, maxDamage = -140 },
	{ name = "corym vanguard wave", interval = 2000, chance = 10, minDamage = -50, maxDamage = -100, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -40,
		maxDamage = -70,
		radius = 4,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 65,
	armor = 65,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 30, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
