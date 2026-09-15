local mType = Game.createMonsterType("Brain Head")
local monster = {}

monster.description = "Brain Head"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 36113,
}

monster.health = 75000
monster.maxHealth = monster.health
monster.race = "undead"
monster.corpse = 32272
monster.speed = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1862,
	bossRace = RARITY_ARCHFOE,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.loot = {
	{ id = 2160, chance = 96300, maxCount = 3 },
	{ id = 36428, chance = 55560, maxCount = 2 },
	{ id = 26029, chance = 51850, maxCount = 6 },
	{ id = 36427, chance = 51850, maxCount = 2 },
	{ id = 26031, chance = 29630 },
	{ id = 7440, chance = 22220 },
	{ id = 36432, chance = 22220 },
	{ id = 7439, chance = 18520 },
	{ id = 36367, chance = 18520, maxCount = 2 },
	{ id = 36431, chance = 18520 },
	{ id = 7443, chance = 14810, maxCount = 10 },
	{ id = 26030, chance = 14810, maxCount = 6 },
	{ id = 36429, chance = 14810 },
	{ id = 36324, chance = 8520 },
	{ id = 36430, chance = 7410 },
	{ id = 36319, chance = 7410 },
	{ id = 36310, chance = 3700 },
	{ id = 36325, chance = 3700 },
	{ id = 36316, chance = 3700 },
	{ id = 36315, chance = 3200 },
}

monster.attacks = {
	{
		name = "combat",
		type = COMBAT_DEATHDAMAGE,
		interval = 2000,
		chance = 80,
		minDamage = -700,
		maxDamage = -1200,
		effect = CONST_ME_MORTAREA,
		shootEffect = CONST_ANI_SUDDENDEATH,
		target = true,
		range = 7,
	},
	{
		name = "combat",
		type = COMBAT_LIFEDRAIN,
		interval = 2000,
		chance = 20,
		length = 8,
		spread = 0,
		minDamage = -900,
		maxDamage = -1300,
		effect = CONST_ME_ELECTRICALSPARK,
	},
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of death unleashed!", yell = false },
	{ text = "I will rule again and my realm of death will span the world!", yell = false },
	{ text = "My lich-knights will conquer this world for me!", yell = false },
}

mType:register(monster)
