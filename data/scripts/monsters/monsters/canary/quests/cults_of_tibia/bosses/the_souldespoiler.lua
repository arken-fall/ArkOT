local mType = Game.createMonsterType("The Souldespoiler")
local monster = {}

monster.description = "The Souldespoiler"
monster.experience = 50000
monster.outfit = {
	lookType = 875,
	lookHead = 0,
	lookBody = 3,
	lookLegs = 77,
	lookFeet = 81,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1422,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 290000
monster.maxHealth = 290000
monster.race = "blood"
monster.corpse = 23564
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 6000,
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
	canPushCreatures = true,
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

monster.maxSummons = 5
monster.summons = {
	{ name = "Freed Soul", chance = 5, interval = 5000, max = 5 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Stop freeing the souls! They are mine alone!", yell = false },
	{ text = "The souls shall not escape me! ", yell = false },
	{ text = " You will be mine!", yell = false },
}

monster.loot = {
	{ id = 26167, chance = 8920, maxCount = 10 },
	{ id = 26172, chance = 20000 },
	{ id = 7633, chance = 26900 },
	{ id = 18390, chance = 8920 },
	{ id = 25383, chance = 13200 },
	{ id = 25523, chance = 7620 },
	{ id = 7407, chance = 9700 },
	{ id = 25172, chance = 2320 },
	{ id = 25377, chance = 1532 },
	{ id = 7437, chance = 14000 },
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2152, chance = 29840, maxCount = 35 },
	{ id = 18390, chance = 8723 },
	{ id = 2154, chance = 29460 },
	{ id = 2158, chance = 21892 },
	{ id = 2536, chance = 7270 },
	{ id = 8910, chance = 9510 },
	{ id = 26165, chance = 100000 },
	{ id = 31051, chance = 13390, maxCount = 10 },
	{ id = 2145, chance = 12760, maxCount = 10 },
	{ id = 2150, chance = 14700, maxCount = 10 },
	{ id = 9970, chance = 11520, maxCount = 10 },
	{ id = 2146, chance = 13790, maxCount = 10 },
	{ id = 2149, chance = 14700, maxCount = 10 },
	{ id = 2150, chance = 12259, maxCount = 10 },
	{ id = 26166, chance = 100000 },
	{ id = 26191, chance = 16872, maxCount = 3 },
	{ id = 8473, chance = 27652, maxCount = 10 },
	{ id = 7590, chance = 33721, maxCount = 10 },
	{ id = 8472, chance = 25690, maxCount = 10 },
	{ id = 12649, chance = 3775 },
	{ id = 7891, chance = 15890 },
	{ id = 26174, chance = 80000 },
	{ id = 8903, chance = 7890 },
	{ id = 12644, chance = 150 },
	{ id = 26162, chance = 100000 },
	{ id = 7452, chance = 16892, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -783 },
	{
		name = "combat",
		interval = 2000,
		chance = 60,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -30,
		maxDamage = -181,
		range = 7,
		radius = 3,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_SMALLCLOUDS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -210,
		maxDamage = -538,
		length = 7,
		spread = 2,
		effect = CONST_ME_PURPLEENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 30,
		type = COMBAT_DROWNDAMAGE,
		minDamage = -125,
		maxDamage = -640,
		length = 9,
		spread = 0,
		effect = CONST_ME_LOSEENERGY,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 40,
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_HEALING, minDamage = 1000, maxDamage = 7000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
