local mType = Game.createMonsterType("The Rootkraken")
local monster = {}

monster.name = "The Rootkraken"
monster.experience = 600000
monster.outfit = {
	lookType = 1765,
}

monster.bosstiary = {
	bossRaceId = 2528,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 360000
monster.maxHealth = 360000
monster.race = "venom"
monster.corpse = 49124
monster.speed = 180

monster.changeTarget = {
	interval = 4000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	attackable = true,
	hostile = true,
	summonable = false,
	convinceable = false,
	illusionable = false,
	boss = true,
	rewardBoss = true,
	ignoreSpawnBlock = false,
	pushable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	healthHidden = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 90

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 100000, maxCount = 3 },
	{ id = 2152, chance = 100000, maxCount = 100 },
	{ id = 36320, chance = 44444 },
	{ id = 8473, chance = 42593, maxCount = 20 },
	{ id = 8472, chance = 42593, maxCount = 14 },
	{ id = 7590, chance = 31481, maxCount = 14 },
	{ id = 26031, chance = 31481, maxCount = 8 },
	{ id = 26030, chance = 25926, maxCount = 15 },
	{ id = 7589, chance = 25926, maxCount = 20 },
	{ id = 2154, chance = 24074, maxCount = 2 },
	{ id = 36427, chance = 20370, maxCount = 2 },
	{ id = 45932, chance = 20000 },
	{ id = 45933, chance = 20000 },
	{ id = 45934, chance = 20000 },
	{ id = 45938, chance = 20000 },
	{ id = 45939, chance = 20000 },
	{ id = 45940, chance = 20000 },
	{ id = 45941, chance = 20000 },
	{ id = 48200, chance = 20000 },
	{ id = 36318, chance = 18519 },
	{ id = 36319, chance = 18519 },
	{ id = 2158, chance = 18519, maxCount = 2 },
	{ id = 36317, chance = 7407 },
	{ id = 46920, chance = 5556 },
	{ id = 36316, chance = 5556 },
	{ id = 34283, chance = 3704 },
	{ id = 46921, chance = 1852 },
	{ id = 34282, chance = 1852 },
	{ id = 46918, chance = 1852 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -800, maxDamage = -1200 },
	{
		name = "combat",
		interval = 2000,
		chance = 40,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -450,
		maxDamage = -700,
		range = 6,
		shootEffect = CONST_ANI_DEATH,
		target = false,
	},
}

monster.defenses = {
	defense = 85,
	armor = 85,
	mitigation = 2.0,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
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
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
