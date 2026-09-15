local mType = Game.createMonsterType("Duke Krule")
local monster = {}

monster.description = "Duke Krule"
monster.experience = 55000
monster.outfit = {
	lookType = 1221,
	lookHead = 8,
	lookBody = 8,
	lookLegs = 19,
	lookFeet = 79,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
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
	bossRaceId = 1758,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.maxSummons = 4
monster.summons = {
	{ name = "Soul Scourge", chance = 20, interval = 2000, max = 4 },
}

monster.loot = {
	{ id = 2152, minCount = 1, maxCount = 5, chance = 100000 },
	{ id = 2160, minCount = 0, maxCount = 2, chance = 50000 },
	{ id = 26031, minCount = 0, maxCount = 6, chance = 35000 },
	{ id = 26029, minCount = 0, maxCount = 20, chance = 32000 },
	{ id = 26030, minCount = 0, maxCount = 20, chance = 32000 },
	{ id = 7443, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 7440, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 7439, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 5889, minCount = 0, maxCount = 3, chance = 9000 },
	{ id = 2155, minCount = 0, maxCount = 2, chance = 12000 },
	{ id = 25172, minCount = 0, maxCount = 2, chance = 9500 },
	{ id = 2158, chance = 11000 },
	{ id = 2497, chance = 6400 },
	{ id = 9971, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 2156, chance = 11000 },
	{ id = 7903, chance = 7800 },
	{ id = 2154, chance = 9500 },
	{ id = 35572, chance = 5800 },
	{ id = 35560, chance = 1800 },
	{ id = 35577, chance = 1100 },
	{ id = 35571, chance = 1700 },
	{ id = 35559, chance = 700 },
	{ id = 35711, chance = 460 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		interval = 3500,
		chance = 37,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -700,
		maxDamage = -1200,
		length = 7,
		spread = 0,
		effect = CONST_ME_BLOCKHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2500,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -400,
		maxDamage = -1000,
		length = 7,
		spread = 0,
		effect = CONST_ME_BLOCKHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 4200,
		chance = 40,
		type = COMBAT_FIREDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		radius = 9,
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
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
