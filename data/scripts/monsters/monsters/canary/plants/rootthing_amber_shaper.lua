local mType = Game.createMonsterType("Rootthing Amber Shaper")
local monster = {}

monster.description = "a rootthing amber shaper"
monster.experience = 12400
monster.outfit = {
	lookType = 1762,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 2539
monster.bestiary = {
	race = "Plant",
	class = "Plant",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Podzilla Stalk",
}

monster.health = 15000
monster.maxHealth = 15000
monster.race = "venom"
monster.corpse = 48402
monster.speed = 185
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
	{ text = "KNARR!", yell = false },
	{ text = "RATTLE!", yell = false },
	{ text = "CROAK!", yell = false },
}

monster.loot = {
	{ id = 2148, chance = 100000, maxCount = 200 },
	{ id = 2152, chance = 88010, maxCount = 37 },
	{ id = 46914, chance = 6840 },
	{ id = 46818, chance = 5980 },
	{ id = 46915, chance = 5980 },
	{ id = 2160, chance = 2560 },
	{ id = 31702, chance = 2560 },
	{ id = 36320, chance = 1710 },
	{ id = 7426, chance = 850 },
	{ id = 7422, chance = 850 },
	{ id = 5741, chance = 1310 },
	{ id = 36318, chance = 1110 },
	{ id = 36319, chance = 1110 },
	{ id = 45681, chance = 110 },
	{ id = 45682, chance = 110 },
	{ id = 45686, chance = 110 },
	{ id = 46910, chance = 110 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_EARTHDAMAGE, minDamage = -550, maxDamage = -750, effect = CONST_ME_SMALLPLANTS, target = true },
	{
		name = "combat",
		interval = 2500,
		chance = 17,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -600,
		maxDamage = -800,
		radius = 2,
		effect = CONST_ME_STONES,
		target = true,
	},
	{ name = "rotthingshaper", interval = 2000, chance = 18, target = false },
	{ name = "poison chain", interval = 2000, chance = 15, minDamage = -600, maxDamage = -900 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.75,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 500, maxDamage = 800, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 25 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
