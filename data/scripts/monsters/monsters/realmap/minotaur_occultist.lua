local mtype = Game.createMonsterType("Minotaur Occultist")
local monster = {}

monster.name = "Minotaur Occultist"
monster.description = "a minotaur occultist"

monster.experience = 100
monster.race = "blood"
monster.maxHealth = 125
monster.health = 125
monster.speed = 170
monster.manaCost = 0
monster.corpse = 5981
monster.outfit = { lookType = 23 }
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
        maxDamage = -10,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = 0,
        maxDamage = -20,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = 0,
        maxDamage = -20,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "energyfield",
        interval = 2000,
        chance = 10,
        range = 7,
        target = true,
        shootEffect = CONST_ANI_ENERGYBALL,
    },
}
monster.defenses = {
    defense = 10,
    armor = 10,
}
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 21},
    {id = 2684, chance = 35000, maxCount = 4},
    {id = 20104, chance = 12000},
    {id = 12428, chance = 10000},
    {id = 2649, chance = 9000},
    {id = 7620, chance = 3500},
    {id = 2050, chance = 3500},
    {id = 2461, chance = 1800},
    {id = 12429, chance = 1800},
}

mtype:register(monster)
