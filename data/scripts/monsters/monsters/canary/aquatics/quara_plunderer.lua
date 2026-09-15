local mType = Game.createMonsterType("Quara Plunderer")
local monster = {}

monster.description = "a quara plunderer"
monster.experience = 10800
monster.outfit = {
	lookType = 1758,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2542
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Podzilla Bottom, Podzilla Underwater",
}

monster.health = 13500
monster.maxHealth = 13500
monster.race = "undead"
monster.corpse = 48389
monster.speed = 205
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	{ text = "Tssssh!!!", yell = false },
	{ text = "BLUP! BLUP!", yell = false },
	{ text = "Burp!", yell = false },
}

monster.loot = {
	{ id = 46912, chance = 7040 },
	{ id = 46913, chance = 6460 },
	{ id = 2156, chance = 4940 },
	{ id = 2158, chance = 4900 },
	{ id = 7407, chance = 350 },
	{ id = 2152, chance = 10000, maxCount = 25 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_PHYSICALDAMAGE, minDamage = -350, maxDamage = -500 },
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_ICEDAMAGE,
		minDamage = -800,
		maxDamage = -1100,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEAREA,
		target = false,
	},
	{ name = "quaracrossdeath", interval = 2000, chance = 20, minDamage = -1100, maxDamage = -1700, target = false },
	{ name = "quarasmokedeath", interval = 2000, chance = 20, minDamage = -850, maxDamage = -1150, target = false },
}

monster.defenses = {
	defense = 95,
	armor = 90,
	mitigation = 2.75,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
