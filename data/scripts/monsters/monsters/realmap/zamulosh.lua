local mtype = Game.createMonsterType("Zamulosh")
local monster = {}

monster.name = "Zamulosh"
monster.description = "a zamulosh"

monster.experience = 30000
monster.race = "blood"
monster.maxHealth = 100000
monster.health = 100000
monster.speed = 525
monster.manaCost = 200
monster.corpse = 9780
monster.outfit = { lookType = 862, lookHead = 17, lookBody = 12, lookLegs = 73, lookFeet = 92, lookAddons = 0 }
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
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 250,
        skill = 200,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 7,
        range = 7,
        minDamage = -100,
        maxDamage = -500,
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
        minDamage = -100,
        maxDamage = -400,
        radius = 8,
        target = false,
        effect = CONST_ME_LOSEENERGY,
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
        maxDamage = -450,
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
        interval = 6000,
        chance = 25,
        minDamage = 2000,
        maxDamage = 3000,
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
        interval = 1000,
        chance = 4,
        duration = 10000,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "invisible",
        interval = 1000,
        chance = 17,
        duration = 2000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.immunities = {
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.maxSummons = 3
monster.summons = {
    {name = "Zamulosh Summom", interval = 1000, chance = 15, max = 3},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "I AM ZAMULOSH!", yell = true},
}
monster.loot = {
    {id = 2148, chance = 9000, maxCount = 100},
    {id = 2148, chance = 9000, maxCount = 100},
    {id = 2152, chance = 9000, maxCount = 25},
    {id = 25172, chance = 80500},
    {id = 25411, chance = 200},
    {id = 25523, chance = 200},
    {id = 2154, chance = 1500},
    {id = 2169, chance = 2500},
    {id = 2165, chance = 900},
    {id = 2214, chance = 300},
    {id = 2155, chance = 600},
    {id = 6500, chance = 700},
    {id = 2158, chance = 10500},
    {id = 2147, chance = 8500, maxCount = 5},
    {id = 2146, chance = 9500, maxCount = 5},
    {id = 8473, chance = 8500, maxCount = 10},
    {id = 7590, chance = 9500, maxCount = 10},
    {id = 18416, chance = 7500, maxCount = 6},
    {id = 18417, chance = 3500, maxCount = 5},
    {id = 18418, chance = 7500, maxCount = 6},
}
monster.events = {
    "Zamulosh",
}

mtype:register(monster)
