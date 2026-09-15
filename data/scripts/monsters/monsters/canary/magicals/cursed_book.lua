local mType = Game.createMonsterType("Cursed Book")
local monster = {}

monster.description = "a cursed book"
monster.experience = 13345
monster.outfit = {
	lookType = 1061,
	lookHead = 79,
	lookBody = 81,
	lookLegs = 93,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1655
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Secret Library (earth section).",
}

monster.health = 20000
monster.maxHealth = 20000
monster.race = "ink"
monster.corpse = 28590
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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
	{ id = 33440, chance = 10000, maxCount = 3 },
	{ id = 2152, chance = 10000, maxCount = 10 },
	{ id = 33437, chance = 10000, maxCount = 3 },
	{ id = 2145, chance = 10000, maxCount = 7 },
	{ id = 1294, chance = 10000, maxCount = 7 },
	{ id = 9970, chance = 10000, maxCount = 7 },
	{ id = 2200, chance = 10000 },
	{ id = 7886, chance = 350 },
	{ id = 7903, chance = 600 },
	{ id = 7387, chance = 600 },
	{ id = 7884, chance = 250 },
	{ id = 7885, chance = 250 },
	{ id = 7887, chance = 500 },
	{ id = 2197, chance = 350 },
	{ id = 8912, chance = 350 },
	{ id = 10219, chance = 350 },
	{ id = 8880, chance = 250 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -400,
		maxDamage = -680,
		range = 7,
		shootEffect = CONST_ANI_EARTHARROW,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -400,
		maxDamage = -575,
		length = 5,
		spread = 0,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 12,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -230,
		maxDamage = -880,
		range = 7,
		radius = 3,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
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
