local mtype = Game.createMonsterType("Brittle Skeleton")
local monster = {}

monster.name = "Brittle Skeleton"
monster.description = "a brittle skeleton"

monster.experience = 35
monster.race = "undead"
monster.maxHealth = 50
monster.health = 50
monster.speed = 154
monster.manaCost = 0
monster.corpse = 5972
monster.outfit = { lookType = 33 }
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
        attack = 18,
        skill = 10,
        interval = 2000,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 8,
        range = 7,
        minDamage = -7,
        maxDamage = -13,
        shootEffect = CONST_ANI_SUDDENDEATH,
    },
}
monster.defenses = {
    defense = 9,
    armor = 2,
}
monster.loot = {
    {id = 2230, chance = 49870},
    {id = 2511, chance = 2920},
    {id = 2148, chance = 100000, maxCount = 5},
    {id = 2388, chance = 4770},
    {id = 2398, chance = 4770},
    {id = 12437, chance = 9280},
    {id = 2484, chance = 2920},
    {id = 2376, chance = 6100},
    {id = 2050, chance = 10610},
    {id = 2473, chance = 3980},
}

mtype:register(monster)
