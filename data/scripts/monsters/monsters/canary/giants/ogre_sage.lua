local mType = Game.createMonsterType("Ogre Sage")
local monster = {}

monster.description = "an ogre sage"
monster.experience = 5500
monster.outfit = {
	lookType = 1214,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1822
monster.bestiary = {
	race = "Giant",
	class = "Giant",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt, Kilmaresh Mountains underground.",
}

monster.health = 4800
monster.maxHealth = 4800
monster.race = "blood"
monster.corpse = 31535
monster.speed = 230
monster.manaCost = 0

monster.faction = FACTION_ANUMA
monster.enemyFactions = { FACTION_PLAYER, FACTION_FAFNAR }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 1
monster.summons = {
	{ name = "Young Goanna", chance = 10, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 24844, chance = 7950 },
	{ id = 24845, chance = 15830 },
	{ id = 24840, chance = 10230 },
	{ id = 12408, chance = 12500 },
	{ id = 24847, chance = 9090 },
	{ id = 7886, chance = 4550 },
	{ id = 20111, chance = 2270 },
	{ id = 10219, chance = 1140 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 24,
		type = COMBAT_LIFEDRAIN,
		minDamage = -50,
		maxDamage = -130,
		range = 7,
		shootEffect = CONST_ANI_SMALLSTONE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 16,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -100,
		maxDamage = -165,
		range = 4,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -115,
		maxDamage = -200,
		range = 7,
		radius = 3,
		shootEffect = CONST_ANI_DEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
}

monster.defenses = {
	defense = 93,
	armor = 93,
	mitigation = 2.51,
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 300 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
