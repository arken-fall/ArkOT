local mType = Game.createMonsterType("Arctic Faun")
local monster = {}

monster.description = "an arctic faun"
monster.experience = 300
monster.outfit = {
	lookType = 980,
	lookHead = 85,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1626
monster.bestiary = {
	race = "Fey",
	class = "Fey",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 1,
	locations = "Arctic Faun's Island.",
}

monster.health = 300
monster.maxHealth = 300
monster.race = "blood"
monster.corpse = 28811
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	isPreyExclusive = true,
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
	{ text = "Dance with me!", yell = false },
	{ text = "In vino veritas! Hahaha!", yell = false },
	{ text = "Wine, women and song!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 105 },
	{ id = 31698, chance = 14870 },
	{ id = 7588, chance = 11760 },
	{ id = 31695, chance = 10290 },
	{ id = 31696, chance = 9330 },
	{ id = 31734, chance = 8720, maxCount = 3 },
	{ id = 2760, chance = 7280 },
	{ id = 2687, chance = 6150, maxCount = 5 },
	{ id = 2681, chance = 5400 },
	{ id = 31736, chance = 5260, maxCount = 2 },
	{ id = 1294, chance = 5260, maxCount = 2 },
	{ id = 2074, chance = 4510 },
	{ id = 7591, chance = 3590 },
	{ id = 2664, chance = 820 },
	{ id = 9928, chance = 340 },
	{ id = 31702, chance = 210 },
	{ id = 5792, chance = 140 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -180,
		range = 7,
		shootEffect = CONST_ANI_SNOWBALL,
		effect = CONST_ME_POFF,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 12,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = 0,
		maxDamage = -175,
		length = 3,
		spread = 0,
		effect = CONST_ME_POFF,
		target = false,
	},
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 0.83,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 80 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
