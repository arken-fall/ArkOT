local mType = Game.createMonsterType("Darkfang")
local monster = {}

monster.description = "Darkfang"
monster.experience = 4000
monster.outfit = {
	lookType = 308,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4800
monster.maxHealth = 4800
monster.race = "blood"
monster.corpse = 18099
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1558,
	bossRace = RARITY_ARCHFOE,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 2
monster.summons = {
	{ name = "Gloom Wolf", chance = 20, interval = 2000, max = 2 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You are my next meal! Grrr!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 13600000, maxCount = 100 },
	{ id = 2148, chance = 13600000, maxCount = 100 },
	{ id = 2152, chance = 13600000, maxCount = 10 },
	{ id = 7439, chance = 13600000, maxCount = 3 },
	{ id = 2144, chance = 13600000, maxCount = 3 },
	{ id = 24849, chance = 13600000, maxCount = 5 },
	{ id = 7759, chance = 13600000, maxCount = 10 },
	{ id = 8473, chance = 13600000, maxCount = 5 },
	{ id = 2171, chance = 13600000 },
	{ id = 2197, chance = 13600000 },
	{ id = 2169, chance = 13600000 },
	{ id = 2805, chance = 13600000, maxCount = 2 },
	{ id = 11234, chance = 13600000, maxCount = 2 },
	{ id = 5897, chance = 13600000, maxCount = 2 },
	{ id = 7428, chance = 400 },
	{ id = 7419, chance = 400 },
	{ id = 24716, chance = 400 },
	{ id = 11306, chance = 250 },
	{ id = 7394, chance = 13600000 },
	{ id = 25172, chance = 250 },
	{ id = 24740, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "werewolf skill reducer", interval = 2000, chance = 15, range = 1, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -300,
		radius = 8,
		effect = CONST_ME_SOUND_RED,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 200,
		maxDamage = 340,
		radius = 3,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 15, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000, speed = -600 },
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 70 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
