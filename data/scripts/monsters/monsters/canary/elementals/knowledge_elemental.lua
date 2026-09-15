local mType = Game.createMonsterType("Knowledge Elemental")
local monster = {}

monster.description = "a knowledge elemental"
monster.experience = 10603
monster.outfit = {
	lookType = 1065,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1670
monster.bestiary = {
	race = "Elemental",
	class = "Elemental",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Secret Library energy section.",
}

monster.health = 10500
monster.maxHealth = 10500
monster.race = "undead"
monster.corpse = 28605
monster.speed = 230
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
	level = 4,
	color = 71,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Did you know... there are over 200 bones in your body to break?", yell = false },
	{ text = "Did you know... a lot of so-called trivia facts aren't even remotely true?", yell = false },
	{ text = "Did you know... fear can be smelled?", yell = false },
	{ text = "Did you know... you could die in 1.299.223 ways within the next ten seconds?", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 9 },
	{ id = 33440, chance = 10000, maxCount = 6 },
	{ id = 2150, chance = 10000, maxCount = 8 },
	{ id = 33441, chance = 10000, maxCount = 3 },
	{ id = 33438, chance = 10000, maxCount = 3 },
	{ id = 33437, chance = 10000, maxCount = 3 },
	{ id = 7838, chance = 10000, maxCount = 6 },
	{ id = 2399, chance = 10000, maxCount = 10 },
	{ id = 7449, chance = 10000 },
	{ id = 2167, chance = 10000 },
	{ id = 2515, chance = 10000 },
	{ id = 7620, chance = 10000, maxCount = 10 },
	{ id = 26029, chance = 10000, maxCount = 8 },
	{ id = 8473, chance = 10000, maxCount = 8 },
	{ id = 2189, chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -200,
		maxDamage = -680,
		radius = 3,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 14,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -680,
		range = 7,
		shootEffect = CONST_ANI_ENERGY,
		target = false,
	},
}

monster.defenses = {
	defense = 33,
	armor = 76,
	mitigation = 2.08,
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 100,
		maxDamage = 300,
		radius = 3,
		effect = CONST_ME_BLOCKHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 200,
		chance = 55,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 100,
		maxDamage = 300,
		radius = 3,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
