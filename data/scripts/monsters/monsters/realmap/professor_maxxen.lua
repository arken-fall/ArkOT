local mtype = Game.createMonsterType("Professor Maxxen")
local monster = {}

monster.name = "Professor Maxxen"
monster.description = "a professor maxxen"

monster.experience = 31000
monster.race = "blood"
monster.maxHealth = 90000
monster.health = 90000
monster.speed = 600
monster.manaCost = 490
monster.corpse = 24279
monster.outfit = { lookType = 679 }
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
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
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
        minDamage = -100,
        maxDamage = -700,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_BLOCKHIT,
    },
    {
        name = "physical",
        interval = 1000,
        chance = 7,
        minDamage = -50,
        maxDamage = -150,
        radius = 6,
        target = false,
        effect = CONST_ME_EXPLOSIONHIT,
    },
    {
        name = "fire",
        interval = 1000,
        chance = 50,
        minDamage = -20,
        maxDamage = -100,
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
        maxDamage = -150,
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
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.maxSummons = 4
monster.summons = {
    {name = "glooth trasher", interval = 1000, chance = 7, max = 2},
    {name = "glooth slasher", interval = 1000, chance = 10, max = 2},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Let's see if you can handle THIS!", yell = false},
    {text = "The world will bow before my brilliancy!", yell = false},
    {text = "You will perish!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 199},
    {id = 2152, chance = 37170, maxCount = 14},
    {id = 23474, chance = 23574, maxCount = 3},
    {id = 9971, chance = 23574},
    {id = 9808, chance = 23574},
}

mtype:register(monster)
