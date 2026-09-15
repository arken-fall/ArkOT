local mType = Game.createMonsterType("Rootthing Nutshell")
local monster = {}

monster.description = "a rootthing nutshell"
monster.experience = 9200
monster.outfit = {
	lookType = 1760,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2540
monster.bestiary = {
	race = "Plant",
	class = "Plant",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Podzilla Stalk",
}

monster.health = 13500
monster.maxHealth = 13500
monster.race = "venom"
monster.corpse = 48397
monster.speed = 190
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
	canPushCreatures = false,
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
	{ text = "<CREEAK>", yell = true },
	{ text = "<KNARRR>", yell = true },
	{ text = "<KNOORRR>", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 88000, maxCount = 41 },
	{ id = 46914, chance = 7160 },
	{ id = 46915, chance = 3940 },
	{ id = 2149, chance = 3030 },
	{ id = 2438, chance = 830 },
	{ id = 2155, chance = 730 },
	{ id = 8880, chance = 550 },
	{ id = 6553, chance = 90 },
	{ id = 35559, chance = 30 },
	{ id = 45681, chance = 110 },
	{ id = 45682, chance = 110 },
	{ id = 45686, chance = 110 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -670 },
	{ name = "rotthligulus", interval = 2000, chance = 20, minDamage = -750, maxDamage = -1100 },
	{ name = "rotthingwave", interval = 2000, chance = 20 },
	{
		name = "combat",
		interval = 2000,
		chance = 17,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -400,
		maxDamage = -700,
		range = 6,
		effect = CONST_ME_BITE,
		target = true,
	},
}

monster.defenses = {
	defense = 85,
	armor = 85,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
