local mType = Game.createMonsterType("Tremendous Tyrant")
local monster = {}

monster.description = "a tremendous tyrant"
monster.experience = 6100
monster.outfit = {
	lookType = 1396,
	lookHead = 60,
	lookBody = 84,
	lookLegs = 40,
	lookFeet = 94,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2089
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Dwelling of the Forgotten",
}

monster.health = 11500
monster.maxHealth = 11500
monster.race = "blood"
monster.corpse = 36684
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 10,
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
	rewardBoss = false,
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
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 3,
	color = 106,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 70000, maxCount = 24 },
	{ id = 9971, chance = 11820, maxCount = 2 },
	{ id = 2156, chance = 14550, maxCount = 1 },
	{ id = 18414, chance = 6360, maxCount = 3 },
	{ id = 18415, chance = 5450 },
	{ id = 18413, chance = 5450 },
	{ id = 39221, chance = 4550 },
	{ id = 2154, chance = 9090, maxCount = 1 },
	{ id = 8901, chance = 8180 },
	{ id = 8920, chance = 910 },
	{ id = 2396, chance = 1820 },
	{ id = 2183, chance = 2730 },
	{ id = 2430, chance = 4550 },
	{ id = 7430, chance = 3640 },
	{ id = 39220, chance = 8180 },
	{ id = 2189, chance = 2730 },
	{ id = 15453, chance = 1820 },
	{ id = 2198, chance = 2730 },
	{ id = 8871, chance = 1820 },
	{ id = 7897, chance = 4555 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_ICEDAMAGE,
		minDamage = -600,
		maxDamage = -650,
		length = 5,
		spread = 0,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -600,
		maxDamage = -700,
		radius = 4,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -750,
		maxDamage = -950,
		range = 5,
		shootEffect = CONST_ANI_HOLY,
		effect = CONST_ME_HOLYAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 71,
	armor = 71,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
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
