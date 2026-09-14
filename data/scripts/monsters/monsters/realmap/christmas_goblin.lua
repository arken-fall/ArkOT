local mtype = Game.createMonsterType("Christmas Goblin")
local monster = {}

monster.name = "Christmas Goblin"
monster.description = "a christmas goblin"

monster.experience = 25
monster.race = "blood"
monster.maxHealth = 550
monster.health = 550
monster.speed = 550
monster.manaCost = 290
monster.corpse = 6002
monster.outfit = { lookType = 61 }
monster.changeTarget = {
    interval = 5000,
    chance = 0,
}
monster.targetDistance = 3
monster.staticAttackChance = 90
monster.runHealth = 550
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
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
        chance = 10,
        range = 7,
        minDamage = 0,
        maxDamage = -25,
        shootEffect = CONST_ANI_SMALLSTONE,
    },
}
monster.defenses = {
    defense = 10,
    armor = 10,
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 20},
    {type = COMBAT_HOLYDAMAGE, percent = 1},
    {type = COMBAT_EARTHDAMAGE, percent = -12},
    {type = COMBAT_DEATHDAMAGE, percent = -10},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Me have him!", yell = false},
    {text = "Zig Zag! Gobo attack!", yell = false},
    {text = "Help! Goblinkiller!", yell = false},
    {text = "Bugga! Bugga!", yell = false},
    {text = "Me green, me mean!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 50320, maxCount = 9},
    {id = 2230, chance = 1130},
    {id = 2449, chance = 4900},
    {id = 2379, chance = 1800},
    {id = 2667, chance = 12750},
    {id = 6527, chance = 35100, maxCount = 3},
    {id = 2461, chance = 1940},
    {id = 2235, chance = 1000},
    {id = 2406, chance = 8870},
    {id = 2559, chance = 9700},
    {id = 1294, chance = 15290, maxCount = 3},
    {id = 12495, chance = 910},
}

mtype:register(monster)
