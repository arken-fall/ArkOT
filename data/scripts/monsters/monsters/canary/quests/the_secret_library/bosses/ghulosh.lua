local mType = Game.createMonsterType("Ghulosh")
local monster = {}

monster.description = "Ghulosh"
monster.experience = 45000
monster.outfit = {
	lookType = 1062,
	lookHead = 78,
	lookBody = 113,
	lookLegs = 94,
	lookFeet = 18,
	lookAddons = 3,
	lookMount = 0,
}

monster.events = {
	"ghuloshThink",
}

monster.bosstiary = {
	bossRaceId = 1608,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 26133
monster.speed = 50
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 4,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 98
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
	{ id = 2152, chance = 90000, maxCount = 53 },
	{ id = 2160, chance = 90000, maxCount = 12 },
	{ id = 8472, chance = 90000, maxCount = 8 },
	{ id = 26031, chance = 90000, maxCount = 8 },
	{ id = 26029, chance = 90000, maxCount = 10 },
	{ id = 26030, chance = 90000, maxCount = 8 },
	{ id = 25172, chance = 90000, maxCount = 6 },
	{ id = 7443, chance = 90000 },
	{ id = 5954, chance = 90000 },
	{ id = 5904, chance = 90000 },
	{ id = 2156, chance = 90000 },
	{ id = 2197, chance = 90000 },
	{ id = 2154, chance = 90000 },
	{ id = 8922, chance = 90000 },
	{ id = 7440, chance = 30000, maxCount = 2 },
	{ id = 47306, chance = 30000, maxCount = 2 },
	{ id = 24849, chance = 30000, maxCount = 12 },
	{ id = 2145, chance = 30000, maxCount = 12 },
	{ id = 2149, chance = 30000, maxCount = 12 },
	{ id = 2147, chance = 30000, maxCount = 12 },
	{ id = 9970, chance = 30000, maxCount = 12 },
	{ id = 2158, chance = 30000 },
	{ id = 26173, chance = 30000 },
	{ id = 25377, chance = 1000 },
	{ id = 7412, chance = 1000 },
	{ id = 7419, chance = 1000 },
	{ id = 7386, chance = 1000 },
	{ id = 9816, chance = 5880 },
	{ id = 9822, chance = 35290 },
	{ id = 33636, chance = 500 },
	{ id = 34282, chance = 500 },
	{ id = 33673, chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 1000, chance = 100, skill = 150, attack = 280 },
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -900,
		maxDamage = -1500,
		length = 8,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -210,
		maxDamage = -600,
		length = 8,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -210,
		maxDamage = -600,
		range = 7,
		radius = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_LIFEDRAIN,
		minDamage = -1500,
		maxDamage = -2000,
		range = 7,
		radius = 3,
		effect = CONST_ME_DRAWBLOOD,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -5 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
