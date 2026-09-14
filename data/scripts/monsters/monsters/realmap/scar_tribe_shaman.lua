local mtype = Game.createMonsterType("Scar Tribe Shaman")
local monster = {}

monster.name = "Scar Tribe Shaman"
monster.description = "an scar tribe shaman"

monster.experience = 85
monster.race = "blood"
monster.maxHealth = 115
monster.health = 115
monster.speed = 140
monster.manaCost = 0
monster.corpse = 5978
monster.outfit = { lookType = 6 }
monster.changeTarget = {
    interval = 2000,
    chance = 50,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 15
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 10,
        skill = 10,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 13,
        range = 7,
        minDamage = -10,
        maxDamage = -25,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 8,
        range = 7,
        minDamage = -5,
        maxDamage = -30,
        radius = 1,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
}
monster.defenses = {
    defense = 11,
    armor = 4,
    {
        name = "healing",
        interval = 2000,
        chance = 25,
        minDamage = 25,
        maxDamage = 35,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.maxSummons = 4
monster.summons = {
    {name = "Snake", interval = 2000, chance = 25, max = 4},
}
monster.loot = {
    {id = 12408, chance = 3700},
    {id = 2686, chance = 11110, maxCount = 2},
    {id = 2148, chance = 100000, maxCount = 17},
    {id = 11113, chance = 11110},
    {id = 12434, chance = 3700},
    {id = 2389, chance = 55560},
    {id = 2484, chance = 3700},
    {id = 2468, chance = 11110},
}

mtype:register(monster)
