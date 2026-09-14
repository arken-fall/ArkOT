local mtype = Game.createMonsterType("Minion Of Versperoth")
local monster = {}

monster.name = "Minion Of Versperoth"
monster.description = "a minion of Versperoth"

monster.experience = 2900
monster.race = "fire"
monster.maxHealth = 3800
monster.health = 3800
monster.speed = 290
monster.manaCost = 0
monster.corpse = 0
monster.outfit = { lookType = 491 }
monster.changeTarget = {
    interval = 5000,
    chance = 8,
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
        maxDamage = -390,
        interval = 2000,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 15,
        minDamage = -350,
        maxDamage = -700,
        length = 8,
        spread = 0,
        effect = CONST_ME_FIREATTACK,
    },
    {
        name = "manadrain",
        interval = 2000,
        chance = 10,
        minDamage = -600,
        maxDamage = -1300,
        length = 8,
        spread = 0,
        effect = CONST_ME_MORTAREA,
    },
    {
        name = "lava golem soulfire",
        interval = 2000,
        chance = 15,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 15,
        minDamage = -220,
        maxDamage = -350,
        radius = 4,
        target = true,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 10,
        length = 5,
        spread = 3,
        duration = 10000,
        speed = -300,
        target = false,
        effect = CONST_ME_BLOCKHIT,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 30,
        minDamage = -280,
        maxDamage = -350,
        radius = 3,
        target = false,
        effect = CONST_ME_HITBYFIRE,
    },
}
monster.defenses = {
    defense = 60,
    armor = 60,
}
monster.elements = {
    {type = COMBAT_ICEDAMAGE, percent = -5},
    {type = COMBAT_PHYSICALDAMAGE, percent = 1},
    {type = COMBAT_ENERGYDAMAGE, percent = 1},
    {type = COMBAT_DEATHDAMAGE, percent = 1},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Grrrrunt", yell = false},
}

mtype:register(monster)
