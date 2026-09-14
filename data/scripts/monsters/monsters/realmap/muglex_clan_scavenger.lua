local mtype = Game.createMonsterType("Muglex Clan Scavenger")
local monster = {}

monster.name = "Muglex Clan Scavenger"
monster.description = "a muglex clan scavenger"

monster.experience = 37
monster.race = "blood"
monster.maxHealth = 60
monster.health = 60
monster.speed = 132
monster.manaCost = 0
monster.corpse = 6002
monster.outfit = { lookType = 297 }
monster.changeTarget = {
    interval = 5000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 15
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
        attack = 10,
        skill = 10,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 13,
        range = 7,
        minDamage = -0,
        maxDamage = -22,
        shootEffect = CONST_ANI_SPEAR,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 3,
        range = 1,
        minDamage = -20,
        maxDamage = -30,
        shootEffect = CONST_ANI_DEATH,
        effect = CONST_ME_MORTAREA,
    },
}
monster.defenses = {
    defense = 4,
    armor = 2,
    {
        name = "healing",
        interval = 2000,
        chance = 1,
        minDamage = 10,
        maxDamage = 20,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 5,
        duration = 4000,
        speed = 140,
        effect = CONST_ME_ENERGYHIT,
    },
}
monster.loot = {
    {id = 2230, chance = 10820},
    {id = 2449, chance = 11860},
    {id = 2379, chance = 30410},
    {id = 2667, chance = 16750, maxCount = 3},
    {id = 2148, chance = 100000, maxCount = 12},
    {id = 2467, chance = 7990},
    {id = 2461, chance = 7990},
    {id = 2235, chance = 9020},
    {id = 2406, chance = 11860},
    {id = 2559, chance = 15210},
    {id = 1294, chance = 22420, maxCount = 2},
}

mtype:register(monster)
