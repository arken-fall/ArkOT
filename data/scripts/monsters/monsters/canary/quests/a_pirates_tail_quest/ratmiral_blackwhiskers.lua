local mType = Game.createMonsterType("Ratmiral Blackwhiskers")
local monster = {}

monster.description = "Ratmiral Blackwhiskers"
monster.experience = 50000
monster.outfit = {
	lookType = 1377,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 220000
monster.maxHealth = 220000
monster.race = "blood"
monster.corpse = 35846
monster.speed = 115
monster.manaCost = 0

monster.events = {
	"RatmiralBlackwhiskersDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2006,
	bossRace = RARITY_ARCHFOE,
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
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 4
monster.summons = {
	{ name = "elite pirat", chance = 30, interval = 1000 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2160, chance = 100000, minCount = 1, maxCount = 3 },
	{ id = 2152, chance = 55000, minCount = 1, maxCount = 39 },
	{ id = 8472, chance = 40000, minCount = 1, maxCount = 19 },
	{ id = 8473, chance = 40000, minCount = 1, maxCount = 19 },
	{ id = 7591, chance = 30000, minCount = 1, maxCount = 19 },
	{ id = 7590, chance = 30000, minCount = 1, maxCount = 19 },
	{ id = 26029, chance = 25000, minCount = 1, maxCount = 19 },
	{ id = 7440, chance = 22000, minCount = 1, maxCount = 9 },
	{ id = 49220, chance = 22000, minCount = 1, maxCount = 9 },
	{ id = 7443, chance = 20000, minCount = 1, maxCount = 9 },
	{ id = 38469, chance = 17000, minCount = 3, maxCount = 102 },
	{ id = 7439, chance = 16000, minCount = 1, maxCount = 9 },
	{ id = 38508, chance = 8000 },
	{ id = 38468, chance = 7140 },
	{ id = 38475, chance = 6250 },
	{ id = 38476, chance = 3570 },
	{ id = 36320, chance = 2680 },
	{ id = 38478, chance = 2680 },
	{ id = 38490, chance = 2680 },
	{ id = 38547, chance = 1790 },
	{ id = 38509, chance = 890 },
	{ id = 38460, chance = 890 },
	{ id = 38452, chance = 890 },
	{ id = 38454, chance = 890 },
	{ id = 38453, chance = 890 },
	{ id = 48154, chance = 890 },
	{ id = 38455, chance = 890 },
	{ id = 38461, chance = 890 },
	{ id = 38451, chance = 890 },
	{ id = 38458, chance = 890 },
	{ id = 38459, chance = 890 },
	{ id = 38456, chance = 890 },
	{ id = 38457, chance = 890 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -300,
		maxDamage = -600,
		range = 7,
		shootEffect = CONST_ANI_WHIRLWINDCLUB,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_LIFEDRAIN,
		minDamage = -300,
		maxDamage = -600,
		radius = 4,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_LIFEDRAIN,
		minDamage = -600,
		maxDamage = -1000,
		length = 4,
		spread = 0,
		effect = CONST_ME_SOUND_PURPLE,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
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
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
