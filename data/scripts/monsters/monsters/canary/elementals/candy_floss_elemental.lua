local mType = Game.createMonsterType("Candy Floss Elemental")
local monster = {}

monster.description = "a candy floss elemental"
monster.experience = 3850
monster.outfit = {
	lookType = 1749,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2533
monster.bestiary = {
	race = "Elemental",
	class = "Elemental",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Dessert Dungeons.",
}

monster.health = 3700
monster.maxHealth = 3700
monster.race = "undead"
monster.corpse = 48345
monster.speed = 105
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Come into my fluffy embrace!", yell = false },
	{ text = "Want fairy floss? I will feed you up.", yell = false },
	{ text = "Did you have to come here, little one? I just wanted to lay around and take it easy.", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 95860, maxCount = 149 },
	{ id = 2152, chance = 86660, maxCount = 11 },
	{ id = 31697, chance = 6400 },
	{ id = 26191, chance = 4100 },
	{ id = 46581, chance = 3410, maxCount = 3 },
	{ id = 24850, chance = 3260 },
	{ id = 31736, chance = 3030, maxCount = 2 },
	{ id = 18414, chance = 2450 },
	{ id = 46948, chance = 1690 },
	{ id = 2153, chance = 1500 },
	{ id = 46699, chance = 920, maxCount = 10 },
	{ id = 8912, chance = 650 },
	{ id = 2209, chance = 310 },
	{ id = 2170, chance = 120 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -350 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -150,
		maxDamage = -250,
		range = 7,
		shootEffect = CONST_ANI_CHERRYBOMB,
		effect = CONST_ME_STARBURST,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -160,
		maxDamage = -300,
		range = 6,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -160,
		maxDamage = -300,
		range = 6,
		radius = 2,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_PIXIE_EXPLOSION,
		target = true,
	},
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 40 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
