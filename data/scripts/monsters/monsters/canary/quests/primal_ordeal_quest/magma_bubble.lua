local mType = Game.createMonsterType("Magma Bubble")
local monster = {}

monster.description = "magma bubble"
monster.experience = 80000
monster.outfit = {
	lookType = 1413,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"MagmaBubbleDeath",
	"ThePrimeOrdealBossDeath",
}

monster.bosstiary = {
	bossRaceId = 2242,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 450000
monster.maxHealth = 450000
monster.race = "undead"
monster.corpse = 36847
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 98
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
	{ id = 2160, chance = 100000, maxCount = 60 },
	{ id = 26029, chance = 32653, maxCount = 14 },
	{ id = 8473, chance = 30612, maxCount = 14 },
	{ id = 7443, chance = 24490, maxCount = 5 },
	{ id = 7439, chance = 22449, maxCount = 5 },
	{ id = 7440, chance = 18367, maxCount = 5 },
	{ id = 47306, chance = 18367, maxCount = 5 },
	{ id = 36316, chance = 6122 },
	{ id = 34281, chance = 4082 },
	{ id = 34282, chance = 4082 },
	{ id = 34283, chance = 2041 },
	{ id = 36317, chance = 2041 },
	{ id = 41180, chance = 1000 },
	{ id = 41261, chance = 250 },
	{ id = 41260, chance = 250 },
	{ id = 41254, chance = 250 },
	{ id = 41255, chance = 250 },
	{ id = 48156, chance = 250 },
	{ id = 41256, chance = 250 },
	{ id = 41257, chance = 250 },
	{ id = 41258, chance = 250 },
	{ id = 41259, chance = 250 },
	{ id = 41290, chance = 250 },
	{ id = 41293, chance = 250 },
	{ id = 41287, chance = 250 },
	{ id = 41284, chance = 250 },
	{ id = 48115, chance = 250 },
	{ id = 41594, chance = 250 },
	{ id = 41593, chance = 250 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -275, maxDamage = -750 },
	{
		name = "combat",
		interval = 2000,
		chance = 75,
		type = COMBAT_FIREDAMAGE,
		minDamage = -725,
		maxDamage = -1000,
		radius = 3,
		range = 8,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_HITBYFIRE,
		target = true,
	},
	{
		name = "combat",
		interval = 3700,
		chance = 37,
		type = COMBAT_FIREDAMAGE,
		minDamage = -1700,
		maxDamage = -2750,
		length = 8,
		spread = 3,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
	{
		name = "combat",
		interval = 3100,
		chance = 27,
		type = COMBAT_FIREDAMAGE,
		minDamage = -1000,
		maxDamage = -2000,
		range = 8,
		effect = CONST_ME_FIREAREA,
		shootEffect = CONST_ANI_FIRE,
		target = true,
	},
}

monster.defenses = {
	defense = 65,
	armor = 0,
	mitigation = 2.0,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
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
