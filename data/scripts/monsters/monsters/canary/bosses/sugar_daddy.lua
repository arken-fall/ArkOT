local mType = Game.createMonsterType("Sugar Daddy")
local monster = {}

monster.description = "Sugar Daddy"
monster.experience = 15550
monster.outfit = {
	lookType = 1764,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2562,
	bossRace = RARITY_BANE,
}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "blood"
monster.corpse = 48416
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 98
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "SUGAR!!!", yell = false },
	{ text = "Sweet vengeance!", yell = false },
	{ text = "Let me have a bite!", yell = false },
	{ text = "YOU HAVE BAD BREATH, TAKE A MINT!!!", yell = false },
	{ text = "I LOOOOOOVE CHOCOLATE TRUFFLES!!!", yell = false },
	{ text = "Yummy!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 95 },
	{ id = 2152, chance = 100000, maxCount = 11 },
	{ id = 7759, chance = 8900 },
	{ id = 2156, chance = 94465, maxCount = 1 },
	{ id = 36427, chance = 5600, maxCount = 1 },
	{ id = 46579, chance = 1000 },
	{ id = 45673, chance = 555 },
	{ id = 45674, chance = 1009 },
	{ id = 45669, chance = 555 },
	{ id = 45670, chance = 555 },
	{ id = 45671, chance = 2300 },
	{ id = 45672, chance = 7650 },
	{ id = 46704, chance = 11655, maxCount = 1 },
	{ id = 46700, chance = 46555, maxCount = 1 },
	{ id = 46702, chance = 15300, maxCount = 1 },
	{ id = 45672, chance = 14650, maxCount = 1 },
	{ id = 46699, chance = 54465, maxCount = 1 },
	{ id = 46706, chance = 2367, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 20, minDamage = 0, maxDamage = -550 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		range = 6,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -200,
		maxDamage = -300,
		radius = 12,
		effect = CONST_ME_PIXIE_EXPLOSION,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -250,
		maxDamage = -410,
		radius = 12,
		effect = CONST_ME_HEARTS,
		target = false,
	},
}

monster.defenses = {
	defense = 65,
	armor = 55,
	{ name = "combat", interval = 3000, chance = 25, type = COMBAT_HEALING, minDamage = 400, maxDamage = 1500, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000, speed = 320 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
