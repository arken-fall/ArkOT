local mType = Game.createMonsterType("The Monster")
local monster = {}

monster.description = "The Monster"
monster.experience = 30000
monster.outfit = {
	lookType = 1600,
}

monster.bosstiary = {
	bossRaceId = 2299,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 450000
monster.maxHealth = 450000
monster.race = "blood"
monster.corpse = 42247
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 30,
	damage = 10,
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
	critChance = 10,
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

monster.loot = {
	{ id = 2152, chance = 100000, maxcount = 30 },
	{ id = 2156, chance = 35542, maxCount = 2 },
	{ id = 8473, chance = 27000, maxcount = 7 },
	{ id = 26029, chance = 24300, maxcount = 5 },
	{ id = 26030, chance = 25750, maxcount = 4 },
	{ id = 7440, chance = 23200, maxcount = 3 },
	{ id = 47306, chance = 23200, maxcount = 3 },
	{ id = 7439, chance = 24800, maxcount = 3 },
	{ id = 7443, chance = 23500, maxcount = 3 },
	{ id = 2154, chance = 26200, maxcount = 5 },
	{ id = 2158, chance = 25100 },
	{ id = 2155, chance = 24600 },
	{ id = 2153, chance = 25350 },
	{ id = 36316, chance = 4300 },
	{ id = 36317, chance = 4600 },
	{ id = 34282, chance = 4500 },
	{ id = 37127, chance = 900 },
	{ id = 42471, chance = 420 },
	{ id = 42465, chance = 390 },
	{ id = 42472, chance = 450 },
	{ id = 42468, chance = 430 },
	{ id = 42467, chance = 410 },
	{ id = 42466, chance = 440 },
	{ id = 42469, chance = 460 },
	{ id = 42470, chance = 400 },
	{ id = 48152, chance = 400 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2800 },
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -600,
		maxDamage = -1200,
		effect = CONST_ME_ENERGYAREA,
		target = true,
		radius = 5,
		range = 3,
	},
	{ name = "destroy magic walls", interval = 1000, chance = 50 },
}

monster.defenses = {
	defense = 54,
	armor = 59,
	mitigation = 3.7,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 900, maxDamage = 2400, effect = CONST_ME_MAGIC_BLUE, target = false },
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
