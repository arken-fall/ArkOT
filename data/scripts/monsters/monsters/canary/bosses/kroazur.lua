local mType = Game.createMonsterType("Kroazur")
local monster = {}

monster.description = "Kroazur"
monster.experience = 2700
monster.outfit = {
	lookType = 842,
	lookHead = 0,
	lookBody = 114,
	lookLegs = 94,
	lookFeet = 80,
	lookAddons = 2,
	lookMount = 0,
}

monster.events = {
	"ThreatenedDreamsNightmareMonstersDeath",
}

monster.bosstiary = {
	bossRaceId = 1515,
	bossRace = RARITY_BANE,
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "undead"
monster.corpse = 6324
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
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
	{ id = 31697, chance = 100000 },
	{ id = 2148, chance = 100000, maxCount = 365 },
	{ id = 2152, chance = 100000, maxCount = 7 },
	{ id = 7588, chance = 91460, maxCount = 2 },
	{ id = 7591, chance = 76330, maxCount = 3 },
	{ id = 7762, chance = 53560, maxCount = 5 },
	{ id = 30497, chance = 46980, maxCount = 3 },
	{ id = 30499, chance = 32030 },
	{ id = 7761, chance = 11003, maxCount = 5 },
	{ id = 7760, chance = 2000 },
	{ id = 25172, chance = 10140 },
	{ id = 22396, chance = 19960 },
	{ id = 18420, chance = 9960 },
	{ id = 7759, chance = 8900 },
	{ id = 7368, chance = 8540 },
	{ id = 25377, chance = 6580 },
	{ id = 9971, chance = 6410 },
	{ id = 7418, chance = 3020 },
}

monster.attacks = {
	{ name = "melee", interval = 200, chance = 20, minDamage = 0, maxDamage = -650 },
	{ name = "combat", interval = 200, chance = 20, type = COMBAT_DEATHDAMAGE, minDamage = -300, maxDamage = -500, target = false },
	{
		name = "combat",
		interval = 500,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		length = 8,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 500,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -250,
		maxDamage = -300,
		radius = 8,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 400, maxDamage = 500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 80 },
	{ type = COMBAT_FIREDAMAGE, percent = 55 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
