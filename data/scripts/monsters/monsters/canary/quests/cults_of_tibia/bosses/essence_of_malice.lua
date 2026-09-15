local mType = Game.createMonsterType("Essence of Malice")
local monster = {}

monster.description = "Essence of Malice"
monster.experience = 150000
monster.outfit = {
	lookType = 351,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1487,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "undead"
monster.corpse = 10445
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 366,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
monster.runHealth = 366

monster.light = {
	level = 4,
	color = 119,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your demised will please me!", yell = false },
	{ text = "You will suffer!", yell = false },
}

monster.loot = {
	{ id = 25172, chance = 2732 },
	{ id = 25377, chance = 1530 },
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2152, chance = 29840, maxCount = 57 },
	{ id = 7895, chance = 8723 },
	{ id = 2154, chance = 29460 },
	{ id = 2520, chance = 2270 },
	{ id = 10221, chance = 15100 },
	{ id = 10570, chance = 9510 },
	{ id = 26165, chance = 100000 },
	{ id = 2150, chance = 14700, maxCount = 10 },
	{ id = 2150, chance = 12259, maxCount = 10 },
	{ id = 26166, chance = 100000 },
	{ id = 26191, chance = 16872, maxCount = 3 },
	{ id = 26185, chance = 8762 },
	{ id = 8473, chance = 27652, maxCount = 10 },
	{ id = 12649, chance = 3775 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -603 },
	{ name = "ghastly dragon curse", interval = 2000, chance = 5, range = 5, target = false },
	{
		name = "condition",
		type = CONDITION_POISON,
		interval = 2000,
		chance = 10,
		minDamage = -520,
		maxDamage = -780,
		range = 5,
		effect = CONST_ME_SMALLCLOUDS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -80,
		maxDamage = -230,
		range = 7,
		effect = CONST_ME_MAGIC_RED,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -120,
		maxDamage = -250,
		length = 8,
		spread = 0,
		effect = CONST_ME_LOSEENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -110,
		maxDamage = -180,
		radius = 4,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 20, range = 7, effect = CONST_ME_SMALLCLOUDS, target = true, duration = 30000, speed = -800 },
}

monster.defenses = {
	defense = 35,
	armor = 35,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -50 },
	{ type = COMBAT_FIREDAMAGE, percent = -50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -50 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
