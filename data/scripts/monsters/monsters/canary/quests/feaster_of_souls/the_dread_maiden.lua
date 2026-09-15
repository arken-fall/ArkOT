local mType = Game.createMonsterType("The Dread Maiden")
local monster = {}

monster.description = "The Dread Maiden"
monster.experience = 72000
monster.outfit = {
	lookType = 1278,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"FeasterOfSoulsBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1872,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 32744
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	{ text = "You will be mine for eternity!", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 100000, minCount = 1, maxCount = 2 },
	{ id = 36428, chance = 48000 },
	{ id = 36427, chance = 48000 },
	{ id = 26029, chance = 44000, minCount = 3, maxCount = 11 },
	{ id = 36429, chance = 40000, minCount = 1, maxCount = 2 },
	{ id = 26030, chance = 36000, minCount = 2, maxCount = 9 },
	{ id = 36430, chance = 20000 },
	{ id = 26031, chance = 20000, minCount = 4, maxCount = 9 },
	{ id = 7443, chance = 16000, minCount = 2, maxCount = 16 },
	{ id = 36431, chance = 16000 },
	{ id = 36320, chance = 12000 },
	{ id = 7439, chance = 12000, minCount = 6, maxCount = 15 },
	{ id = 7440, chance = 12000, minCount = 4, maxCount = 15 },
	{ id = 49220, chance = 12000, minCount = 4, maxCount = 15 },
	{ id = 36367, chance = 8000, minCount = 1, maxCount = 3 },
	{ id = 36284, chance = 4000 },
	{ id = 36432, chance = 4000 },
	{ id = 36290, chance = 4000 },
	{ id = 36316, chance = 4000 },
	{ id = 36289, chance = 4000 },
	{ id = 36286, chance = 4000 },
	{ id = 36313, chance = 730 },
	{ id = 36325, chance = 730 },
	{ id = 36324, chance = 730 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = -100,
		maxDamage = -600,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 4, maxDamage = 4 },
	},
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -350,
		maxDamage = -750,
		radius = 4,
		shootEffect = CONST_ANI_DEATH,
		effect = CONST_ME_SMALLCLOUDS,
		target = true,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 50,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -600,
		maxDamage = -1500,
		length = 7,
		effect = CONST_ME_POFF,
		target = false,
	},
	{ name = "dread rcircle", interval = 2000, chance = 40, minDamage = -400, maxDamage = -1000 },
}

monster.defenses = {
	defense = 170,
	armor = 170,
	{ name = "speed", interval = 10000, chance = 40, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000, speed = 510 },
	{ name = "combat", interval = 5000, chance = 60, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 2500, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
