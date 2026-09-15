local mType = Game.createMonsterType("Goshnar's Cruelty")
local monster = {}

monster.description = "Goshnar's Cruelty"
monster.experience = 75000
monster.outfit = {
	lookType = 1303,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"SoulWarBossesDeath",
	"GoshnarsCrueltyBuff",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33859
monster.speed = 200
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1902,
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
	{ id = 34275, chance = 10000 },
	{ id = 7443, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 7440, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 7439, chance = 15000, minCount = 10, maxCount = 25 },
	{ id = 26029, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 26031, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 26030, chance = 18000, minCount = 50, maxCount = 100 },
	{ id = 37255, chance = 2000 },
	{ id = 37254, chance = 2000 },
	{ id = 37349, chance = 400 },
	{ id = 37403, chance = 400 },
	{ id = 37404, chance = 400 },
	{ id = 37439, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_LIFEDRAIN,
		minDamage = -1400,
		maxDamage = -1800,
		length = 8,
		spread = 0,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{ name = "singlecloudchain", interval = 6000, chance = 40, minDamage = -1700, maxDamage = -2500, range = 6, effect = CONST_ME_ENERGYHIT, target = true },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -1000,
		maxDamage = -2500,
		range = 7,
		radius = 4,
		shootEffect = CONST_ANI_EXPLOSION,
		effect = CONST_ME_DRAWBLOOD,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -1500,
		maxDamage = -3000,
		radius = 3,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{ name = "cruelty transform elemental", interval = Ref(SoulWarQuest.goshnarsCrueltyWaveInterval) * 1000, chance = 50 },
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

local firstTime = 0
-- Canary-only, not available in BlackTek:
-- mType.onThink = function(monster, interval)
-- 	firstTime = firstTime + interval
-- 	-- Run only 15 seconds before creation
-- 	if firstTime >= 15000 then
-- 		monster:goshnarsDefenseIncrease("greedy-maw-action")
-- 	end
-- end

-- Canary-only, not available in BlackTek:
-- mType.onSpawn = function(monsterCallback)
-- 	firstTime = 0
-- end

mType.onDisappear = function(monster, creature)
	if creature:getName() == "Goshnar's Cruelty" then
		local eyeCreature = Creature("A Greedy Eye")
		if eyeCreature then
			eyeCreature:remove()
		end
	end
end

mType:register(monster)
