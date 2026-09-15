local mType = Game.createMonsterType("Gorzindel")
local monster = {}

monster.description = "Gorzindel"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 94,
	lookBody = 81,
	lookLegs = 10,
	lookFeet = 0,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"gorzindelHealth",
}

monster.bosstiary = {
	bossRaceId = 1591,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "blood"
monster.corpse = 22495
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
	{ id = 2152, chance = 90000 },
	{ id = 2160, chance = 90000, maxCount = 8 },
	{ id = 2150, chance = 90000, maxCount = 12 },
	{ id = 2145, chance = 90000, maxCount = 12 },
	{ id = 2149, chance = 90000, maxCount = 12 },
	{ id = 2147, chance = 90000, maxCount = 12 },
	{ id = 9970, chance = 90000, maxCount = 12 },
	{ id = 24849, chance = 90000, maxCount = 12 },
	{ id = 8472, chance = 90000, maxCount = 8 },
	{ id = 26031, chance = 90000, maxCount = 12 },
	{ id = 8473, chance = 90000, maxCount = 18 },
	{ id = 26029, chance = 90000, maxCount = 8 },
	{ id = 26030, chance = 90000, maxCount = 12 },
	{ id = 7439, chance = 90000, maxCount = 2 },
	{ id = 7443, chance = 90000, maxCount = 2 },
	{ id = 7440, chance = 90000, maxCount = 2 },
	{ id = 7427, chance = 30000 },
	{ id = 2487, chance = 30000 },
	{ id = 26167, chance = 30000 },
	{ id = 5954, chance = 30000 },
	{ id = 7419, chance = 30000 },
	{ id = 7632, chance = 30000 },
	{ id = 25377, chance = 1000, maxCount = 6 },
	{ id = 2155, chance = 1000 },
	{ id = 32845, chance = 1000 },
	{ id = 32844, chance = 1000 },
	{ id = 5904, chance = 1000, maxCount = 2 },
	{ id = 18411, chance = 1000 },
	{ id = 2156, chance = 1000 },
	{ id = 9816, chance = 11760 },
	{ id = 25172, chance = 1000, maxCount = 6 },
	{ id = 32843, chance = 1000 },
	{ id = 8901, chance = 1000 },
	{ id = 2645, chance = 1000 },
	{ id = 2197, chance = 1000 },
	{ id = 2189, chance = 1000 },
	{ id = 2154, chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 100, attack = 100 },
	{ name = "melee", interval = 2000, chance = 15, minDamage = -600, maxDamage = -2800 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1300 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -800, maxDamage = -1000 },
	{ name = "melee", interval = 1000, chance = 15, minDamage = -200, maxDamage = -800 },
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -200,
		maxDamage = -600,
		radius = 9,
		effect = CONST_ME_MAGIC_RED,
		target = false,
	},
}

monster.defenses = {
	defense = 33,
	armor = 28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
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
