local mType = Game.createMonsterType("Shadowpelt")
local monster = {}

monster.description = "Shadowpelt"
monster.experience = 4600
monster.outfit = {
	lookType = 1040,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 6000
monster.maxHealth = 6000
monster.race = "blood"
monster.corpse = 27722
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 11,
}

monster.bosstiary = {
	bossRaceId = 1561,
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
	runHealth = 300,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 300

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 2
monster.summons = {
	{ name = "Werebear", chance = 20, interval = 2000, max = 2 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2148, chance = 13600000, maxCount = 200 },
	{ id = 2148, chance = 13600000, maxCount = 100 },
	{ id = 2152, chance = 13600000, maxCount = 5 },
	{ id = 2144, chance = 13600000, maxCount = 2 },
	{ id = 2671, chance = 13600000, maxCount = 2 },
	{ id = 24850, chance = 13600000, maxCount = 2 },
	{ id = 7759, chance = 13600000, maxCount = 2 },
	{ id = 5896, chance = 13600000, maxCount = 2 },
	{ id = 7432, chance = 13600000 },
	{ id = 7632, chance = 5000 },
	{ id = 7591, chance = 13600000, maxCount = 5 },
	{ id = 5902, chance = 13600000, maxCount = 2 },
	{ id = 7452, chance = 13600000 },
	{ id = 8473, chance = 13600000, maxCount = 5 },
	{ id = 24713, chance = 13600000, maxCount = 2 },
	{ id = 24712, chance = 13600000, maxCount = 2 },
	{ id = 7419, chance = 550 },
	{ id = 24741, chance = 550 },
	{ id = 7383, chance = 550 },
	{ id = 25172, chance = 150 },
	{ id = 24759, chance = 150 },
	{ id = 24740, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 50, attack = 50 },
	{
		name = "combat",
		interval = 100,
		chance = 22,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -200,
		maxDamage = -310,
		radius = 3,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{ name = "outfit", interval = 1000, chance = 1, radius = 1, target = true, duration = 2000, monster = "Werebear" },
	{
		name = "combat",
		interval = 100,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -100,
		maxDamage = -200,
		radius = 3,
		effect = CONST_ME_SOUND_WHITE,
		target = false,
	},
}

monster.defenses = {
	defense = 30,
	armor = 30,
	{ name = "combat", interval = 2000, chance = 7, type = COMBAT_HEALING, minDamage = 120, maxDamage = 310, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 10, effect = CONST_ME_POFF, target = false, duration = 5000, speed = 520 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
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
