local mType = Game.createMonsterType("Brachiodemon")
local monster = {}

monster.description = "a brachiodemon"
monster.experience = 15770
monster.outfit = {
	lookType = 1299,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1930
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Claustrophobic Inferno.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 25000
monster.maxHealth = 25000
monster.race = "blood"
monster.corpse = 33817
monster.speed = 220
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the heat!", yell = false },
	{ text = "Hand over your life.", yell = false },
	{ text = "I can give you a hand... or two.", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 58990 },
	{ id = 8473, chance = 29110, maxCount = 4 },
	{ id = 37268, chance = 5490 },
	{ id = 37269, chance = 3710 },
	{ id = 2438, chance = 3290 },
	{ id = 2445, chance = 1690 },
	{ id = 7456, chance = 1600 },
	{ id = 8902, chance = 1180 },
	{ id = 2436, chance = 930 },
	{ id = 26187, chance = 930 },
	{ id = 2498, chance = 840 },
	{ id = 7422, chance = 840 },
	{ id = 23542, chance = 760 },
	{ id = 37355, chance = 590 },
	{ id = 2432, chance = 590 },
	{ id = 18450, chance = 420 },
	{ id = 7412, chance = 420 },
	{ id = 2514, chance = 420 },
	{ id = 7404, chance = 340 },
	{ id = 23539, chance = 170 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -950 },
	{
		name = "combat",
		interval = 2000,
		chance = 24,
		type = COMBAT_FIREDAMAGE,
		minDamage = -1100,
		maxDamage = -1550,
		radius = 4,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -900,
		maxDamage = -1280,
		radius = 4,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -1150,
		maxDamage = -1460,
		range = 7,
		effect = CONST_ANI_SUDDENDEATH,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -950,
		maxDamage = -1100,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = true,
	},
	{ name = "destroy magic walls", interval = 1000, chance = 30 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.75,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -25 },
	{ type = COMBAT_HOLYDAMAGE, percent = -35 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval)
	monster:tryTeleportToPlayer("Burn in hell!")
end

mType:register(monster)
