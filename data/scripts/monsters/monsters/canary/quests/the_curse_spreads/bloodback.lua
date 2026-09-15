local mType = Game.createMonsterType("Bloodback")
local monster = {}

monster.description = "Bloodback"
monster.experience = 4000
monster.outfit = {
	lookType = 1039,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 5200
monster.maxHealth = 5200
monster.race = "blood"
monster.corpse = 27718
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1560,
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
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
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
	{ name = "Wereboar", chance = 20, interval = 2000, max = 2 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will DIE!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 13600000, maxCount = 100 },
	{ id = 2148, chance = 13600000, maxCount = 100 },
	{ id = 2152, chance = 13600000, maxCount = 10 },
	{ id = 7591, chance = 13600000, maxCount = 10 },
	{ id = 18420, chance = 13600000, maxCount = 2 },
	{ id = 7760, chance = 13600000, maxCount = 3 },
	{ id = 7432, chance = 13600000 },
	{ id = 2156, chance = 13600000 },
	{ id = 7452, chance = 13600000 },
	{ id = 2197, chance = 13600000 },
	{ id = 24709, chance = 13600000, maxCount = 2 },
	{ id = 24743, chance = 13600000, maxCount = 2 },
	{ id = 24710, chance = 13600000, maxCount = 2 },
	{ id = 7419, chance = 400 },
	{ id = 24741, chance = 400 },
	{ id = 7457, chance = 400 },
	{ id = 24758, chance = 250 },
	{ id = 25172, chance = 250 },
	{ id = 24740, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -290 },
	{ name = "combat", interval = 1000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = -100, maxDamage = -420, range = 7, target = false },
	{ name = "speed", interval = 2000, chance = 15, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000, speed = -600 },
	{
		name = "combat",
		interval = 1000,
		chance = 14,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -100,
		maxDamage = -200,
		length = 5,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 45,
	armor = 40,
	{ name = "combat", interval = 4000, chance = 15, type = COMBAT_HEALING, minDamage = 150, maxDamage = 345, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
