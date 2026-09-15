local mType = Game.createMonsterType("Megasylvan Yselda")
local monster = {}

monster.description = "Megasylvan Yselda"
monster.experience = 19900
monster.outfit = {
	lookTypeEx = 39364,
}

monster.bosstiary = {
	bossRaceId = 2114,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 32000
monster.maxHealth = 32000
monster.race = "blood"
monster.corpse = 36929
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 1
monster.summons = {
	{ name = "Carnisylvan Sapling", chance = 70, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "What are you... doing!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, minCount = 1, maxCount = 9 },
	{ id = 8838, chance = 100000, minCount = 1, maxCount = 5 },
	{ id = 26031, chance = 57140, minCount = 1, maxCount = 33 },
	{ id = 26029, chance = 57140, minCount = 1, maxCount = 31 },
	{ id = 26030, chance = 30000, minCount = 1, maxCount = 11 },
	{ id = 7443, chance = 22860, minCount = 4, maxCount = 19 },
	{ id = 7439, chance = 21430, minCount = 1, maxCount = 16 },
	{ id = 2158, chance = 18570, count = 1 },
	{ id = 7440, chance = 17140, minCount = 4, maxCount = 19 },
	{ id = 49220, chance = 17140, minCount = 1, maxCount = 15 },
	{ id = 2155, chance = 17140, minCount = 1, maxCount = 2 },
	{ id = 2153, chance = 15710, minCount = 1, maxCount = 2 },
	{ id = 2156, chance = 14290, minCount = 1, maxCount = 2 },
	{ id = 34282, chance = 11430, count = 1 },
	{ id = 2154, chance = 10000, count = 1 },
	{ id = 2160, chance = 8570, count = 1 },
	{ id = 39246, chance = 4290 },
	{ id = 15515, chance = 4290 },
	{ id = 7887, chance = 2860 },
	{ id = 2181, chance = 2860 },
	{ id = 7903, chance = 2860 },
	{ id = 39248, chance = 1430 },
	{ id = 39245, chance = 1430 },
	{ id = 7885, chance = 1430 },
	{ id = 7884, chance = 1430 },
	{ id = 36317, chance = 1200, count = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{ name = "earth beamMY", interval = 2000, chance = 50, minDamage = -400, maxDamage = -900, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -800,
		range = 5,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -400,
		maxDamage = -800,
		radius = 5,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{ name = "mana leechMY", interval = 2000, chance = 50, minDamage = -100, maxDamage = -400, target = false },
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 85 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 90 },
	{ type = COMBAT_FIREDAMAGE, percent = 60 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 90 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 70 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
