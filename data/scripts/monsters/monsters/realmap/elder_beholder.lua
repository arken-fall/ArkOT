local mtype = Game.createMonsterType("Elder Bonelord")
local monster = {}

monster.name = "Elder Bonelord"
monster.description = "an elder bonelord"

monster.experience = 280
monster.race = "blood"
monster.maxHealth = 500
monster.health = 500
monster.speed = 180
monster.manaCost = 0
monster.corpse = 6037
monster.outfit = { lookType = 108 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 4
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
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -55,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = -45,
        maxDamage = -60,
        shootEffect = CONST_ANI_ENERGY,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = -40,
        maxDamage = -80,
        shootEffect = CONST_ANI_FIRE,
    },
    {
        name = "death",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -45,
        maxDamage = -90,
        shootEffect = CONST_ANI_SUDDENDEATH,
        effect = CONST_ME_MORTAREA,
        effect = CONST_ME_SMALLCLOUDS,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -20,
        maxDamage = -40,
        shootEffect = CONST_ANI_POISON,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = -45,
        maxDamage = -85,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "manadrain",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = 0,
        maxDamage = -40,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 10,
        range = 7,
        duration = 20000,
        speed = -600,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 20},
    {type = COMBAT_ICEDAMAGE, percent = 30},
    {type = COMBAT_DEATHDAMAGE, percent = 30},
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "invisible", condition = true},
}
monster.maxSummons = 6
monster.summons = {
    {name = "Gazer", interval = 2000, chance = 10, max = 1},
    {name = "Crypt Shambler", interval = 2000, chance = 15, max = 1},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Let me take a look at you!", yell = false},
    {text = "Inferior creatures, bow before my power!", yell = false},
}
monster.loot = {
    {id = "gold coin", chance = 30000, maxCount = 86},
    {id = 2175, chance = 7500},
    {id = "two handed sword", chance = 6000},
    {id = "steel shield", chance = 6000},
    {id = "bonelord shield", chance = 150},
    {id = "bonelord helmet", chance = 150},
    {id = "sniper arrow", chance = 10000, maxCount = 5},
    {id = "strong mana potion", chance = 1000},
    {id = "elder bonelord tentacle", chance = 21725},
    {id = "giant eye", chance = 850},
    {id = "small flask of eyedrops", chance = 10025},
}

mtype:register(monster)
