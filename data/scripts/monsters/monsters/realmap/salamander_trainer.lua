local mtype = Game.createMonsterType("Salamander Trainer")
local monster = {}

monster.name = "Salamander Trainer"
monster.description = "a salamander trainer"

monster.experience = 64
monster.race = "blood"
monster.maxHealth = 220
monster.health = 220
monster.speed = 300
monster.manaCost = 0
monster.corpse = 5960
monster.outfit = { lookType = 15 }
monster.changeTarget = {
    interval = 2000,
    chance = 0,
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
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 25,
        skill = 10,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 13,
    armor = 8,
    {
        name = "healing",
        interval = 2000,
        chance = 25,
        minDamage = 10,
        maxDamage = 25,
        effect = CONST_ME_MAGIC_GREEN,
    },
    {
        name = "salamander trainer summon",
        interval = 2000,
        chance = 30,
    },
}
monster.loot = {
    {id = 10606, chance = 1050},
    {id = 2148, chance = 65300, maxCount = 12},
    {id = 2380, chance = 17960},
    {id = 2643, chance = 9800},
    {id = 2461, chance = 11780},
    {id = 2666, chance = 15200},
    {id = 2120, chance = 7960},
    {id = 2389, chance = 12970, maxCount = 3},
    {id = 2512, chance = 4710},
    {id = 2448, chance = 5030},
    {id = 2170, chance = 80},
}

mtype:register(monster)
