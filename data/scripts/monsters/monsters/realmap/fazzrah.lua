local mtype = Game.createMonsterType("Fazzrah")
local monster = {}

monster.name = "Fazzrah"
monster.description = "Fazzrah"

monster.experience = 2600
monster.race = "blood"
monster.maxHealth = 2955
monster.health = 2955
monster.speed = 290
monster.manaCost = 0
monster.corpse = 11284
monster.outfit = { lookType = 343 }
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
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -260,
        interval = 2000,
    },
    {
        name = "poison",
        interval = 2000,
        chance = 25,
        range = 7,
        minDamage = -220,
        maxDamage = -270,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_GREEN_RINGS,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
    {
        name = "healing",
        interval = 2000,
        chance = 10,
        minDamage = 200,
        maxDamage = 280,
        effect = CONST_ME_MAGIC_GREEN,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 1},
    {type = COMBAT_ICEDAMAGE, percent = -1},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Zztand and fight!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 292},
    {id = 5876, chance = 100000},
    {id = 5881, chance = 100000},
    {id = 2152, chance = 100000, maxCount = 5},
    {id = 7588, chance = 100000},
    {id = 11330, chance = 100000},
    {id = 11331, chance = 100000},
    {id = 7591, chance = 75000, maxCount = 3},
    {id = 11303, chance = 75000},
    {id = 2149, chance = 71000, maxCount = 5},
    {id = 11206, chance = 25000},
    {id = 11304, chance = 6250},
    {id = 11301, chance = 3130},
}

mtype:register(monster)
