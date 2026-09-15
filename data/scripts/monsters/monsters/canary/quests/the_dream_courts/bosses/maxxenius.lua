local mType = Game.createMonsterType("Maxxenius")
local monster = {}

monster.description = "Maxxenius"
monster.experience = 55000
monster.outfit = {
	lookType = 1142,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 320000
monster.maxHealth = 320000
monster.race = "blood"
monster.corpse = 30151
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1697,
	bossRace = RARITY_NEMESIS,
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
}

monster.loot = {
	{ id = 26185, chance = 14290 },
	{ id = 26185, chance = 3570 },
	{ id = 26187, chance = 10710 },
	{ id = 26189, chance = 14290 },
	{ id = 26189, chance = 7140 },
	{ id = 26198, chance = 14290 },
	{ id = 26198, chance = 3570 },
	{ id = 26199, chance = 10710 },
	{ id = 26200, chance = 17860 },
	{ id = 2156, chance = 28570 },
	{ id = 7414, chance = 3570 },
	{ id = 7439, chance = 28570, maxCount = 19 },
	{ id = 2158, chance = 10710 },
	{ id = 7443, chance = 10710 },
	{ id = 7427, chance = 7140 },
	{ id = 2160, chance = 14290, maxCount = 3 },
	{ id = 34155, chance = 3570 },
	{ id = 26191, chance = 82140 },
	{ id = 34281, chance = 17860 },
	{ id = 7633, chance = 21430 },
	{ id = 9971, chance = 14290 },
	{ id = 25377, chance = 60710 },
	{ id = 2155, chance = 28570 },
	{ id = 5892, chance = 42860 },
	{ id = 5904, chance = 3570 },
	{ id = 7440, chance = 42860, maxCount = 6 },
	{ id = 47306, chance = 42860, maxCount = 6 },
	{ id = 34166, chance = 7140 },
	{ id = 26165, chance = 85710 },
	{ id = 34278, chance = 14290 },
	{ id = 2114, chance = 89290 },
	{ id = 2152, chance = 100000, maxCount = 6 },
	{ id = 34371, chance = 21430 },
	{ id = 2123, chance = 7140 },
	{ id = 31758, chance = 57140, maxCount = 194 },
	{ id = 25172, chance = 96430, maxCount = 3 },
	{ id = 2436, chance = 21430 },
	{ id = 5809, chance = 14290 },
	{ id = 26031, chance = 85710, maxCount = 32 },
	{ id = 26029, chance = 42860, maxCount = 14 },
	{ id = 26030, chance = 64290, maxCount = 20 },
	{ id = 2153, chance = 3570 },
	{ id = 2154, chance = 50000, maxCount = 2 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -500, maxDamage = -1000 },
	{
		name = "energy beam",
		interval = 2000,
		chance = 10,
		minDamage = -500,
		maxDamage = -1200,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
	{
		name = "energy wave",
		interval = 2000,
		chance = 10,
		minDamage = -500,
		maxDamage = -1200,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = false,
	},
}

monster.defenses = {
	defense = 60,
	armor = 60,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 600 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.heals = {
	{ type = COMBAT_ENERGYDAMAGE, percent = 500 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
