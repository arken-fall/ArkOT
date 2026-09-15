local mType = Game.createMonsterType("Ravenous Hunger")
local monster = {}

monster.description = "Ravenous Hunger"
monster.experience = 0
monster.outfit = {
	lookType = 556,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"CultsOfTibiaBossDeath",
}

monster.bosstiary = {
	bossRaceId = 1427,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 100000
monster.maxHealth = 100000
monster.race = "blood"
monster.corpse = 6323
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 4
monster.summons = {
	{ name = "Mutated Bat", chance = 100, interval = 2000, max = 1 },
	{ name = "Mutated Bat", chance = 100, interval = 2000, max = 1 },
	{ name = "Mutated Bat", chance = 100, interval = 2000, max = 1 },
	{ name = "Mutated Bat", chance = 100, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "SU-*burp* SUFFEEER!", yell = false },
}

monster.loot = {
	{ id = 31742, chance = 67000 },
	{ id = 2146, chance = 21000, maxCount = 10 },
	{ id = 8472, chance = 33230, maxCount = 5 },
	{ id = 2154, chance = 12000 },
	{ id = 7633, chance = 5000 },
	{ id = 2152, chance = 68299, maxCount = 30 },
	{ id = 7895, chance = 18000 },
	{ id = 10219, chance = 15000 },
	{ id = 2664, chance = 9000 },
	{ id = 25377, chance = 1532 },
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2149, chance = 19000, maxCount = 10 },
	{ id = 7590, chance = 31230, maxCount = 5 },
	{ id = 2156, chance = 12000 },
	{ id = 24637, chance = 11000 },
	{ id = 31743, chance = 42000 },
	{ id = 31741, chance = 32000 },
	{ id = 12410, chance = 35000 },
	{ id = 31702, chance = 4500 },
	{ id = 2507, chance = 16000 },
	{ id = 2145, chance = 21000, maxCount = 10 },
	{ id = 8473, chance = 28230, maxCount = 5 },
	{ id = 26191, chance = 53000, maxCount = 5 },
	{ id = 2155, chance = 12000 },
	{ id = 12608, chance = 4000 },
	{ id = 18411, chance = 10000 },
	{ id = 26165, chance = 100000 },
	{ id = 12630, chance = 400 },
	{ id = 25172, chance = 2500 },
	{ id = 2505, chance = 3000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
}

monster.defenses = {
	defense = 50,
	armor = 35,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
