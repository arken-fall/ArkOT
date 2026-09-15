local mType = Game.createMonsterType("Werelion")
local monster = {}

monster.description = "a werelion"
monster.experience = 2200
monster.outfit = {
	lookType = 1301,
	lookHead = 58,
	lookBody = 2,
	lookLegs = 94,
	lookFeet = 10,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1965
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

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 33825
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
	canWalkOnEnergy = false,
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
	{ id = 8472, chance = 100000, maxCount = 2 },
	{ id = 7760, chance = 5000, maxCount = 2 },
	{ id = 2666, chance = 5000, maxCount = 2 },
	{ id = 7449, chance = 5000 },
	{ id = 10608, chance = 5000 },
	{ id = 2134, chance = 1500 },
	{ id = 2145, chance = 1500, maxCount = 2 },
	{ id = 2391, chance = 1500 },
	{ id = 2485, chance = 1500 },
	{ id = 2521, chance = 1500 },
	{ id = 7413, chance = 1500 },
	{ id = 7452, chance = 1500 },
	{ id = 7454, chance = 1500 },
	{ id = 8870, chance = 1500 },
	{ id = 24849, chance = 1500 },
	{ id = 30498, chance = 1500 },
	{ id = 37277, chance = 1500 },
	{ id = 31736, chance = 1500 },
	{ id = 7456, chance = 500 },
	{ id = 37338, chance = 500 },
	{ id = 37130, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "werelion wave", interval = 2000, chance = 20, minDamage = -150, maxDamage = -250, target = false },
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
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 45 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
