local mtype = Game.createMonsterType("Omnivora")
local monster = {}

monster.name = "Omnivora"
monster.description = "a omnivora"

monster.experience = 750
monster.race = "blood"
monster.maxHealth = 1200
monster.health = 1200
monster.speed = 210
monster.manaCost = 0
monster.corpse = 24651
monster.outfit = { lookType = 717 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
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
        maxDamage = -150,
        interval = 2000,
    },
    {
        name = "speed",
        interval = 4000,
        chance = 20,
        range = 7,
        duration = 12000,
        speed = -350,
        target = true,
        shootEffect = CONST_ANI_POISON,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -80,
        maxDamage = -100,
        shootEffect = CONST_ANI_POISON,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 10,
        minDamage = -50,
        maxDamage = -100,
        length = 8,
        spread = 3,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 250,
        maxDamage = 400,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = -10},
    {type = COMBAT_ENERGYDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Sssssouls for the one", yell = false},
    {text = "HISSSS", yell = true},
    {text = "Tsssse one will risssse again", yell = false},
    {text = "I bring your deathhh, mortalssss", yell = false},
}
monster.loot = {
    {id = 2148, chance = 97000, maxCount = 242},
    {id = 2667, chance = 18200, maxCount = 2},
    {id = 18418, chance = 2000},
    {id = 18417, chance = 2000},
    {id = 18416, chance = 2210},
    {id = 2671, chance = 1200},
    {id = 2787, chance = 1900},
    {id = 2168, chance = 950},
    {id = 2409, chance = 780},
    {id = 7887, chance = 700},
    {id = 7886, chance = 560},
    {id = 2185, chance = 430},
    {id = 8900, chance = 320},
    {id = 13298, chance = 100},
}

mtype:register(monster)
