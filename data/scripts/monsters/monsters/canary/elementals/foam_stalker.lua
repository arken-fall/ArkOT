local mType = Game.createMonsterType("Foam Stalker")
local monster = {}

monster.description = "a foam stalker"
monster.experience = 3120
monster.outfit = {
	lookType = 1562,
}

monster.raceId = 2259
monster.bestiary = {
	race = "Elemental",
	class = "Elemental",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Great Pearl Fan Reef",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 39344
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 2,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}
monster.targetDistance = 2
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "splash", yell = false },
	{ text = "gurgle", yell = false },
	{ text = "dribble", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 50 },
	{ id = 2381, chance = 11025 },
	{ id = 7589, chance = 9728 },
	{ id = 5022, chance = 9728 },
	{ id = 2383, chance = 8301 },
	{ id = 2404, chance = 7004 },
	{ id = 41495, chance = 6874 },
	{ id = 2143, chance = 6485 },
	{ id = 2245, chance = 6355 },
	{ id = 2401, chance = 6355 },
	{ id = 2240, chance = 5966 },
	{ id = 7892, chance = 5707 },
	{ id = 41494, chance = 4929 },
	{ id = 5944, chance = 4929 },
	{ id = 2144, chance = 4669 },
	{ id = 2145, chance = 3891 },
	{ id = 2149, chance = 3243, maxCount = 2 },
	{ id = 7632, chance = 2205 },
	{ id = 7886, chance = 5075 },
	{ id = 7386, chance = 4167 },
	{ id = 2477, chance = 3649 },
	{ id = 2153, chance = 3389 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -100, maxDamage = -300 },
	{ name = "foamsplash", interval = 5000, chance = 50, minDamage = -100, maxDamage = -300 },
	{
		name = "combat",
		interval = 2500,
		chance = 35,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		length = 6,
		spread = 0,
		effect = CONST_ME_LOSEENERGY,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 45,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		range = 4,
		radius = 1,
		target = true,
		effect = CONST_ME_ICEATTACK,
		shootEffect = CONST_ANI_ICE,
	},
	{
		name = "combat",
		interval = 1000,
		chance = 15,
		type = COMBAT_ICEDAMAGE,
		minDamage = -100,
		maxDamage = -300,
		radius = 4,
		target = false,
		effect = CONST_ME_ICEAREA,
	},
}

monster.defenses = {
	defense = 64,
	armor = 64,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 80, maxDamage = 113 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -30 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
