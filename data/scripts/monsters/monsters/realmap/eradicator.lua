local mtype = Game.createMonsterType("Eradicator")
local monster = {}

monster.name = "Eradicator"
monster.description = "a eradicator"

monster.experience = 300000
monster.race = "blood"
monster.maxHealth = 290000
monster.health = 290000
monster.speed = 525
monster.manaCost = 200
monster.corpse = 26220
monster.outfit = { lookType = 875, lookHead = 79, lookBody = 38, lookLegs = 114, lookFeet = 79, lookAddons = 0 }
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
        skill = 150,
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
        maxDamage = -1200,
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
        maxDamage = -225,
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
        maxDamage = -900,
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
    defense = 70,
    armor = 70,
    {
        name = "healing",
        interval = 6000,
        chance = 25,
        minDamage = 1000,
        maxDamage = 2000,
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
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 20},
    {type = COMBAT_DEATHDAMAGE, percent = 1},
    {type = COMBAT_EARTHDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.maxSummons = 9
monster.summons = {
    {name = "Charger", interval = 1000, chance = 15, max = 5},
    {name = "Spark of Destruction", interval = 1000, chance = 15, max = 4},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "I AM ERADICATOR!", yell = true},
}
monster.events = {
    "Eradicator1",
}

mtype:register(monster)
