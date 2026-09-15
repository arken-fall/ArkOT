local mType = Game.createMonsterType("Sister Hetai")
local monster = {}

monster.description = "Sister Hetai"
monster.experience = 20500
monster.outfit = {
	lookType = 1199,
	lookHead = 114,
	lookBody = 19,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 31419
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 2104,
	bossRace = RARITY_ARCHFOE,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
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
	{ id = 2379, chance = 5052 },
	{ id = 2160, chance = 4323, maxCount = 1 },
	{ id = 10219, chance = 781 },
	{ id = 9971, chance = 677, maxCount = 1 },
	{ id = 7901, chance = 469 },
	{ id = 8910, chance = 469 },
	{ id = 2153, chance = 469 },
	{ id = 2189, chance = 469 },
	{ id = 24849, chance = 417 },
	{ id = 31736, chance = 417 },
	{ id = 2145, chance = 417 },
	{ id = 2187, chance = 417 },
	{ id = 2476, chance = 365 },
	{ id = 7889, chance = 365 },
	{ id = 2149, chance = 365 },
	{ id = 8871, chance = 313 },
	{ id = 7899, chance = 313 },
	{ id = 2214, chance = 313 },
	{ id = 8920, chance = 313 },
	{ id = 7891, chance = 260 },
	{ id = 23540, chance = 260 },
	{ id = 15453, chance = 260 },
	{ id = 2213, chance = 208 },
	{ id = 35320, chance = 208 },
	{ id = 7903, chance = 208 },
	{ id = 39428, chance = 156 },
	{ id = 26187, chance = 156 },
	{ id = 7886, chance = 156 },
	{ id = 2154, chance = 156 },
	{ id = 7895, chance = 104 },
	{ id = 35319, chance = 104 },
	{ id = 39427, chance = 52 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -270, maxDamage = -500 },
	{ name = "targetfirering", interval = 2000, chance = 40, minDamage = -500, maxDamage = -650, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 70,
		type = COMBAT_FIREDAMAGE,
		minDamage = -350,
		maxDamage = -500,
		radius = 2,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_EXPLOSIONHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -500,
		maxDamage = -750,
		radius = 4,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
