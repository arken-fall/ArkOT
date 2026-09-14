local mtype = Game.createMonsterType("Meadow Strider")
local monster = {}

monster.name = "Meadow Strider"
monster.description = "a meadow strider"

monster.experience = 50
monster.race = "blood"
monster.maxHealth = 100
monster.health = 100
monster.speed = 150
monster.manaCost = 0
monster.corpse = 23821
monster.outfit = { lookType = 530 }
monster.changeTarget = {
    interval = 5000,
    chance = 8,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 10
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
        attack = 13,
        skill = 10,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 11,
        range = 7,
        minDamage = -0,
        maxDamage = -10,
        shootEffect = CONST_ANI_SMALLSTONE,
        effect = CONST_ME_EXPLOSIONAREA,
    },
}
monster.defenses = {
    defense = 2,
    armor = 1,
    {
        name = "speed",
        interval = 2000,
        chance = 13,
        duration = 5000,
        speed = 192,
        effect = CONST_ME_HITAREA,
    },
}
monster.loot = {
    {id = 2120, chance = 4530},
    {id = 2148, chance = 100000, maxCount = 10},
    {id = 3976, chance = 14280, maxCount = 2},
    {id = 2667, chance = 25180, maxCount = 2},
    {id = 2666, chance = 25250, maxCount = 1},
    {id = 19741, chance = 6060},
    {id = 7732, chance = 160},
    {id = 19742, chance = 8980},
    {id = 2397, chance = 7640},
    {id = 2398, chance = 8310},
    {id = 2388, chance = 6660},
}

mtype:register(monster)
