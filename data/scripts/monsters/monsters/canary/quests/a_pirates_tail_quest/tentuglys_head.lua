local mType = Game.createMonsterType("Tentugly's Head")
local monster = {}

monster.description = "Tentugly's Head"
monster.experience = 40000
monster.outfit = {
	lookTypeEx = 38117,
}

monster.bosstiary = {
	bossRaceId = 2238,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 75000
monster.maxHealth = 75000
monster.race = "blood"
monster.corpse = 35600
monster.speed = 0
monster.manaCost = 0

monster.events = {
	"TentuglysHeadDeath",
}

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
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
	{ id = 2160, chance = 59860, minCount = 1, maxCount = 3 },
	{ id = 26029, chance = 59860, minCount = 1, maxCount = 34 },
	{ id = 8473, chance = 47890, minCount = 1, maxCount = 33 },
	{ id = 26030, chance = 28870, minCount = 2, maxCount = 19 },
	{ id = 7439, chance = 23940, minCount = 1, maxCount = 9 },
	{ id = 2152, chance = 23240, minCount = 2, maxCount = 19 },
	{ id = 7443, chance = 20420, minCount = 1, maxCount = 9 },
	{ id = 7440, chance = 16900, minCount = 2, maxCount = 9 },
	{ id = 49220, chance = 16900, minCount = 2, maxCount = 9 },
	{ id = 38469, chance = 13380, minCount = 3, maxCount = 86 },
	{ id = 38446, chance = 7750 },
	{ id = 36317, chance = 4930 },
	{ id = 38468, chance = 4230 },
	{ id = 38478, chance = 3520 },
	{ id = 38477, chance = 3520 },
	{ id = 36316, chance = 2820 },
	{ id = 35719, chance = 2820 },
	{ id = 34281, chance = 2110 },
	{ id = 38476, chance = 2110 },
	{ id = 38473, chance = 2110 },
	{ id = 38506, chance = 2110 },
	{ id = 38475, chance = 1410 },
	{ id = 38505, chance = 700 },
	{ id = 38507, chance = 700 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{
		name = "combat",
		type = COMBAT_ENERGYDAMAGE,
		interval = 2000,
		chance = 40,
		minDamage = -100,
		maxDamage = -400,
		range = 5,
		radius = 4,
		target = true,
		shootEffect = CONST_ANI_ENERGY,
		effect = CONST_ME_GHOSTLY_BITE,
	},
	{ name = "energy waveT", interval = 2000, chance = 30, minDamage = 0, maxDamage = -250 },
	{ name = "combat", type = COMBAT_ENERGYDAMAGE, interval = 2000, chance = 50, minDamage = -100, maxDamage = -300, radius = 5, effect = CONST_ME_LOSEENERGY },
}

monster.defenses = {
	defense = 60,
	armor = 82,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 30 },
	{ type = COMBAT_EARTHDAMAGE, percent = -30 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
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
	{ type = "bleed", condition = false },
}

mType:register(monster)
