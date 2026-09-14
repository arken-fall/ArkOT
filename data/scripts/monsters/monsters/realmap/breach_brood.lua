local mtype = Game.createMonsterType("Breach Brood")
local monster = {}

monster.name = "Breach Brood"
monster.description = "a breach brood"

monster.experience = 2200
monster.race = "undead"
monster.maxHealth = 3500
monster.health = 3500
monster.speed = 370
monster.manaCost = 0
monster.corpse = 26209
monster.outfit = { lookType = 878 }
monster.changeTarget = {
    interval = 20000,
    chance = 15,
}
monster.staticAttackChance = 85
monster.targetDistance = 1
monster.runHealth = 0
monster.light = { level = 0, color = 0 }
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 150,
        skill = 50,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 20,
        range = 6,
        minDamage = -168,
        maxDamage = -400,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_PURPLEENERGY,
    },
    {
        name = "energy strike",
        interval = 2000,
        chance = 30,
        range = 1,
        minDamage = -50,
        maxDamage = -180,
    },
    {
        name = "energycondition",
        interval = 1000,
        chance = 15,
        radius = 3,
        target = false,
        effect = CONST_ME_YELLOWENERGY,
    },
}
monster.defenses = {
    defense = 25,
    armor = 25,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 90,
        maxDamage = 150,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_DEATHDAMAGE, percent = -10},
    {type = COMBAT_ICEDAMAGE, percent = -30},
    {type = COMBAT_FIREDAMAGE, percent = -40},
    {type = COMBAT_EARTHDAMAGE, percent = 20},
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 20,
    {text = "Hisss!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 50000, maxCount = 100},
    {id = 2152, chance = 50000, maxCount = 2},
    {id = 26201, chance = 2000},
    {id = 26191, chance = 2000},
    {id = 26174, chance = 1000},
    {id = 26163, chance = 700},
    {id = 7590, chance = 3000},
    {id = 7591, chance = 3000},
    {id = 8472, chance = 3000},
    {id = 26167, chance = 1000},
    {id = 26162, chance = 1000},
    {id = 26170, chance = 1000},
    {id = 18418, chance = 900, maxCount = 2},
    {id = 18419, chance = 1300},
    {id = 18413, chance = 1300},
    {id = 18415, chance = 1500},
    {id = 26198, chance = 200},
    {id = 26200, chance = 200},
}

mtype:register(monster)
