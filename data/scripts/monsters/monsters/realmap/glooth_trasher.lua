local mtype = Game.createMonsterType("Glooth Trasher")
local monster = {}

monster.name = "Glooth Trasher"
monster.description = "a glooth trasher"

monster.experience = 100
monster.race = "blood"
monster.maxHealth = 1000
monster.health = 1000
monster.speed = 270
monster.manaCost = 490
monster.corpse = 8062
monster.outfit = { lookType = 600 }
monster.changeTarget = {
    interval = 4000,
    chance = 80,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = true,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 260,
        skill = 210,
        interval = 2000,
    },
    {
        name = "firecondition",
        interval = 1000,
        chance = 7,
        range = 2,
        minDamage = -20,
        maxDamage = -100,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_BLOCKHIT,
    },
    {
        name = "physical",
        interval = 1000,
        chance = 7,
        minDamage = -10,
        maxDamage = -50,
        radius = 6,
        target = false,
        effect = CONST_ME_EXPLOSIONHIT,
    },
    {
        name = "fire",
        interval = 1000,
        chance = 50,
        minDamage = -20,
        maxDamage = -50,
        radius = 5,
        target = false,
        effect = CONST_ME_BLOCKHIT,
    },
    {
        name = "firefield",
        interval = 1000,
        chance = 4,
        radius = 8,
        target = false,
        effect = CONST_ME_EXPLOSIONHIT,
    },
    {
        name = "fire",
        interval = 1000,
        chance = 34,
        range = 7,
        minDamage = -50,
        maxDamage = -100,
        radius = 7,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "fire",
        interval = 1000,
        chance = 13,
        minDamage = -50,
        maxDamage = -100,
        length = 8,
        spread = 0,
        effect = CONST_ME_EXPLOSIONHIT,
    },
    {
        name = "fire",
        interval = 1000,
        chance = 10,
        minDamage = -30,
        maxDamage = -100,
        length = 8,
        spread = 3,
        effect = CONST_ME_FIREAREA,
    },
}
monster.defenses = {
    defense = 150,
    armor = 165,
    {
        name = "healing",
        interval = 1000,
        chance = 15,
        minDamage = 500,
        maxDamage = 1000,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "healing",
        interval = 1000,
        chance = 25,
        minDamage = 200,
        maxDamage = 300,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 1000,
        chance = 10,
        duration = 3000,
        speed = 1800,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 5},
    {type = COMBAT_HOLYDAMAGE, percent = 5},
    {type = COMBAT_EARTHDAMAGE, percent = -5},
    {type = COMBAT_DEATHDAMAGE, percent = -5},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Let's see if you can handle THIS!", yell = false},
    {text = "The world will bow before my brilliancy!", yell = false},
    {text = "You will perish!", yell = false},
}

mtype:register(monster)
