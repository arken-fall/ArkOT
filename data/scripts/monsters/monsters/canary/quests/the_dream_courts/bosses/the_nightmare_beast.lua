local mType = Game.createMonsterType("The Nightmare Beast")
local monster = {}

monster.description = "The Nightmare Beast"
monster.experience = 75000
monster.outfit = {
	lookType = 1144,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 850000
monster.maxHealth = 850000
monster.race = "blood"
monster.corpse = 30159
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1718,
	bossRace = RARITY_ARCHFOE,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 26198, chance = 6450 },
	{ id = 26185, chance = 3230 },
	{ id = 26187, chance = 16129 },
	{ id = 26189, chance = 9680 },
	{ id = 26199, chance = 9680 },
	{ id = 26200, chance = 12900 },
	{ id = 34540, chance = 2830 },
	{ id = 2156, chance = 41940, maxCount = 2 },
	{ id = 7414, chance = 2830 },
	{ id = 2453, chance = 3130 },
	{ id = 34170, chance = 3770 },
	{ id = 7439, chance = 16129, maxCount = 9 },
	{ id = 2158, chance = 6450 },
	{ id = 7443, chance = 32259, maxCount = 19 },
	{ id = 7427, chance = 10380 },
	{ id = 2160, chance = 22580, maxCount = 3 },
	{ id = 34157, chance = 3230 },
	{ id = 34275, chance = 7550 },
	{ id = 26191, chance = 91510 },
	{ id = 34282, chance = 1890 },
	{ id = 34281, chance = 6450 },
	{ id = 34283, chance = 2830 },
	{ id = 7633, chance = 9680 },
	{ id = 9971, chance = 16129 },
	{ id = 25377, chance = 64150 },
	{ id = 2155, chance = 19350 },
	{ id = 5892, chance = 38710 },
	{ id = 34370, chance = 9680 },
	{ id = 5904, chance = 8490 },
	{ id = 7440, chance = 12900, maxCount = 18 },
	{ id = 26165, chance = 93400 },
	{ id = 47306, chance = 12900, maxCount = 18 },
	{ id = 2114, chance = 100000 },
	{ id = 2114, chance = 94340 },
	{ id = 2152, chance = 100000, maxCount = 9 },
	{ id = 34373, chance = 6600 },
	{ id = 2123, chance = 4720 },
	{ id = 31758, chance = 48390, maxCount = 193 },
	{ id = 25172, chance = 98110, maxCount = 4 },
	{ id = 2436, chance = 12900 },
	{ id = 5809, chance = 4720 },
	{ id = 26031, chance = 58060, maxCount = 29 },
	{ id = 34372, chance = 7550 },
	{ id = 48158, chance = 4350 },
	{ id = 26029, chance = 64519, maxCount = 29 },
	{ id = 26030, chance = 58060, maxCount = 24 },
	{ id = 2153, chance = 6450 },
	{ id = 2154, chance = 45160, maxCount = 2 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -1000, maxDamage = -3500, target = true },
	{ name = "death beam", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2100, target = false },
	{ name = "big death wave", interval = 2000, chance = 25, minDamage = -1000, maxDamage = -2000, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -700,
		maxDamage = -1000,
		radius = 5,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 160,
	armor = 160,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
