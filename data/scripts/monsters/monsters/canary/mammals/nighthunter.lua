local mType = Game.createMonsterType("Nighthunter")
local monster = {}

monster.description = "a nighthunter"
monster.experience = 12647
monster.outfit = {
	lookType = 1552,
	lookHead = 85,
	lookBody = 1,
	lookLegs = 85,
	lookFeet = 105,
	lookAddons = 3,
	lookMount = 0,
}

monster.raceId = 2270
monster.bestiary = {
	race = "Mammal",
	class = "Mammal",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Monster Graveyard",
}

monster.health = 19200
monster.maxHealth = 19200
monster.race = "blood"
monster.corpse = 39299
monster.speed = 205
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
	{ text = "Shriiiiek! Shriiiiek!", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 34190 },
	{ id = 41469, chance = 24370, minCount = 1, maxCount = 2 },
	{ id = 8473, chance = 12640, minCount = 1, maxCount = 3 },
	{ id = 18420, chance = 3980 },
	{ id = 18415, chance = 3670 },
	{ id = 18419, chance = 3080 },
	{ id = 2154, chance = 2940 },
	{ id = 7449, chance = 1590 },
	{ id = 15451, chance = 1400 },
	{ id = 8902, chance = 960 },
	{ id = 2197, chance = 850 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700 },
	{
		name = "combat",
		interval = 3500,
		chance = 35,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -950,
		maxDamage = -1300,
		range = 1,
		radius = 1,
		shootEffect = CONST_ANI_POISON,
		effect = CONST_ME_POISONAREA,
		target = true,
	},
	{ name = "nighthunter wave", interval = 5000, chance = 25, minDamage = -600, maxDamage = -775 },
}

monster.defenses = {
	defense = 85,
	armor = 81,
	mitigation = 2.28,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)

RegisterPrimalPackBeast(monster)
