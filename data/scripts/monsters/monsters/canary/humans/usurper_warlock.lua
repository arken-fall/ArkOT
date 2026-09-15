local mType = Game.createMonsterType("Usurper Warlock")
local monster = {}

monster.description = "an usurper warlock"
monster.experience = 7000
monster.outfit = {
	lookType = 1316,
	lookHead = 57,
	lookBody = 2,
	lookLegs = 21,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1974
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

monster.health = 7500
monster.maxHealth = 7500
monster.race = "blood"
monster.corpse = 34184
monster.speed = 165
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "What, are you afraid? So you should be!", yell = false },
	{ text = "Die in the flames of true righteousness!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 77111, maxCount = 4 },
	{ id = 9971, chance = 11778 },
	{ id = 37485, chance = 8444 },
	{ id = 37483, chance = 8222 },
	{ id = 2144, chance = 5778 },
	{ id = 7632, chance = 5556 },
	{ id = 7903, chance = 4667 },
	{ id = 7901, chance = 3778 },
	{ id = 2155, chance = 3556 },
	{ id = 8912, chance = 2667 },
	{ id = 2671, chance = 2444 },
	{ id = 7900, chance = 1778 },
	{ id = 2189, chance = 1778 },
	{ id = 8910, chance = 1333 },
	{ id = 2477, chance = 1111 },
	{ id = 8920, chance = 667 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, effect = CONST_ME_DRAWBLOOD },
	{ name = "singledeathchain", interval = 6000, chance = 15, minDamage = -250, maxDamage = -530, range = 5, effect = CONST_ME_MORTAREA, target = true },
	{ name = "singleicechain", interval = 6000, chance = 18, minDamage = -150, maxDamage = -450, range = 5, effect = CONST_ME_ICEATTACK, target = true },
	{
		name = "combat",
		interval = 4000,
		chance = 12,
		type = COMBAT_ICEDAMAGE,
		minDamage = -200,
		maxDamage = -450,
		radius = 4,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
}

monster.defenses = {
	defense = 50,
	armor = 80,
	mitigation = 2.25,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 32 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
