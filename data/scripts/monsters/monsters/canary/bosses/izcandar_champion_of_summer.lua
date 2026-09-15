local mType = Game.createMonsterType("Izcandar Champion of Summer")
local monster = {}

monster.description = "Izcandar Champion of Summer"
monster.experience = 6900
monster.outfit = {
	lookType = 1137,
	lookHead = 43,
	lookBody = 78,
	lookLegs = 43,
	lookFeet = 43,
	lookAddons = 3,
	lookMount = 0,
}

monster.health = 130000
monster.maxHealth = 130000
monster.race = "blood"
monster.corpse = 25151
monster.speed = 200
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"izcandarThink",
}

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
	{ text = "Dream or nightmare?", yell = false },
}

monster.loot = {
	{ id = 26191, chance = 100000 },
	{ id = 25377, chance = 100000, maxCount = 2 },
	{ id = 2114, chance = 100000 },
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 25172, chance = 100000, maxCount = 2 },
	{ id = 26165, chance = 100000 },
	{ id = 2154, chance = 69230, maxCount = 2 },
	{ id = 26030, chance = 61540, maxCount = 20 },
	{ id = 26031, chance = 53850, maxCount = 20 },
	{ id = 26029, chance = 53850, maxCount = 14 },
	{ id = 2156, chance = 46150 },
	{ id = 26185, chance = 38460 },
	{ id = 7427, chance = 23080 },
	{ id = 5892, chance = 30777 },
	{ id = 7443, chance = 23080, maxCount = 10 },
	{ id = 34151, chance = 100, unique = true },
	{ id = 7632, chance = 23080 },
	{ id = 31758, chance = 23080, maxCount = 100 },
	{ id = 2158, chance = 15380 },
	{ id = 7440, chance = 15380, maxCount = 10 },
	{ id = 2436, chance = 15380 },
	{ id = 7439, chance = 7690, maxCount = 10 },
	{ id = 26199, chance = 7690 },
	{ id = 26200, chance = 7690 },
	{ id = 2160, chance = 7690, maxCount = 2 },
	{ id = 34278, chance = 7690 },
	{ id = 34371, chance = 7690 },
	{ id = 32130, chance = 7690 },
	{ id = 2123, chance = 7690 },
	{ id = 34168, chance = 1500 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -320, maxDamage = -750 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ICEDAMAGE, minDamage = -500, maxDamage = -850, radius = 6, effect = false, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DROWNDAMAGE,
		minDamage = -300,
		maxDamage = -850,
		length = 8,
		spread = 3,
		effect = false,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_MANADRAIN,
		minDamage = -444,
		maxDamage = -850,
		radius = 4,
		effect = false,
		shootEffect = CONST_ANI_SUDDENDEATH,
		target = true,
	},
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_FIREDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -410, maxDamage = -850, length = 9, effect = false, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -410,
		maxDamage = -850,
		radius = 3,
		shootEffect = CONST_ANI_EARTH,
		effect = false,
		target = false,
	},
}

monster.defenses = {
	defense = 76,
	armor = 76,
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 310, maxDamage = 640, effect = CONST_ME_REDSPARK },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
	{ type = "fire", condition = true },
}

mType:register(monster)
