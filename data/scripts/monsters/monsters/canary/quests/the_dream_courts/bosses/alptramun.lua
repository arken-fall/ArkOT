local mType = Game.createMonsterType("Alptramun")
local monster = {}

monster.description = "Alptramun"
monster.experience = 55000
monster.outfit = {
	lookType = 1143,
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
monster.corpse = 30155
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"facelessHealth",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1698, -- or 1715 need test
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
}

monster.loot = {
	{ id = 26185, chance = 7500 },
	{ id = 26187, chance = 8330 },
	{ id = 26189, chance = 7500 },
	{ id = 26198, chance = 10000 },
	{ id = 26198, chance = 20000 },
	{ id = 26199, chance = 15000 },
	{ id = 2156, chance = 27500, maxCount = 2 },
	{ id = 7414, chance = 2500 },
	{ id = 34167, chance = 7500 },
	{ id = 7439, chance = 12500 },
	{ id = 2158, chance = 20000, maxCount = 2 },
	{ id = 7443, chance = 12500 },
	{ id = 7427, chance = 10000 },
	{ id = 34277, chance = 7500 },
	{ id = 2160, chance = 20000 },
	{ id = 34153, chance = 10000 },
	{ id = 26191, chance = 92500 },
	{ id = 34281, chance = 2500 },
	{ id = 7633, chance = 7500 },
	{ id = 9971, chance = 20000 },
	{ id = 25377, chance = 75000, maxCount = 2 },
	{ id = 2155, chance = 20000, maxCount = 2 },
	{ id = 5892, chance = 37500 },
	{ id = 5904, chance = 7500 },
	{ id = 7440, chance = 60000, maxCount = 11 },
	{ id = 26165, chance = 92500 },
	{ id = 34154, chance = 5000 },
	{ id = 2114, chance = 92500 },
	{ id = 2152, chance = 100000, maxCount = 7 },
	{ id = 34371, chance = 22500 },
	{ id = 34373, chance = 2500 },
	{ id = 2123, chance = 5000 },
	{ id = 31758, chance = 60000, maxCount = 194 },
	{ id = 25172, chance = 100000, maxCount = 5 },
	{ id = 2436, chance = 32500 },
	{ id = 5809, chance = 5000 },
	{ id = 26031, chance = 60000, maxCount = 24 },
	{ id = 26029, chance = 52500, maxCount = 20 },
	{ id = 26030, chance = 80000, maxCount = 24 },
	{ id = 2153, chance = 17500 },
	{ id = 2154, chance = 32500, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -1000 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -700,
		maxDamage = -2000,
		range = 7,
		length = 6,
		spread = 0,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_HITBYPOISON,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -700,
		range = 3,
		length = 6,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -500,
		range = 3,
		length = 6,
		spread = 0,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{ name = "stone shower rune", interval = 2000, chance = 10, minDamage = -230, maxDamage = -450, range = 7, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
