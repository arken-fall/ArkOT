local mType = Game.createMonsterType("Dragon Hoard")
local monster = {}

monster.description = "Dragon Hoard"
monster.experience = 0
monster.outfit = {
	lookTypeEx = 5675,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"TwentyYearsACookBossDeath",
}

monster.bosstiary = {
	bossRace = RARITY_ARCHFOE,
	bossRaceId = 2466,
}

monster.health = 999999
monster.maxHealth = 999999
monster.race = "blood"
monster.corpse = 0
monster.speed = 0
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 4,
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
	hostile = false,
	convinceable = false,
	pushable = false,
	boss = true,
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 100,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 100
monster.runHealth = 0

monster.light = {
	level = 0,
	color = 0,
}

monster.loot = {
	{ id = 2160, chance = 100000, maxCount = 4 },
	{ id = 2152, chance = 100000, maxCount = 199 },
	{ id = 2148, chance = 100000, maxCount = 384 },
	{ id = 2158, chance = 31818, maxCount = 2 },
	{ id = 36427, chance = 31818, maxCount = 2 },
	{ id = 7441, chance = 27273 },
	{ id = 2479, chance = 22727 },
	{ id = 6500, chance = 22727, maxCount = 2 },
	{ id = 2177, chance = 22727 },
	{ id = 2154, chance = 22727, maxCount = 2 },
	{ id = 2498, chance = 18182 },
	{ id = 2187, chance = 13636 },
	{ id = 7290, chance = 9091 },
	{ id = 2409, chance = 9091 },
	{ id = 11305, chance = 9091 },
	{ id = 7402, chance = 9091 },
	{ id = 2392, chance = 9091 },
	{ id = 44686, chance = 4545, maxCount = 2 },
	{ id = 7430, chance = 4545 },
	{ id = 44692, chance = 4545, maxCount = 2 },
	{ id = 44688, chance = 4545, maxCount = 2 },
	{ id = 8885, chance = 4545 },
	{ id = 36316, chance = 4245 },
	{ id = 36317, chance = 3245 },
	{ id = 11368, chance = 2745 },
	{ id = 44685, chance = 5545, maxCount = 2 },
	{ id = 34283, chance = 4545 },
	{ id = 2528, chance = 7545 },
	{ id = 44706, chance = 1143 },
	{ id = 44704, chance = 1427 },
	{ id = 44705, chance = 1556 },
	{ id = 44707, chance = 1285 },
	{ id = 48224, chance = 1285 },
	{ id = 44827, chance = 862 },
	{ id = 44828, chance = 920 },
}

monster.attacks = {}

monster.defenses = {
	defense = 40,
	armor = 40,
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
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
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
