local mType = Game.createMonsterType("Rotten Golem")
local monster = {}

monster.description = "a rotten golem"
monster.experience = 17860
monster.outfit = {
	lookType = 1312,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1939
monster.bestiary = {
	race = "Construct",
	class = "Construct",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Rotten Wasteland.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "venom"
monster.corpse = 33897
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2160, chance = 60590 },
	{ id = 8472, chance = 31180, maxCount = 5 },
	{ id = 10219, chance = 3590 },
	{ id = 8910, chance = 3030 },
	{ id = 7632, chance = 2690 },
	{ id = 7413, chance = 2500 },
	{ id = 7887, chance = 1900 },
	{ id = 7386, chance = 1900 },
	{ id = 2454, chance = 1560 },
	{ id = 2393, chance = 1540 },
	{ id = 24741, chance = 990 },
	{ id = 2664, chance = 920 },
	{ id = 2197, chance = 740 },
	{ id = 7884, chance = 510 },
	{ id = 23536, chance = 430 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -950 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1200,
		maxDamage = -1450,
		range = 7,
		shootEffect = CONST_ANI_SMALLHOLY,
		effect = CONST_ME_HOLYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -900,
		maxDamage = -1400,
		radius = 5,
		effect = CONST_ME_BIGPLANTS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1100,
		maxDamage = -1300,
		radius = 7,
		effect = CONST_ME_BIGPLANTS,
		target = false,
	},
	{ name = "poison chain", interval = 2000, chance = 20, minDamage = -1050, maxDamage = -1200, radius = 7, effect = CONST_ME_BIGPLANTS, target = false },
	{ name = "root", interval = 2000, chance = 1, target = true },
}

monster.defenses = {
	defense = 108,
	armor = 108,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 50 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
