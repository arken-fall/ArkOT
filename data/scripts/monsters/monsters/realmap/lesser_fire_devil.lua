local mtype = Game.createMonsterType("Lesser Fire Devil")
local monster = {}

monster.name = "Lesser Fire Devil"
monster.description = "a lesser fire devil"

monster.experience = 110
monster.race = "blood"
monster.maxHealth = 175
monster.health = 175
monster.speed = 180
monster.manaCost = 0
monster.corpse = 5985
monster.outfit = { lookType = 40 }
monster.changeTarget = {
    interval = 2000,
    chance = 5,
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
        attack = 25,
        skill = 10,
        interval = 2000,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 5,
        range = 7,
        minDamage = -24,
        maxDamage = -36,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 35,
        range = 7,
        minDamage = -4,
        maxDamage = -12,
        radius = 2,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREATTACK,
    },
}
monster.defenses = {
    defense = 9,
    armor = 5,
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
}
monster.loot = {
    {id = 2260, chance = 21050},
    {id = 2148, chance = 100000, maxCount = 10},
    {id = 12469, chance = 22810},
    {id = 2050, chance = 1750},
    {id = 2050, chance = 1750},
}

mtype:register(monster)
