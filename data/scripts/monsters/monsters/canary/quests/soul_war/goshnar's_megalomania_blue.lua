local mType = Game.createMonsterType("Goshnar's Megalomania Blue")
local monster = {}

monster.name = "Goshnar's Megalomania"
monster.description = "Goshnar's Megalomania"
monster.experience = 3000000
monster.outfit = {
	lookType = 1337,
}

monster.health = 620000
monster.maxHealth = 620000
monster.race = "undead"
monster.corpse = 33889
monster.speed = 0
monster.manaCost = 0
monster.maxSummons = 4

monster.bosstiary = {
	bossRaceId = 1969,
	bossRace = RARITY_NEMESIS,
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	health = 10,
	damage = 10,
}

monster.events = {
	"GoshnarsHatredBuff",
	"MegalomaniaDeath",
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
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
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
	{ id = 7439, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 26029, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 26031, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 26030, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 37348, chance = 400 },
	{ id = 37349, chance = 400 },
	{ id = 37350, chance = 400 },
	{ id = 37351, chance = 400 },
	{ id = 37284, chance = 400 },
	{ id = 37285, chance = 400 },
	{ id = 37257, chance = 400 },
	{ id = 37260, chance = 400 },
	{ id = 37439, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -400, maxDamage = -2225 },
	{ name = "megalomania blue", interval = 6000, chance = 100, target = true },
	{
		name = "combat",
		interval = 30000,
		chance = 100,
		type = COMBAT_LIFEDRAIN,
		minDamage = -1000,
		maxDamage = -1500,
		length = 8,
		radius = 5,
		spread = 0,
		effect = CONST_ME_PINK_ENERGY_SPARK,
		target = true,
	},
}

monster.defenses = {
	defense = 55,
	armor = 55,
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

local intervalBetweenExecutions = 10000

-- local zone = Zone.getByName("boss.goshnar's-megalomania-purple")
-- local zonePositions = zone:getPositions()

-- Canary-only, not available in BlackTek:
-- mType.onThink = function(monsterCallback, interval)
-- 	monsterCallback:onThinkGoshnarTormentCounter(interval, 36, intervalBetweenExecutions, SoulWarQuest.levers.goshnarsMegalomania.boss.position)
-- 	monsterCallback:onThinkMegalomaniaWhiteTiles(interval, zonePositions, 8000)
-- 	monsterCallback:goshnarsDefenseIncrease("cleansed-sanity-action")
-- end

-- Canary-only, not available in BlackTek:
-- mType.onDisappear = function(monster, creature)
-- 	creature:removeGoshnarsMegalomaniaMonsters(zone)
-- end

mType:register(monster)
