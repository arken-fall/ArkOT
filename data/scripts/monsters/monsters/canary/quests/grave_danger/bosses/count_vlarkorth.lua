local mType = Game.createMonsterType("Count Vlarkorth")
local monster = {}

monster.description = "Count Vlarkorth"
monster.experience = 55000
monster.outfit = {
	lookType = 1221,
	lookHead = 19,
	lookBody = 0,
	lookLegs = 83,
	lookFeet = 20,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"count_vlarkorth_transform",
	"grave_danger_death",
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1753,
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

monster.maxSummons = 4
monster.summons = {
	{ name = "Soulless Minion", chance = 70, interval = 5500, max = 4 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, minCount = 1, maxCount = 5, chance = 100000 },
	{ id = 2160, minCount = 0, maxCount = 2, chance = 50000 },
	{ id = 26031, minCount = 0, maxCount = 6, chance = 35000 },
	{ id = 26029, minCount = 0, maxCount = 20, chance = 32000 },
	{ id = 26030, minCount = 0, maxCount = 20, chance = 32000 },
	{ id = 7443, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 7440, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 47306, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 25172, minCount = 0, maxCount = 2, chance = 8000 },
	{ id = 2158, chance = 9000 },
	{ id = 26198, chance = 5200 },
	{ id = 26200, chance = 5200 },
	{ id = 2158, chance = 8500 },
	{ id = 9971, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 2155, chance = 8200 },
	{ id = 5904, chance = 6500 },
	{ id = 2156, chance = 8000 },
	{ id = 26185, chance = 5000 },
	{ id = 26189, chance = 5000 },
	{ id = 26187, chance = 5000 },
	{ id = 2436, chance = 7000 },
	{ id = 2154, chance = 8500 },
	{ id = 35572, chance = 5500 },
	{ id = 35560, chance = 1600 },
	{ id = 35561, chance = 1100 },
	{ id = 34282, chance = 1700 },
	{ id = 34281, chance = 1900 },
	{ id = 34283, chance = 1800 },
	{ id = 35573, chance = 1200 },
	{ id = 35559, chance = 700 },
	{ id = 35711, chance = 400 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 2300,
		chance = 20,
		type = COMBAT_LIFEDRAIN,
		minDamage = -250,
		maxDamage = -350,
		range = 1,
		effect = CONST_ME_MAGIC_RED,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_MANADRAIN,
		minDamage = -1,
		maxDamage = -250,
		length = 7,
		spread = 0,
		effect = CONST_ME_SMALLCLOUDS,
		target = false,
	},
	{
		name = "combat",
		interval = 2500,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -1500,
		length = 7,
		spread = 0,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 350, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
