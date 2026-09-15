local mType = Game.createMonsterType("Amenef the Burning")
local monster = {}

monster.description = "Amenef the Burning"
monster.experience = 21500
monster.outfit = {
	lookType = 541,
	lookHead = 113,
	lookBody = 114,
	lookLegs = 113,
	lookFeet = 113,
	lookAddons = 1,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2103,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 26000
monster.maxHealth = 26000
monster.race = "blood"
monster.corpse = 31646
monster.speed = 115
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

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2160, chance = 4494, maxCount = 1 },
	{ id = 9813, chance = 1392 },
	{ id = 9810, chance = 1203 },
	{ id = 2427, chance = 1139 },
	{ id = 2213, chance = 886 },
	{ id = 7440, chance = 823 },
	{ id = 2485, chance = 633 },
	{ id = 2476, chance = 570 },
	{ id = 26185, chance = 506 },
	{ id = 2438, chance = 443 },
	{ id = 8910, chance = 443 },
	{ id = 2430, chance = 380 },
	{ id = 8912, chance = 380 },
	{ id = 2189, chance = 316 },
	{ id = 2187, chance = 316 },
	{ id = 7632, chance = 253 },
	{ id = 8901, chance = 253 },
	{ id = 2153, chance = 253 },
	{ id = 8920, chance = 253 },
	{ id = 7426, chance = 190 },
	{ id = 7404, chance = 190 },
	{ id = 2158, chance = 190 },
	{ id = 39428, chance = 190 },
	{ id = 15451, chance = 190 },
	{ id = 8871, chance = 127 },
	{ id = 7456, chance = 127 },
	{ id = 10219, chance = 127 },
	{ id = 35320, chance = 63 },
	{ id = 7386, chance = 63 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -150, maxDamage = -510 },
	{ name = "firering", interval = 2000, chance = 10, minDamage = -300, maxDamage = -600, target = false },
	{ name = "firex", interval = 2000, chance = 15, minDamage = -450, maxDamage = -750, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 17,
		type = COMBAT_FIREDAMAGE,
		minDamage = -300,
		maxDamage = -600,
		radius = 2,
		effect = CONST_ME_FIREATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -500,
		maxDamage = -750,
		length = 3,
		spread = 0,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
