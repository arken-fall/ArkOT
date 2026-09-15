local mType = Game.createMonsterType("Menacing Carnivor")
local monster = {}

monster.description = "a menacing carnivor"
monster.experience = 2112
monster.outfit = {
	lookType = 1138,
	lookHead = 86,
	lookBody = 51,
	lookLegs = 83,
	lookFeet = 91,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 1723
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

monster.health = 3500
monster.maxHealth = 3500
monster.race = "blood"
monster.corpse = 30103
monster.speed = 170
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
	level = 5,
	color = 184,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 65410, maxCount = 8 },
	{ id = 2394, chance = 16730 },
	{ id = 26029, chance = 9820 },
	{ id = 34130, chance = 691 },
	{ id = 7449, chance = 4750 },
	{ id = 2181, chance = 4480 },
	{ id = 2147, chance = 4000 },
	{ id = 24849, chance = 3350 },
	{ id = 18421, chance = 3180 },
	{ id = 7760, chance = 2050 },
	{ id = 7885, chance = 2000 },
	{ id = 2477, chance = 1780 },
	{ id = 2420, chance = 1730 },
	{ id = 8922, chance = 1570 },
	{ id = 2442, chance = 1240 },
	{ id = 8920, chance = 1240 },
	{ id = 2191, chance = 970 },
	{ id = 31050, chance = 920 },
	{ id = 24850, chance = 810 },
	{ id = 2459, chance = 760 },
	{ id = 2409, chance = 700 },
	{ id = 2188, chance = 490 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -300, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -180,
		length = 4,
		spread = 0,
		effect = CONST_ME_SMOKE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 14,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -200,
		length = 4,
		spread = 0,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -150,
		maxDamage = -330,
		radius = 4,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
}

monster.defenses = {
	defense = 0,
	armor = 68,
	mitigation = 1.88,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
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
