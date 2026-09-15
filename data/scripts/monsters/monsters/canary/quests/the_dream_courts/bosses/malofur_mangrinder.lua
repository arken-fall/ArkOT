local mType = Game.createMonsterType("Malofur Mangrinder")
local monster = {}

monster.description = "Malofur Mangrinder"
monster.experience = 55000
monster.outfit = {
	lookType = 1120,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 30017
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
	bossRaceId = 1696,
	bossRace = RARITY_NEMESIS,
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
	{ text = "RAAAARGH! I'M MASHING YE TO DUST BOOM!", yell = true },
	{ text = "BOOOM!", yell = true },
	{ text = "BOOOOM!!!", yell = true },
	{ text = "BOOOOOM!!!", yell = true },
}

monster.loot = {
	{ id = 26200, chance = 22220 },
	{ id = 26185, chance = 13890 },
	{ id = 26187, chance = 8330 },
	{ id = 26198, chance = 8330 },
	{ id = 26199, chance = 16670 },
	{ id = 2156, chance = 47220 },
	{ id = 7439, chance = 20000 },
	{ id = 2158, chance = 20000 },
	{ id = 7443, chance = 20000 },
	{ id = 7427, chance = 8330 },
	{ id = 2160, chance = 25000, maxCount = 2 },
	{ id = 26191, chance = 88890 },
	{ id = 7633, chance = 8330 },
	{ id = 9971, chance = 22220 },
	{ id = 25377, chance = 60000, maxCount = 3 },
	{ id = 2155, chance = 11110 },
	{ id = 5892, chance = 40000 },
	{ id = 5904, chance = 5560 },
	{ id = 7440, chance = 22220 },
	{ id = 26165, chance = 88890 },
	{ id = 2114, chance = 97220 },
	{ id = 2152, chance = 100000, maxCount = 8 },
	{ id = 34371, chance = 16670 },
	{ id = 34149, chance = 2780 },
	{ id = 26189, chance = 5560 },
	{ id = 2123, chance = 2780 },
	{ id = 31758, chance = 52780 },
	{ id = 25172, chance = 91670, maxCount = 3 },
	{ id = 2436, chance = 8330 },
	{ id = 5809, chance = 8330 },
	{ id = 26031, chance = 80000, maxCount = 29 },
	{ id = 26029, chance = 55560, maxCount = 20 },
	{ id = 26030, chance = 80000, maxCount = 13 },
	{ id = 2153, chance = 8330 },
	{ id = 2154, chance = 44440, maxCount = 2 },
}

monster.attacks = {
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -400, maxDamage = -2500, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -400,
		maxDamage = -5500,
		effect = CONST_ME_GROUNDSHAKER,
		radius = 4,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
