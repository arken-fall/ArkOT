local mType = Game.createMonsterType("Urmahlullu the Weakened")
local monster = {}

monster.description = "Urmahlullu the Weakened"
monster.experience = 55000
monster.outfit = {
	lookType = 1197,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1811,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 100000
monster.maxHealth = 512000
monster.race = "blood"
monster.corpse = 31413
monster.speed = 95
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You will regret this!", yell = false },
	{ text = "Now you have to die!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 9 },
	{ id = 2155, chance = 100000, maxCount = 2 },
	{ id = 26191, chance = 100000 },
	{ id = 26029, chance = 73080, maxCount = 31 },
	{ id = 26031, chance = 53850, maxCount = 28 },
	{ id = 2156, chance = 53850, maxCount = 2 },
	{ id = 7889, chance = 30770 },
	{ id = 7439, chance = 23080, maxCount = 15 },
	{ id = 7443, chance = 23080, maxCount = 15 },
	{ id = 7899, chance = 23080 },
	{ id = 31758, chance = 19230, maxCount = 168 },
	{ id = 7838, chance = 19230, maxCount = 175 },
	{ id = 26030, chance = 19230, maxCount = 8 },
	{ id = 7890, chance = 19230 },
	{ id = 9971, chance = 19230 },
	{ id = 2158, chance = 15380 },
	{ id = 7900, chance = 15380 },
	{ id = 2154, chance = 15380 },
	{ id = 2160, chance = 11540, maxCount = 5 },
	{ id = 25172, chance = 7690, maxCount = 5 },
	{ id = 2153, chance = 7690 },
	{ id = 35606, chance = 7690 },
	{ id = 7632, chance = 7690 },
	{ id = 7440, chance = 3850 },
	{ id = 35596, chance = 1850 },
	{ id = 34283, chance = 3850 },
	{ id = 35259, chance = 3850 },
	{ id = 35556, chance = 3850 },
	{ id = 35605, chance = 3850 },
	{ id = 35599, chance = 1850 },
	{ id = 35604, chance = 6980 },
	{ id = 7895, chance = 6400 },
	{ id = 34282, chance = 3490 },
	{ id = 34281, chance = 3490 },
	{ id = 34570, chance = 1740 },
	{ id = 35555, chance = 580 },
	{ id = 35557, chance = 580 },
	{ id = 35607, chance = 250 },
	{ id = 34521, chance = 1160 },
	{ id = 34570, chance = 160 },
	{ id = 35555, chance = 160 },
	{ id = 35556, chance = 160 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -50, maxDamage = -1100 },
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -800,
		radius = 4,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -550,
		maxDamage = -800,
		radius = 3,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{ name = "urmahlulluring", interval = 2000, chance = 18, minDamage = -450, maxDamage = -600, target = false },
}

monster.defenses = {
	defense = 84,
	armor = 84,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
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
