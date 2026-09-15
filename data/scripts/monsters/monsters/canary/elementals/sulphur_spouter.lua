local mType = Game.createMonsterType("Sulphur Spouter")
local monster = {}

monster.description = "a sulphur spouter"
monster.experience = 11517
monster.outfit = {
	lookType = 1547,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2265
monster.bestiary = {
	race = "Elemental",
	class = "Elemental",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Monster Graveyard",
}

monster.health = 19000
monster.maxHealth = 19000
monster.race = "blood"
monster.corpse = 39279
monster.speed = 180
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
	targetDistance = 2,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 2
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Gruugl...", yell = false },
}

monster.loot = {
	{ id = 41464, chance = 39440 },
	{ id = 2160, chance = 22310, minCount = 1, maxCount = 2 },
	{ id = 26029, chance = 12890, minCount = 1, maxCount = 2 },
	{ id = 2154, chance = 2820 },
	{ id = 7633, chance = 2450 },
	{ id = 9813, chance = 2420 },
	{ id = 2477, chance = 2360 },
	{ id = 2156, chance = 2190 },
	{ id = 15453, chance = 1760 },
	{ id = 26189, chance = 1110 },
	{ id = 2392, chance = 770 },
	{ id = 18453, chance = 510 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -801 },
	{
		name = "combat",
		interval = 3500,
		chance = 35,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -800,
		maxDamage = -1200,
		range = 4,
		shootEffect = CONST_ANI_HOLY,
		effect = CONST_ME_YELLOW_RINGS,
		target = true,
	},
	{
		name = "combat",
		interval = 4000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -800,
		maxDamage = -1200,
		radius = 4,
		effect = CONST_ME_YELLOWSMOKE,
		target = true,
	},
	{ name = "sulphur spouter wave", interval = 4500, chance = 30, minDamage = -650, maxDamage = -900 },
}

monster.defenses = {
	defense = 110,
	armor = 84,
	mitigation = 2.05,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
