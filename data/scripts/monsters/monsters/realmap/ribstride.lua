local mtype = Game.createMonsterType("Ribstride")
local monster = {}

monster.name = "Ribstride"
monster.description = "Ribstride"

monster.experience = 1100
monster.race = "undead"
monster.maxHealth = 1000
monster.health = 1000
monster.speed = 210
monster.manaCost = 0
monster.corpse = 6030
monster.outfit = { lookType = 101 }
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
        maxDamage = -200,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -5, maxDamage = -5, interval = 4000 },
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -25,
        maxDamage = -47,
        radius = 3,
        target = false,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -50,
        maxDamage = -90,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 10,
        minDamage = -50,
        maxDamage = -60,
        radius = 3,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 10,
        minDamage = -70,
        maxDamage = -80,
        length = 6,
        spread = 0,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 13000,
        speed = -300,
        target = true,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 30,
        maxDamage = 50,
        effect = CONST_ME_HITBYPOISON,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
    {type = COMBAT_HOLYDAMAGE, percent = -20},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 11194, chance = 100000},
    {id = 5925, chance = 98910, maxCount = 3},
    {id = 2152, chance = 98910, maxCount = 8},
    {id = 2145, chance = 61960, maxCount = 4},
    {id = 2541, chance = 60000},
    {id = 2796, chance = 60000, maxCount = 4},
    {id = 11161, chance = 29000},
    {id = 5741, chance = 8700},
    {id = 13291, chance = 2000},
}

mtype:register(monster)
