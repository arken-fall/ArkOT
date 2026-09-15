local mType = Game.createMonsterType("Courage Leech")
local monster = {}

monster.description = "a courage leech"
monster.experience = 18900
monster.outfit = {
	lookType = 1315,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1941
monster.bestiary = {
	race = "Extra Dimensional",
	class = "Extra Dimensional",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Furious Crater",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 27000
monster.maxHealth = 27000
monster.race = "undead"
monster.corpse = 33909
monster.speed = 226
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
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Hiss.", yell = false },
	{ text = "Zap! Zap!", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 70910 },
	{ id = 8473, chance = 11820, maxCount = 7 },
	{ id = 7889, chance = 3640 },
	{ id = 7895, chance = 3640 },
	{ id = 7901, chance = 2730 },
	{ id = 2444, chance = 1820 },
	{ id = 7422, chance = 910 },
	{ id = 7419, chance = 910 },
	{ id = 7421, chance = 910 },
	{ id = 2179, chance = 910 },
	{ id = 7412, chance = 910 },
	{ id = 2197, chance = 910 },
	{ id = 7418, chance = 1190 },
	{ id = 7382, chance = 600 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700 },
	{
		name = "combat",
		interval = 2000,
		chance = 17,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -1100,
		maxDamage = -1400,
		radius = 4,
		shootEffect = CONST_ANI_ETHEREALSPEAR,
		effect = CONST_ME_ENERGYAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -1100,
		maxDamage = -1400,
		radius = 4,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 3000,
		chance = 15,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -900,
		maxDamage = -1100,
		length = 7,
		spread = 0,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -1100,
		maxDamage = -1300,
		range = 7,
		shootEffect = CONST_ANI_SMALLHOLY,
		effect = CONST_ME_HOLYDAMAGE,
		target = true,
	},
	{ name = "energy chain", interval = 2000, chance = 20, minDamage = -900, maxDamage = -1000, range = 3, target = true },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.04,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
