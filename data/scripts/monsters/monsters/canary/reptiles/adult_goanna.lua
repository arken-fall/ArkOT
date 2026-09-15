local mType = Game.createMonsterType("Adult Goanna")
local monster = {}

monster.description = "an adult goanna"
monster.experience = 6650
monster.outfit = {
	lookType = 1195,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1818
monster.bestiary = {
	race = "Reptile",
	class = "Reptile",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt.",
}

monster.health = 8300
monster.maxHealth = 8300
monster.race = "blood"
monster.corpse = 31405
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 10

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 18437, chance = 60120, maxCount = 8 },
	{ id = 7850, chance = 13180, maxCount = 30 },
	{ id = 2127, chance = 12240 },
	{ id = 35542, chance = 11650 },
	{ id = 7761, chance = 10030 },
	{ id = 18416, chance = 9100 },
	{ id = 2181, chance = 8250 },
	{ id = 35540, chance = 7910 },
	{ id = 18413, chance = 7820 },
	{ id = 2146, chance = 6890, maxCount = 2 },
	{ id = 7903, chance = 6630 },
	{ id = 35543, chance = 6210 },
	{ id = 7887, chance = 6040 },
	{ id = 2154, chance = 4250 },
	{ id = 2134, chance = 4000 },
	{ id = 2155, chance = 3150 },
	{ id = 2409, chance = 2810 },
	{ id = 35479, chance = 2720 },
	{ id = 24850, chance = 2640, maxCount = 2 },
	{ id = 24849, chance = 2640 },
	{ id = 30499, chance = 1530 },
	{ id = 2150, chance = 1360 },
	{ id = 24741, chance = 1360 },
	{ id = 2664, chance = 1280 },
	{ id = 2143, chance = 1280 },
	{ id = 35436, chance = 1190 },
	{ id = 10219, chance = 1020 },
	{ id = 30498, chance = 770 },
	{ id = 35336, chance = 770 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -400,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 200, maxDamage = 200 },
	},
	{
		name = "combat",
		interval = 2500,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -600,
		range = 3,
		shootEffect = CONST_ANI_EARTH,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 30,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -380,
		radius = 2,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{
		name = "combat",
		interval = 3600,
		chance = 40,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -390,
		length = 8,
		spread = 3,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
}

monster.defenses = {
	defense = 84,
	armor = 84,
	mitigation = 2.6,
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 420 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
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
