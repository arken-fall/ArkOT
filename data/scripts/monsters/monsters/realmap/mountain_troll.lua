local mtype = Game.createMonsterType("Mountain Troll")
local monster = {}

monster.name = "Mountain Troll"
monster.description = "a mountain troll"

monster.experience = 12
monster.race = "blood"
monster.maxHealth = 30
monster.health = 30
monster.speed = 126
monster.manaCost = 290
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
    summonable = true,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = true,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 9,
        skill = 10,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 2,
    armor = 1,
}
monster.loot = {
    {id = 10606, chance = 920},
    {id = 2148, chance = 100000, maxCount = 8},
    {id = 2380, chance = 3590},
    {id = 2467, chance = 4060},
    {id = 2666, chance = 27980},
    {id = 2384, chance = 3470},
    {id = 2120, chance = 7870},
    {id = 2389, chance = 6800},
    {id = 2448, chance = 3510},
}

mtype:register(monster)
