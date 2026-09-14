local mtype = Game.createMonsterType("Woodling")
local monster = {}

monster.name = "Woodling"
monster.description = "a woodling"

monster.experience = 40
monster.race = "blood"
monster.maxHealth = 80
monster.health = 80
monster.speed = 190
monster.manaCost = 0
monster.corpse = 23817
monster.outfit = { lookType = 535 }
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
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 14,
        skill = 10,
        interval = 2000,
    },
    {
        name = "woodling paralyze",
        interval = 2000,
        chance = 10,
    },
    {
        name = "poison",
        interval = 2000,
        chance = 15,
        range = 3,
        minDamage = -4,
        maxDamage = -9,
        shootEffect = CONST_ANI_SMALLEARTH,
        effect = CONST_ME_INSECTS,
    },
}
monster.defenses = {
    defense = 2,
    armor = 1,
}
monster.loot = {
    {id = 23839, chance = 9450, maxCount = 10},
    {id = 2148, chance = 100000, maxCount = 12},
    {id = 20103, chance = 14500},
    {id = 2120, chance = 5700},
    {id = 2484, chance = 4950},
    {id = 2526, chance = 2670},
    {id = 20102, chance = 20250},
    {id = 2787, chance = 18200, maxCount = 4},
}

mtype:register(monster)
