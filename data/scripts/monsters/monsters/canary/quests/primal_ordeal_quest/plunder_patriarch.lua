local mType = Game.createMonsterType("Plunder Patriarch")
local monster = {}

monster.description = "plunder patriarch"
monster.experience = 0
monster.outfit = {
	lookType = 1567,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "undead"
monster.corpse = 39538
monster.speed = 40
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 5000,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 98
monster.runHealth = 5000

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 41595, chance = 100000, unique = true },
	{ id = 2160, chance = 100000, maxCount = 60 },
	{ id = 26029, chance = 32653, maxCount = 14 },
	{ id = 8473, chance = 30612, maxCount = 14 },
	{ id = 7443, chance = 24490, maxCount = 5 },
	{ id = 7439, chance = 22449, maxCount = 5 },
	{ id = 7440, chance = 18367, maxCount = 5 },
	{ id = 41178, chance = 8322 },
	{ id = 37127, chance = 7322 },
	{ id = 36316, chance = 6122 },
	{ id = 34281, chance = 4082 },
	{ id = 34282, chance = 4082 },
	{ id = 34283, chance = 2041 },
	{ id = 36317, chance = 2041 },
	{ id = 36318, chance = 2450 },
	{ id = 36319, chance = 2150 },
	{ id = 41261, chance = 100 },
	{ id = 41260, chance = 100 },
	{ id = 41254, chance = 100 },
	{ id = 41255, chance = 100 },
	{ id = 41256, chance = 100 },
	{ id = 41257, chance = 100 },
	{ id = 41258, chance = 100 },
	{ id = 41259, chance = 100 },
	{ id = 41290, chance = 100 },
	{ id = 41293, chance = 100 },
	{ id = 41287, chance = 100 },
	{ id = 41284, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 200, chance = 20, minDamage = 0, maxDamage = -950 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_FIREDAMAGE, minDamage = -600, maxDamage = -1000, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -700,
		length = 5,
		spread = 2,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 65,
	armor = 0,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
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
