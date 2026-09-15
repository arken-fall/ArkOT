local mType = Game.createMonsterType("Unaz the Mean")
local monster = {}

monster.description = "Unaz the Mean"
monster.experience = 22000
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 95,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 28000
monster.maxHealth = 28000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 1891,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
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
	{ id = 2152, chance = 10000, maxCount = 5 },
	{ id = 36431, chance = 1000 },
	{ id = 36278, chance = 1000 },
	{ id = 36429, chance = 1000, maxCount = 2 },
	{ id = 36428, chance = 100 },
	{ id = 2420, chance = 400 },
	{ id = 36313, chance = 200 },
	{ id = 2436, chance = 400 },
	{ id = 15451, chance = 400 },
	{ id = 36367, chance = 150 },
	{ id = 36430, chance = 150 },
	{ id = 2156, chance = 150, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500 },
	{
		name = "combat",
		interval = 1500,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		radius = 3,
		shootEffect = CONST_ANI_ENVENOMEDARROW,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
	{
		name = "combat",
		interval = 1500,
		chance = 25,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -300,
		maxDamage = -650,
		length = 4,
		spread = 0,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 1500,
		chance = 35,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -300,
		maxDamage = -650,
		radius = 4,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 1500,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -300,
		maxDamage = -650,
		radius = 4,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
