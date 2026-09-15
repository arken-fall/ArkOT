local mType = Game.createMonsterType("Redeemed Soul")
local monster = {}

monster.description = "a redeemed soul"
monster.experience = 0
monster.outfit = {
	lookType = 714,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1138
monster.bestiary = {
	race = "Magical",
	class = "Magical",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Tainted Caves in the Green Claw Swamp (under the right conditions).",
}

monster.health = 250
monster.maxHealth = 250
monster.race = "undead"
monster.corpse = 21978
monster.speed = 70
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 250,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 250

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ting-a-ling.", yell = false },
	{ text = "Free ... finally.", yell = false },
}

monster.loot = {}

monster.attacks = {}

monster.defenses = {
	defense = 15,
	armor = 12,
	mitigation = 0.64,
	{ name = "speed", interval = 2000, chance = 8, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000, speed = 240 },
	{ name = "combat", interval = 2000, chance = 100, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 60 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 100 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
