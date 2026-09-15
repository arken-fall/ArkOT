local mType = Game.createMonsterType("Cobra Vizier")
local monster = {}

monster.description = "a cobra vizier"
monster.experience = 7650
monster.outfit = {
	lookType = 1217,
	lookHead = 19,
	lookBody = 19,
	lookLegs = 67,
	lookFeet = 78,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1824
monster.bestiary = {
	race = "Human",
	class = "Human",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Cobra Bastion.",
}

monster.health = 8500
monster.maxHealth = 8500
monster.race = "blood"
monster.corpse = 31639
monster.speed = 160
monster.manaCost = 0

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
	{ text = "COMBINE FORCES MY BRETHEN!", yell = true },
	{ text = "Feel the cobras wrath!", yell = false },
	{ text = "OH NO, YOU WON'T!", yell = true },
}

monster.loot = {
	{ id = 2152, chance = 85480, maxCount = 4 },
	{ id = 2181, chance = 43000 },
	{ id = 2182, chance = 20970 },
	{ id = 35655, chance = 16130 },
	{ id = 7903, chance = 13710 },
	{ id = 18419, chance = 10805 },
	{ id = 7886, chance = 9680 },
	{ id = 7632, chance = 8870 },
	{ id = 2156, chance = 6450 },
	{ id = 2127, chance = 5650 },
	{ id = 30499, chance = 4840 },
	{ id = 18421, chance = 3230 },
	{ id = 18420, chance = 3230 },
	{ id = 2409, chance = 2420 },
	{ id = 18414, chance = 2420 },
	{ id = 2155, chance = 1610 },
	{ id = 24849, chance = 1610, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -480 },
	{ name = "explosion wave", interval = 2000, chance = 15, minDamage = -280, maxDamage = -400, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -350,
		maxDamage = -520,
		radius = 4,
		shootEffect = CONST_ANI_SMALLEARTH,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{ name = "death chain", interval = 4000, chance = 30, minDamage = -550, maxDamage = -800, range = 3, target = true },
}

monster.defenses = {
	defense = 82,
	armor = 82,
	mitigation = 2.31,
	{ name = "speed", interval = 2000, chance = 8, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 5000, speed = 250 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

-- Canary-only callback, not bound by BlackTek:
-- mType.onSpawn = function(monster)
-- 	monster:handleCobraOnSpawn()
-- end

mType:register(monster)
