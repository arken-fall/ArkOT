local mtype = Game.createMonsterType("Ethershreck")
local monster = {}

monster.name = "Ethershreck"
monster.description = "Ethershreck"

monster.experience = 7500
monster.race = "undead"
monster.maxHealth = 12500
monster.health = 12500
monster.speed = 320
monster.manaCost = 0
monster.corpse = 11362
monster.outfit = { lookType = 351 }
monster.changeTarget = {
    interval = 4000,
    chance = 5,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 366
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 1000,
        skill = 124,
        interval = 2000,
    },
    {
        name = "ghastly dragon curse",
        interval = 2000,
        chance = 5,
        range = 5,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 10,
        range = 5,
        minDamage = -920,
        maxDamage = -1280,
        target = true,
        effect = CONST_ME_BATS,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -180,
        maxDamage = -330,
        target = true,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "death",
        interval = 2000,
        chance = 10,
        minDamage = -220,
        maxDamage = -350,
        length = 8,
        spread = 3,
        effect = CONST_ME_LOSEENERGY,
    },
    {
        name = "death",
        interval = 2000,
        chance = 15,
        minDamage = -210,
        maxDamage = -280,
        radius = 4,
        target = false,
        effect = CONST_ME_SMALLCLOUDS,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 20,
        range = 7,
        duration = 30000,
        speed = -300,
        target = true,
        effect = CONST_ME_SMALLCLOUDS,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
    {
        name = "healing",
        interval = 4000,
        chance = 10,
        minDamage = 215,
        maxDamage = 300,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 10},
    {type = COMBAT_ICEDAMAGE, percent = 50},
    {type = COMBAT_PHYSICALDAMAGE, percent = -10},
    {type = COMBAT_HOLYDAMAGE, percent = -15},
    {type = COMBAT_ENERGYDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "EMBRACE MY GIFTS!", yell = true},
    {text = "I WILL FEAST ON YOUR SOUL!", yell = true},
}
monster.loot = {
    {id = 11366, chance = 100000},
    {id = 2148, chance = 100000, maxCount = 230},
    {id = 2152, chance = 100000, maxCount = 15},
    {id = 11367, chance = 100000},
    {id = 6500, chance = 97000},
    {id = 7632, chance = 45000},
    {id = 7633, chance = 45000},
    {id = 9970, chance = 97000, maxCount = 10},
    {id = 11323, chance = 76000},
    {id = 8473, chance = 60000},
    {id = 11227, chance = 45000},
    {id = 11368, chance = 37000},
    {id = 7591, chance = 34000, maxCount = 3},
    {id = 11303, chance = 30000},
    {id = 7590, chance = 26000, maxCount = 3},
    {id = 8472, chance = 26000, maxCount = 3},
    {id = 11355, chance = 21000},
    {id = 11304, chance = 15000},
    {id = 11301, chance = 13000},
    {id = 11302, chance = 13000},
    {id = 11306, chance = 10000},
    {id = 11305, chance = 8700},
    {id = 13938, chance = 2170},
}

mtype:register(monster)
