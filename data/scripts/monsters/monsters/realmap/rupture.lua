local mtype = Game.createMonsterType("Rupture")
local monster = {}

monster.name = "Rupture"
monster.description = "a rupture"

monster.experience = 300000
monster.race = "blood"
monster.maxHealth = 290000
monster.health = 290000
monster.speed = 525
monster.manaCost = 200
monster.corpse = 26220
monster.outfit = { lookType = 875, lookHead = 77, lookBody = 38, lookLegs = 59, lookFeet = 87, lookAddons = 0 }
monster.changeTarget = {
    interval = 2000,
    chance = 40,
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
        attack = 340,
        skill = 190,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 7,
        range = 7,
        minDamage = -400,
        maxDamage = -700,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_POFF,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 10,
        minDamage = -1000,
        maxDamage = -2050,
        length = 8,
        spread = 0,
        target = false,
        effect = CONST_ME_FIREATTACK,
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
        name = "energy strike",
        interval = 2000,
        chance = 30,
        range = 1,
        minDamage = -510,
        maxDamage = -2200,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 8,
        range = 7,
        minDamage = -750,
        maxDamage = -1550,
        radius = 7,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
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
        name = "manadrain",
        interval = 2000,
        chance = 12,
        minDamage = -545,
        maxDamage = -1490,
        radius = 8,
        target = false,
        effect = CONST_ME_YELLOW_RINGS,
    },
    {
        name = "phantasm drown",
        interval = 2000,
        chance = 20,
    },
    {
        name = "drunk",
        interval = 2000,
        chance = 15,
        range = 7,
        radius = 6,
        duration = 10000,
        target = false,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "lifedrain",
        interval = 1000,
        chance = 20,
        minDamage = -600,
        maxDamage = -900,
        radius = 8,
        target = false,
        effect = CONST_ME_LOSEENERGY,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -750,
        maxDamage = -1200,
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
        minDamage = -350,
        maxDamage = -700,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_MORTAREA,
    },
    {
        name = "bleedcondition",
        interval = 2000,
        chance = 20,
        minDamage = -150,
        maxDamage = -725,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_THROWINGKNIFE,
        effect = CONST_ME_DRAWBLOOD,
    },
    {
        name = "vile grandmaster",
        interval = 2000,
        chance = 15,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 10,
        minDamage = -500,
        maxDamage = -1700,
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
}
monster.defenses = {
    defense = 160,
    armor = 160,
    {
        name = "healing",
        interval = 6000,
        chance = 20,
        minDamage = 1700,
        maxDamage = 4400,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = -5},
    {type = COMBAT_DEATHDAMAGE, percent = 1},
    {type = COMBAT_EARTHDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.maxSummons = 6
monster.summons = {
    {name = "Instable Breach BroodSummon", interval = 1000, chance = 15, max = 6},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "I AM RUPTURE!", yell = true},
}
monster.loot = {
    {id = 2148, chance = 29000, maxCount = 100},
    {id = 2148, chance = 29000, maxCount = 100},
    {id = 2152, chance = 20000, maxCount = 8},
    {id = 8473, chance = 100000, maxCount = 5},
    {id = 7590, chance = 9000, maxCount = 4},
    {id = 18413, chance = 9000, maxCount = 3},
    {id = 18415, chance = 3000, maxCount = 3},
    {id = 2150, chance = 10000, maxCount = 2},
    {id = 2146, chance = 12000, maxCount = 2},
    {id = 18414, chance = 5000, maxCount = 3},
    {id = 26187, chance = 2000},
    {id = 26191, chance = 19000, maxCount = 5},
    {id = 7427, chance = 7000},
    {id = 26162, chance = 3000},
    {id = 2155, chance = 1200},
    {id = 26166, chance = 3000},
    {id = 25377, chance = 3000},
    {id = 26165, chance = 8000},
}
monster.events = {
    "Rupture",
}

mtype:register(monster)
