local mType = Game.createMonsterType("Goshnar's Hatred")
local monster = {}

monster.description = "Goshnar's Hatred"
monster.experience = 75000
monster.outfit = {
	lookType = 1307,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.events = {
	"GoshnarsHatredBuff",
	"SoulWarBossesDeath",
}

monster.health = 300000
monster.maxHealth = 300000
monster.race = "undead"
monster.corpse = 33875
monster.speed = 150
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
}

monster.bosstiary = {
	bossRaceId = 1904,
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
	{ id = 37259, chance = 25000, maxCount = 1 },
	{ id = 37350, chance = 400 },
	{ id = 37402, chance = 400 },
	{ id = 37404, chance = 400 },
	{ id = 37406, chance = 400 },
	{ id = 37439, chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -5000 },
	{
		name = "combat",
		interval = 2000,
		chance = 30,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -1350,
		maxDamage = -1700,
		range = 7,
		radius = 5,
		shootEffect = CONST_ANI_DEATH,
		effect = CONST_ME_GROUNDSHAKER,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 10,
		type = COMBAT_DEATHDAMAGE,
		minDamage = -1400,
		maxDamage = -2200,
		length = 8,
		spread = 0,
		effect = CONST_ME_GROUNDSHAKER,
		target = false,
	},
	{ name = "singlecloudchain", interval = 6000, chance = 40, minDamage = -1700, maxDamage = -2500, range = 6, effect = CONST_ME_ENERGYHIT, target = true },
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

mType.onDisappear = function(monster, creature)
	if creature:getName() == "Goshnar's Hatred" then
		for _, monsterName in pairs(SoulWarQuest.burningHatredMonsters) do
			local ashesCreature = Creature(monsterName)
			if ashesCreature then
				ashesCreature:remove()
			end
		end
	end
end

-- Canary-only, not available in BlackTek:
-- mType.onSpawn = function(monster)
-- 	monster:resetHatredDamageMultiplier()
-- end

mType:register(monster)
