local mType = Game.createMonsterType("Cave Devourer")
local monster = {}

monster.description = "a cave devourer"
monster.experience = 3380
monster.outfit = {
	lookType = 1036,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1544
monster.bestiary = {
	race = "Vermin",
	class = "Vermin",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Warzone 5",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 27559
monster.speed = 120
monster.manaCost = 305

monster.changeTarget = {
	interval = 5000,
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
	convinceable = true,
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
}

monster.loot = {
	{ id = 32630, chance = 24580 },
	{ id = 32631, chance = 27540 },
	{ id = 7759, chance = 8050 },
	{ id = 7760, chance = 6780 },
	{ id = 18304, chance = 23520, maxCount = 40 },
	{ id = 18413, chance = 10590 },
	{ id = 18414, chance = 7630 },
	{ id = 18415, chance = 8900 },
	{ id = 18419, chance = 5720 },
	{ id = 23565, chance = 13770, maxCount = 4 },
	{ id = 32632, chance = 17160 },
	{ id = 2165, chance = 2540 },
	{ id = 32682, chance = 850 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "stalagmite rune", interval = 2000, chance = 15, minDamage = -190, maxDamage = -300, range = 7, shootEffect = CONST_ANI_POISON, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -70,
		maxDamage = -160,
		range = 3,
		length = 6,
		spread = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -90,
		maxDamage = -160,
		range = 3,
		length = 6,
		spread = 3,
		effect = CONST_ME_HITBYFIRE,
		target = false,
	},
	{ name = "stone shower rune", interval = 2000, chance = 10, minDamage = -230, maxDamage = -450, range = 7, radius = 3, effect = CONST_ME_STONES, target = true },
}

monster.defenses = {
	defense = 5,
	armor = 70,
	mitigation = 2.02,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
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
