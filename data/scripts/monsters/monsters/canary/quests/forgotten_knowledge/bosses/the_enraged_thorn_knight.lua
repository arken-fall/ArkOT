local mType = Game.createMonsterType("The Enraged Thorn Knight")
local monster = {}

monster.description = "the enraged Thorn Knight"
monster.experience = 30000
monster.outfit = {
	lookType = 512,
	lookHead = 81,
	lookBody = 121,
	lookLegs = 121,
	lookFeet = 121,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ForgottenKnowledgeBossDeath",
	"HealthForgotten",
}

monster.bosstiary = {
	bossRaceId = 1297,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 90000
monster.maxHealth = 90000
monster.race = "blood"
monster.corpse = 111
monster.speed = 175
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	runHealth = 15,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 15

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You've killed my only friend!", yell = false },
	{ text = "You will pay for this!", yell = false },
	{ text = "NOOOOO!", yell = true },
}

monster.loot = {
	{ id = 2148, chance = 50320, maxCount = 165 },
	{ id = 2152, chance = 50320, maxCount = 30 },
	{ id = 18413, chance = 9660, maxCount = 5 },
	{ id = 18414, chance = 9660, maxCount = 5 },
	{ id = 18415, chance = 9660, maxCount = 5 },
	{ id = 2149, chance = 9660, maxCount = 5 },
	{ id = 2147, chance = 7360, maxCount = 5 },
	{ id = 9970, chance = 7350, maxCount = 5 },
	{ id = 2150, chance = 7150, maxCount = 5 },
	{ id = 5887, chance = 5909, maxCount = 2 },
	{ id = 7590, chance = 22120, maxCount = 3 },
	{ id = 8473, chance = 19500, maxCount = 3 },
	{ id = 8472, chance = 18250, maxCount = 3 },
	{ id = 2158, chance = 5000 },
	{ id = 2156, chance = 2200 },
	{ id = 2155, chance = 5000 },
	{ id = 2154, chance = 5000 },
	{ id = 6500, chance = 14460 },
	{ id = 7439, chance = 14460 },
	{ id = 7443, chance = 14460 },
	{ id = 7632, chance = 7000 },
	{ id = 2407, chance = 20000 },
	{ id = 7453, chance = 100 },
	{ id = 31055, chance = 100 },
	{ id = 5015, chance = 500 },
	{ id = 2536, chance = 1000 },
	{ id = 10219, chance = 500 },
	{ id = 5875, chance = 1000 },
	{ id = 5884, chance = 1000 },
	{ id = 8880, chance = 500 },
	{ id = 22537, chance = 1000 },
	{ id = 31043, chance = 500, unique = true },
	{ id = 25377, chance = 100000 },
	{ id = 25172, chance = 100000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -600, maxDamage = -1000 },
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_LIFEDRAIN,
		minDamage = -400,
		maxDamage = -700,
		length = 4,
		spread = 0,
		effect = CONST_ME_POFF,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_MANADRAIN,
		minDamage = -1400,
		maxDamage = -1700,
		length = 9,
		spread = 0,
		effect = CONST_ME_CARNIPHILA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -700,
		length = 9,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = -250,
		radius = 10,
		effect = CONST_ME_BLOCKHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 60,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 1550, maxDamage = 2550, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 1000, chance = 12, effect = CONST_ME_MAGIC_RED, target = false, duration = 4000, speed = 620 },
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
	{ type = COMBAT_DEATHDAMAGE, percent = -100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

monster.heals = {
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

mType:register(monster)
