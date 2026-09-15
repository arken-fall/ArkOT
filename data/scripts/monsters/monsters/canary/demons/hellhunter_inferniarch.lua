local mType = Game.createMonsterType("Hellhunter Inferniarch")
local monster = {}

monster.description = "a hellhunter inferniarch"
monster.experience = 8100
monster.outfit = {
	lookType = 1793,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2600
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 2500,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Azzilon Castle Catacombs.",
}

monster.health = 11300
monster.maxHealth = 11300
monster.race = "fire"
monster.corpse = 49994
monster.speed = 175
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
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	isPreyExclusive = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Ardash... El...!", yell = true },
	{ text = "Urrrglll!", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 5000, maxCount = 35 },
	{ id = 7368, chance = 3000, maxCount = 10 },
	{ id = 48027, chance = 1500 },
	{ id = 2150, chance = 3000, maxCount = 4 },
	{ id = 2490, chance = 1500 },
	{ id = 7364, chance = 1500, maxCount = 5 },
	{ id = 7365, chance = 1000, maxCount = 5 },
	{ id = 6300, chance = 900 },
	{ id = 18419, chance = 900 },
}

monster.attacks = {
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -219,
		maxDamage = -261,
		range = 4,
		shootEffect = CONST_ANI_BOLT,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 15,
	armor = 73,
	mitigation = 2.19,
}

monster.elements = {
	{ type = COMBAT_DEATHDAMAGE, percent = -15 },
	{ type = COMBAT_EARTHDAMAGE, percent = -15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
