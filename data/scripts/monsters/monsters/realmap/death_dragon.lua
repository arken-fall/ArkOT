local mtype = Game.createMonsterType("Death Dragon")
local monster = {}

monster.name = "Death Dragon"
monster.description = "an death dragon"

monster.experience = 7200
monster.race = "undead"
monster.maxHealth = 8350
monster.health = 8350
monster.speed = 250
monster.manaCost = 0
monster.corpse = 6306
monster.outfit = { lookType = 231 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 70
monster.runHealth = 300
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
        maxDamage = -700,
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
    {type = COMBAT_PHYSICALDAMAGE, percent = 5},
    {type = COMBAT_ICEDAMAGE, percent = 50},
    {type = COMBAT_HOLYDAMAGE, percent = -25},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "death", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
    {type = "drown", combat = true, condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "FEEEED MY ETERNAL HUNGER!", yell = true},
    {text = "I SENSE LIFE", yell = true},
}
monster.loot = {
    {id = 2148, chance = 35500, maxCount = 100},
    {id = 2148, chance = 55500, maxCount = 98},
    {id = 6500, chance = 8460},
    {id = 2152, chance = 52000, maxCount = 5},
    {id = 6300, chance = 1150},
    {id = 7591, chance = 21200},
    {id = 2033, chance = 6002},
    {id = 2547, chance = 15190, maxCount = 15},
    {id = 7430, chance = 4000},
    {id = 2476, chance = 5500},
    {id = 2177, chance = 2500},
    {id = 5925, chance = 14180},
    {id = 9971, chance = 570},
    {id = 2498, chance = 1720},
    {id = 2454, chance = 1290},
    {id = 8885, chance = 330},
    {id = 11233, chance = 33380},
    {id = 2146, chance = 3370, maxCount = 2},
    {id = 7368, chance = 26650, maxCount = 5},
    {id = 7402, chance = 660},
    {id = 2144, chance = 4780, maxCount = 2},
    {id = 7590, chance = 3490},
    {id = 11355, chance = 460},
    {id = 2466, chance = 460},
    {id = 8889, chance = 290},
}

mtype:register(monster)
