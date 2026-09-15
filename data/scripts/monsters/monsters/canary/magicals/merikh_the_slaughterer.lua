local mType = Game.createMonsterType("Merikh the Slaughterer")
local monster = {}

monster.description = "Merikh the Slaughterer"
monster.experience = 1500
monster.outfit = {
	lookType = 103,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 2000
monster.maxHealth = 2000
monster.race = "blood"
monster.corpse = 6032
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	canPushCreatures = false,
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

monster.maxSummons = 2
monster.summons = {
	{ name = "green djinn", chance = 10, interval = 2000, max = 1 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your death will be slow and painful.", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 97250, maxCount = 120 },
	{ id = 5910, chance = 100000, maxCount = 4 },
	{ id = 12442, chance = 63900 },
	{ id = 2442, chance = 41650 },
	{ id = 7900, chance = 8400 },
	{ id = 7732, chance = 100 },
	{ id = 12426, chance = 100000 },
	{ id = 11227, chance = 58300 },
	{ id = 7589, chance = 41650, maxCount = 3 },
	{ id = 2149, chance = 2800, maxCount = 2 },
	{ id = 2063, chance = 100 },
	{ id = 7378, chance = 55550, maxCount = 3 },
	{ id = 2663, chance = 36100 },
	{ id = 2155, chance = 2800 },
	{ id = 2673, chance = 100, maxCount = 8 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -304 },
}

monster.defenses = {
	defense = 0,
	armor = 0,
	mitigation = 1.29,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 100, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 1 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -1 },
	{ type = COMBAT_HOLYDAMAGE, percent = -1 },
	{ type = COMBAT_DEATHDAMAGE, percent = 1 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
