local mType = Game.createMonsterType("The Brainstealer")
local monster = {}

monster.description = "The Brainstealer"
monster.experience = 72000
monster.outfit = {
	lookType = 1412,
	lookHead = 94,
	lookBody = 88,
	lookLegs = 88,
	lookFeet = 114,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2055,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 300000
monster.maxHealth = monster.health
monster.race = "undead"
monster.corpse = 36843
monster.speed = 425

monster.maxSummons = 2
monster.summons = {
	{ name = "brain parasite", chance = 20, interval = 4000, max = 1 },
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0

monster.loot = {
	{ id = 2152, mincount = 10, maxcount = 50, chance = 100000 },
	{ id = 2160, mincount = 1, maxcount = 5, chance = 100000 },
	{ id = 2153, chance = 50000 },
	{ id = 7440, chance = 50000 },
	{ id = 47306, chance = 50000 },
	{ id = 36429, chance = 50000 },
	{ id = 26030, chance = 50000 },
	{ id = 36427, chance = 50000 },
	{ id = 39231, chance = 6000 },
	{ id = 39232, chance = 5000 },
	{ id = 39233, chance = 2500 },
	{ id = 39115, chance = 180 },
	{ id = 48225, chance = 180 },
	{ id = 39118, chance = 240 },
	{ id = 39119, chance = 225 },
	{ id = 39112, chance = 210 },
	{ id = 39114, chance = 250 },
	{ id = 39105, chance = 130 },
	{ id = 39109, chance = 110 },
	{ id = 39107, chance = 320 },
	{ id = 48137, chance = 150 },
	{ id = 39104, chance = 180 },
	{ id = 39111, chance = 160 },
	{ id = 39120, chance = 170 },
	{ id = 39121, chance = 190 },
	{ id = 39122, chance = 200 },
	{ id = 39116, chance = 180 },
	{ id = 39106, chance = 140 },
	{ id = 39110, chance = 120 },
	{ id = 39108, chance = 100 },
	{ id = 39117, chance = 80 },
	{ id = 39123, chance = 60 },
	{ id = 39113, chance = 50 },
	{ id = 48138, chance = 60 },
	{ id = 39272, chance = 30 },
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = 0, maxDamage = -900 },
	{
		name = "combat",
		type = COMBAT_DEATHDAMAGE,
		interval = 2000,
		chance = 20,
		radius = 4,
		minDamage = -1200,
		maxDamage = -1900,
		effect = CONST_ME_MORTAREA,
		shootEffect = CONST_ANI_SUDDENDEATH,
		target = true,
		range = 7,
	},
	{ name = "combat", type = COMBAT_LIFEDRAIN, interval = 2000, chance = 20, radius = 4, minDamage = -700, maxDamage = -1000, effect = CONST_ME_DRAWBLOOD },
	{
		name = "combat",
		type = COMBAT_LIFEDRAIN,
		interval = 2000,
		chance = 10,
		length = 8,
		spread = 0,
		minDamage = -1200,
		maxDamage = -1600,
		effect = CONST_ME_ELECTRICALSPARK,
	},
}

monster.defenses = {
	defense = 78,
	armor = 78,
	mitigation = 3.27,
	{ name = "combat", type = COMBAT_HEALING, chance = 15, interval = 2000, minDamage = 1450, maxDamage = 5350, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 3 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "invisible", condition = true },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of death unleashed!", yell = false },
	{ text = "I will rule again and my realm of death will span the world!", yell = false },
	{ text = "My lich-knights will conquer this world for me!", yell = false },
}

mType:register(monster)
