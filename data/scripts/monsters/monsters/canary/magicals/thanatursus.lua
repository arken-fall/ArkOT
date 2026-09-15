local mType = Game.createMonsterType("Thanatursus")
local monster = {}

monster.description = "a thanatursus"
monster.experience = 6300
monster.outfit = {
	lookType = 1134,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1728
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Haunted Temple, Court of Winter, Dream Labyrinth.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "blood"
monster.corpse = 30069
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
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
	{ text = "Uuuuuuuuuaaaaaarg!!!", yell = false },
	{ text = "Nobody will ever escape from this place, muwahaha!!!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 17 },
	{ id = 2666, chance = 90000, maxCount = 3 },
	{ id = 8472, chance = 50000, maxCount = 3 },
	{ id = 8473, chance = 50000 },
	{ id = 11223, chance = 17000 },
	{ id = 2430, chance = 14000 },
	{ id = 23546, chance = 12000 },
	{ id = 7886, chance = 7000 },
	{ id = 7903, chance = 6400 },
	{ id = 3962, chance = 500 },
	{ id = 2529, chance = 3500 },
	{ id = 10550, chance = 4200 },
	{ id = 2521, chance = 1500 },
	{ id = 2425, chance = 1500 },
	{ id = 2405, chance = 1100 },
	{ id = 7413, chance = 1100 },
	{ id = 2189, chance = 400 },
	{ id = 18390, chance = 400 },
	{ id = 15451, chance = 400 },
	{ id = 15453, chance = 400 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -250,
		maxDamage = -400,
		radius = 3,
		effect = CONST_ME_HOLYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -280,
		maxDamage = -450,
		length = 4,
		spread = 0,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -250,
		maxDamage = -400,
		radius = 6,
		effect = CONST_ME_BLOCKHIT,
		target = true,
	},
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_HEALING, minDamage = 150, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
