local mType = Game.createMonsterType("Deathling Scout")
local monster = {}

monster.description = "a deathling scout"
monster.experience = 6300
monster.outfit = {
	lookType = 1073,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1667
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Deepling Ancestorial Grounds and Sunken Temple.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 28629
monster.speed = 155
monster.manaCost = 0

monster.faction = FACTION_DEATHLING
monster.enemyFactions = { FACTION_PLAYER, FACTION_DEEPLING }

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
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
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
	{ text = "VBOX°O", yell = false },
	{ text = 'O(J-"LJ-T =|-°', yell = false },
}

monster.loot = {
	{ id = 18304, chance = 25260, maxCount = 25 },
	{ id = 15649, chance = 21340, maxCount = 25 },
	{ id = 2149, chance = 20910, maxCount = 12 },
	{ id = 15425, chance = 20280 },
	{ id = 15426, chance = 15100 },
	{ id = 15488, chance = 14630 },
	{ id = 7759, chance = 13000, maxCount = 8 },
	{ id = 15452, chance = 11240 },
	{ id = 7590, chance = 10000 },
	{ id = 7591, chance = 10000 },
	{ id = 13838, chance = 6620 },
	{ id = 13870, chance = 6070 },
	{ id = 15453, chance = 3630 },
	{ id = 15451, chance = 3470 },
	{ id = 2168, chance = 3000 },
	{ id = 5895, chance = 920 },
	{ id = 15403, chance = 440 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 4000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = -400,
		range = 5,
		shootEffect = CONST_ANI_HUNTINGSPEAR,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -150,
		maxDamage = -300,
		range = 5,
		shootEffect = CONST_ANI_LARGEROCK,
		target = false,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -350,
		maxDamage = -550,
		radius = 3,
		effect = CONST_ME_POFF,
		target = false,
	},
}

monster.defenses = {
	defense = 72,
	armor = 72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
