local mType = Game.createMonsterType("Sir Baeloc")
local monster = {}

monster.description = "Sir Baeloc"
monster.experience = 55000
monster.outfit = {
	lookType = 1222,
	lookHead = 57,
	lookBody = 81,
	lookLegs = 3,
	lookFeet = 93,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "venom"
monster.corpse = 31599
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"BossHealthCheck",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1755,
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

monster.maxSummons = 3
monster.summons = {
	{ name = "Retainer of Baeloc", chance = 20, interval = 2000, max = 3 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, minCount = 1, maxCount = 5, chance = 100000 },
	{ id = 2160, minCount = 0, maxCount = 2, chance = 50000 },
	{ id = 25172, minCount = 0, maxCount = 3, chance = 40000 },
	{ id = 26031, minCount = 0, maxCount = 6, chance = 35000 },
	{ id = 26029, minCount = 0, maxCount = 20, chance = 32000 },
	{ id = 26030, minCount = 0, maxCount = 20, chance = 32000 },
	{ id = 7440, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 7439, minCount = 0, maxCount = 10, chance = 12000 },
	{ id = 5889, minCount = 0, maxCount = 4, chance = 9000 },
	{ id = 2156, minCount = 0, maxCount = 1, chance = 12000 },
	{ id = 26198, chance = 5200 },
	{ id = 26200, chance = 5200 },
	{ id = 2477, chance = 11000 },
	{ id = 9971, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 2153, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 2154, minCount = 0, maxCount = 1, chance = 10000 },
	{ id = 26185, chance = 5000 },
	{ id = 26189, chance = 5000 },
	{ id = 2436, chance = 9000 },
	{ id = 35572, chance = 5800 },
	{ id = 35561, chance = 1400 },
	{ id = 35574, chance = 1800 },
	{ id = 35559, chance = 750 },
	{ id = 35711, chance = 450 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 3100,
		chance = 37,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -400,
		maxDamage = -1000,
		length = 7,
		spread = 0,
		effect = CONST_ME_DRAWBLOOD,
		target = false,
	},
	{
		name = "combat",
		interval = 2500,
		chance = 35,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -350,
		maxDamage = -625,
		range = 5,
		shootEffect = CONST_ANI_WHIRLWINDAXE,
		effect = CONST_ME_DRAWBLOOD,
		target = true,
	},
	{
		name = "combat",
		interval = 2700,
		chance = 30,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -180,
		maxDamage = -250,
		range = 1,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 25,
	armor = 78,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 350, maxDamage = 550, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 35 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
