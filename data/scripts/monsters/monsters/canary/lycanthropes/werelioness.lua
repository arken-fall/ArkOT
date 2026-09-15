local mType = Game.createMonsterType("Werelioness")
local monster = {}

monster.description = "a werelioness"
monster.experience = 2300
monster.outfit = {
	lookType = 1301,
	lookHead = 0,
	lookBody = 2,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1966
monster.bestiary = {
	race = "Lycanthrope",
	class = "Lycanthrope",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Lion Sanctum.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "blood"
monster.corpse = 34185
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	runHealth = 5,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 5

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 2148, chance = 100000, maxCount = 60 },
	{ id = 7759, chance = 5000, maxCount = 2 },
	{ id = 2144, chance = 5000, maxCount = 2 },
	{ id = 2671, chance = 5000, maxCount = 2 },
	{ id = 2666, chance = 5000, maxCount = 2 },
	{ id = 5944, chance = 5000, maxCount = 2 },
	{ id = 2143, chance = 1500, maxCount = 2 },
	{ id = 2193, chance = 5000 },
	{ id = 7449, chance = 5000 },
	{ id = 2409, chance = 5000 },
	{ id = 2384, chance = 5000 },
	{ id = 10608, chance = 5000 },
	{ id = 7901, chance = 1500 },
	{ id = 2457, chance = 1500 },
	{ id = 2485, chance = 1500 },
	{ id = 37277, chance = 1500 },
	{ id = 7894, chance = 500 },
	{ id = 2491, chance = 500 },
	{ id = 37338, chance = 200 },
	{ id = 37130, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -300,
		maxDamage = -410,
		range = 3,
		effect = CONST_ME_HOLYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -170,
		maxDamage = -350,
		range = 3,
		shootEffect = CONST_ANI_HOLY,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_FIREDAMAGE,
		minDamage = -250,
		maxDamage = -300,
		length = 4,
		spread = 0,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 38,
	mitigation = 0.91,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 35 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
