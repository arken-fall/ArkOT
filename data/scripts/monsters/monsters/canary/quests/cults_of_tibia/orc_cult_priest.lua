local mType = Game.createMonsterType("Orc Cult Priest")
local monster = {}

monster.description = "an orc cult priest"
monster.experience = 1000
monster.outfit = {
	lookType = 6,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1504
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 1,
	locations = "Edron Orc Cave.",
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "blood"
monster.corpse = 5978
monster.speed = 70
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
	{ text = "We will crush all oposition!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 176 },
	{ id = 7588, chance = 16340 },
	{ id = 2147, chance = 12870, maxCount = 6 },
	{ id = 2144, chance = 1980 },
	{ id = 10556, chance = 18870 },
	{ id = 12435, chance = 8420, maxCount = 3 },
	{ id = 11113, chance = 5940, maxCount = 2 },
	{ id = 5910, chance = 12380 },
	{ id = 2194, chance = 8910 },
	{ id = 12434, chance = 14360 },
	{ id = 12408, chance = 5940 },
	{ id = 30187, chance = 99 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -310,
		range = 7,
		shootEffect = CONST_ANI_ENERGYBALL,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 5,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -250,
		range = 7,
		radius = 1,
		shootEffect = CONST_ANI_FIRE,
		target = true,
	},
	{ name = "outfit", interval = 4000, chance = 15, target = true, duration = 30000, monster = "orc warlord" },
	{ name = "outfit", interval = 4000, chance = 10, target = true, duration = 30000, monster = "orc shaman" },
	{ name = "outfit", interval = 4000, chance = 20, target = true, duration = 30000, monster = "orc" },
}

monster.defenses = {
	defense = 27,
	armor = 27,
	mitigation = 1.18,
	{ name = "heal monster", interval = 2000, chance = 20, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
