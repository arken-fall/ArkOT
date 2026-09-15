local mType = Game.createMonsterType("Branchy Crawler")
local monster = {}

monster.description = "a branchy crawler"
monster.experience = 17860
monster.outfit = {
	lookType = 1297,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1931
monster.bestiary = {
	race = "Plant",
	class = "Plant",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Rotten Wasteland.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 27000
monster.maxHealth = 27000
monster.race = "blood"
monster.corpse = 33809
monster.speed = 235
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	{ text = "Bones are just sticks. They break easily.", yell = false },
	{ text = "Decay!", yell = false },
	{ text = "I'll make you crawl, too!", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 55480 },
	{ id = 9971, chance = 9090 },
	{ id = 8473, chance = 8810, maxCount = 8 },
	{ id = 37270, chance = 6000 },
	{ id = 2158, chance = 1900 },
	{ id = 37314, chance = 1450 },
	{ id = 7885, chance = 970 },
	{ id = 2155, chance = 800 },
	{ id = 2444, chance = 760 },
	{ id = 2153, chance = 650 },
	{ id = 18453, chance = 630 },
	{ id = 7418, chance = 540 },
	{ id = 12613, chance = 420 },
	{ id = 18450, chance = 390 },
	{ id = 6553, chance = 330 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -950 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1100,
		maxDamage = -1300,
		range = 7,
		shootEffect = CONST_ANI_PIERCINGBOLT,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1000,
		maxDamage = -1280,
		radius = 4,
		effect = CONST_ME_SMALLPLANTS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1100,
		maxDamage = -1250,
		radius = 4,
		effect = CONST_ME_HOLYDAMAGE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1100,
		maxDamage = -1400,
		range = 7,
		shootEffect = CONST_ANI_SMALLHOLY,
		effect = CONST_ME_HOLYAREA,
		target = true,
	},
	{ name = "root", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = -9 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

-- Canary-only, not available in BlackTek:
-- mType.onThink = function(monster, interval)
-- 	monster:tryTeleportToPlayer("My growth is your death!")
-- end

mType:register(monster)
