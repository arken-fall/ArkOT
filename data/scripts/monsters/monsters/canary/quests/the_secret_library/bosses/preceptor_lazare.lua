local mType = Game.createMonsterType("Preceptor Lazare")
local monster = {}

monster.description = "Preceptor Lazare"
monster.experience = 10000
monster.outfit = {
	lookType = 1078,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1583,
	bossRace = RARITY_BANE,
}

monster.health = 16000
monster.maxHealth = 16000
monster.race = "blood"
monster.corpse = 28643
monster.speed = 105
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	{ text = "There is nothing here for you and you will die alone.", yell = false },
	{ text = "You will obey and you will kneel and you will BOW TO US.", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 90 },
	{ id = 2148, chance = 100000, maxCount = 45 },
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 7590, chance = 100000, maxCount = 3 },
	{ id = 6500, chance = 100000, maxCount = 5 },
	{ id = 2156, chance = 700, maxCount = 3 },
	{ id = 7368, chance = 100000, maxCount = 5 },
	{ id = 6558, chance = 100000, maxCount = 3 },
	{ id = 2671, chance = 100000, maxCount = 2 },
	{ id = 2149, chance = 100000, maxCount = 5 },
	{ id = 2145, chance = 100000, maxCount = 4 },
	{ id = 2150, chance = 100000, maxCount = 3 },
	{ id = 2476, chance = 3100 },
	{ id = 2466, chance = 2200 },
	{ id = 33663, chance = 1800, maxCount = 3 },
	{ id = 2153, chance = 1800 },
	{ id = 7413, chance = 1600 },
	{ id = 2454, chance = 1400 },
	{ id = 2136, chance = 800 },
	{ id = 2452, chance = 600 },
	{ id = 2514, chance = 500 },
	{ id = 33579, chance = 200 },
	{ id = 33583, chance = 110 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -700 },
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -300,
		maxDamage = -1100,
		range = 7,
		shootEffect = CONST_ANI_POWERBOLT,
		target = true,
	},
	{
		name = "combat",
		interval = 2400,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -400,
		maxDamage = -500,
		range = 7,
		shootEffect = CONST_ANI_ENERGYBALL,
		target = true,
	},
	{
		name = "combat",
		interval = 2700,
		chance = 20,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -500,
		maxDamage = -600,
		range = 7,
		radius = 4,
		effect = CONST_ME_HOLYDAMAGE,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 86,
	{ name = "combat", interval = 1500, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 50 },
	{ type = COMBAT_FIREDAMAGE, percent = 50 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
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
