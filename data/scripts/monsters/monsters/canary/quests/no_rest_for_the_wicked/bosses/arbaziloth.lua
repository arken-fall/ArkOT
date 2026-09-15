local mType = Game.createMonsterType("Arbaziloth")
local monster = {}

monster.description = "Arbaziloth"
monster.experience = 500000
monster.outfit = {
	lookType = 1802,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 2594,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 360000
monster.maxHealth = 360000
monster.race = "fire"
monster.corpse = 50029
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 40,
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

monster.maxSummons = 2
monster.summons = {
	{ name = "Overcharged Demon", chance = 12, interval = 2000, max = 2 },
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "I am superior!", yell = true },
	{ text = "You are mad to challange a demon prince!", yell = true },
	{ text = "You can't stop me or my plans!", yell = true },
	{ text = "Pesky humans!", yell = true },
	{ text = "This insolence!", yell = true },
	{ text = "Nobody can stop me!", yell = true },
	{ text = "All will have to bow to me!", yell = true },
	{ text = "With this power I can crush everyone!", yell = true },
	{ text = "All that energy is mine!", yell = true },
	{ text = "Face the power of hell!", yell = true },
	{ text = "AHHH! THE POWER!!", yell = true },
}

monster.loot = {
	{ id = 2160, chance = 5000, minCount = 1, maxCount = 3 },
	{ id = 2152, chance = 5000, minCount = 50, maxCount = 100 },
	{ id = 7589, chance = 3500, minCount = 11, maxCount = 20 },
	{ id = 7590, chance = 3000, minCount = 2, maxCount = 15 },
	{ id = 8472, chance = 2900, maxCount = 6 },
	{ id = 26029, chance = 3000, minCount = 20, maxCount = 40 },
	{ id = 8473, chance = 3500, minCount = 10, maxCount = 20 },
	{ id = 26031, chance = 2900, minCount = 5, maxCount = 10 },
	{ id = 26030, chance = 3500, minCount = 2, maxCount = 14 },
	{ id = 2158, chance = 2900, maxCount = 2 },
	{ id = 2156, chance = 2500, maxCount = 2 },
	{ id = 2154, chance = 2000, maxCount = 2 },
	{ id = 6300, chance = 1900 },
	{ id = 2462, chance = 1800 },
	{ id = 2432, chance = 1700 },
	{ id = 2392, chance = 1600 },
	{ id = 2393, chance = 1500 },
	{ id = 2179, chance = 1400 },
	{ id = 2418, chance = 1300 },
	{ id = 2396, chance = 1200 },
	{ id = 2168, chance = 1150 },
	{ id = 7890, chance = 1100 },
	{ id = 7894, chance = 1050 },
	{ id = 2164, chance = 1890 },
	{ id = 2171, chance = 1000 },
	{ id = 1982, chance = 1000 },
	{ id = 2214, chance = 1300 },
	{ id = 2170, chance = 1000 },
	{ id = 2436, chance = 1000 },
	{ id = 11355, chance = 1300 },
	{ id = 2197, chance = 900 },
	{ id = 2479, chance = 1000 },
	{ id = 8910, chance = 1600 },
	{ id = 2187, chance = 1600 },
	{ id = 48039, chance = 900 },
	{ id = 2520, chance = 900 },
	{ id = 2136, chance = 900 },
	{ id = 7382, chance = 900 },
	{ id = 36316, chance = 900 },
	{ id = 34282, chance = 900 },
	{ id = 34281, chance = 900 },
	{ id = 34283, chance = 900 },
	{ id = 2470, chance = 900 },
	{ id = 2472, chance = 900 },
	{ id = 48032, chance = 100 },
	{ id = 48033, chance = 100 },
	{ id = 48036, chance = 90 },
	{ id = 47527, chance = 100 },
	{ id = 47528, chance = 100 },
	{ id = 47532, chance = 100 },
	{ id = 47526, chance = 100 },
	{ id = 47530, chance = 100 },
	{ id = 47529, chance = 100 },
	{ id = 47534, chance = 100 },
	{ id = 47535, chance = 100 },
	{ id = 47533, chance = 100 },
	{ id = 47531, chance = 100 },
	{ id = 47536, chance = 100 },
	{ id = 47537, chance = 100 },
	{ id = 47538, chance = 100 },
	{ id = 47539, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = -1520, maxDamage = -2000 },
}

monster.defenses = {
	defense = 145,
	armor = 80,
	mitigation = 2.45,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 200, maxDamage = 600, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_PHYSICALDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType.onAppear = function(monster, creature)
	if monster:getType():isRewardBoss() then
		monster:setReward(true)
	end
end

mType:register(monster)
