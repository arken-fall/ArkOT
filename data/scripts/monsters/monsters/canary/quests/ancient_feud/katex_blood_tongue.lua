local mType = Game.createMonsterType("Katex Blood Tongue")
local monster = {}

monster.description = "Katex Blood Tongue"
monster.experience = 5000
monster.outfit = {
	lookType = 1300,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 113,
	lookFeet = 113,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6300
monster.maxHealth = 6300
monster.race = "blood"
monster.corpse = 34189
monster.speed = 100
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
}

monster.bosstiary = {
	bossRaceId = 1981,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
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

monster.maxSummons = 1
monster.summons = {
	{ name = "werehyaena", chance = 50, interval = 5000, max = 1 },
}

monster.voices = {
	interval = 0,
	chance = 0,
}

monster.loot = {
	{ id = 2152, chance = 100000, minCount = 1, maxCount = 17 },
	{ id = 8473, chance = 100000, minCount = 1, maxCount = 5 },
	{ id = 9971, chance = 25000 },
	{ id = 37275, chance = 21110 },
	{ id = 2153, chance = 5000 },
	{ id = 37430, chance = 4440 },
	{ id = 37276, chance = 4440 },
	{ id = 37541, chance = 3890 },
	{ id = 5741, chance = 3330 },
	{ id = 2158, chance = 3330 },
	{ id = 2520, chance = 1670 },
	{ id = 2393, chance = 1670 },
	{ id = 15644, chance = 1670 },
	{ id = 2179, chance = 1670 },
	{ id = 2472, chance = 1110 },
	{ id = 7404, chance = 1110 },
	{ id = 7440, chance = 1110 },
	{ id = 24739, chance = 1110 },
	{ id = 26187, chance = 1110 },
	{ id = 7422, chance = 1110 },
	{ id = 2454, chance = 1000 },
	{ id = 23539, chance = 1000 },
	{ id = 37574, chance = 560 },
	{ id = 7382, chance = 560 },
	{ id = 2466, chance = 560 },
	{ id = 37127, chance = 360 },
	{ id = 7633, chance = 140 },
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, maxDamage = -300 },
	{
		name = "combat",
		type = COMBAT_EARTHDAMAGE,
		interval = 2000,
		chance = 30,
		minDamage = -350,
		maxDamage = -500,
		range = 5,
		radius = 3,
		length = 3,
		spread = 3,
		target = true,
		shootEffect = CONST_ANI_LARGEROCK,
		effect = CONST_ME_POFF,
	},
	{
		name = "combat",
		type = COMBAT_DEATHDAMAGE,
		interval = 2000,
		chance = 40,
		minDamage = -300,
		maxDamage = -400,
		radius = 5,
		target = false,
		effect = CONST_ME_MORTAREA,
	},
	{ name = "katex deathT", interval = 2000, chance = 30, minDamage = -250, maxDamage = -350, target = false },
}

monster.defenses = {
	defense = 0,
	armor = 38,
	{ name = "speed", interval = 2000, chance = 15, speed = 200, duration = 5000, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
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
	{ type = "bleed", condition = true },
}

mType:register(monster)
