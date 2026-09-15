local mType = Game.createMonsterType("The False God")
local monster = {}

monster.description = "The False God"
monster.experience = 50000
monster.outfit = {
	lookType = 984,
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
	bossRaceId = 1409,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 30,
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
	{ text = "CREEEAK!", yell = true },
}

monster.loot = {
	{ id = 7633, chance = 26900 },
	{ id = 5904, chance = 18920 },
	{ id = 23546, chance = 17620 },
	{ id = 25172, chance = 1732 },
	{ id = 25377, chance = 1532 },
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2152, chance = 29840, maxCount = 30 },
	{ id = 5888, chance = 12370, maxCount = 9 },
	{ id = 5911, chance = 16370, maxCount = 6 },
	{ id = 2154, chance = 29460 },
	{ id = 2158, chance = 21892 },
	{ id = 8910, chance = 117270 },
	{ id = 2454, chance = 127270 },
	{ id = 20108, chance = 9510 },
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
	{ id = 5887, chance = 15890 },
	{ id = 23547, chance = 7890 },
	{ id = 25418, chance = 1890 },
	{ id = 15414, chance = 7890 },
	{ id = 8868, chance = 1890 },
	{ id = 5880, chance = 14542 },
	{ id = 2393, chance = 16892 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = 0,
		maxDamage = -500,
		range = 4,
		radius = 4,
		effect = CONST_ME_STONES,
		target = true,
	},
	{ name = "speed", interval = 2000, chance = 20, radius = 5, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = -650 },
}

monster.defenses = {
	defense = 30,
	armor = 30,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
