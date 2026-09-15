local mType = Game.createMonsterType("Flimsy Lost Soul")
local monster = {}

monster.description = "a flimsy lost soul"
monster.experience = 4500
monster.outfit = {
	lookType = 1268,
	lookHead = 0,
	lookBody = 6,
	lookLegs = 0,
	lookFeet = 116,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1864
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

monster.health = 4000
monster.maxHealth = 4000
monster.race = "undead"
monster.corpse = 32610
monster.speed = 240
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
	{ id = 2152, chance = 100000, maxCount = 2 },
	{ id = 35997, chance = 30300 },
	{ id = 2189, chance = 5220 },
	{ id = 8912, chance = 3830 },
	{ id = 36367, chance = 3540 },
	{ id = 2181, chance = 3030 },
	{ id = 2183, chance = 2830 },
	{ id = 36362, chance = 2260 },
	{ id = 15403, chance = 1760 },
	{ id = 36432, chance = 1570 },
	{ id = 8920, chance = 1520 },
	{ id = 18412, chance = 960 },
	{ id = 8922, chance = 330 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -500 },
	{
		name = "combat",
		interval = 1700,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -150,
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
		radius = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 79,
	mitigation = 2.22,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
