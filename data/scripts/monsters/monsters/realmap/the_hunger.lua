local mtype = Game.createMonsterType("The Hunger")
local monster = {}

monster.name = "The Hunger"
monster.description = "a the hunger"

monster.experience = 15000
monster.race = "fire"
monster.maxHealth = 400000
monster.health = 400000
monster.speed = 400
monster.manaCost = 0
monster.corpse = 26220
monster.outfit = { lookType = 876, lookHead = 77, lookBody = 80, lookLegs = 84, lookFeet = 94, lookAddons = 0 }
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
        maxDamage = -1400,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -800,
        maxDamage = -1400,
    },
    {
        name = "physical",
        interval = 3000,
        chance = 34,
        range = 7,
        minDamage = -600,
        maxDamage = -1700,
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
        name = "fire",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -800,
        maxDamage = -2200,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "firefield",
        interval = 2000,
        chance = 10,
        range = 7,
        radius = 8,
        target = true,
        shootEffect = CONST_ANI_FIRE,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 30,
        minDamage = -450,
        maxDamage = -1730,
        length = 8,
        spread = 3,
        effect = CONST_ME_FIREAREA,
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
        maxDamage = -1600,
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
        maxDamage = -1550,
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
    {type = COMBAT_ICEDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.maxSummons = 8
monster.summons = {
    {name = "Frenzy", interval = 4000, chance = 8, max = 5},
    {name = "Charger", interval = 4000, chance = 8, max = 3},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "I AM HUNGER!", yell = true},
}
monster.events = {
    "The Hunger",
}

mtype:register(monster)
