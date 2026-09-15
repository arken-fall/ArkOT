local mType = Game.createMonsterType("Mercurial Menace")
local monster = {}

monster.description = "a mercurial menace"
monster.experience = 12095
monster.outfit = {
	lookType = 1561,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2279
monster.bestiary = {
	race = "Reptile",
	class = "Reptile",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Crystal Enigma",
}

monster.health = 18500
monster.maxHealth = 18500
monster.race = "blood"
monster.corpse = 39335
monster.speed = 190
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 3,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 3
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Shwooo...", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 24890, minCount = 1, maxCount = 2 },
	{ id = 41483, chance = 21500 },
	{ id = 7886, chance = 4250 },
	{ id = 2134, chance = 2700 },
	{ id = 2181, chance = 1660 },
	{ id = 18390, chance = 1230 },
	{ id = 31703, chance = 1090 },
	{ id = 30498, chance = 1030 },
	{ id = 7893, chance = 1000 },
	{ id = 2189, chance = 860 },
	{ id = 30499, chance = 830 },
	{ id = 31701, chance = 800 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		interval = 2000,
		chance = 75,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -750,
		range = 4,
		shootEffect = CONST_ANI_SMALLSTONE,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 40,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -800,
		maxDamage = -1500,
		range = 3,
		effect = CONST_ME_BLUE_ENERGY_SPARK,
		target = true,
	},
	{ name = "mercurial menace ring", interval = 4500, chance = 37, minDamage = -500, maxDamage = -700 },
}

monster.defenses = {
	defense = 110,
	armor = 91,
	mitigation = 2.54,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
