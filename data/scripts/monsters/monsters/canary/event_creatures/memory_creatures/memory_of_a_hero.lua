local mType = Game.createMonsterType("Memory of a Hero")
local monster = {}

monster.description = "a memory of a hero"
monster.experience = 1750
monster.outfit = {
	lookType = 73,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 3850
monster.maxHealth = 3850
monster.race = "blood"
monster.corpse = 18134
monster.speed = 140
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
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
	{ id = 2114, chance = 80 },
	{ id = 2120, chance = 2190 },
	{ id = 2121, chance = 4910 },
	{ id = 2148, chance = 59500, maxCount = 80 },
	{ id = 2377, chance = 1500 },
	{ id = 2391, chance = 870 },
	{ id = 2392, chance = 550 },
	{ id = 2652, chance = 8000 },
	{ id = 2666, chance = 8200, maxCount = 3 },
	{ id = 2681, chance = 19850 },
	{ id = 2744, chance = 20450 },
	{ id = 39879, chance = 2006 },
	{ id = 7364, chance = 11400, maxCount = 4 },
	{ id = 7591, chance = 720 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -170 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = 0,
		maxDamage = -120,
		range = 7,
		shootEffect = CONST_ANI_ARROW,
		target = false,
	},
}

monster.defenses = {
	defense = 40,
	armor = 40,
	mitigation = 1.5,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 200, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
