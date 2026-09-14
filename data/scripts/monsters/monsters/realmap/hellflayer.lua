local mtype = Game.createMonsterType("Hellflayer")
local monster = {}

monster.name = "Hellflayer"
monster.description = "a hellflayer"

monster.experience = 11000
monster.race = "blood"
monster.maxHealth = 14000
monster.health = 14000
monster.speed = 400
monster.manaCost = 0
monster.corpse = 25440
monster.outfit = { lookType = 856 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
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
        minDamage = 200,
        maxDamage = -869,
        interval = 2000,
        condition = { type = CONDITION_FIRE, minDamage = -6, maxDamage = -6, interval = 9000 },
    },
    {
        name = "fire",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -170,
        maxDamage = -300,
        shootEffect = CONST_ANI_POISON,
    },
    {
        name = "renegade knight",
        interval = 2000,
        chance = 20,
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
        minDamage = -250,
        maxDamage = -500,
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
        name = "fire",
        interval = 2000,
        chance = 10,
        minDamage = -300,
        maxDamage = -550,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREATTACK,
    },
    {
        name = "warlock skill reducer",
        interval = 2000,
        chance = 5,
        range = 5,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 10,
        minDamage = 300,
        maxDamage = -500,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_EXPLOSION,
        effect = CONST_ME_SLEEP,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
    {
        name = "healing",
        interval = 2000,
        chance = 10,
        minDamage = 80,
        maxDamage = 95,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 3000,
    chance = 50,
    {text = "You should consider bargaining for you life!", yell = false},
    {text = "Your tainted soul belongs to us anyway!", yell = false},
    {text = "Today I deal only in death!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 90000, maxCount = 130},
    {id = 2152, chance = 20000, maxCount = 9},
    {id = 6558, chance = 4000, maxCount = 3},
    {id = 9971, chance = 1300, maxCount = 2},
    {id = 7590, chance = 9600, maxCount = 2},
    {id = 8472, chance = 2300, maxCount = 2},
    {id = 2150, chance = 2000, maxCount = 5},
    {id = 2145, chance = 900, maxCount = 5},
    {id = 2149, chance = 900, maxCount = 5},
    {id = 2147, chance = 2000, maxCount = 5},
    {id = 9970, chance = 900, maxCount = 5},
    {id = 8473, chance = 5300, maxCount = 2},
    {id = 2136, chance = 1000},
    {id = 6500, chance = 1600},
    {id = 7632, chance = 800},
    {id = 2155, chance = 800},
    {id = 7891, chance = 500},
    {id = 7894, chance = 1200},
    {id = 2514, chance = 350},
    {id = 25385, chance = 800},
    {id = 2156, chance = 500},
    {id = 25522, chance = 280},
    {id = 25523, chance = 180},
    {id = 5741, chance = 450},
    {id = 25383, chance = 200},
    {id = 7413, chance = 900},
    {id = 2466, chance = 750},
    {id = 8902, chance = 900},
    {id = 2452, chance = 400},
}

mtype:register(monster)
