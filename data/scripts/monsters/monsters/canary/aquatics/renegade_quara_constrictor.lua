local mType = Game.createMonsterType("Renegade Quara Constrictor")
local monster = {}

monster.description = "a renegade quara constrictor"
monster.experience = 1250
monster.outfit = {
	lookType = 46,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1097
monster.bestiary = {
	race = "Aquatic",
	class = "Aquatic",
	toKill = 1000,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 25,
	stars = 3,
	occurrence = 2,
	locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 1500
monster.maxHealth = 1500
monster.race = "blood"
monster.corpse = 6065
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 0,
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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 20

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ id = 2152, chance = 79280, maxCount = 3 },
	{ id = 12443, chance = 15240 },
	{ id = 2178, chance = 6880 },
	{ id = 2214, chance = 5580 },
	{ id = 7590, chance = 5390, maxCount = 5 },
	{ id = 2670, chance = 5300, maxCount = 4 },
	{ id = 2150, chance = 5200, maxCount = 2 },
	{ id = 2147, chance = 4650, maxCount = 2 },
	{ id = 7368, chance = 4460, maxCount = 7 },
	{ id = 15649, chance = 3720, maxCount = 10 },
	{ id = 18414, chance = 1210 },
	{ id = 8911, chance = 740 },
	{ id = 5895, chance = 370 },
	{ id = 2114, chance = 190 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 60, attack = 40, effect = CONST_ME_DRAWBLOOD },
	{ name = "quara constrictor freeze", interval = 2000, chance = 10, target = false },
	{ name = "quara constrictor electrify", interval = 2000, chance = 10, range = 1, target = false },
}

monster.defenses = {
	defense = 20,
	armor = 35,
	mitigation = 1.04,
	{ name = "combat", interval = 3000, chance = 35, type = COMBAT_HEALING, minDamage = 150, maxDamage = 300, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
