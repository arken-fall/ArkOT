local mType = Game.createMonsterType("Mazzinor")
local monster = {}

monster.description = "Mazzinor"
monster.experience = 100000
monster.outfit = {
	lookType = 1062,
	lookHead = 85,
	lookBody = 7,
	lookLegs = 3,
	lookFeet = 15,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"mazzinorDeath",
	"mazzinorHealth",
}

monster.bosstiary = {
	bossRaceId = 1605,
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
	{ id = 2152, chance = 90000, maxCount = 38 },
	{ id = 2160, chance = 70000, maxCount = 5 },
	{ id = 26029, chance = 70000, maxCount = 8 },
	{ id = 26030, chance = 70000, maxCount = 4 },
	{ id = 26031, chance = 70000, maxCount = 4 },
	{ id = 7439, chance = 70000, maxCount = 2 },
	{ id = 7440, chance = 70000, maxCount = 2 },
	{ id = 24849, chance = 70000, maxCount = 12 },
	{ id = 2149, chance = 70000, maxCount = 12 },
	{ id = 5954, chance = 70000 },
	{ id = 7893, chance = 70000 },
	{ id = 2156, chance = 70000 },
	{ id = 2153, chance = 70000 },
	{ id = 2197, chance = 70000 },
	{ id = 8920, chance = 70000 },
	{ id = 25377, chance = 30000, maxCount = 4 },
	{ id = 7404, chance = 30000 },
	{ id = 8878, chance = 30000 },
	{ id = 7419, chance = 30000 },
	{ id = 26175, chance = 30000 },
	{ id = 32843, chance = 1000 },
	{ id = 13760, chance = 10 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 80 },
	{ name = "divine missile", interval = 2000, chance = 10, minDamage = -135, maxDamage = -700, target = true },
	{ name = "berserk", interval = 2000, chance = 20, minDamage = -90, maxDamage = -500, range = 7, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -135,
		maxDamage = -280,
		range = 7,
		radius = 5,
		effect = CONST_ME_MAGIC_BLUE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -210,
		maxDamage = -600,
		length = 8,
		spread = 0,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -210,
		maxDamage = -700,
		length = 8,
		spread = 0,
		effect = CONST_ME_HOLYAREA,
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
