local mType = Game.createMonsterType("Eyeless Devourer")
local monster = {}

monster.description = "an eyeless devourer"
monster.experience = 6000
monster.outfit = {
	lookType = 1399,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2092
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Antrum of the Fallen.",
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 36696
monster.speed = 165
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
	{ id = 2152, chance = 70000, maxCount = 22 },
	{ id = 8473, chance = 29210, maxCount = 3 },
	{ id = 39212, chance = 14680, maxCount = 1 },
	{ id = 18413, chance = 6700, maxCount = 3 },
	{ id = 18415, chance = 6380, maxCount = 3 },
	{ id = 18414, chance = 6230, maxCount = 3 },
	{ id = 39213, chance = 7500, maxCount = 2 },
	{ id = 2155, chance = 6300 },
	{ id = 39214, chance = 3590 },
	{ id = 10219, chance = 3190 },
	{ id = 2445, chance = 1840 },
	{ id = 7888, chance = 2790 },
	{ id = 7456, chance = 1840 },
	{ id = 15451, chance = 1440 },
	{ id = 7383, chance = 880 },
	{ id = 2393, chance = 880 },
	{ id = 7386, chance = 640 },
	{ id = 2454, chance = 1360, maxCount = 1 },
	{ id = 23547, chance = 640 },
	{ id = 15644, chance = 1040 },
	{ id = 7422, chance = 1200 },
	{ id = 7451, chance = 400 },
	{ id = 23542, chance = 320 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 2750,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -700,
		maxDamage = -800,
		range = 5,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 60,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -500,
		maxDamage = -700,
		radius = 3,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -500,
		maxDamage = -560,
		length = 5,
		spread = 0,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
}

monster.defenses = {
	defense = 63,
	armor = 63,
	mitigation = 1.82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
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
