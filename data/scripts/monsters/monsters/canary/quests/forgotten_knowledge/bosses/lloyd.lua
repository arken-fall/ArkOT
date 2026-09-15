local mType = Game.createMonsterType("Lloyd")
local monster = {}

monster.description = "Lloyd"
monster.experience = 50000
monster.outfit = {
	lookType = 940,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"LloydPrepareDeath",
}

monster.bosstiary = {
	bossRaceId = 1329,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 64000
monster.maxHealth = 64000
monster.race = "venom"
monster.corpse = 24927
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
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
	runHealth = 1,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 1

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 329 },
	{ id = 2152, chance = 100000, maxCount = 35 },
	{ id = 2216, chance = 100000 },
	{ id = 8920, chance = 100000 },
	{ id = 7440, chance = 100000 },
	{ id = 18414, chance = 71790, maxCount = 5 },
	{ id = 18413, chance = 69230, maxCount = 5 },
	{ id = 8472, chance = 61540, maxCount = 10 },
	{ id = 8473, chance = 56410, maxCount = 10 },
	{ id = 18415, chance = 56410, maxCount = 5 },
	{ id = 7590, chance = 46150, maxCount = 10 },
	{ id = 12410, chance = 41030 },
	{ id = 26198, chance = 38460 },
	{ id = 25377, chance = 30770 },
	{ id = 7633, chance = 30770 },
	{ id = 9809, chance = 28210 },
	{ id = 2156, chance = 28210 },
	{ id = 2149, chance = 25640, maxCount = 10 },
	{ id = 2150, chance = 25640, maxCount = 12 },
	{ id = 25172, chance = 25640 },
	{ id = 9970, chance = 20510, maxCount = 10 },
	{ id = 2147, chance = 17950, maxCount = 18 },
	{ id = 8901, chance = 15380 },
	{ id = 2154, chance = 12820 },
	{ id = 2145, chance = 10260, maxCount = 10 },
	{ id = 5909, chance = 10260, maxCount = 3 },
	{ id = 5888, chance = 10260, maxCount = 3 },
	{ id = 2158, chance = 10260 },
	{ id = 2155, chance = 10260 },
	{ id = 7895, chance = 7690 },
	{ id = 2153, chance = 7690 },
	{ id = 11355, chance = 5130 },
	{ id = 2493, chance = 5130 },
	{ id = 2195, chance = 2560 },
	{ id = 31048, chance = 500, unique = true },
	{ id = 30500, chance = 256 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1400 },
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -330,
		maxDamage = -660,
		length = 6,
		spread = 0,
		effect = CONST_ME_PURPLEENERGY,
		target = false,
	},
	{ name = "lloyd wave", interval = 2000, chance = 12, minDamage = -430, maxDamage = -560, target = false },
	{ name = "lloyd wave2", interval = 2000, chance = 12, minDamage = -230, maxDamage = -460, target = false },
	{ name = "lloyd wave3", interval = 2000, chance = 12, minDamage = -430, maxDamage = -660, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	mitigation = 2.35,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
