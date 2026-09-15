local mType = Game.createMonsterType("Chagorz")
local monster = {}

monster.description = "Chagorz"
monster.experience = 3250000
monster.outfit = {
	lookType = 1666,
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
	bossRaceId = 2366,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44024
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

monster.summons = {}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "The light... that... drains!", yell = false },
	{ text = "RAAAR!", yell = false },
	{ text = "WILL ... PUNISH ... YOU!", yell = false },
	{ text = "Darkness ... devours!", yell = false },
}

monster.loot = {
	{ id = 2160, chance = 5441, maxCount = 108 },
	{ id = 7440, chance = 5530, maxCount = 28 },
	{ id = 26031, chance = 5044, maxCount = 154 },
	{ id = 34283, chance = 10546, maxCount = 1 },
	{ id = 26029, chance = 5752, maxCount = 107 },
	{ id = 2153, chance = 13217, maxCount = 4 },
	{ id = 2156, chance = 13465, maxCount = 1 },
	{ id = 2154, chance = 14071, maxCount = 1 },
	{ id = 2158, chance = 11156, maxCount = 3 },
	{ id = 7443, chance = 6792, maxCount = 21 },
	{ id = 36316, chance = 11603, maxCount = 1 },
	{ id = 36317, chance = 12280, maxCount = 1 },
	{ id = 2155, chance = 8348, maxCount = 1 },
	{ id = 26030, chance = 10934, maxCount = 18 },
	{ id = 36427, chance = 9600, maxCount = 3 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1300, maxDamage = -2250 },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -500,
		maxDamage = -900,
		radius = 4,
		effect = CONST_ME_GREEN_RINGS,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -500,
		maxDamage = -900,
		range = 4,
		radius = 4,
		effect = 241,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_EARTHDAMAGE,
		minDamage = -1000,
		maxDamage = -1200,
		length = 10,
		spread = 0,
		effect = CONST_ME_POFF,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_LIFEDRAIN,
		minDamage = -1500,
		maxDamage = -1900,
		length = 10,
		spread = 0,
		effect = 225,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 20, radius = 7, effect = CONST_ME_MAGIC_GREEN, target = false, duration = 20000, speed = -600 },
}

monster.defenses = {
	defense = 105,
	armor = 105,
	{ name = "combat", interval = 3000, chance = 10, type = COMBAT_HEALING, minDamage = 700, maxDamage = 1500, effect = 236, target = false },
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
