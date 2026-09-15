local mType = Game.createMonsterType("Crazed Summer Rearguard")
local monster = {}

monster.description = "a crazed summer rearguard"
monster.experience = 4700
monster.outfit = {
	lookType = 1136,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 3,
	lookFeet = 121,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1733
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Court of Summer, Dream Labyrinth.",
}

monster.health = 5300
monster.maxHealth = 5300
monster.race = "blood"
monster.corpse = 30081
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	{ text = "Is this real life?", yell = false },
	{ text = "Weeeuuu weeeuuu!!!", yell = false },
}

monster.loot = {
	{ id = 2547, chance = 1000000 },
	{ id = 7759, chance = 790, maxCount = 2 },
	{ id = 2152, chance = 85000, maxCount = 11 },
	{ id = 5921, chance = 10500 },
	{ id = 34229, chance = 8500 },
	{ id = 10552, chance = 7200 },
	{ id = 18414, chance = 4500 },
	{ id = 7760, chance = 6000 },
	{ id = 18420, chance = 4500 },
	{ id = 31734, chance = 4000, maxCount = 8 },
	{ id = 26185, chance = 2500 },
	{ id = 34219, chance = 890 },
	{ id = 26198, chance = 900 },
	{ id = 2664, chance = 1300 },
	{ id = 2145, chance = 600 },
	{ id = 2154, chance = 1000 },
	{ id = 18453, chance = 500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{
		name = "combat",
		interval = 2500,
		chance = 30,
		type = COMBAT_FIREDAMAGE,
		minDamage = -150,
		maxDamage = -300,
		range = 6,
		effect = CONST_ME_FIREATTACK,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 30,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		range = 6,
		radius = 2,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 20,
	armor = 76,
	mitigation = 2.11,
}

monster.reflects = {
	{ type = COMBAT_FIREDAMAGE, percent = 70 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 40 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
