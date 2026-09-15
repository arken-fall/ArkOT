local mType = Game.createMonsterType("Enfeebled Silencer")
local monster = {}

monster.description = "an enfeebled silencer"
monster.experience = 1100
monster.outfit = {
	lookType = 585,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"ThreatenedDreamsNightmareMonstersDeath",
}

monster.raceId = 1443
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 0,
	locations = "Feyrist.",
}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "blood"
monster.corpse = 20155
monster.speed = 165
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	{ text = "Prrrroooaaaah!!! PRROAAAH!!", yell = false },
	{ text = "PRRRROOOOOAAAAAHHHH!!!", yell = true },
	{ text = "HUUUSSSSSSSSH!!", yell = true },
	{ text = "Hussssssh!!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 100 },
	{ id = 2152, chance = 40000, maxCount = 1 },
	{ id = 2165, chance = 1200 },
	{ id = 2195, chance = 500 },
	{ id = 7368, chance = 7600, maxCount = 10 },
	{ id = 7387, chance = 800 },
	{ id = 7407, chance = 1600 },
	{ id = 7451, chance = 1000 },
	{ id = 7454, chance = 1000 },
	{ id = 7885, chance = 960 },
	{ id = 7886, chance = 480 },
	{ id = 22534, chance = 4000 },
	{ id = 31697, chance = 12000 },
}

monster.attacks = {
	{
		name = "melee",
		interval = 2000,
		chance = 100,
		skill = 80,
		attack = 70,
		condition = { type = CONDITION_POISON, interval = 4000, minDamage = 200, maxDamage = 200 },
	},
	{ name = "silencer skill reducer", interval = 2000, chance = 10, range = 3, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_MANADRAIN,
		minDamage = -40,
		maxDamage = -90,
		radius = 4,
		shootEffect = CONST_ANI_ONYXARROW,
		effect = CONST_ME_MAGIC_RED,
		target = true,
	},
}

monster.defenses = {
	defense = 20,
	armor = 44,
	mitigation = 1.43,
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 450 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 80, maxDamage = 225, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 60 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = -25 },
	{ type = COMBAT_DEATHDAMAGE, percent = 65 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
