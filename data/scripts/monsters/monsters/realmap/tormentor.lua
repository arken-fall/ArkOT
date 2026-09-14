local mtype = Game.createMonsterType("Tormentor")
local monster = {}

monster.name = "Tormentor"
monster.description = "Tormentor"

monster.experience = 3200
monster.race = "blood"
monster.maxHealth = 4100
monster.health = 4100
monster.speed = 240
monster.manaCost = 0
monster.corpse = 6340
monster.outfit = { lookType = 245 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 300
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
        maxDamage = -340,
        interval = 2000,
    },
    {
        name = "death",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -130,
        maxDamage = -170,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_DEATH,
        effect = CONST_ME_SMALLCLOUDS,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -250,
        maxDamage = -400,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
}
monster.defenses = {
    defense = 25,
    armor = 25,
    {
        name = "healing",
        interval = 2000,
        chance = 10,
        minDamage = 60,
        maxDamage = 100,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 5000,
        speed = 420,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 20},
    {type = COMBAT_ENERGYDAMAGE, percent = 20},
    {type = COMBAT_ICEDAMAGE, percent = 10},
}
monster.immunities = {
    {type = "invisible", condition = true},
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "lifedrain", combat = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Take a ride with me.", yell = false},
    {text = "Pffffrrrrrrrrrrrr.", yell = false},
    {text = "Close your eyes... I have something for you.", yell = false},
    {text = "I will make you scream.", yell = false},
    {text = "I will haunt you forever!", yell = false},
}
monster.loot = {
    {id = 6558, chance = 100000},
    {id = 6300, chance = 100000},
    {id = 6500, chance = 100000},
    {id = 11223, chance = 100000},
    {id = 2671, chance = 100000, maxCount = 2},
    {id = 2152, chance = 90000, maxCount = 10},
    {id = 11229, chance = 81000},
    {id = 2477, chance = 70000},
    {id = 5669, chance = 40000},
    {id = 6526, chance = 28000},
    {id = 2454, chance = 14000},
    {id = 7418, chance = 10000},
    {id = 2195, chance = 8000},
}

mtype:register(monster)
