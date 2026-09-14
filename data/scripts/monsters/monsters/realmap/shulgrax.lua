local mtype = Game.createMonsterType("Shulgrax")
local monster = {}

monster.name = "Shulgrax"
monster.description = "a shulgrax"

monster.experience = 30000
monster.race = "blood"
monster.maxHealth = 120000
monster.health = 120000
monster.speed = 485
monster.manaCost = 200
monster.corpse = 9780
monster.outfit = { lookType = 842, lookHead = 19, lookBody = 82, lookLegs = 41, lookFeet = 41, lookAddons = 1 }
monster.changeTarget = {
    interval = 2000,
    chance = 10,
}
monster.targetDistance = 1
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 290,
        skill = 200,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 7,
        range = 7,
        minDamage = -200,
        maxDamage = -800,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_POFF,
    },
    {
        name = "drunk",
        interval = 1000,
        chance = 7,
        range = 7,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYAREA,
    },
    {
        name = "strength",
        interval = 1000,
        chance = 9,
        range = 7,
        shootEffect = CONST_ANI_LARGEROCK,
        effect = CONST_ME_ENERGYAREA,
    },
    {
        name = "lifedrain",
        interval = 1000,
        chance = 13,
        minDamage = -500,
        maxDamage = -1400,
        radius = 8,
        target = false,
        effect = CONST_ME_LOSEENERGY,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 10,
        minDamage = -100,
        maxDamage = -300,
        radius = 8,
        target = false,
        effect = CONST_ME_MAGIC_GREEN,
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
        name = "renegade knight",
        interval = 2000,
        chance = 30,
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
        minDamage = -450,
        maxDamage = -1400,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_MORTAREA,
    },
    {
        name = "speed",
        interval = 1000,
        chance = 12,
        radius = 6,
        duration = 60000,
        speed = -1900,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "strength",
        interval = 1000,
        chance = 8,
        radius = 5,
        target = false,
        effect = CONST_ME_HITAREA,
    },
    {
        name = "fire",
        interval = 1000,
        chance = 34,
        range = 7,
        minDamage = -100,
        maxDamage = -700,
        radius = 7,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "lifedrain",
        interval = 1000,
        chance = 15,
        minDamage = -100,
        maxDamage = -550,
        length = 8,
        spread = 0,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.defenses = {
    defense = 160,
    armor = 160,
    {
        name = "healing",
        interval = 3000,
        chance = 13,
        minDamage = 2000,
        maxDamage = 4000,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 1000,
        chance = 8,
        duration = 5000,
        speed = 1901,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "invisible",
        interval = 3000,
        chance = 17,
        duration = 2000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 2148, chance = 9000, maxCount = 100},
    {id = 2148, chance = 9000, maxCount = 100},
    {id = 2152, chance = 9000, maxCount = 25},
    {id = 25172, chance = 80500},
    {id = 2154, chance = 2500},
    {id = 2153, chance = 2500},
    {id = 2156, chance = 2500},
    {id = 2155, chance = 2500},
    {id = 25412, chance = 500},
    {id = 25382, chance = 120},
    {id = 25383, chance = 300},
    {id = 25523, chance = 200},
    {id = 7451, chance = 500},
    {id = 20108, chance = 900},
    {id = 7889, chance = 1500, subType = 200},
    {id = 7895, chance = 700},
    {id = 6500, chance = 1000},
    {id = 7419, chance = 900},
    {id = 6300, chance = 1000},
    {id = 8473, chance = 9500, maxCount = 10},
    {id = 8472, chance = 9500, maxCount = 10},
    {id = 7590, chance = 900, maxCount = 10},
    {id = 7416, chance = 800, maxCount = 5},
    {id = 9970, chance = 700, maxCount = 5},
    {id = 2149, chance = 500, maxCount = 5},
    {id = 2147, chance = 500, maxCount = 5},
    {id = 2145, chance = 4500, maxCount = 5},
    {id = 24850, chance = 5500, maxCount = 5},
    {id = 24849, chance = 5500, maxCount = 5},
    {id = 6558, chance = 4500, maxCount = 5},
}
monster.events = {
    "Shulgrax",
}

mtype:register(monster)
