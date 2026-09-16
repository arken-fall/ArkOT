local mType = Game.createMonsterType("Goshnar's Malice")
local monster = {}

monster.description = "Goshnar's Malice"
monster.experience = 75000
monster.outfit = {
	lookType = 1306,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"SoulWarBossesDeath",
	"Goshnar's-Malice",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33871
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1901,
	bossRace = RARITY_ARCHFOE,
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
	staticAttackChance = 95,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 95
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
	{ id = 2160, chance = 55000, minCount = 70, maxCount = 75 },
	{ id = 7632, chance = 1150 },
	{ id = 34283, chance = 10000, maxCount = 1 },
	{ id = 36317, chance = 10000, maxCount = 1 },
	{ id = 2153, chance = 6000, maxCount = 1 },
	{ id = 2158, chance = 10000, maxCount = 3 },
	{ id = 2156, chance = 10000, maxCount = 3 },
	{ id = 2155, chance = 10000, maxCount = 3 },
	{ id = 2154, chance = 10000, maxCount = 3 },
	{ id = 36427, chance = 6000, maxCount = 3 },
	{ id = 34275, chance = 10000, maxCount = 1 },
	{ id = 7443, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 7440, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 47306, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 7439, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 26029, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 26031, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 26030, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 37253, chance = 2000, maxCount = 1 },
	{ id = 37252, chance = 2000, maxCount = 1 },
	{ id = 37406, chance = 400 },
	{ id = 37402, chance = 400 },
	{ id = 37405, chance = 400 },
	{ id = 37348, chance = 400 },
	{ id = 37439, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{
		name = "combat",
		interval = 2000,
		chance = 22,
		type = COMBAT_ICEDAMAGE,
		minDamage = -2450,
		maxDamage = -4400,
		length = 10,
		spread = 4,
		effect = CONST_ME_ICEAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_ICEDAMAGE,
		minDamage = -2350,
		maxDamage = -3000,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_ICE,
		effect = CONST_ME_ICEAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 160,
	armor = 160,
	mitigation = 5.4,
	{ name = "speed", interval = 1000, chance = 20, effect = CONST_ME_MAGIC_RED, target = false, duration = 10000, speed = 500 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 1250, maxDamage = 3250, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
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

-- local zone = Zone.getByName("boss.goshnar's-malice")
-- local zonePositions = zone:getPositions()

local accumulatedTime = 0
local desiredInterval = 40000
-- Canary-only, not available in BlackTek:
-- mType.onThink = function(monster, interval)
-- 	accumulatedTime = accumulatedTime + interval
-- 	-- Execute only after 40 seconds
-- 	if accumulatedTime >= desiredInterval then
-- 		monster:createSoulWarWhiteTiles(SoulWarQuest.levers.goshnarsMalice.boss.position, zonePositions)
-- 		accumulatedTime = 0
-- 	end
-- end

mType:register(monster)
