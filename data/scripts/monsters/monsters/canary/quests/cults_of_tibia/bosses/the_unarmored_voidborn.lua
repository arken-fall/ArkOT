local mType = Game.createMonsterType("The Unarmored Voidborn")
local monster = {}

monster.description = "The Unarmored Voidborn"
monster.experience = 15000
monster.outfit = {
	lookType = 987,
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
	bossRaceId = 1406,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 250000
monster.maxHealth = 250000
monster.race = "undead"
monster.corpse = 26133
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 50,
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
	canPushCreatures = false,
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
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
	{ id = 5904, chance = 8920, maxCount = 10 },
	{ id = 9971, chance = 21200, maxCount = 10 },
	{ id = 7633, chance = 26900 },
	{ id = 7403, chance = 8920 },
	{ id = 7414, chance = 7620 },
	{ id = 5741, chance = 9700 },
	{ id = 25172, chance = 2732 },
	{ id = 25377, chance = 1532 },
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2152, chance = 29840, maxCount = 25 },
	{ id = 2154, chance = 29460 },
	{ id = 2158, chance = 21892 },
	{ id = 24847, chance = 7270 },
	{ id = 7428, chance = 9510 },
	{ id = 26165, chance = 100000 },
	{ id = 2145, chance = 12760, maxCount = 10 },
	{ id = 2150, chance = 14700, maxCount = 10 },
	{ id = 9970, chance = 11520, maxCount = 10 },
	{ id = 2146, chance = 13790, maxCount = 10 },
	{ id = 2149, chance = 14700, maxCount = 10 },
	{ id = 2150, chance = 12259, maxCount = 10 },
	{ id = 26191, chance = 16872, maxCount = 3 },
	{ id = 8473, chance = 27652, maxCount = 10 },
	{ id = 7590, chance = 33721, maxCount = 10 },
	{ id = 8472, chance = 25690, maxCount = 5 },
	{ id = 26198, chance = 12798 },
	{ id = 5887, chance = 15890 },
	{ id = 7451, chance = 7890 },
	{ id = 26189, chance = 14542 },
	{ id = 7903, chance = 16892 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = 0,
		maxDamage = -400,
		length = 7,
		spread = 5,
		effect = CONST_ME_SMALLCLOUDS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -250,
		maxDamage = -440,
		radius = 5,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 50,
	armor = 50,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -300 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -255 },
	{ type = COMBAT_EARTHDAMAGE, percent = -255 },
	{ type = COMBAT_FIREDAMAGE, percent = -255 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -300 },
	{ type = COMBAT_HOLYDAMAGE, percent = -300 },
	{ type = COMBAT_DEATHDAMAGE, percent = -300 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
