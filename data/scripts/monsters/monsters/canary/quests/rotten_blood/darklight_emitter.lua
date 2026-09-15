local mType = Game.createMonsterType("Darklight Emitter")
local monster = {}

monster.description = "a darklight emitter"
monster.experience = 20600
monster.outfit = {
	lookType = 1627,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2382
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Darklight Core",
}

monster.health = 27500
monster.maxHealth = 27500
monster.race = "undead"
monster.corpse = 43583
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	targetDistance = 0,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 0
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.loot = {
	{ id = 2160, chance = 12516, maxCount = 2 },
	{ id = 44043, chance = 13367, maxCount = 1 },
	{ id = 11301, chance = 8574, maxCount = 1 },
	{ id = 9970, chance = 5784, maxCount = 3 },
	{ id = 7426, chance = 6240, maxCount = 1 },
	{ id = 2156, chance = 8459, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1050 },
	{
		name = "combat",
		interval = 2600,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -1400,
		maxDamage = -1750,
		length = 8,
		spread = 3,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{
		name = "combat",
		interval = 3100,
		chance = 20,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1000,
		maxDamage = -1600,
		length = 8,
		spread = 3,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2600,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -1200,
		maxDamage = -1650,
		radius = 5,
		effect = CONST_ME_HITBYFIRE,
		target = true,
	},
	{ name = "largefirering", interval = 2000, chance = 10, minDamage = -800, maxDamage = -1400, target = false },
}

monster.defenses = {
	defense = 120,
	armor = 120,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 25 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
