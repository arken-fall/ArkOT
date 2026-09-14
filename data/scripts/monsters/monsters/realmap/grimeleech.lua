local mtype = Game.createMonsterType("Grimeleech")
local monster = {}

monster.name = "Grimeleech"
monster.description = "a grimeleech"

monster.experience = 7200
monster.race = "undead"
monster.maxHealth = 9500
monster.health = 9500
monster.speed = 320
monster.manaCost = 0
monster.corpse = 25436
monster.outfit = { lookType = 855 }
monster.changeTarget = {
    interval = 3000,
    chance = 20,
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
        attack = 80,
        skill = 70,
        interval = 2000,
    },
    {
        name = "melee",
        attack = 100,
        skill = 153,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 14,
        range = 7,
        minDamage = 100,
        maxDamage = -565,
        target = true,
        shootEffect = CONST_ANI_DEATH,
        effect = CONST_ME_MORTAREA,
    },
    {
        name = "death",
        interval = 2000,
        chance = 12,
        minDamage = -150,
        maxDamage = -220,
        length = 8,
        spread = 0,
        effect = CONST_ME_DRAWBLOOD,
    },
    {
        name = "death",
        interval = 2000,
        chance = 13,
        minDamage = -225,
        maxDamage = -375,
        radius = 4,
        target = false,
        effect = CONST_ME_DRAWBLOOD,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 9,
        minDamage = -0,
        maxDamage = -300,
        length = 8,
        spread = 3,
        effect = CONST_ME_EXPLOSIONAREA,
    },
}
monster.defenses = {
    defense = 30,
    armor = 30,
    {
        name = "healing",
        interval = 2000,
        chance = 16,
        minDamage = 130,
        maxDamage = 205,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "effect",
        interval = 2000,
        chance = 9,
        effect = CONST_ME_MAGIC_GREEN,
    },
    {
        name = "effect",
        interval = 2000,
        chance = 10,
        effect = CONST_ME_DRAWBLOOD,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 12,
        duration = 4000,
        speed = 532,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = -10},
    {type = COMBAT_EARTHDAMAGE, percent = 40},
    {type = COMBAT_PHYSICALDAMAGE, percent = 20},
    {type = COMBAT_ICEDAMAGE, percent = 65},
    {type = COMBAT_HOLYDAMAGE, percent = -10},
    {type = COMBAT_DEATHDAMAGE, percent = 80},
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 5,
    {text = "Death!", yell = true},
    {text = "Come a little closer!", yell = true},
    {text = "The end is near!", yell = true},
}
monster.loot = {
    {id = 2148, chance = 59020, maxCount = 271},
    {id = 2152, chance = 45230, maxCount = 4},
    {id = 6558, chance = 2760},
    {id = 6500, chance = 2920},
    {id = 2795, chance = 9720, maxCount = 4},
    {id = 7591, chance = 8550, maxCount = 4},
    {id = 7590, chance = 8070, maxCount = 4},
    {id = 8472, chance = 8170, maxCount = 4},
    {id = 2796, chance = 2140, maxCount = 4},
    {id = 2150, chance = 1940, maxCount = 2},
    {id = 2145, chance = 1940, maxCount = 2},
    {id = 2147, chance = 1940, maxCount = 2},
    {id = 9970, chance = 1940, maxCount = 2},
    {id = 2520, chance = 390},
    {id = 2462, chance = 1500},
    {id = 7894, chance = 1000},
    {id = 7418, chance = 1460},
    {id = 2156, chance = 760},
    {id = 25523, chance = 240},
    {id = 25382, chance = 230},
    {id = 25386, chance = 1910},
    {id = 2645, chance = 690},
    {id = 8910, chance = 1280},
    {id = 25383, chance = 100},
    {id = 2154, chance = 900},
    {id = 8922, chance = 900},
    {id = 7388, chance = 1000},
    {id = 7414, chance = 900},
}

mtype:register(monster)
