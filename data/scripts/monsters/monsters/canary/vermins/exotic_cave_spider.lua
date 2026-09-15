local mType = Game.createMonsterType("Exotic Cave Spider")
local monster = {}

monster.description = "a exotic cave spider"
monster.experience = 1400
monster.outfit = {
	lookType = 1344,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2024
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Exotic cave spider cave.",
}

monster.health = 1900
monster.maxHealth = 1900
monster.race = "venom"
monster.corpse = 35358
monster.speed = 132
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 20,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
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
	{ id = 2152, chance = 100000 },
	{ id = 7591, chance = 9600 },
	{ id = 2545, chance = 14600 },
	{ id = 7886, chance = 4400 },
	{ id = 2170, chance = 4550 },
	{ id = 5879, chance = 2850 },
	{ id = 7884, chance = 850 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		minDamage = 0,
		maxDamage = -450,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 250, maxDamage = 250 },
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_EARTHDAMAGE,
		range = 7,
		radius = 1,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -90,
		maxDamage = -150,
		range = 7,
		radius = 3,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 40,
	armor = 40,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
