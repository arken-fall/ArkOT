local mType = Game.createMonsterType("Angry Sugar Fairy")
local monster = {}

monster.description = "an angry sugar fairy"
monster.experience = 3100
monster.outfit = {
	lookType = 1747,
	lookHead = 16,
	lookBody = 5,
	lookLegs = 54,
	lookFeet = 93,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2552
monster.bestiary = {
	race = "Fey",
	class = "Fey",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Dessert Dungeons, Candy Carnival.",
}

monster.health = 3000
monster.maxHealth = 3000
monster.race = "undead"
monster.corpse = 48340
monster.speed = 120
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
	canWalkOnFire = false,
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
	{ text = "Don't trample the beautiful sprinkles! That makes me angry!", yell = false },
	{ text = "No sweet sugar jewellery for you, intruder!", yell = false },
	{ text = "This is not the Candy Carnival! You should leave!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 93020, maxCount = 11 },
	{ id = 7761, chance = 8830, maxCount = 4 },
	{ id = 31694, chance = 7410 },
	{ id = 7759, chance = 5860, maxCount = 4 },
	{ id = 18416, chance = 5820 },
	{ id = 18414, chance = 4040 },
	{ id = 7760, chance = 3840, maxCount = 3 },
	{ id = 2189, chance = 3770 },
	{ id = 2143, chance = 2710, maxCount = 3 },
	{ id = 31051, chance = 2320 },
	{ id = 2133, chance = 1890 },
	{ id = 46701, chance = 1650 },
	{ id = 8900, chance = 960 },
	{ id = 31701, chance = 760 },
	{ id = 46699, chance = 760, maxCount = 10 },
	{ id = 2214, chance = 730 },
	{ id = 8873, chance = 360 },
	{ id = 2157, chance = 230 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -110 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		minDamage = -100,
		maxDamage = -230,
		range = 6,
		shootEffect = CONST_ANI_SMALLICE,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		minDamage = -130,
		maxDamage = -280,
		range = 5,
		radius = 3,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ELECTRICALSPARK,
		target = true,
	},
}

monster.defenses = {
	defense = 37,
	armor = 37,
	mitigation = 1.1,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_CACAO, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 40 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
