local mType = Game.createMonsterType("Scarlett Etzel")
local monster = {}

monster.description = "Scarlett Etzel"
monster.experience = 20000
monster.outfit = {
	lookType = 1201,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"scarlettThink",
	"scarlettHealth",
	"grave_danger_death",
}

monster.bosstiary = {
	bossRaceId = 1804,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 30000
monster.maxHealth = 30000
monster.race = "blood"
monster.corpse = 31453
monster.speed = 120
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
	{ text = "Galthen... is that you? ", yell = false },
	{ text = " Where... have you been all that time? ", yell = false },
	{ text = " What...? How dare you? Give me that back! ", yell = false },
	{ text = " Aaaaaaah!!!", yell = false },
}

monster.loot = {
	{ id = 26191, chance = 100000 },
	{ id = 2152, chance = 87000, maxCount = 9 },
	{ id = 2155, chance = 85000 },
	{ id = 26031, chance = 53700, maxCount = 14 },
	{ id = 26029, chance = 48150, maxCount = 20 },
	{ id = 2156, chance = 42500 },
	{ id = 26030, chance = 34000, maxCount = 6 },
	{ id = 2154, chance = 29600, maxCount = 2 },
	{ id = 31758, chance = 26600, maxCount = 100 },
	{ id = 7632, chance = 24000 },
	{ id = 7439, chance = 20300, maxCount = 10 },
	{ id = 2158, chance = 18500, maxCount = 2 },
	{ id = 7443, chance = 18500, maxCount = 10 },
	{ id = 47306, chance = 18500, maxCount = 10 },
	{ id = 7899, chance = 16600 },
	{ id = 2181, chance = 1100 },
	{ id = 2160, chance = 9200 },
	{ id = 2153, chance = 9000 },
	{ id = 7885, chance = 8500 },
	{ id = 7903, chance = 7400 },
	{ id = 7884, chance = 7250 },
	{ id = 7890, chance = 5500 },
	{ id = 25172, chance = 6000, maxCount = 4 },
	{ id = 9971, chance = 5000 },
	{ id = 7887, chance = 4800 },
	{ id = 34283, chance = 4800 },
	{ id = 7900, chance = 3700 },
	{ id = 34562, chance = 700 },
	{ id = 34563, chance = 600 },
	{ id = 34560, chance = 600 },
	{ id = 34564, chance = 400 },
	{ id = 34567, chance = 650 },
	{ id = 34565, chance = 650 },
	{ id = 34566, chance = 650 },
	{ id = 35613, chance = 350 },
	{ id = 48135, chance = 600 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1200 },
	{ name = "sudden death rune", interval = 2000, chance = 16, minDamage = -400, maxDamage = -600, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -450,
		maxDamage = -640,
		length = 7,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -480,
		maxDamage = -800,
		radius = 5,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 88,
	armor = 88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
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
