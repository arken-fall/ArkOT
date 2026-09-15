local mType = Game.createMonsterType("Bulltaur Alchemist")
local monster = {}

monster.description = "a Bulltaur Alchemist"
monster.experience = 4500
monster.outfit = {
	lookType = 1718,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5690
monster.maxHealth = 5690
monster.race = "blood"
monster.corpse = 44713
monster.speed = 160
monster.manaCost = 0

monster.raceId = 2448
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Bulltaurs Lair",
}

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	{ text = "Your misfortune is setteled!", yell = false },
	{ text = "Soon I will harvest you for ingredients!", yell = false },
	{ text = "I have just the solution for this problem!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 51528, maxCount = 30 },
	{ id = 44810, chance = 15234 },
	{ id = 44813, chance = 9169 },
	{ id = 44814, chance = 6256 },
	{ id = 7591, chance = 5540 },
	{ id = 9971, chance = 3534 },
	{ id = 8473, chance = 2722 },
	{ id = 7590, chance = 2006 },
	{ id = 2153, chance = 1862 },
	{ id = 26029, chance = 1385 },
	{ id = 2158, chance = 1003 },
	{ id = 2179, chance = 1003 },
	{ id = 23539, chance = 1003 },
	{ id = 36427, chance = 669 },
	{ id = 11355, chance = 621 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -120, maxDamage = -270 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -300,
		maxDamage = -420,
		radius = 3,
		effect = CONST_ME_REDSMOKE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -280,
		maxDamage = -400,
		range = 4,
		radius = 4,
		shootEffect = CONST_ANI_ENERGYBALL,
		effect = CONST_ME_PURPLESMOKE,
		target = true,
	},
	{ name = "bulltaur avalanche", interval = 2000, chance = 20, minDamage = -350, maxDamage = -450 },
}

monster.defenses = {
	defense = 67,
	armor = 67,
	mitigation = 2.11,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "drunk", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
