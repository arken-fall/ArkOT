local mType = Game.createMonsterType("Deepworm")
local monster = {}

monster.description = "a deepworm"
monster.experience = 2520
monster.outfit = {
	lookType = 1033,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"WarzoneWormDeath",
}

monster.raceId = 1531
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Gnome Deep Hub",
}

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 27545
monster.speed = 102
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
	{ id = 32625, chance = 24010 },
	{ id = 2168, chance = 7320 },
	{ id = 2666, chance = 19660, maxCount = 4 },
	{ id = 2671, chance = 19660, maxCount = 4 },
	{ id = 2791, chance = 22280 },
	{ id = 2792, chance = 14960 },
	{ id = 2796, chance = 18520 },
	{ id = 18415, chance = 5360 },
	{ id = 32624, chance = 13210, maxCount = 2 },
	{ id = 32623, chance = 9880 },
	{ id = 7762, chance = 3430, maxCount = 2 },
	{ id = 7887, chance = 5060 },
	{ id = 8912, chance = 1120 },
	{ id = 10219, chance = 2390 },
	{ id = 7632, chance = 860 },
	{ id = 32682, chance = 530 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -190,
		maxDamage = -300,
		range = 7,
		length = 6,
		spread = 2,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -200,
		maxDamage = -400,
		length = 3,
		spread = 3,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 5,
	armor = 73,
	mitigation = 1.88,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
