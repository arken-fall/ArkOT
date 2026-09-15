local mType = Game.createMonsterType("Bony Sea Devil")
local monster = {}

monster.description = "a bony sea devil"
monster.experience = 19470
monster.outfit = {
	lookType = 1294,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1926
monster.bestiary = {
	race = "Undead",
	class = "Undead",
	toKill = 5000,
	firstUnlock = 200,
	secondUnlock = 2000,
	charmPoints = 100,
	stars = 5,
	occurrence = 0,
	locations = "Ebb and Flow.",
}

monster.events = {
	"FourthTaintBossesPrepareDeath",
}

monster.health = 24000
monster.maxHealth = 24000
monster.race = "undead"
monster.corpse = 33797
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
	level = 4,
	color = 143,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Bling.", yell = false },
	{ text = "Clank.", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 59290 },
	{ id = 8473, chance = 19470, maxCount = 6 },
	{ id = 9971, chance = 15040 },
	{ id = 7633, chance = 9730 },
	{ id = 2183, chance = 7960 },
	{ id = 24849, chance = 6190 },
	{ id = 18421, chance = 5310 },
	{ id = 8922, chance = 4420 },
	{ id = 2153, chance = 4420 },
	{ id = 37344, chance = 3540 },
	{ id = 31736, chance = 2650, maxCount = 3 },
	{ id = 8911, chance = 1770 },
	{ id = 8910, chance = 1770 },
	{ id = 8889, chance = 1770 },
	{ id = 37261, chance = 880 },
	{ id = 37352, chance = 880 },
	{ id = 7896, chance = 880 },
	{ id = 18412, chance = 1210 },
	{ id = 37439, chance = 15 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -900,
		maxDamage = -1350,
		length = 5,
		spread = 3,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -700,
		maxDamage = -1000,
		radius = 7,
		effect = CONST_ME_BIGCLOUDS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -950,
		maxDamage = -1260,
		range = 7,
		shootEffect = CONST_ANI_SNOWBALL,
		effect = CONST_ME_ICEATTACK,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_ICEDAMAGE,
		minDamage = -950,
		maxDamage = -1100,
		range = 7,
		radius = 5,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEAREA,
		target = true,
	},
	{ name = "ice chain", interval = 2000, chance = 15, minDamage = -1100, maxDamage = -1300, range = 7 },
	{ name = "soulwars fear", interval = 2000, chance = 1, target = true },
	{ name = "destroy magic walls", interval = 1000, chance = 30 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 3.34,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 60 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval)
	monster:tryTeleportToPlayer("Get out the way!")
end

mType:register(monster)
