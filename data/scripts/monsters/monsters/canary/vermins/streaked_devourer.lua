local mType = Game.createMonsterType("Streaked Devourer")
local monster = {}

monster.description = "a streaked devourer"
monster.experience = 6300
monster.outfit = {
	lookType = 1398,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2091
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Grotto of the Lost.",
}

monster.health = 7000
monster.maxHealth = 7000
monster.race = "blood"
monster.corpse = 36692
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
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
	{ id = 2152, chance = 70000, maxCount = 28 },
	{ id = 9971, chance = 16920, maxCount = 3 },
	{ id = 39210, chance = 13850, maxCount = 2 },
	{ id = 39209, chance = 9230, maxCount = 2 },
	{ id = 2156, chance = 4620, maxCount = 1 },
	{ id = 39211, chance = 1540 },
	{ id = 2154, chance = 1540 },
	{ id = 2445, chance = 1540 },
	{ id = 7386, chance = 1540 },
	{ id = 7456, chance = 1280 },
	{ id = 15644, chance = 1100 },
	{ id = 7383, chance = 1010 },
	{ id = 2427, chance = 3080 },
	{ id = 15451, chance = 1540 },
	{ id = 2393, chance = 830 },
	{ id = 2454, chance = 4620 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_FIREDAMAGE,
		minDamage = -800,
		maxDamage = -900,
		radius = 3,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -580,
		maxDamage = -620,
		range = 5,
		radius = 3,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREATTACK,
		target = true,
	},
	{ name = "devourer death wave", interval = 2000, chance = 40, minDamage = -730, maxDamage = -770 },
}

monster.defenses = {
	defense = 62,
	armor = 62,
	mitigation = 1.6,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -15 },
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
