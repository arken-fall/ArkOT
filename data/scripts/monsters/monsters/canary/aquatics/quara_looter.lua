local mType = Game.createMonsterType("Quara Looter")
local monster = {}

monster.description = "a quara looter"
monster.experience = 8650
monster.outfit = {
	lookType = 1741,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2543
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Podzilla Bottom, Podzilla Underwater",
}

monster.health = 11500
monster.maxHealth = 11500
monster.race = "undead"
monster.corpse = 48277
monster.speed = 210
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11,
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
	targetDistance = 3,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 3
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Krrrck!", yell = false },
	{ text = "Tchky!", yell = false },
	{ text = "<splatter>", yell = false },
}

monster.loot = {
	{ id = 46912, chance = 7040 },
	{ id = 46913, chance = 6460 },
	{ id = 2156, chance = 4340 },
	{ id = 2158, chance = 2700 },
	{ id = 7896, chance = 940 },
	{ id = 15403, chance = 820 },
	{ id = 18453, chance = 470 },
	{ id = 25383, chance = 350 },
	{ id = 12445, chance = 230 },
	{ id = 2152, chance = 10000, maxCount = 25 },
	{ id = 7897, chance = 1000 },
	{ id = 45683, chance = 110 },
	{ id = 45685, chance = 110 },
	{ id = 45684, chance = 110 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, type = COMBAT_DEATHDAMAGE, minDamage = -150, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_ICEDAMAGE,
		minDamage = -400,
		maxDamage = -750,
		range = 7,
		shootEffect = CONST_ANI_SHIVERARROW,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{ name = "quarasmallicering", interval = 2000, chance = 16 },
	{ name = "podzillaphyschain", interval = 2000, chance = 15 },
}

monster.defenses = {
	defense = 95,
	armor = 95,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 600, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
