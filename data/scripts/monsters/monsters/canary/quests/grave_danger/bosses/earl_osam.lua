local mType = Game.createMonsterType("Earl Osam")
local monster = {}

monster.description = "Earl Osam"
monster.experience = 55000
monster.outfit = {
	lookType = 1223,
	lookHead = 113,
	lookBody = 0,
	lookLegs = 79,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"earl_osam_transform",
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
	bossRaceId = 1757,
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
	{ name = "Frozen Soul", chance = 50, interval = 2000, max = 4 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I ... will ... get ... you ... all!", yell = false },
	{ text = "I ... will ... rise ... again!", yell = false },
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
	{ id = 47306, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 5889, minCount = 0, maxCount = 3, chance = 9000 },
	{ id = 2156, minCount = 0, maxCount = 2, chance = 12000 },
	{ id = 25172, minCount = 0, maxCount = 2, chance = 9500 },
	{ id = 26198, chance = 5200 },
	{ id = 26200, chance = 5200 },
	{ id = 26185, chance = 5000 },
	{ id = 26189, chance = 5000 },
	{ id = 2475, chance = 11000 },
	{ id = 15454, chance = 6400 },
	{ id = 9971, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 35572, chance = 5800 },
	{ id = 35561, chance = 1600 },
	{ id = 35576, chance = 1200 },
	{ id = 35571, chance = 1700 },
	{ id = 35559, chance = 730 },
	{ id = 35711, chance = 440 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -400,
		maxDamage = -1000,
		length = 7,
		spread = 0,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{ name = "ice chain", interval = 2500, chance = 25, minDamage = -260, maxDamage = -360, range = 3, target = true },
	{
		name = "combat",
		interval = 3500,
		chance = 37,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -400,
		maxDamage = -1000,
		length = 7,
		spread = 2,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
