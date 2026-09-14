local mtype = Game.createMonsterType("Dawnfly")
local monster = {}

monster.name = "Dawnfly"
monster.description = "a dawnfly"

monster.experience = 35
monster.race = "venom"
monster.maxHealth = 90
monster.health = 90
monster.speed = 200
monster.manaCost = 0
monster.corpse = 23825
monster.outfit = { lookType = 528 }
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
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 16,
        skill = 10,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -8, maxDamage = -8, interval = 4000 },
    },
    {
        name = "poison",
        interval = 2000,
        chance = 9,
        range = 7,
        minDamage = -4,
        maxDamage = -8,
        shootEffect = CONST_ANI_POISONARROW,
    },
}
monster.defenses = {
    defense = 2,
    armor = 1,
    {
        name = "speed",
        interval = 2000,
        chance = 11,
        duration = 5000,
        speed = 238,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.loot = {
    {id = 23839, chance = 21360, maxCount = 16},
    {id = 2485, chance = 4140},
    {id = 19738, chance = 11940},
    {id = 19743, chance = 10130},
    {id = 2148, chance = 100000, maxCount = 12},
    {id = 7618, chance = 3630},
    {id = 7620, chance = 3800},
    {id = 2545, chance = 14500, maxCount = 8},
}

mtype:register(monster)
