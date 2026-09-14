local mtype = Game.createMonsterType("Vexclaw")
local monster = {}

monster.name = "Vexclaw"
monster.description = "a vexclaw"

monster.experience = 7800
monster.race = "fire"
monster.maxHealth = 10200
monster.health = 10200
monster.speed = 380
monster.manaCost = 0
monster.corpse = 25432
monster.outfit = { lookType = 854 }
monster.changeTarget = {
    interval = 4000,
    chance = 20,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 150,
        skill = 75,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = 0,
        maxDamage = -120,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -150,
        maxDamage = -250,
        radius = 7,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "choking fear drown",
        interval = 2000,
        chance = 20,
    },
    {
        name = "death",
        interval = 2000,
        chance = 20,
        minDamage = -150,
        maxDamage = -400,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_MORTAREA,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -50,
        maxDamage = -200,
        length = 8,
        spread = 0,
        effect = CONST_ME_PURPLEENERGY,
    },
    {
        name = "firefield",
        interval = 2000,
        chance = 10,
        range = 7,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_FIRE,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -300,
        maxDamage = -490,
        length = 8,
        spread = 0,
        effect = CONST_ME_PURPLEENERGY,
    },
    {
        name = "energy strike",
        interval = 2000,
        chance = 10,
        range = 1,
        minDamage = -210,
        maxDamage = -300,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        radius = 1,
        duration = 30000,
        speed = -300,
        target = true,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.defenses = {
    defense = 55,
    armor = 55,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 180,
        maxDamage = 250,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 5000,
        speed = 320,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 30},
    {type = COMBAT_DEATHDAMAGE, percent = 30},
    {type = COMBAT_ENERGYDAMAGE, percent = 50},
    {type = COMBAT_EARTHDAMAGE, percent = 40},
    {type = COMBAT_ICEDAMAGE, percent = -10},
    {type = COMBAT_HOLYDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Weakness must be culled!", yell = false},
    {text = "Power is miiiiine!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 60000, maxCount = 100},
    {id = 2148, chance = 60000, maxCount = 99},
    {id = 2152, chance = 100000, maxCount = 6},
    {id = 2795, chance = 7740, maxCount = 6},
    {id = 7590, chance = 8285, maxCount = 3},
    {id = 8472, chance = 8285, maxCount = 3},
    {id = 8473, chance = 8285, maxCount = 3},
    {id = 2147, chance = 4985, maxCount = 3},
    {id = 2149, chance = 3000},
    {id = 2150, chance = 1985, maxCount = 3},
    {id = 9970, chance = 2485, maxCount = 3},
    {id = 2151, chance = 1571, maxCount = 3},
    {id = 6500, chance = 1885},
    {id = 25384, chance = 1285},
    {id = 2156, chance = 885},
    {id = 2164, chance = 1285},
    {id = 2418, chance = 1328},
    {id = 1982, chance = 9390},
    {id = 2171, chance = 1213},
    {id = 2462, chance = 1504},
    {id = 2396, chance = 1666},
    {id = 2432, chance = 1003},
    {id = 2520, chance = 989},
    {id = 2393, chance = 1290},
    {id = 7382, chance = 320},
    {id = 2514, chance = 400},
    {id = 2472, chance = 340},
    {id = 25523, chance = 220},
    {id = 25522, chance = 220},
}

mtype:register(monster)
