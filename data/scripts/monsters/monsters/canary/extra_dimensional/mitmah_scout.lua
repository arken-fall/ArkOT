local mType = Game.createMonsterType("Mitmah Scout")
local monster = {}

monster.description = "a mitmah scout"
monster.experience = 3230
monster.outfit = {
	lookType = 1709,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2460
monster.bestiary = {
	race = "Extra Dimensional",
	class = "Extra Dimensional",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Iksupan Waterways",
}

monster.health = 3940
monster.maxHealth = 3940
monster.race = "venom"
monster.corpse = 44667
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 15,
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
	critChance = 3,
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
	{ text = "Die for us!", yell = false },
	{ text = "Humans ought to be extinct!", yell = false },
	{ text = "This belongs to us now!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 10 },
	{ id = 44550, chance = 17180 },
	{ id = 18417, chance = 7620 },
	{ id = 7632, chance = 7400 },
	{ id = 18416, chance = 6890 },
	{ id = 7588, chance = 6170, maxCount = 3 },
	{ id = 24850, chance = 4080 },
	{ id = 24849, chance = 3670 },
	{ id = 9971, chance = 2880 },
	{ id = 2154, chance = 2450 },
	{ id = 31051, chance = 2410 },
	{ id = 2133, chance = 1810 },
	{ id = 42406, chance = 1340 },
	{ id = 18436, chance = 1270, maxCount = 10 },
	{ id = 2157, chance = 320 },
	{ id = 15644, chance = 140 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -250,
		maxDamage = -400,
		radius = 4,
		effect = CONST_ME_POFF,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -400,
		range = 5,
		shootEffect = CONST_ANI_POWERBOLT,
		effect = CONST_ME_ENERGYAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 40,
	armor = 45,
	mitigation = 2.02,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 50, maxDamage = 180, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
