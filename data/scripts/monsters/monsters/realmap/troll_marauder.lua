local mtype = Game.createMonsterType("Troll Marauder")
local monster = {}

monster.name = "Troll Marauder"
monster.description = "a troll marauder"

monster.experience = 40
monster.race = "blood"
monster.maxHealth = 70
monster.health = 70
monster.speed = 120
monster.manaCost = 0
monster.corpse = 7926
monster.outfit = { lookType = 281 }
monster.changeTarget = {
    interval = 2000,
    chance = 0,
}
monster.targetDistance = 1
monster.runHealth = 15
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
        attack = 25,
        skill = 10,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 4,
    armor = 6,
}
monster.loot = {
    {id = 23839, chance = 5190, maxCount = 3},
    {id = 10606, chance = 2600},
    {id = 2148, chance = 100000, maxCount = 8},
    {id = 2643, chance = 5190},
    {id = 2666, chance = 24680},
    {id = 2170, chance = 1300},
    {id = 2389, chance = 25970},
    {id = 2448, chance = 10390},
    {id = 2484, chance = 9090},
    {id = 12471, chance = 5190},
    {id = 2512, chance = 11690},
}

mtype:register(monster)
