local mtype = Game.createMonsterType("Orc Warrior")
local monster = {}

monster.name = "Orc Warrior"
monster.description = "an orc warrior"

monster.raceId = 7
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Ancient Temple in Thais, Orc Fort, below Point of No Return in Outlaw Camp and inside a mountain north of it, Orc Peninsula, Folda, Edron Orc cave, Maze of Lost Souls, Elvenbane Castle, Foreigner Quarter, Zao Orc Land.",
}
monster.experience = 50
monster.race = "blood"
monster.maxHealth = 125
monster.health = 125
monster.speed = 190
monster.manaCost = 360
monster.corpse = 5979
monster.outfit = { lookType = 7 }
monster.runHealth = 10
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.attacks = {
    {
        name = "melee",
        interval = 2000,
        minDamage = 0,
        maxDamage = -60,
    },
}
monster.defenses = {
    defense = 8,
    armor = 8,
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 30},
    {type = COMBAT_HOLYDAMAGE, percent = 10},
    {type = COMBAT_EARTHDAMAGE, percent = -10},
    {type = COMBAT_DEATHDAMAGE, percent = -10},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Grow truk grrrr.", yell = false},
    {text = "Trak grrrr brik.", yell = false},
    {text = "Alk!", yell = false},
}
monster.loot = {
    {
        id = 2148,
        chance = 64165,
        maxCount = 15,
    },
    {
        id = 2666,
        chance = 15373,
    },
    {
        id = 12409,
        chance = 9694,
    },
    {
        id = 2464,
        chance = 7516,
    },
    {
        id = 12435,
        chance = 3696,
    },
    {
        id = 12436,
        chance = 1001,
    },
    {
        id = 11113,
        chance = 681,
    },
    {
        id = 2530,
        chance = 506,
    },
    {
        id = 2411,
        chance = 41,
    },
}

mtype:register(monster)
