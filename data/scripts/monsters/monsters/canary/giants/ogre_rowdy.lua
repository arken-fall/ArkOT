local mType = Game.createMonsterType("Ogre Rowdy")
local monster = {}

monster.description = "an ogre rowdy"
monster.experience = 4200
monster.outfit = {
	lookType = 1213,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1821
monster.bestiary = {
	race = "Giant",
	class = "Giant",
	toKill = 2500,
	firstUnlock = 100,
	secondUnlock = 1000,
	charmPoints = 50,
	stars = 4,
	occurrence = 0,
	locations = "Kilmaresh Central Steppe, Kilmaresh Southern Steppe, Green Belt, Kilmaresh Mountains underground.",
}

monster.health = 4500
monster.maxHealth = 4500
monster.race = "blood"
monster.corpse = 31531
monster.speed = 210
monster.manaCost = 0

monster.faction = FACTION_ANUMA
monster.enemyFactions = { FACTION_PLAYER, FACTION_FAFNAR }

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
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
	{ id = 2152, chance = 100000, maxCount = 6 },
	{ id = 7840, chance = 22040, maxCount = 19 },
	{ id = 24844, chance = 12900 },
	{ id = 24845, chance = 20970 },
	{ id = 24847, chance = 12900 },
	{ id = 2187, chance = 10000 },
	{ id = 8844, chance = 3760, maxCount = 3 },
	{ id = 8921, chance = 2150 },
	{ id = 18409, chance = 1080 },
	{ id = 24828, chance = 540 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	{
		name = "combat",
		interval = 2000,
		chance = 13,
		type = COMBAT_FIREDAMAGE,
		minDamage = -250,
		maxDamage = -400,
		range = 5,
		radius = 4,
		shootEffect = CONST_ANI_WHIRLWINDAXE,
		effect = CONST_ME_EXPLOSIONHIT,
		target = true,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 15,
		type = COMBAT_FIREDAMAGE,
		minDamage = -200,
		maxDamage = -450,
		radius = 3,
		effect = CONST_ME_FIREAREA,
		target = false,
	},
	{
		name = "combat",
		interval = 2000,
		chance = 18,
		type = COMBAT_FIREDAMAGE,
		minDamage = -280,
		maxDamage = -420,
		range = 3,
		shootEffect = CONST_ANI_FLAMMINGARROW,
		target = true,
	},
}

monster.defenses = {
	defense = 98,
	armor = 98,
	mitigation = 2.63,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 30 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
