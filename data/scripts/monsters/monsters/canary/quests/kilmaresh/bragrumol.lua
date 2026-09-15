local mType = Game.createMonsterType("Bragrumol")
local monster = {}

monster.description = "Bragrumol"
monster.experience = 18000
monster.outfit = {
	lookType = 856,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"BragrumolDeath",
}

monster.health = 38000
monster.maxHealth = 38000
monster.race = "fire"
monster.corpse = 12838
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1828,
	bossRace = RARITY_BANE,
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
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 8 },
	{ id = 7840, chance = 60000, maxCount = 15 },
	{ id = 2156, chance = 45000, maxCount = 15 },
	{ id = 35319, chance = 6700 },
	{ id = 35539, chance = 520 },
	{ id = 35365, chance = 16500 },
	{ id = 35599, chance = 110 },
	{ id = 34570, chance = 250 },
	{ id = 7899, chance = 48000 },
	{ id = 2197, chance = 54000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -600 },
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -300,
		maxDamage = -600,
		range = 5,
		shootEffect = CONST_ANI_SUDDENDEATH,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -300,
		maxDamage = -600,
		range = 5,
		radius = 4,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -300,
		maxDamage = -600,
		range = 5,
		radius = 4,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -300,
		maxDamage = -600,
		range = 5,
		length = 5,
		spread = 3,
		effect = CONST_ME_WHITE_ENERGY_SPARK,
		target = true,
	},
}

monster.defenses = {
	defense = 84,
	armor = 84,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
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
