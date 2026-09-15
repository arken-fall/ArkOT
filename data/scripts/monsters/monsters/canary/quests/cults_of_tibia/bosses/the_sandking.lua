local mType = Game.createMonsterType("The Sandking")
local monster = {}

monster.description = "The Sandking"
monster.experience = 0
monster.outfit = {
	lookType = 1013,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1444,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 50000
monster.maxHealth = 50000
monster.race = "venom"
monster.corpse = 25866
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "CRRRK!", yell = true },
}

monster.loot = {
	{ id = 2150, chance = 21000, maxCount = 10 },
	{ id = 2149, chance = 19000, maxCount = 10 },
	{ id = 2156, chance = 12000 },
	{ id = 2152, chance = 68299, maxCount = 30 },
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2145, chance = 21000, maxCount = 10 },
	{ id = 2155, chance = 12000 },
	{ id = 12410, chance = 35000 },
	{ id = 7590, chance = 31230, maxCount = 10 },
	{ id = 8473, chance = 28230, maxCount = 10 },
	{ id = 12630, chance = 400 },
	{ id = 25172, chance = 2500 },
	{ id = 25377, chance = 1532 },
	{ id = 9970, chance = 11520, maxCount = 10 },
	{ id = 2158, chance = 21892 },
	{ id = 2154, chance = 29460 },
	{ id = 5904, chance = 18920 },
	{ id = 7440, chance = 2000 },
	{ id = 22396, chance = 12000, maxCount = 2 },
	{ id = 2183, chance = 3470 },
	{ id = 2153, chance = 1000 },
	{ id = 2214, chance = 20000 },
	{ id = 2147, chance = 7360, maxCount = 10 },
	{ id = 7632, chance = 28540 },
	{ id = 2436, chance = 13790 },
	{ id = 15490, chance = 13790 },
	{ id = 5892, chance = 10000, maxCount = 2 },
	{ id = 7404, chance = 430 },
	{ id = 7417, chance = 6666 },
	{ id = 2451, chance = 200 },
	{ id = 18415, chance = 10000, maxCount = 3 },
	{ id = 18414, chance = 10000, maxCount = 3 },
	{ id = 18413, chance = 10000, maxCount = 3 },
	{ id = 8472, chance = 4800 },
	{ id = 18451, chance = 7030 },
	{ id = 2453, chance = 200 },
	{ id = 31413, chance = 400 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = 0,
		maxDamage = -500,
		range = 4,
		radius = 4,
		effect = CONST_ME_STONES,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 20, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = -650 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
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
