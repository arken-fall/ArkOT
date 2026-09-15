local mType = Game.createMonsterType("Drume")
local monster = {}

monster.description = "Drume"
monster.experience = 25000
monster.outfit = {
	lookType = 1317,
	lookHead = 38,
	lookBody = 76,
	lookLegs = 57,
	lookFeet = 114,
	lookAddons = 2,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 1957,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 80000
monster.maxHealth = 80000
monster.race = "blood"
monster.corpse = 33973
monster.speed = 130
monster.manaCost = 0

monster.faction = FACTION_LIONUSURPERS
monster.enemyFactions = { FACTION_LION, FACTION_PLAYER }

monster.maxSummons = 1
monster.summons = {
	{ name = "preceptor lazare", chance = 10, interval = 8000, max = 1 },
	{ name = "grand commander soeren", chance = 10, interval = 8000, max = 1 },
	{ name = "grand chaplain gaunder", chance = 10, interval = 8000, max = 1 },
}

monster.changeTarget = {
	interval = 4000,
	chance = 25,
}

monster.strategiesTarget = {
	nearest = 50,
	health = 20,
	damage = 20,
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
	canWalkOnEnergy = false,
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
	{ text = "I've studied the Cobras - I wield the secrets of the snake!", yell = false },
	{ text = "I am a true knight of the lion, you will never defeat the true order!", yell = false },
	{ text = "The Falcons will come to my aid in need!", yell = false },
}

monster.loot = {
	{ id = 26191, chance = 100000 },
	{ id = 2152, chance = 100000, maxCount = 5 },
	{ id = 26031, chance = 57831, maxCount = 20 },
	{ id = 26029, chance = 55723, maxCount = 20 },
	{ id = 2154, chance = 35843, maxCount = 2 },
	{ id = 2156, chance = 35542, maxCount = 2 },
	{ id = 26030, chance = 31627, maxCount = 6 },
	{ id = 31758, chance = 31325, maxCount = 100 },
	{ id = 7443, chance = 22590, maxCount = 10 },
	{ id = 7439, chance = 21988, maxCount = 10 },
	{ id = 47306, chance = 21988, maxCount = 10 },
	{ id = 2158, chance = 21687, maxCount = 2 },
	{ id = 7440, chance = 17771, maxCount = 10 },
	{ id = 2155, chance = 17470, maxCount = 2 },
	{ id = 7632, chance = 15060 },
	{ id = 9971, chance = 13253 },
	{ id = 2181, chance = 11145 },
	{ id = 2160, chance = 10241 },
	{ id = 2197, chance = 10241 },
	{ id = 25172, chance = 8735, maxCount = 3 },
	{ id = 7885, chance = 8735 },
	{ id = 7884, chance = 7831 },
	{ id = 37127, chance = 7229 },
	{ id = 8922, chance = 6024 },
	{ id = 2153, chance = 5723 },
	{ id = 7903, chance = 4819 },
	{ id = 7887, chance = 4518 },
	{ id = 34283, chance = 4217 },
	{ id = 34281, chance = 3012 },
	{ id = 8910, chance = 2410 },
	{ id = 37480, chance = 300 },
	{ id = 37481, chance = 300 },
	{ id = 37478, chance = 300 },
	{ id = 37479, chance = 350 },
	{ id = 37570, chance = 300 },
	{ id = 37569, chance = 300 },
	{ id = 37474, chance = 300 },
	{ id = 37477, chance = 350 },
	{ id = 37476, chance = 300 },
	{ id = 37482, chance = 300 },
	{ id = 37475, chance = 300 },
	{ id = 48130, chance = 300 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -1100, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		interval = 2700,
		chance = 25,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -850,
		maxDamage = -1150,
		length = 8,
		spread = 0,
		effect = CONST_ME_HOLYAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 3100,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -800,
		maxDamage = -1200,
		range = 7,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 3300,
		chance = 22,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -800,
		maxDamage = -1000,
		radius = 3,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 3700,
		chance = 24,
		type = COMBAT_ICEDAMAGE,
		minDamage = -700,
		maxDamage = -900,
		length = 4,
		spread = 0,
		effect = CONST_ME_ICEATTACK,
		target = false,
	},
	{ name = "singlecloudchain", interval = 2100, chance = 34, minDamage = -600, maxDamage = -1100, range = 4, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 82,
	{ name = "combat", interval = 4000, chance = 40, type = COMBAT_HEALING, minDamage = 300, maxDamage = 800, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 35 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
