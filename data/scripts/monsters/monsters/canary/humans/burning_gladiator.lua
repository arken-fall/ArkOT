local mType = Game.createMonsterType("Burning Gladiator")
local monster = {}

monster.description = "a burning gladiator"
monster.experience = 7350
monster.outfit = {
	lookType = 541,
	lookHead = 95,
	lookBody = 113,
	lookLegs = 3,
	lookFeet = 3,
	lookAddons = 1,
	lookMount = 0,
}

monster.events = {
	"FafnarMissionsDeath",
}

monster.raceId = 1798
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Issavi Sewers, Kilmaresh Catacombs and Kilmaresh Mountains above and under ground.",
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "blood"
monster.corpse = 31646
monster.speed = 145
monster.manaCost = 0

monster.faction = FACTION_FAFNAR
monster.enemyFactions = { FACTION_PLAYER, FACTION_ANUMA }

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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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
	{ text = "Burn, infidel!", yell = false },
	{ text = "Only the Wild Sun shall shine down on this world!", yell = false },
	{ text = "Praised be Fafnar, the Smiter!", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 100000, maxCount = 3 },
	{ id = 35434, chance = 6600 },
	{ id = 35424, chance = 5600 },
	{ id = 35426, chance = 5600 },
	{ id = 35427, chance = 5600 },
	{ id = 2201, chance = 4700 },
	{ id = 7889, chance = 4100 },
	{ id = 7890, chance = 3700 },
	{ id = 2161, chance = 3000 },
	{ id = 7891, chance = 2700 },
	{ id = 35327, chance = 2400 },
	{ id = 2198, chance = 2100 },
	{ id = 7895, chance = 2000 },
	{ id = 7901, chance = 1700 },
	{ id = 7893, chance = 1400 },
	{ id = 11355, chance = 850 },
	{ id = 35365, chance = 570 },
	{ id = 35319, chance = 140 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -550 },
	{ name = "firering", interval = 2000, chance = 10, minDamage = -300, maxDamage = -500, target = false },
	{ name = "firex", interval = 2000, chance = 15, minDamage = -300, maxDamage = -500, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 17,
		type = COMBAT_FIREDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		radius = 2,
		effect = CONST_ME_FIREATTACK,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -300,
		maxDamage = -500,
		length = 3,
		spread = 0,
		effect = CONST_ME_ENERGYHIT,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 89,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 20 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
