local mType = Game.createMonsterType("Usurper Knight")
local monster = {}

monster.description = "an usurper knight"
monster.experience = 6900
monster.outfit = {
	lookType = 1316,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 76,
	lookFeet = 95,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1972
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Bounac, the Order of the Lion settlement.",
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "blood"
monster.corpse = 33977
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_PLAYER, FACTION_LION }

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
	{ text = "This town is ours now!", yell = false },
	{ text = "Do you really think you can stand?", yell = false },
	{ text = "You don't deserve Bounac!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 89725, maxCount = 5 },
	{ id = 2649, chance = 27060 },
	{ id = 2666, chance = 16582 },
	{ id = 37485, chance = 11190 },
	{ id = 2153, chance = 6002 },
	{ id = 9971, chance = 5799 },
	{ id = 37483, chance = 5697 },
	{ id = 2477, chance = 5290 },
	{ id = 7590, chance = 4680 },
	{ id = 2158, chance = 4171 },
	{ id = 2155, chance = 2238 },
	{ id = 7894, chance = 610 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 6000,
		chance = 14,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -150,
		maxDamage = -300,
		radius = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 6000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -150,
		maxDamage = -400,
		length = 4,
		spread = 0,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{ name = "singlecloudchain", interval = 8000, chance = 17, minDamage = -200, maxDamage = -450, range = 4, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 86,
	armor = 83,
	mitigation = 2.4,
	{ name = "combat", interval = 4000, chance = 40, type = COMBAT_HEALING, minDamage = 200, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
