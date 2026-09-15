local mType = Game.createMonsterType("Hulking Carnisylvan")
local monster = {}

monster.description = "a hulking carnisylvan"
monster.experience = 4700
monster.outfit = {
	lookType = 1418,
	lookHead = 21,
	lookBody = 3,
	lookLegs = 20,
	lookFeet = 57,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2107
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Forest of Life.",
}

monster.health = 8600
monster.maxHealth = 8600
monster.race = "blood"
monster.corpse = 36881
monster.speed = 110
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
	canPushCreatures = false,
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 30 },
	{ id = 2230, chance = 27670, maxCount = 1 },
	{ id = 7591, chance = 14990, maxCount = 4 },
	{ id = 39243, chance = 12100, maxCount = 1 },
	{ id = 39242, chance = 10090, maxCount = 2 },
	{ id = 7903, chance = 7200 },
	{ id = 7886, chance = 4900 },
	{ id = 2430, chance = 3460 },
	{ id = 7901, chance = 3460 },
	{ id = 7430, chance = 5190 },
	{ id = 7387, chance = 4320 },
	{ id = 2438, chance = 2590 },
	{ id = 2391, chance = 3750 },
	{ id = 39244, chance = 580 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 60,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -350,
		maxDamage = -450,
		range = 5,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -600,
		maxDamage = -800,
		radius = 4,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -350,
		maxDamage = -400,
		length = 4,
		spread = 0,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 51,
	armor = 51,
	mitigation = 1.32,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
