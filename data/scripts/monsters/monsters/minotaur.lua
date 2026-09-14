local mtype = Game.createMonsterType("Minotaur")
local monster = {}

monster.name = "Minotaur"
monster.description = "a minotaur"

monster.raceId = 25
monster.bestiary = {
	race = "Humanoid",
	class = "Humanoid",
	toKill = 500,
	firstUnlock = 25,
	secondUnlock = 250,
	charmPoints = 15,
	stars = 2,
	occurrence = 0,
	locations = "Mino Hell (Rookgaard), Two outside Bear Room Quest, (Rookgaard) and also 2x on the premium side, Mintwallin, Folda, Minotaur Pyramid, Outlaw Camp, Kazordoon minotaur cave, Plains of Havoc, Elven Bane, Deeper Fibula Dungeon (level 50+ to open the door), Ancient Temple, Maze of Lost Souls, Thais Minotaur Camp, Foreigner Quarter.",
}
monster.experience = 50
monster.race = "blood"
monster.maxHealth = 100
monster.health = 100
monster.speed = 168
monster.manaCost = 330
monster.corpse = 5969
monster.outfit = { lookType = 25 }
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
        maxDamage = -45,
    },
}
monster.defenses = {
    defense = 11,
    armor = 11,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 20},
    {type = COMBAT_HOLYDAMAGE, percent = 10},
    {type = COMBAT_ICEDAMAGE, percent = -10},
    {type = COMBAT_DEATHDAMAGE, percent = -10},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Kaplar!", yell = false},
    {text = "Hurr", yell = false},
}
monster.loot = {
    {
        id = "gold coin",
        chance = 67500,
        maxCount = 25,
    },
    {
        id = "plate shield",
        chance = 20020,
    },
    {
        id = "mace",
        chance = 12840,
    },
    {
        id = "chain armor",
        chance = 10000,
    },
    {
        id = "brass helmet",
        chance = 7700,
    },
    {
        id = 2376,
        chance = 5000,
    },
    {
        id = "meat",
        chance = 5000,
    },
    {
        id = "axe",
        chance = 4000,
    },
    {
        id = "minotaur horn",
        chance = 2090,
        maxCount = 2,
    },
    {
        id = "minotaur leather",
        chance = 990,
    },
    {
        id = 2554,
        chance = 310,
    },
    {
        id = "bronze amulet",
        chance = 110,
    },
}

mtype:register(monster)
