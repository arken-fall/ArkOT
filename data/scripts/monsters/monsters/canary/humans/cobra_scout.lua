local mType = Game.createMonsterType("Cobra Scout")
local monster = {}

monster.description = "a cobra scout"
monster.experience = 7310
monster.outfit = {
	lookType = 1217,
	lookHead = 1,
	lookBody = 1,
	lookLegs = 102,
	lookFeet = 78,
	lookAddons = 2,
	lookMount = 0,
}

monster.raceId = 1776
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
monster.corpse = 31635
monster.speed = 150
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
	targetDistance = 4,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Think I can't see you? Think again...", yell = false },
	{ text = "You don't stand a chance!", yell = false },
	{ text = "What are you looking for?", yell = false },
}

monster.loot = {
	{ id = 2152, chance = 74000, maxCount = 9 },
	{ id = 7850, chance = 19490, maxCount = 28 },
	{ id = 2197, chance = 6800 },
	{ id = 9971, chance = 5750, maxCount = 1 },
	{ id = 20098, chance = 13800 },
	{ id = 24850, chance = 23800, maxCount = 5 },
	{ id = 35655, chance = 15450 },
	{ id = 2149, chance = 3000, maxCount = 2 },
	{ id = 2153, chance = 1300 },
	{ id = 2154, chance = 3060 },
	{ id = 2155, chance = 1210 },
	{ id = 2156, chance = 4800 },
	{ id = 10219, chance = 5100 },
	{ id = 18415, chance = 2130 },
	{ id = 26189, chance = 740 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -500 },
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -350,
		maxDamage = -450,
		shootEffect = CONST_ANI_SNIPERARROW,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 16,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -300,
		maxDamage = -420,
		radius = 4,
		shootEffect = CONST_ANI_POISONARROW,
		effect = CONST_ME_GREEN_RINGS,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 12,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -300,
		maxDamage = -380,
		radius = 3,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
}

monster.defenses = {
	defense = 81,
	armor = 81,
	mitigation = 2.16,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
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

-- Canary-only, not available in BlackTek:
-- mType.onSpawn = function(monster)
-- 	monster:handleCobraOnSpawn()
-- end

mType:register(monster)
