local mType = Game.createMonsterType("Spiky Carnivor")
local monster = {}

monster.description = "a spiky carnivor"
monster.experience = 1650
monster.outfit = {
	lookType = 1139,
	lookHead = 79,
	lookBody = 121,
	lookLegs = 23,
	lookFeet = 86,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 1722
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Carnivora's Rocks.",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 30099
monster.speed = 160
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
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 4,
	color = 32,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 66230, maxCount = 6 },
	{ id = 2489, chance = 13870 },
	{ id = 34129, chance = 10490, maxCount = 2 },
	{ id = 18418, chance = 7590 },
	{ id = 18417, chance = 7330 },
	{ id = 2515, chance = 5010 },
	{ id = 2475, chance = 2980 },
	{ id = 31736, chance = 2540, maxCount = 2 },
	{ id = 2151, chance = 2000 },
	{ id = 7888, chance = 1920 },
	{ id = 7887, chance = 1920 },
	{ id = 2656, chance = 1670 },
	{ id = 31051, chance = 1380 },
	{ id = 7889, chance = 1270 },
	{ id = 2485, chance = 360 },
	{ id = 7884, chance = 330 },
	{ id = 20109, chance = 180 },
	{ id = 10221, chance = 150 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -200, maxDamage = -400 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -230,
		maxDamage = -380,
		radius = 4,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
}

monster.defenses = {
	defense = 20,
	armor = 71,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
