local mtype = Game.createMonsterType("The Rage")
local monster = {}

monster.name = "The Rage"
monster.description = "a the rage"

monster.experience = 15000
monster.race = "fire"
monster.maxHealth = 400000
monster.health = 400000
monster.speed = 400
monster.manaCost = 0
monster.corpse = 26220
monster.outfit = { lookType = 876, lookHead = 85, lookBody = 114, lookLegs = 59, lookFeet = 0, lookAddons = 0 }
monster.changeTarget = {
    interval = 10000,
    chance = 20,
}
monster.staticAttackChance = 98
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
        minDamage = -500,
        maxDamage = -2900,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -800,
        maxDamage = -2000,
    },
    {
        name = "physical",
        interval = 3000,
        chance = 34,
        range = 7,
        minDamage = -600,
        maxDamage = -2000,
        shootEffect = CONST_ANI_WHIRLWINDSWORD,
        effect = CONST_ME_DRAWBLOOD,
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
        name = "phantasm drown",
        interval = 2000,
        chance = 20,
    },
    {
        name = "energy strike",
        interval = 2000,
        chance = 30,
        range = 1,
        minDamage = -510,
        maxDamage = -1900,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        range = 7,
        duration = 15000,
        speed = -400,
        shootEffect = CONST_ANI_THROWINGKNIFE,
    },
    {
        name = "ice",
        interval = 2000,
        chance = 30,
        range = 7,
        minDamage = -700,
        maxDamage = -3200,
        radius = 7,
        target = false,
        effect = CONST_ME_BIGPLANTS,
    },
    {
        name = "ice",
        interval = 2000,
        chance = 19,
        minDamage = -460,
        maxDamage = -820,
        radius = 3,
        target = false,
        effect = CONST_ME_ICETORNADO,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 15,
        minDamage = -500,
        maxDamage = -1520,
        length = 1,
        spread = 0,
        target = false,
        effect = CONST_ME_POFF,
    },
    {
        name = "death",
        interval = 2000,
        chance = 10,
        minDamage = -200,
        maxDamage = -900,
        length = 5,
        spread = 2,
        target = true,
        effect = CONST_ME_BLACKSMOKE,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 30,
        minDamage = -390,
        maxDamage = -850,
        radius = 4,
        target = true,
        effect = CONST_ME_TELEPORT,
    },
}
monster.defenses = {
    defense = 65,
    armor = 55,
    {
        name = "healing",
        interval = 3000,
        chance = 35,
        minDamage = 400,
        maxDamage = 6000,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 4000,
        chance = 80,
        duration = 6000,
        speed = 460,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 1},
    {type = COMBAT_DEATHDAMAGE, percent = 1},
    {type = COMBAT_HOLYDAMAGE, percent = -1},
    {type = COMBAT_EARTHDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "ice", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.maxSummons = 9
monster.summons = {
    {name = "Dread IntruderSummon", interval = 4000, chance = 8, max = 4},
    {name = "Charger", interval = 4000, chance = 8, max = 3},
    {name = "Spark of Destruction", interval = 1000, chance = 15, max = 2},
}
monster.voices = {
    interval = 5000,
    chance = 20,
    {text = "COME AND GIVE ME SOME AMUSEMENT", yell = false},
    {text = "IS THAT THE BEST YOU HAVE TO OFFER, TIBIANS?", yell = true},
}
monster.events = {
    "The Rage",
}

mtype:register(monster)
