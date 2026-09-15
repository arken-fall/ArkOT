local mType = Game.createMonsterType("Freakish Lost Soul")
local monster = {}

monster.description = "a freakish lost soul"
monster.experience = 7020
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 74,
	lookLegs = 0,
	lookFeet = 83,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1866
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Brain Grounds, Netherworld, Zarganash.",
}

monster.health = 7000
monster.maxHealth = 7000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 260
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	rewardBoss = false,
	illusionable = true,
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
	{ id = 2152, chance = 10000, maxCount = 3 },
	{ id = 35997, chance = 45240 },
	{ id = 36367, chance = 6250 },
	{ id = 2127, chance = 5980 },
	{ id = 30499, chance = 3800 },
	{ id = 36362, chance = 2720 },
	{ id = 26185, chance = 1220 },
	{ id = 36430, chance = 1090 },
	{ id = 15644, chance = 1090 },
	{ id = 18453, chance = 270 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500 },
	{
		name = "combat",
		interval = 1700,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -550,
		radius = 3,
		shootEffect = CONST_ANI_ENVENOMEDARROW,
		effect = CONST_ME_HITBYPOISON,
		target = true,
	},
	{
		name = "combat",
		interval = 1700,
		chance = 25,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -150,
		maxDamage = -550,
		length = 4,
		spread = 0,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 1700,
		chance = 35,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -150,
		maxDamage = -550,
		radius = 4,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 1700,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -150,
		maxDamage = -550,
		radius = 4,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 85,
	mitigation = 2.6,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 35 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
