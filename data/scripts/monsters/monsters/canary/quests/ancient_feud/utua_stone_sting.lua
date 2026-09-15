local mType = Game.createMonsterType("Utua Stone Sting")
local monster = {}

monster.description = "Utua Stone Sting"
monster.experience = 5100
monster.outfit = {
	lookType = 398,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1984,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 6400
monster.maxHealth = 6400
monster.race = "undead"
monster.corpse = 12512
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 60,
	random = 40,
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
	{ id = 2152, chance = 100000, minCount = 1, maxCount = 17 },
	{ id = 8473, chance = 100000, minCount = 1, maxCount = 5 },
	{ id = 10568, chance = 54050, minCount = 1, maxCount = 5 },
	{ id = 2127, chance = 10810 },
	{ id = 30498, chance = 8650 },
	{ id = 7895, chance = 7570 },
	{ id = 37431, chance = 4320 },
	{ id = 30499, chance = 3240 },
	{ id = 5741, chance = 3240 },
	{ id = 2153, chance = 3240 },
	{ id = 7427, chance = 2700 },
	{ id = 9971, chance = 2700 },
	{ id = 2155, chance = 2700 },
	{ id = 2445, chance = 2160 },
	{ id = 7894, chance = 2160 },
	{ id = 7386, chance = 2160 },
	{ id = 15451, chance = 2160 },
	{ id = 7896, chance = 1620 },
	{ id = 7456, chance = 1620 },
	{ id = 7440, chance = 1080 },
	{ id = 26187, chance = 1080 },
	{ id = 13535, chance = 540 },
	{ id = 15454, chance = 540 },
	{ id = 2472, chance = 540 },
	{ id = 37574, chance = 540 },
	{ id = 11355, chance = 540 },
	{ id = 2520, chance = 360 },
	{ id = 7897, chance = 360 },
	{ id = 37127, chance = 360 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -300,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 1000, maxDamage = 1000 },
	},
	{
		name = "combat",
		type = COMBAT_EARTHDAMAGE,
		interval = 2000,
		chance = 30,
		minDamage = -200,
		maxDamage = -300,
		target = true,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
	},
	{
		name = "combat",
		type = COMBAT_EARTHDAMAGE,
		interval = 2000,
		chance = 25,
		minDamage = -300,
		maxDamage = -450,
		radius = 3,
		length = 3,
		spread = 3,
		target = true,
		shootEffect = CONST_ANI_POISONARROW,
		effect = CONST_ME_POISONAREA,
	},
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 4000, chance = 40, minDamage = 0, maxDamage = -400, length = 4, spread = 3, effect = CONST_ME_DRAWBLOOD },
}

monster.defenses = {
	defense = 0,
	armor = 42,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 60, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
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
