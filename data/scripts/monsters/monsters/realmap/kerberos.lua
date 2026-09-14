local mtype = Game.createMonsterType("Kerberos")
local monster = {}

monster.name = "Kerberos"
monster.description = "Kerberos"

monster.experience = 10000
monster.race = "blood"
monster.maxHealth = 11000
monster.health = 11000
monster.speed = 280
monster.manaCost = 0
monster.corpse = 6332
monster.outfit = { lookType = 240 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
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
        minDamage = 0,
        maxDamage = -508,
        interval = 2000,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 5,
        minDamage = 0,
        maxDamage = -700,
        length = 8,
        spread = 3,
        effect = CONST_ME_CARNIPHILA,
    },
    {
        name = "death",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = 0,
        maxDamage = -498,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_SMALLCLOUDS,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 10,
        minDamage = 0,
        maxDamage = -662,
        length = 8,
        spread = 3,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = 0,
        maxDamage = -976,
        length = 8,
        spread = 3,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = 0,
        maxDamage = -549,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 40,
    armor = 40,
}
monster.elements = {
    {type = COMBAT_EARTHDAMAGE, percent = 20},
    {type = COMBAT_ENERGYDAMAGE, percent = 10},
    {type = COMBAT_ICEDAMAGE, percent = -5},
    {type = COMBAT_HOLYDAMAGE, percent = -25},
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
    {type = "fire", combat = true, condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "GROOOWL!", yell = false},
    {text = "GRRRRR!", yell = false},
}
monster.loot = {
    {id = 2152, chance = 100000, maxCount = 18},
    {id = 2144, chance = 96880, maxCount = 5},
    {id = 6558, chance = 100000, maxCount = 1},
    {id = 6500, chance = 62500},
    {id = 9971, chance = 100000, maxCount = 5},
    {id = 2430, chance = 10810},
    {id = 6553, chance = 6250},
    {id = 10554, chance = 100000},
    {id = 2155, chance = 50000},
    {id = 2392, chance = 46880},
    {id = 4873, chance = 65630},
    {id = 7890, chance = 96880},
    {id = 7590, chance = 96880, maxCount = 3},
    {id = 7453, chance = 3130},
    {id = 2466, chance = 31250},
}

mtype:register(monster)
