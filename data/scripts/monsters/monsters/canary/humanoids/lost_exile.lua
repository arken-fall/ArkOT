local mType = Game.createMonsterType("Lost Exile")
local monster = {}

monster.description = "a lost exile"
monster.experience = 1800
monster.outfit = {
	lookType = 537,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"LastExileDeath",
}

monster.raceId = 1529
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "South east of the Gnome Deep Hub's entrance.",
}

monster.health = 1600
monster.maxHealth = 1600
monster.race = "blood"
monster.corpse = 17684
monster.speed = 125
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
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
	{ text = "**", yell = false },
	{ text = "**", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2152, chance = 60240, maxCount = 2 },
	{ id = 7588, chance = 10950, maxCount = 2 },
	{ id = 7590, chance = 8330, maxCount = 2 },
	{ id = 2789, chance = 16900, maxCount = 2 },
	{ id = 13757, chance = 13100 },
	{ id = 20130, chance = 13100 },
	{ id = 9970, chance = 10240 },
	{ id = 20128, chance = 6900 },
	{ id = 20129, chance = 7620 },
	{ id = 20127, chance = 11900 },
	{ id = 20135, chance = 12620 },
	{ id = 20136, chance = 8100 },
	{ id = 20110, chance = 8100 },
	{ id = 20137, chance = 8100 },
	{ id = 20111, chance = 8881 },
	{ id = 2213, chance = 1043 },
	{ id = 2515, chance = 1430 },
	{ id = 20109, chance = 1900 },
	{ id = 11339, chance = 710 },
	{ id = 2430, chance = 950 },
	{ id = 7886, chance = 240 },
	{ id = 32682, chance = 250 },
	{ id = 2528, chance = 240 },
	{ id = 7885, chance = 240 },
	{ id = 2432, chance = 710 },
	{ id = 2436, chance = 480 },
	{ id = 7452, chance = 240 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -120 },
	{
		name = "sudden death rune",
		interval = 2000,
		chance = 15,
		minDamage = -150,
		maxDamage = -350,
		range = 3,
		length = 6,
		spread = 0,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_MANADRAIN,
		minDamage = -150,
		maxDamage = -250,
		range = 3,
		length = 5,
		spread = 5,
		effect = CONST_ME_SMOKE,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_LIFEDRAIN,
		minDamage = -150,
		maxDamage = -290,
		range = 3,
		length = 5,
		spread = 5,
		shootEffect = CONST_ANI_LARGEROCK,
		effect = CONST_ME_POISONAREA,
		target = false,
	},
	{ name = "sudden death rune", interval = 2000, chance = 15, minDamage = -70, maxDamage = -250, range = 7, target = false },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, shootEffect = CONST_ANI_ENERGY, target = false, duration = 5000 },
}

monster.defenses = {
	defense = 20,
	armor = 20,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 0, maxDamage = 160, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
