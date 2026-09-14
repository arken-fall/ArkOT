local mtype = Game.createMonsterType("The Shatterer")
local monster = {}

monster.name = "The Shatterer"
monster.description = "a the shatterer"

monster.experience = 30000
monster.race = "blood"
monster.maxHealth = 100000
monster.health = 100000
monster.speed = 485
monster.manaCost = 200
monster.corpse = 9780
monster.outfit = { lookType = 842, lookHead = 77, lookBody = 132, lookLegs = 2, lookFeet = 2, lookAddons = 0 }
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
        attack = 320,
        skill = 200,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 7,
        range = 7,
        minDamage = -700,
        maxDamage = -1800,
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
        minDamage = -900,
        maxDamage = -2400,
        radius = 8,
        target = false,
        effect = CONST_ME_LOSEENERGY,
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
        maxDamage = -1900,
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
        maxDamage = -1500,
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
        interval = 2000,
        chance = 25,
        minDamage = 2000,
        maxDamage = 5000,
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
        chance = 17,
        duration = 2000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 17,
    {text = "STOMP! SHAKE! SHATTERER!!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 9000, maxCount = 100},
    {id = 2148, chance = 9000, maxCount = 100},
    {id = 2152, chance = 9000, maxCount = 25},
    {id = 8473, chance = 13500, maxCount = 10},
    {id = 8472, chance = 14500, maxCount = 10},
    {id = 7590, chance = 14500, maxCount = 10},
    {id = 2145, chance = 14500, maxCount = 10},
    {id = 2147, chance = 14500, maxCount = 12},
}
monster.events = {
    "Shatterer",
}

mtype:register(monster)
