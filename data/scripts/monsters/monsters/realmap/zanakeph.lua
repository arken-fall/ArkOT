local mtype = Game.createMonsterType("Zanakeph")
local monster = {}

monster.name = "Zanakeph"
monster.description = "Zanakeph"

monster.experience = 9900
monster.race = "undead"
monster.maxHealth = 13000
monster.health = 13000
monster.speed = 330
monster.manaCost = 0
monster.corpse = 6306
monster.outfit = { lookType = 231 }
monster.changeTarget = {
    interval = 2000,
    chance = 6,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 700
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
        attack = 96,
        skill = 90,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = -300,
        maxDamage = -400,
        radius = 4,
        target = true,
        effect = CONST_ME_DRAWBLOOD,
    },
    {
        name = "death",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -125,
        maxDamage = -600,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_SMALLCLOUDS,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = -100,
        maxDamage = -390,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = 0,
        maxDamage = -180,
        target = true,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 10,
        minDamage = -150,
        maxDamage = -690,
        length = 8,
        spread = 3,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -300,
        maxDamage = -700,
        length = 8,
        spread = 3,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -100,
        maxDamage = -200,
        radius = 3,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "undead dragon curse",
        interval = 2000,
        chance = 10,
    },
}
monster.defenses = {
    defense = 40,
    armor = 40,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 200,
        maxDamage = 250,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 10},
    {type = COMBAT_ICEDAMAGE, percent = 50},
    {type = COMBAT_HOLYDAMAGE, percent = -25},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 5,
    {text = "FEEEED MY ETERNAL HUNGER!", yell = true},
    {text = "I SENSE LIFE", yell = true},
}
monster.loot = {
    {id = 6300, chance = 100000},
    {id = 7430, chance = 100000},
    {id = 2148, chance = 100000, maxCount = 100},
    {id = 2033, chance = 100000},
    {id = 2152, chance = 100000, maxCount = 10},
    {id = 11233, chance = 100000, maxCount = 3},
    {id = 9971, chance = 78000},
    {id = 6500, chance = 56000},
    {id = 2476, chance = 47270},
    {id = 2491, chance = 40000},
    {id = 8472, chance = 37000, maxCount = 3},
    {id = 5925, chance = 37000, maxCount = 5},
    {id = 11368, chance = 37000},
    {id = 7591, chance = 35000, maxCount = 4},
    {id = 9810, chance = 35000},
    {id = 2149, chance = 33000, maxCount = 5},
    {id = 2146, chance = 33000, maxCount = 5},
    {id = 7590, chance = 25000, maxCount = 3},
    {id = 2466, chance = 13500},
    {id = 13291, chance = 6780},
    {id = 5741, chance = 5000},
    {id = 8885, chance = 3390},
    {id = 2498, chance = 1690},
}

mtype:register(monster)
