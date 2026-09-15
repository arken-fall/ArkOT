local mType = Game.createMonsterType("Iks Ahpututu")
local monster = {}

monster.description = "an iks ahpututu"
monster.experience = 1700
monster.outfit = {
	lookType = 1590,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2349
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 5,
	firstUnlock = 1,
	secondUnlock = 2,
	charmPoints = 50,
	stars = 3,
	occurrence = 0,
	locations = "Iksupan",
}

monster.health = 1630
monster.maxHealth = 1630
monster.race = "blood"
monster.corpse = 42065
monster.speed = 110
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
}

monster.loot = {
	{ id = 2148, chance = 1000000, maxCount = 477 },
	{ id = 7632, chance = 7100 },
	{ id = 31050, chance = 7100 },
	{ id = 7589, chance = 6380, maxCount = 4 },
	{ id = 2146, chance = 4370, maxCount = 5 },
	{ id = 42399, chance = 2910 },
	{ id = 24850, chance = 1640, maxCount = 2 },
	{ id = 42405, chance = 1460 },
	{ id = 8900, chance = 1090 },
	{ id = 9971, chance = 730 },
	{ id = 42404, chance = 730 },
	{ id = 42408, chance = 360 },
	{ id = 42406, chance = 360 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -235 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -120,
		maxDamage = -250,
		range = 7,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
}

monster.defenses = {
	defense = 35,
	armor = 34,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 25 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
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
