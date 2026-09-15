local mType = Game.createMonsterType("Feral Sphinx")
local monster = {}

monster.description = "a feral sphinx"
monster.experience = 8800
monster.outfit = {
	lookType = 1188,
	lookHead = 76,
	lookBody = 75,
	lookLegs = 57,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1807
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Kilmaresh, south of Issavi.",
}

monster.health = 9800
monster.maxHealth = 9800
monster.race = "blood"
monster.corpse = 31658
monster.speed = 160
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
	{ text = "I am not as kind as my sisters!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 18415, chance = 8740 },
	{ id = 18419, chance = 8620 },
	{ id = 2156, chance = 8390 },
	{ id = 7890, chance = 6060 },
	{ id = 2187, chance = 5710 },
	{ id = 2146, chance = 5590, maxCount = 2 },
	{ id = 2201, chance = 5590 },
	{ id = 2158, chance = 5480 },
	{ id = 35428, chance = 5480 },
	{ id = 35429, chance = 5240 },
	{ id = 2432, chance = 4200 },
	{ id = 8921, chance = 2910 },
	{ id = 2155, chance = 2680 },
	{ id = 7900, chance = 1400 },
	{ id = 7891, chance = 1280 },
	{ id = 7761, chance = 1050, maxCount = 2 },
	{ id = 7894, chance = 930 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "fire wave", interval = 2000, chance = 15, minDamage = -350, maxDamage = -500, length = 1, spread = 0, effect = CONST_ME_FIREAREA, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		radius = 4,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -350,
		maxDamage = -550,
		range = 1,
		shootEffect = CONST_ANI_FIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -400,
		maxDamage = -580,
		length = 6,
		spread = 3,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 90,
	armor = 90,
	mitigation = 2.69,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 425, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
