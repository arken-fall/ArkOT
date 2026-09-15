local mType = Game.createMonsterType("Naga Archer")
local monster = {}

monster.description = "a naga archer"
monster.experience = 5150
monster.outfit = {
	lookType = 1537,
	lookHead = 55,
	lookBody = 6,
	lookLegs = 0,
	lookFeet = 78,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2260
monster.bestiary = {
	race = "Amphibic",
	class = "Reptile",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Temple of the Moon Goddess.",
}

monster.health = 4640
monster.maxHealth = 4640
monster.race = "blood"
monster.corpse = 39225
monster.speed = 182
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
	{ text = "Intruder! Don't violate this sanctuary!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 17 },
	{ id = 41501, chance = 15050, maxCount = 3 },
	{ id = 41500, chance = 12850, maxCount = 3 },
	{ id = 41499, chance = 5960, maxCount = 3 },
	{ id = 2124, chance = 5330 },
	{ id = 3965, chance = 3760 },
	{ id = 2455, chance = 3130 },
	{ id = 18413, chance = 1880 },
	{ id = 2456, chance = 1570 },
	{ id = 7438, chance = 750 },
	{ id = 15644, chance = 630 },
	{ id = 18453, chance = 420 },
	{ id = 7441, chance = 630 },
	{ id = 2127, chance = 930 },
	{ id = 2134, chance = 310 },
}

monster.attacks = {
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -95,
		maxDamage = -390,
		shootEffect = CONST_ANI_EXPLOSION,
		effect = CONST_ME_PURPLEENERGY,
		range = 6,
		target = true,
	},
	{ name = "nagadeathattack", interval = 2500, chance = 20, minDamage = -430, maxDamage = -505, range = 6, target = true },
	{ name = "nagadeath", interval = 3000, chance = 20, minDamage = -380, maxDamage = -470, target = false },
	{ name = "death chain", interval = 3500, chance = 20, minDamage = -460, maxDamage = -520, range = 6, target = true },
	{
		name = "combat",
		interval = 4000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -85,
		maxDamage = -190,
		shootEffect = CONST_ANI_EXPLOSION,
		effect = CONST_ME_PURPLEENERGY,
		range = 6,
		target = true,
	},
}

monster.defenses = {
	defense = 110,
	armor = 63,
	mitigation = 1.74,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
