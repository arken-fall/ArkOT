local mType = Game.createMonsterType("Vemiath")
local monster = {}

monster.description = "Vemiath"
monster.experience = 3250000
monster.outfit = {
	lookType = 1668,
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
	bossRaceId = 2365,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 350000
monster.maxHealth = 350000
monster.race = "undead"
monster.corpse = 44021
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
	{ id = 2160, chance = 8852, maxCount = 125 },
	{ id = 26029, chance = 11337, maxCount = 211 },
	{ id = 34282, chance = 6423, maxCount = 1 },
	{ id = 26031, chance = 8385, maxCount = 179 },
	{ id = 2154, chance = 8604, maxCount = 5 },
	{ id = 7439, chance = 9395, maxCount = 45 },
	{ id = 2158, chance = 14144, maxCount = 5 },
	{ id = 2155, chance = 6221, maxCount = 4 },
	{ id = 7443, chance = 6530, maxCount = 26 },
	{ id = 7440, chance = 5700, maxCount = 44 },
	{ id = 26030, chance = 9216, maxCount = 25 },
	{ id = 36317, chance = 11191, maxCount = 1 },
	{ id = 36316, chance = 8527, maxCount = 1 },
	{ id = 9971, chance = 10866, maxCount = 1 },
	{ id = 2156, chance = 8945, maxCount = 1 },
	{ id = 34275, chance = 11502, maxCount = 1 },
	{ id = 37127, chance = 9302, maxCount = 1 },
	{ id = 2153, chance = 7210, maxCount = 1 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1500, maxDamage = -2500 },
	{
		name = "combat",
		interval = 3000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -1000,
		length = 10,
		spread = 3,
		effect = 244,
		target = false,
	},
	{ name = "speed", interval = 2000, chance = 25, radius = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 15000, speed = -600 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -700, radius = 5, effect = 243, target = false },
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -500,
		maxDamage = -800,
		length = 10,
		spread = 3,
		effect = CONST_ME_EXPLOSIONHIT,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_FIREDAMAGE,
		minDamage = -500,
		maxDamage = -800,
		length = 8,
		spread = 3,
		effect = CONST_ME_FIREATTACK,
		target = false,
	},
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
