local mType = Game.createMonsterType("Diremaw")
local monster = {}

monster.description = "a diremaw"
monster.experience = 2770
monster.outfit = {
	lookType = 1034,
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

monster.raceId = 1532
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Gnome Deep Hub north and south tasking areas, Warzone 6",
}

monster.health = 3600
monster.maxHealth = 3600
monster.race = "blood"
monster.corpse = 27494
monster.speed = 150
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
	{ id = 2671, chance = 40080, maxCount = 4 },
	{ id = 32628, chance = 24120 },
	{ id = 10557, chance = 11930, maxCount = 5 },
	{ id = 18413, chance = 9660 },
	{ id = 18414, chance = 8180 },
	{ id = 18415, chance = 8030 },
	{ id = 24849, chance = 8560, maxCount = 4 },
	{ id = 32629, chance = 9650, maxCount = 2 },
	{ id = 7761, chance = 2940, maxCount = 2 },
	{ id = 2149, chance = 5080, maxCount = 2 },
	{ id = 9971, chance = 2970 },
	{ id = 7632, chance = 3100 },
	{ id = 32682, chance = 600 },
	{ id = 18454, chance = 200 },
	{ id = 18393, chance = 1500 },
}

monster.attacks = {
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -150,
		maxDamage = -200,
		range = 7,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -150,
		maxDamage = -250,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POFF,
		target = true,
	},
	{
		name = "condition",
		type = CONDITION_POISON,
		interval = 2000,
		chance = 21,
		minDamage = -200,
		maxDamage = -310,
		radius = 4,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
}

monster.defenses = {
	defense = 5,
	armor = 71,
	mitigation = 1.94,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
