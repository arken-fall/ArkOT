local mType = Game.createMonsterType("Lokathmor")
local monster = {}

monster.description = "Lokathmor"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 22,
	lookBody = 57,
	lookLegs = 79,
	lookFeet = 77,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"lokathmorDeath",
}

monster.bosstiary = {
	bossRaceId = 1574,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 7893
monster.speed = 115
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

monster.maxSummons = 5
monster.summons = {
	{ name = "demon blood", chance = 10, interval = 2000, max = 5 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 90000, maxCount = 63 },
	{ id = 2160, chance = 70000, maxCount = 4 },
	{ id = 7590, chance = 70000, maxCount = 18 },
	{ id = 8472, chance = 70000, maxCount = 18 },
	{ id = 26029, chance = 70000, maxCount = 12 },
	{ id = 8473, chance = 70000, maxCount = 18 },
	{ id = 7440, chance = 70000, maxCount = 2 },
	{ id = 24849, chance = 70000, maxCount = 12 },
	{ id = 2149, chance = 70000, maxCount = 12 },
	{ id = 2150, chance = 70000, maxCount = 12 },
	{ id = 2145, chance = 70000, maxCount = 12 },
	{ id = 2147, chance = 70000, maxCount = 12 },
	{ id = 2158, chance = 70000 },
	{ id = 5954, chance = 70000 },
	{ id = 6500, chance = 70000 },
	{ id = 7632, chance = 70000 },
	{ id = 2155, chance = 70000 },
	{ id = 5904, chance = 70000 },
	{ id = 2197, chance = 70000 },
	{ id = 25172, chance = 30000, maxCount = 4 },
	{ id = 2656, chance = 30000 },
	{ id = 7419, chance = 30000 },
	{ id = 9816, chance = 26670 },
	{ id = 2187, chance = 30000 },
	{ id = 33635, chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 150, attack = 250 },
	{
		name = "combat",
		interval = 2000,
		chance = 8,
		type = COMBAT_LIFEDRAIN,
		minDamage = -1100,
		maxDamage = -2800,
		range = 7,
		radius = 5,
		shootEffect = CONST_ANI_WHIRLWINDAXE,
		effect = CONST_ME_DRAWBLOOD,
		target = true,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 8,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -800,
		maxDamage = -1900,
		radius = 9,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "condition",
		type = CONDITION_POISON,
		interval = 5000,
		chance = 18,
		minDamage = -1100,
		maxDamage = -2500,
		effect = CONST_ME_HITBYPOISON,
		target = false,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1000,
		maxDamage = -255,
		range = 7,
		radius = 6,
		effect = CONST_ME_LOSEENERGY,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 8,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -90,
		maxDamage = -200,
		range = 7,
		shootEffect = CONST_ANI_WHIRLWINDAXE,
		effect = CONST_ME_EXPLOSIONAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 40,
	armor = 40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
