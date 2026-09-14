local mtype = Game.createMonsterType("Troll-Trained Salamander")
local monster = {}

monster.name = "Troll-Trained Salamander"
monster.description = "a troll-trained salamander"

monster.experience = 23
monster.race = "blood"
monster.maxHealth = 70
monster.health = 70
monster.speed = 120
monster.manaCost = 0
monster.corpse = 19707
monster.outfit = { lookType = 529 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
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
        attack = 11,
        skill = 10,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -5, maxDamage = -5, interval = 4000 },
    },
    {
        name = "earth",
        interval = 2000,
        chance = 11,
        range = 5,
        minDamage = -4,
        maxDamage = -6,
        target = true,
        shootEffect = CONST_ANI_SMALLEARTH,
        effect = CONST_ME_HITBYPOISON,
    },
}
monster.defenses = {
    defense = 0,
    armor = 0,
}
monster.loot = {
    {id = 2386, chance = 5080},
    {id = 2449, chance = 4630},
    {id = 23839, chance = 17650, maxCount = 5},
    {id = 2148, chance = 100000, maxCount = 11},
    {id = 2458, chance = 6300},
    {id = 7618, chance = 1520},
    {id = 19737, chance = 34410, maxCount = 5},
    {id = 2666, chance = 9940},
    {id = 2545, chance = 2970, maxCount = 2},
    {id = 2406, chance = 4470},
    {id = 2554, chance = 5080},
    {id = 2482, chance = 4070},
}

mtype:register(monster)
