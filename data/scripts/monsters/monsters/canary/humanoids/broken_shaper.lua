local mType = Game.createMonsterType("Broken Shaper")
local monster = {}

monster.description = "a broken shaper"
monster.experience = 1800
monster.outfit = {
	lookType = 932,
	lookHead = 94,
	lookBody = 76,
	lookLegs = 0,
	lookFeet = 82,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1321
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Astral Shaper Dungeon, Astral Shaper Ruins, Old Masonry",
}

monster.health = 2200
monster.maxHealth = 2200
monster.race = "blood"
monster.corpse = 25068
monster.speed = 155
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 98
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "<grunt>", yell = false },
	{ text = "Raar!!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100320, maxCount = 165 },
	{ id = 2152, chance = 70320, maxCount = 2 },
	{ id = 30490, chance = 20000, maxCount = 2 },
	{ id = 30491, chance = 17000 },
	{ id = 30492, chance = 20000 },
	{ id = 30493, chance = 13000 },
	{ id = 30497, chance = 4000 },
	{ id = 2260, chance = 15000 },
	{ id = 2666, chance = 50320, maxCount = 2 },
	{ id = 5022, chance = 5000, maxCount = 2 },
	{ id = 5912, chance = 1000, maxCount = 2 },
	{ id = 5913, chance = 5000, maxCount = 2 },
	{ id = 5914, chance = 2000, maxCount = 2 },
	{ id = 2195, chance = 230 },
	{ id = 7591, chance = 7000 },
	{ id = 2396, chance = 1000 },
	{ id = 2162, chance = 1000 },
	{ id = 24849, chance = 4200 },
	{ id = 2214, chance = 2000 },
	{ id = 2147, chance = 3000 },
	{ id = 2146, chance = 5000 },
	{ id = 2789, chance = 6500, maxCount = 5 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -150,
		range = 7,
		shootEffect = CONST_ANI_SMALLSTONE,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -100,
		length = 5,
		spread = 0,
		effect = CONST_ME_SOUND_RED,
		target = false,
	},
}

monster.defenses = {
	defense = 25,
	armor = 37,
	mitigation = 1.46,
	{ name = "speed", interval = 2000, chance = 10, effect = CONST_ME_MAGIC_RED, target = false, duration = 2000, speed = 336 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 0, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 30 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
