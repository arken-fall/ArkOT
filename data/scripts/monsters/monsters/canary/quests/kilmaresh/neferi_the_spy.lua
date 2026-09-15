local mType = Game.createMonsterType("Neferi the Spy")
local monster = {}

monster.description = "Neferi the Spy"
monster.experience = 19650
monster.outfit = {
	lookType = 149,
	lookHead = 95,
	lookBody = 121,
	lookLegs = 94,
	lookFeet = 1,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "blood"
monster.corpse = 36982
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2105,
	bossRace = RARITY_ARCHFOE,
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
}

monster.loot = {
	{ id = 2160, chance = 4366, maxCount = 1 },
	{ id = 2181, chance = 2276 },
	{ id = 2379, chance = 1791 },
	{ id = 8473, chance = 1119, maxCount = 4 },
	{ id = 9971, chance = 1045, maxCount = 1 },
	{ id = 8472, chance = 784, maxCount = 2 },
	{ id = 2392, chance = 746 },
	{ id = 7886, chance = 522 },
	{ id = 2183, chance = 485 },
	{ id = 7901, chance = 410 },
	{ id = 7903, chance = 373 },
	{ id = 2430, chance = 336 },
	{ id = 7895, chance = 336 },
	{ id = 26189, chance = 299 },
	{ id = 8901, chance = 261 },
	{ id = 7892, chance = 224 },
	{ id = 2476, chance = 224 },
	{ id = 39428, chance = 187 },
	{ id = 18414, chance = 187 },
	{ id = 7902, chance = 149 },
	{ id = 35319, chance = 149 },
	{ id = 2165, chance = 149 },
	{ id = 2153, chance = 149 },
	{ id = 35320, chance = 75 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -350 },
	{
		name = "combat",
		interval = 2000,
		chance = 60,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -700,
		maxDamage = -1100,
		radius = 3,
		effect = CONST_ME_SMALLPLANTS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -650,
		maxDamage = -800,
		range = 5,
		radius = 3,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
