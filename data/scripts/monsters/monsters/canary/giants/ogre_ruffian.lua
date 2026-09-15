local mType = Game.createMonsterType("Ogre Ruffian")
local monster = {}

monster.description = "an ogre ruffian"
monster.experience = 5000
monster.outfit = {
	lookType = 1212,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1820
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

monster.health = 5500
monster.maxHealth = 5500
monster.race = "blood"
monster.corpse = 31527
monster.speed = 215
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
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 24844, chance = 17270 },
	{ id = 24845, chance = 15830 },
	{ id = 20108, chance = 2160 },
	{ id = 2666, chance = 8630, maxCount = 5 },
	{ id = 7387, chance = 5760 },
	{ id = 2391, chance = 2160 },
	{ id = 23540, chance = 1440 },
	{ id = 24847, chance = 1440 },
	{ id = 2197, chance = 4320 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -250,
		maxDamage = -450,
		radius = 5,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = -350,
		range = 4,
		radius = 5,
		shootEffect = CONST_ANI_LARGEROCK,
		effect = CONST_ME_POFF,
		target = true,
	},
}

monster.defenses = {
	defense = 102,
	armor = 102,
	mitigation = 2.72,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
