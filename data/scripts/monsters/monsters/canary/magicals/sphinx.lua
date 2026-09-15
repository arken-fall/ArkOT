local mType = Game.createMonsterType("Sphinx")
local monster = {}

monster.description = "a sphinx"
monster.experience = 7500
monster.outfit = {
	lookType = 1188,
	lookHead = 0,
	lookBody = 39,
	lookLegs = 0,
	lookFeet = 3,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1808
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Nykri Delta, Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Kilmaresh Catacombs.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 31386
monster.speed = 145
monster.manaCost = 0

monster.faction = FACTION_ANUMA
monster.enemyFactions = { FACTION_PLAYER, FACTION_FAFNAR }

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
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 10

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 35428, chance = 9300 },
	{ id = 7890, chance = 7000 },
	{ id = 35429, chance = 5500 },
	{ id = 7891, chance = 3600 },
	{ id = 7889, chance = 3500 },
	{ id = 7901, chance = 3100 },
	{ id = 8920, chance = 2900 },
	{ id = 18390, chance = 1800 },
	{ id = 7900, chance = 1400 },
	{ id = 7894, chance = 1300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -500,
		length = 6,
		spread = 0,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -100,
		maxDamage = -350,
		range = 5,
		radius = 3,
		shootEffect = CONST_ANI_SMALLHOLY,
		effect = CONST_ME_HOLYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -400,
		radius = 3,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 82,
	armor = 82,
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
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
