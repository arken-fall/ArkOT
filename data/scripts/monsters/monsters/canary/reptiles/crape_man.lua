local mType = Game.createMonsterType("Crape Man")
local monster = {}

monster.description = "a crape man"
monster.experience = 5040
monster.outfit = {
	lookType = 1601,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2337
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Ingol",
}

monster.health = 9150
monster.maxHealth = 9150
monster.race = "blood"
monster.corpse = 42210
monster.speed = 155
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
	{ text = "Ungh! Ungh!", yell = false },
	{ text = "Klack klack!", yell = false },
	{ text = "Hugah!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 71540, maxCount = 25 },
	{ id = 42459, chance = 5210, maxCount = 2 },
	{ id = 2155, chance = 3010 },
	{ id = 7591, chance = 2000, maxCount = 5 },
	{ id = 7632, chance = 1700 },
	{ id = 2427, chance = 2400 },
	{ id = 7895, chance = 900 },
	{ id = 15453, chance = 900 },
	{ id = 7896, chance = 750 },
	{ id = 7456, chance = 700 },
	{ id = 2444, chance = 400 },
	{ id = 2123, chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -498 },
	{
		name = "combat",
		interval = 3500,
		chance = 40,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -120,
		maxDamage = -320,
		range = 7,
		shootEffect = CONST_ANI_SUDDENDEATH,
		target = true,
	},
	{
		name = "combat",
		interval = 2500,
		chance = 50,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -330,
		maxDamage = -380,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_ENERGYBALL,
		effect = CONST_ME_PURPLEENERGY,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 65,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -311,
		maxDamage = -370,
		length = 3,
		spread = 3,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 50,
	armor = 80,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
