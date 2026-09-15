local mType = Game.createMonsterType("Liodile")
local monster = {}

monster.description = "a liodile"
monster.experience = 6860
monster.outfit = {
	lookType = 1602,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2338
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Ingol",
}

monster.health = 8600
monster.maxHealth = 8600
monster.race = "blood"
monster.corpse = 42214
monster.speed = 165
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
	{ text = "Growl!", yell = false },
	{ text = "Meat!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 80540, maxCount = 23 },
	{ id = 2146, chance = 9790, maxCount = 4 },
	{ id = 18415, chance = 5360 },
	{ id = 42460, chance = 4030, maxCount = 3 },
	{ id = 2154, chance = 3720 },
	{ id = 7404, chance = 2600 },
	{ id = 7885, chance = 2420 },
	{ id = 8912, chance = 1610 },
	{ id = 10219, chance = 830 },
	{ id = 10220, chance = 720 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{
		name = "combat",
		interval = 2000,
		chance = 50,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -325,
		maxDamage = -400,
		range = 7,
		shootEffect = CONST_ANI_POISONARROW,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 34,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -300,
		maxDamage = -400,
		range = 2,
		effect = CONST_ME_GROUNDSHAKER,
		target = true,
	},
}

monster.defenses = {
	defense = 50,
	armor = 71,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
