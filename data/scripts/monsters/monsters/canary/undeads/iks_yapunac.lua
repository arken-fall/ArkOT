local mType = Game.createMonsterType("Iks Yapunac")
local monster = {}

monster.description = "an iks yapunac"
monster.experience = 3125
monster.outfit = {
	lookType = 1702,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2437
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 500,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Iksupan Waterways",
}

monster.health = 3125
monster.maxHealth = 3125
monster.race = "blood"
monster.corpse = 44447
monster.speed = 120
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	{ text = "MIT-MAH!", yell = false },
	{ text = "Grrrmh...", yell = false },
	{ text = "CHAHAAAR!!!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 10 },
	{ id = 2148, chance = 100000, maxCount = 50 },
	{ id = 7632, chance = 14830 },
	{ id = 7591, chance = 14530 },
	{ id = 31050, chance = 4820 },
	{ id = 18416, chance = 4190 },
	{ id = 18417, chance = 4160 },
	{ id = 24850, chance = 3450, maxCount = 2 },
	{ id = 23541, chance = 3150 },
	{ id = 24849, chance = 2490 },
	{ id = 42405, chance = 2410 },
	{ id = 7452, chance = 1700 },
	{ id = 12470, chance = 1500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -250, effect = CONST_ME_PURPLEENERGY },
	{ name = "iksyapunacwave", interval = 2000, chance = 20, minDamage = -175, maxDamage = -300 },
	{
		name = "combat",
		interval = 2000,
		chance = 17,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -140,
		maxDamage = -260,
		range = 5,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = -20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
