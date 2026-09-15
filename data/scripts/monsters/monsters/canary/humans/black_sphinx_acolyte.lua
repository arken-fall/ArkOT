local mType = Game.createMonsterType("Black Sphinx Acolyte")
local monster = {}

monster.description = "a black sphinx acolyte"
monster.experience = 7200
monster.outfit = {
	lookType = 1200,
	lookHead = 95,
	lookBody = 95,
	lookLegs = 94,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1800
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Issavi Sewers, Kilmaresh Catacombs and Kilmaresh Mountains (above and under ground).",
}

monster.health = 8100
monster.maxHealth = 8100
monster.race = "blood"
monster.corpse = 31423
monster.speed = 155
monster.manaCost = 0

monster.faction = FACTION_FAFNAR
monster.enemyFactions = { FACTION_PLAYER, FACTION_ANUMA }

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
	canPushCreatures = false,
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

monster.maxSummons = 1
monster.summons = {
	{ name = "Skeleton Elite Warrior", chance = 10, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Darkness is the mother of all knowledge!", yell = false },
	{ text = "Get thee gone, unworthy!", yell = false },
	{ text = "The Black Sphinx will prevail!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 18413, chance = 5000 },
	{ id = 2182, chance = 4700 },
	{ id = 8910, chance = 3400 },
	{ id = 2153, chance = 2600 },
	{ id = 24850, chance = 2200, maxCount = 2 },
	{ id = 8922, chance = 2200 },
	{ id = 35327, chance = 3400 },
	{ id = 7761, chance = 1500, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -400,
		radius = 3,
		effect = CONST_ME_SMALLPLANTS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -400,
		maxDamage = -450,
		range = 4,
		radius = 3,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 82,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
