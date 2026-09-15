local mType = Game.createMonsterType("The Percht Queen")
local monster = {}

monster.description = "The Percht Queen"
monster.experience = 500
monster.outfit = {
	lookTypeEx = 34538,
}

monster.bosstiary = {
	bossRaceId = 1744,
	bossRace = RARITY_NEMESIS,
}

monster.health = 2300
monster.maxHealth = 2300
monster.race = "undead"
monster.corpse = 30272
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
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
}

monster.loot = {
	{ id = 2114, chance = 80000 },
	{ id = 31758, chance = 80000, maxCount = 100 },
	{ id = 2152, chance = 80000, maxCount = 5 },
	{ id = 26191, chance = 75000 },
	{ id = 26031, chance = 65000, maxCount = 20 },
	{ id = 5892, chance = 64000 },
	{ id = 26165, chance = 63000 },
	{ id = 26030, chance = 62000, maxCount = 20 },
	{ id = 26029, chance = 61000, maxCount = 20 },
	{ id = 7443, chance = 25500, maxCount = 10 },
	{ id = 7427, chance = 25000 },
	{ id = 34479, chance = 24500 },
	{ id = 7439, chance = 23000, maxCount = 10 },
	{ id = 2156, chance = 22500 },
	{ id = 5809, chance = 224000 },
	{ id = 34475, chance = 25000 },
	{ id = 34478, chance = 18000 },
	{ id = 34520, chance = 24980 },
	{ id = 9971, chance = 22480 },
	{ id = 2160, chance = 24890, maxCount = 2 },
	{ id = 7632, chance = 21580 },
	{ id = 2436, chance = 19850 },
	{ id = 5904, chance = 25480 },
	{ id = 34480, chance = 26800 },
	{ id = 34394, chance = 25842 },
	{ id = 34477, chance = 25840 },
	{ id = 25172, chance = 5480, maxCount = 5 },
	{ id = 34484, chance = 5808 },
	{ id = 2123, chance = 5100 },
	{ id = 26185, chance = 8486 },
	{ id = 34519, chance = 4848 },
	{ id = 34482, chance = 6485 },
	{ id = 34483, chance = 5485 },
	{ id = 26189, chance = 4858 },
	{ id = 26187, chance = 3485 },
	{ id = 2154, chance = 5485 },
	{ id = 2153, chance = 6485 },
	{ id = 26200, chance = 7848 },
	{ id = 26199, chance = 5485 },
	{ id = 2155, chance = 5485 },
	{ id = 2158, chance = 5845 },
	{ id = 34481, chance = 5485 },
	{ id = 26198, chance = 5158 },
	{ id = 34516, chance = 1250 },
	{ id = 34517, chance = 2510 },
	{ id = 7414, chance = 1480 },
	{ id = 34397, chance = 2548 },
	{ id = 34485, chance = 1254 },
	{ id = 34518, chance = 2540 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -200 },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -200,
		range = 7,
		shootEffect = CONST_ANI_ICE,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 79,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 90 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 80 },
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
