local mType = Game.createMonsterType("Lamassu")
local monster = {}

monster.description = "a lamassu"
monster.experience = 9000
monster.outfit = {
	lookType = 1190,
	lookHead = 50,
	lookBody = 2,
	lookLegs = 0,
	lookFeet = 76,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1806
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Kilmaresh.",
}

monster.health = 8700
monster.maxHealth = 8700
monster.race = "blood"
monster.corpse = 31394
monster.speed = 160
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
	{ text = "Be gone, mortal! This is not your place!", yell = false },
	{ text = "I won't tolerate any sacrilege!", yell = false },
	{ text = "I guard this site in Suon's name!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000 },
	{ id = 35433, chance = 13400, maxCount = 5 },
	{ id = 18420, chance = 10500 },
	{ id = 7887, chance = 10000 },
	{ id = 35432, chance = 7700 },
	{ id = 18414, chance = 6800 },
	{ id = 18413, chance = 6500 },
	{ id = 2156, chance = 6200 },
	{ id = 7903, chance = 5900 },
	{ id = 10219, chance = 2300 },
	{ id = 2198, chance = 2000 },
	{ id = 2153, chance = 1700 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		radius = 1,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		radius = 3,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -405,
		range = 5,
		radius = 2,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_SMALLPLANTS,
		target = true,
	},
}

monster.defenses = {
	defense = 82,
	armor = 82,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -30 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
