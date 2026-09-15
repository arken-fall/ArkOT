local mType = Game.createMonsterType("Murcion")
local monster = {}

monster.description = "Murcion"
monster.experience = 3250000
monster.outfit = {
	lookType = 1664,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"RottenBloodBossDeath",
}

monster.bosstiary = {
	bossRaceId = 2362,
	bossRace = RARITY_NEMESIS,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44015
monster.speed = 250
monster.manaCost = 0

monster.changeTarget = {
	interval = 10000,
	chance = 20,
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
	staticAttackChance = 98,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 98
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.maxSummons = 8
monster.summons = {
	{ name = "Mushroom", chance = 30, interval = 5000, max = 8 },
}

monster.voices = {}

monster.loot = {
	{ id = 2160, chance = 12317, maxCount = 91 },
	{ id = 2156, chance = 10896, maxCount = 2 },
	{ id = 36318, chance = 14590, maxCount = 1 },
	{ id = 36319, chance = 5405, maxCount = 1 },
	{ id = 7443, chance = 10821, maxCount = 44 },
	{ id = 2155, chance = 7763, maxCount = 4 },
	{ id = 7440, chance = 9534, maxCount = 15 },
	{ id = 26031, chance = 6212, maxCount = 102 },
	{ id = 26029, chance = 8785, maxCount = 29 },
	{ id = 26030, chance = 8783, maxCount = 161 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1400, maxDamage = -2300 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -500,
		maxDamage = -900,
		radius = 4,
		effect = CONST_ME_SMALLCLOUDS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_HOLYDAMAGE,
		minDamage = -500,
		maxDamage = -900,
		range = 4,
		radius = 4,
		shootEffect = 31,
		effect = 248,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ICEDAMAGE,
		minDamage = -1000,
		maxDamage = -1200,
		length = 10,
		spread = 0,
		effect = 53,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -1500,
		maxDamage = -1900,
		length = 10,
		spread = 0,
		effect = 158,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 20, radius = 7, effect = CONST_ME_POFF, target = false, duration = 20000, speed = -600 },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 800, maxDamage = 1500, effect = 236, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 15 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 15 },
	{ type = COMBAT_EARTHDAMAGE, percent = 15 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 15 },
	{ type = COMBAT_HOLYDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 15 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onThink = function(monster, interval) end

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType.onDisappear = function(monster, creature) end

mType.onMove = function(monster, creature, fromPosition, toPosition) end

mType.onSay = function(monster, creature, type, message) end

mType:register(monster)
