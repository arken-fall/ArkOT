local mType = Game.createMonsterType("White Lion")
local monster = {}

monster.description = "a white lion"
monster.experience = 2300
monster.outfit = {
	lookType = 1290,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1967
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Lion Sanctum.",
}

monster.health = 2700
monster.maxHealth = 2700
monster.race = "blood"
monster.corpse = 34245
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 15,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 5

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 8472, chance = 5000, maxCount = 2 },
	{ id = 10608, chance = 5000 },
	{ id = 18415, chance = 5000, maxCount = 2 },
	{ id = 18419, chance = 1500 },
	{ id = 18421, chance = 1500 },
	{ id = 7886, chance = 5000 },
	{ id = 2386, chance = 5000 },
	{ id = 2643, chance = 5000 },
	{ id = 11309, chance = 5000 },
	{ id = 2391, chance = 1500 },
	{ id = 2404, chance = 1500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 0, minDamage = 0, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 0,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -300,
		maxDamage = -400,
		range = 1,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 0,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -250,
		maxDamage = -350,
		range = 1,
		radius = 2,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 100,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -250,
		maxDamage = -350,
		range = 1,
		radius = 2,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 38,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
