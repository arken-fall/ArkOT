local mType = Game.createMonsterType("Faceless Bane")
local monster = {}

monster.description = "Faceless Bane"
monster.experience = 20000
monster.outfit = {
	lookType = 1119,
	lookHead = 0,
	lookBody = 2,
	lookLegs = 95,
	lookFeet = 97,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 35000
monster.maxHealth = 35000
monster.race = "blood"
monster.corpse = 30013
monster.speed = 125
monster.manaCost = 0

monster.events = {
	"dreamCourtsDeath",
	"facelessThink",
}

monster.changeTarget = {
	interval = 4000,
	chance = 20,
}

monster.reflects = {
	{ type = COMBAT_DEATHDAMAGE, percent = 90 },
}

monster.bosstiary = {
	bossRaceId = 1727,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
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
}

monster.loot = {
	{ id = 2156, chance = 16670 },
	{ id = 2158, chance = 2630 },
	{ id = 33442, chance = 880 },
	{ id = 2416, chance = 16670 },
	{ id = 18419, chance = 13160 },
	{ id = 2379, chance = 48250 },
	{ id = 31703, chance = 1750 },
	{ id = 34160, chance = 1750 },
	{ id = 34542, chance = 1750 },
	{ id = 7633, chance = 880 },
	{ id = 9971, chance = 8330 },
	{ id = 18415, chance = 4390 },
	{ id = 2155, chance = 8330 },
	{ id = 2183, chance = 9650 },
	{ id = 34382, chance = 880 },
	{ id = 2396, chance = 18420 },
	{ id = 2403, chance = 12280 },
	{ id = 2177, chance = 10530 },
	{ id = 7889, chance = 2630 },
	{ id = 2186, chance = 5260 },
	{ id = 2185, chance = 2630 },
	{ id = 2176, chance = 2630 },
	{ id = 2152, chance = 83330, maxCount = 19 },
	{ id = 18420, chance = 16670 },
	{ id = 2146, chance = 33330, maxCount = 4 },
	{ id = 2182, chance = 7020 },
	{ id = 2389, chance = 16670, maxCount = 3 },
	{ id = 34161, chance = 1750 },
	{ id = 8912, chance = 880 },
	{ id = 2161, chance = 2630 },
	{ id = 2181, chance = 22810 },
	{ id = 11309, chance = 13160 },
	{ id = 8910, chance = 3510 },
	{ id = 18414, chance = 2630 },
	{ id = 2153, chance = 1750 },
	{ id = 18409, chance = 880 },
	{ id = 2154, chance = 16670 },
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2000, minDamage = 0, maxDamage = -575 },
	{
		name = "combat",
		interval = 2000,
		chance = 65,
		type = COMBAT_FIREDAMAGE,
		minDamage = -350,
		maxDamage = -500,
		radius = 3,
		Effect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 45,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -335,
		maxDamage = -450,
		radius = 4,
		Effect = CONST_ANI_SUDDENDEATH,
		effect = CONST_ME_MORTAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 25,
		type = COMBAT_PHYSICALDAMAGE,
		minDamage = -330,
		maxDamage = -380,
		length = 7,
		effect = CONST_ME_EXPLOSIONAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 35,
		type = COMBAT_FIREDAMAGE,
		minDamage = -300,
		maxDamage = -410,
		range = 4,
		radius = 4,
		shootEffect = CONST_ANI_FIRE,
		effect = CONST_ME_FIREAREA,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 20,
		type = COMBAT_ENERGYDAMAGE,
		minDamage = -385,
		maxDamage = -535,
		range = 4,
		radius = 1,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_ENERGYAREA,
		target = true,
	},
}

monster.defenses = {
	defense = 5,
	armor = 10,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 50 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 50 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

-- Canary-only callback, not bound by BlackTek:
-- mType.onSpawn = function(monster, spawnPosition)
-- 	if monster:getType():isRewardBoss() then
-- 		-- reset global storage state to default / ensure sqm's reset for the next team
-- 		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.Deaths, -1)
-- 		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.StepsOn, -1)
-- 		Game.setStorageValue(GlobalStorage.TheDreamCourts.FacelessBane.ResetSteps, 1)
-- 		monster:registerEvent("facelessBaneImmunity")
-- 		monster:setReward(true)
-- 	end
-- end

mType:register(monster)
