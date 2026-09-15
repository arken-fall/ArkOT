local mType = Game.createMonsterType("Lord Azaram")
local monster = {}

monster.description = "Lord Azaram"
monster.experience = 55000
monster.outfit = {
	lookType = 1223,
	lookHead = 19,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 81,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"azaram_health",
	"azaram_summon",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1756,
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

monster.maxSummons = 5
monster.summons = {
	{ name = "Condensed Sins", chance = 50, interval = 2000, max = 5 },
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
	{ id = 7439, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 5888, minCount = 0, maxCount = 4, chance = 9000 },
	{ id = 2156, minCount = 0, maxCount = 2, chance = 12000 },
	{ id = 2158, minCount = 0, maxCount = 2, chance = 12000 },
	{ id = 25172, minCount = 0, maxCount = 2, chance = 9500 },
	{ id = 35570, chance = 5200 },
	{ id = 26198, chance = 5200 },
	{ id = 26200, chance = 5200 },
	{ id = 26199, chance = 5200 },
	{ id = 34283, chance = 7000 },
	{ id = 7407, chance = 9000 },
	{ id = 5892, chance = 4500 },
	{ id = 2476, chance = 15000 },
	{ id = 2153, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 2154, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 26187, chance = 5000 },
	{ id = 26189, chance = 5000 },
	{ id = 35572, chance = 5800 },
	{ id = 35560, chance = 1600 },
	{ id = 35575, chance = 1500 },
	{ id = 35559, chance = 720 },
	{ id = 35711, chance = 410 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{ name = "lord azaram wave", interval = 3500, chance = 50, minDamage = -360, maxDamage = -900 },
	{
		name = "combat",
		interval = 2700,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -500,
		maxDamage = -1200,
		length = 7,
		spread = 0,
		effect = CONST_ME_STONES,
		target = false,
	},
}

monster.defenses = {
	defense = 25,
	armor = 78,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
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
