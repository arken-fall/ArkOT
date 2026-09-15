local mType = Game.createMonsterType("Faun")
local monster = {}

monster.description = "a faun"
monster.experience = 800
monster.outfit = {
	lookType = 980,
	lookHead = 61,
	lookBody = 96,
	lookLegs = 95,
	lookFeet = 62,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1434
monster.bestiary = {
	race = "Fey",
	class = "Fey",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Feyrist (daytime).",
}

monster.health = 900
monster.maxHealth = 900
monster.race = "blood"
monster.corpse = 25815
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 20

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "In vino veritas! Hahaha!", yell = false },
	{ text = "Wine, women and song!", yell = false },
	{ text = "Are you posing a threat to this realm? I suppose so.", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 30000, maxCount = 136 },
	{ id = 2760, chance = 5155 },
	{ id = 31734, chance = 10000, maxCount = 7 },
	{ id = 2681, chance = 30100, maxCount = 2 },
	{ id = 7759, chance = 492, maxCount = 2 },
	{ id = 9928, chance = 492 },
	{ id = 31698, chance = 5800 },
	{ id = 31696, chance = 492 },
	{ id = 2074, chance = 172 },
	{ id = 2687, chance = 55000, maxCount = 5 },
	{ id = 7591, chance = 6400, maxCount = 2 },
	{ id = 31702, chance = 92 },
	{ id = 7588, chance = 6800, maxCount = 2 },
	{ id = 31695, chance = 3400, maxCount = 3 },
	{ id = 31736, chance = 1086, maxCount = 4 },
	{ id = 1294, chance = 492, maxCount = 3 },
	{ id = 2664, chance = 492 },
	{ id = 5792, chance = 80 },
	{ id = 5015, chance = 50 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -370 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -60,
		maxDamage = -115,
		range = 7,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{ name = "drunk", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 25000 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -100,
		range = 7,
		shootEffect = CONST_ANI_LEAFSTAR,
		target = false,
	},
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.1,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 75, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
