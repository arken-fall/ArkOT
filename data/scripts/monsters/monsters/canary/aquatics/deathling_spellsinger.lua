local mType = Game.createMonsterType("Deathling Spellsinger")
local monster = {}

monster.description = "a deathling spellsinger"
monster.experience = 6400
monster.outfit = {
	lookType = 1088,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1677
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Ancient Ancestorial Grounds and Sunken Temple.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 28851
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
	staticAttackChance = 60,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 60
monster.runHealth = 20

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = 'BOQOL"°', yell = false },
	{ text = 'QOL" VBOXCL°', yell = false },
}

monster.loot = {
	{ id = 2152, chance = 86000, maxCount = 14 },
	{ id = 18304, chance = 26000, maxCount = 25 },
	{ id = 2149, chance = 14040, maxCount = 14 },
	{ id = 15488, chance = 12470 },
	{ id = 15426, chance = 12470 },
	{ id = 7591, chance = 9130 },
	{ id = 15452, chance = 8840 },
	{ id = 15425, chance = 8540 },
	{ id = 7590, chance = 8200 },
	{ id = 15649, chance = 6380, maxCount = 25 },
	{ id = 13870, chance = 4760 },
	{ id = 13838, chance = 4120 },
	{ id = 15453, chance = 3090 },
	{ id = 5895, chance = 2990 },
	{ id = 15451, chance = 2950 },
	{ id = 7759, chance = 2220, maxCount = 4 },
	{ id = 2168, chance = 2010 },
	{ id = 15403, chance = 200 },
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
		interval = 2000,
		chance = 14,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -400,
		maxDamage = -700,
		length = 8,
		spread = 0,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 72,
	armor = 72,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
