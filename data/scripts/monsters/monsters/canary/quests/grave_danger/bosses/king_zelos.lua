local mType = Game.createMonsterType("King Zelos")
local monster = {}

monster.description = "King Zelos"
monster.experience = 75000
monster.outfit = {
	lookType = 1224,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 480000
monster.maxHealth = 480000
monster.race = "venom"
monster.corpse = 31611
monster.speed = 212

monster.events = {
	"zelos_damage",
	"zelos_init",
	"grave_danger_death",
}

monster.bosstiary = {
	bossRaceId = 1784,
	bossRace = RARITY_ARCHFOE,
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.loot = {
	{ id = 2152, minCount = 1, maxCount = 5, chance = 100000 },
	{ id = 2160, minCount = 0, maxCount = 5, chance = 50000 },
	{ id = 26031, minCount = 0, maxCount = 20, chance = 45000 },
	{ id = 26029, minCount = 0, maxCount = 6, chance = 42000 },
	{ id = 26030, minCount = 0, maxCount = 14, chance = 42000 },
	{ id = 7443, minCount = 0, maxCount = 10, chance = 22000 },
	{ id = 7439, minCount = 0, maxCount = 10, chance = 22000 },
	{ id = 25377, minCount = 0, maxCount = 3, chance = 18000 },
	{ id = 25172, minCount = 0, maxCount = 3, chance = 25000 },
	{ id = 2155, chance = 19000 },
	{ id = 2156, chance = 18500 },
	{ id = 2154, chance = 18500 },
	{ id = 34283, chance = 16800 },
	{ id = 26199, chance = 15200 },
	{ id = 7899, chance = 15200 },
	{ id = 9971, minCount = 0, maxCount = 1, chance = 18000 },
	{ id = 1986, chance = 18200 },
	{ id = 26185, chance = 12000 },
	{ id = 26189, chance = 12000 },
	{ id = 35572, chance = 5500 },
	{ id = 35562, chance = 1300 },
	{ id = 13532, chance = 1100 },
	{ id = 35563, chance = 600 },
	{ id = 35564, chance = 550 },
	{ id = 35710, chance = 530 },
	{ id = 35565, chance = 500 },
	{ id = 48220, chance = 500 },
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = -900, maxDamage = -2700 },
	{
		name = "combat",
		type = COMBAT_FIREDAMAGE,
		interval = 2000,
		chance = 15,
		length = 8,
		spread = 0,
		minDamage = -1200,
		maxDamage = -3200,
		effect = CONST_ME_HITBYFIRE,
	},
	{
		name = "combat",
		type = COMBAT_LIFEDRAIN,
		interval = 2000,
		chance = 10,
		length = 8,
		spread = 0,
		minDamage = -600,
		maxDamage = -1600,
		effect = CONST_ME_SMALLCLOUDS,
	},
	{
		name = "combat",
		type = COMBAT_DEATHDAMAGE,
		interval = 2000,
		chance = 30,
		radius = 6,
		minDamage = -1200,
		maxDamage = -1500,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		type = COMBAT_DEATHDAMAGE,
		interval = 2000,
		chance = 20,
		length = 8,
		minDamage = -1700,
		maxDamage = -2000,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 130,
	armor = 130,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 1450, maxDamage = 5350, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of death unleashed!", yell = false },
	{ text = "I will rule again and my realm of death will span the world!", yell = false },
	{ text = "My lich-knights will conquer this world for me!", yell = false },
}

mType:register(monster)
