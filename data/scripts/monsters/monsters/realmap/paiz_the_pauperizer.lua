local mtype = Game.createMonsterType("Paiz The Pauperizer")
local monster = {}

monster.name = "Paiz The Pauperizer"
monster.description = "Paiz The Pauperizer"

monster.experience = 6300
monster.race = "blood"
monster.maxHealth = 8500
monster.health = 8500
monster.speed = 280
monster.manaCost = 0
monster.corpse = 12609
monster.outfit = { lookType = 362 }
monster.changeTarget = {
    interval = 5000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
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
        minDamage = 0,
        maxDamage = -450,
        interval = 2000,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 10,
        minDamage = -240,
        maxDamage = -550,
        length = 5,
        spread = 3,
        effect = CONST_ME_EXPLOSIONHIT,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 12,
        range = 7,
        minDamage = -200,
        maxDamage = -350,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 12,
        range = 4,
        minDamage = -280,
        maxDamage = -450,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_EARTH,
        effect = CONST_ME_POFF,
    },
    {
        name = "soulfire",
        interval = 2000,
        chance = 10,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 11,
        range = 7,
        minDamage = -20,
        maxDamage = -20,
        shootEffect = CONST_ANI_POISON,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
    {
        name = "healing",
        interval = 2000,
        chance = 25,
        minDamage = 230,
        maxDamage = 330,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = 30},
    {type = COMBAT_PHYSICALDAMAGE, percent = 10},
    {type = COMBAT_DEATHDAMAGE, percent = 30},
    {type = COMBAT_ENERGYDAMAGE, percent = 40},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "invisibility"},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Hizzzzzz!", yell = false},
    {text = "For ze emperor!", yell = false},
    {text = "You will die zhouzandz deazhz!", yell = false},
}
monster.loot = {
    {id = 12616, chance = 100000},
    {id = 12617, chance = 100000},
    {id = 12614, chance = 100000},
    {id = 12615, chance = 100000},
    {id = 2148, chance = 100000, maxCount = 99},
    {id = 5881, chance = 100000},
    {id = 2666, chance = 100000, maxCount = 5},
    {id = 2152, chance = 100000, maxCount = 10},
    {id = 5904, chance = 43000},
    {id = 7591, chance = 36960, maxCount = 3},
    {id = 2154, chance = 36960},
    {id = 8472, chance = 32610, maxCount = 3},
    {id = 7590, chance = 30430, maxCount = 3},
    {id = 2156, chance = 23910},
    {id = 11306, chance = 23910},
    {id = 2155, chance = 21740},
    {id = 11307, chance = 19570},
    {id = 11301, chance = 15220},
    {id = 2492, chance = 13040},
    {id = 8880, chance = 10870},
    {id = 12613, chance = 10870},
    {id = 2158, chance = 8700},
    {id = 12607, chance = 8700},
    {id = 2149, chance = 8700, maxCount = 8},
    {id = 13294, chance = 4350},
}

mtype:register(monster)
