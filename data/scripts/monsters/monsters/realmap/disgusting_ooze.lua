local mtype = Game.createMonsterType("Disgusting Ooze")
local monster = {}

monster.name = "Disgusting Ooze"
monster.description = "a disgusting ooze"

monster.experience = 3700
monster.race = "venom"
monster.maxHealth = 50000
monster.health = 50000
monster.speed = 430
monster.manaCost = 0
monster.corpse = 6532
monster.outfit = { lookType = 238 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 85
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
        skill = 50,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -150, maxDamage = -150, interval = 4000 },
    },
    {
        name = "poison",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -160,
        maxDamage = -870,
        shootEffect = CONST_ANI_POISON,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -400,
        maxDamage = -640,
        radius = 7,
        target = false,
        effect = CONST_ME_HITBYPOISON,
    },
    {
        name = "poison",
        interval = 2000,
        chance = 20,
        minDamage = -120,
        maxDamage = -170,
        radius = 3,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 10,
        minDamage = -500,
        maxDamage = -1500,
        length = 8,
        spread = 3,
        effect = CONST_ME_SMALLPLANTS,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        length = 8,
        spread = 3,
        duration = 15000,
        speed = -700,
        effect = CONST_ME_SMALLCLOUDS,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
    {
        name = "healing",
        interval = 2000,
        chance = 10,
        minDamage = 280,
        maxDamage = 350,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 10},
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = -25},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Blubb", yell = false},
    {text = "Blubb Blubb", yell = false},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 100},
    {id = 2148, chance = 100000, maxCount = 100},
    {id = 2148, chance = 100000, maxCount = 72},
    {id = 2152, chance = 95000, maxCount = 6},
    {id = 5944, chance = 5000},
    {id = 6500, chance = 2320},
    {id = 9967, chance = 4210},
    {id = 9968, chance = 2000},
    {id = 2151, chance = 1710},
    {id = 2158, chance = 300},
    {id = 2149, chance = 1366, maxCount = 3},
    {id = 2147, chance = 1000, maxCount = 2},
    {id = 6300, chance = 3030},
    {id = 2145, chance = 2439, maxCount = 2},
    {id = 2156, chance = 1538},
    {id = 2154, chance = 1219},
    {id = 2155, chance = 613},
}

mtype:register(monster)
