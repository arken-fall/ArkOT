local mType = Game.createMonsterType("Gorger Inferniarch")
local monster = {}

monster.description = "a gorger inferniarch"
monster.experience = 7180
monster.outfit = {
	lookType = 1797,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2604
monster.bestiary = {
	race = "Demon",
	class = "Demon",
	toKill = 2500,
	firstUnlock = 50,
	secondUnlock = 500,
	charmPoints = 50,
	stars = 4,
	occurrence = 1,
	locations = "Azzilon Castle.",
}

monster.health = 9450
monster.maxHealth = 9450
monster.race = "fire"
monster.corpse = 50010
monster.speed = 160
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
	{ text = "Kar Ath... Ul", yell = true },
	{ text = "Rezzz Kor ... Urrrgh!", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 5000, maxCount = 24 },
	{ id = 7452, chance = 1500 },
	{ id = 2169, chance = 800 },
	{ id = 2157, chance = 4761 },
	{ id = 2146, chance = 1500, maxCount = 3 },
	{ id = 2209, chance = 1000 },
	{ id = 48031, chance = 1000 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -199, maxDamage = -503 },
	{ name = "extended fire chain", interval = 3000, chance = 15, minDamage = -1, maxDamage = -400, range = 7 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -1, maxDamage = -500, effect = CONST_ME_REAPER, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -1,
		maxDamage = -500,
		radius = 6,
		effect = CONST_ME_BLACKSMOKE,
		target = false,
	},
}

monster.defenses = {
	defense = 15,
	armor = 74,
	mitigation = 1.99,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 100, maxDamage = 150, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 10 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
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
