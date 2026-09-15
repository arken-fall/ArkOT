local mType = Game.createMonsterType("Pirat Mate")
local monster = {}

monster.description = "a pirat mate"
monster.experience = 2400
monster.outfit = {
	lookType = 1346,
	lookHead = 0,
	lookBody = 95,
	lookLegs = 95,
	lookFeet = 113,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2039
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "The Wreckoning",
}

monster.health = 3200
monster.maxHealth = 3200
monster.race = "blood"
monster.corpse = 35388
monster.speed = 175
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 50,
	healthHidden = false,
	isBlockable = true,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 50

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 38469, chance = 10000, maxCount = 10 },
	{ id = 18419, chance = 10000 },
	{ id = 2145, chance = 10000 },
	{ id = 18420, chance = 10000 },
	{ id = 38491, chance = 9000 },
	{ id = 38470, chance = 7000 },
	{ id = 2156, chance = 6000 },
	{ id = 2392, chance = 5000 },
	{ id = 2149, chance = 5000 },
	{ id = 24849, chance = 4000 },
	{ id = 38471, chance = 4000 },
	{ id = 2154, chance = 3000 },
	{ id = 2396, chance = 3000 },
	{ id = 18415, chance = 2000 },
	{ id = 38468, chance = 2000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "energy beam",
		interval = 2000,
		chance = 10,
		minDamage = -150,
		maxDamage = -210,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "energy wave",
		interval = 2000,
		chance = 10,
		minDamage = -140,
		maxDamage = -80,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 20,
	armor = 75,
	mitigation = 1.94,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 30, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = -30 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
