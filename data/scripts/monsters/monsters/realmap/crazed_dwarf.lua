local mtype = Game.createMonsterType("Crazed Dwarf")
local monster = {}

monster.name = "Crazed Dwarf"
monster.description = "a crazed dwarf"

monster.experience = 50
monster.race = "blood"
monster.maxHealth = 105
monster.health = 105
monster.speed = 170
monster.manaCost = 0
monster.corpse = 6007
monster.outfit = { lookType = 69 }
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
        attack = 26,
        skill = 10,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 10,
    armor = 7,
}
monster.loot = {
    {id = 2386, chance = 12860},
    {id = 2148, chance = 100000, maxCount = 4},
    {id = 2388, chance = 25710},
    {id = 2649, chance = 8570},
    {id = 2597, chance = 4290},
    {id = 2553, chance = 8570},
    {id = 2510, chance = 17140},
    {id = 2484, chance = 8570},
    {id = 2787, chance = 47140, maxCount = 1},
}

mtype:register(monster)
