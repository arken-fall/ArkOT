local mtype = Game.createMonsterType("Orc Warrior")
local monster = {}

monster.name = "Orc Warrior"
monster.description = "an orc warrior"

monster.experience = 45
monster.race = "blood"
monster.maxHealth = 125
monster.health = 125
monster.speed = 190
monster.manaCost = 0
monster.corpse = 5979
monster.outfit = { lookType = 7 }
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
        attack = 25,
        skill = 10,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 10,
    armor = 5,
}
monster.loot = {
    {id = 12409, chance = 6740},
    {id = 2464, chance = 5620},
    {id = 2148, chance = 100000, maxCount = 8},
    {id = 2666, chance = 13480},
    {id = 12435, chance = 5620},
    {id = 2510, chance = 1120},
    {id = 12436, chance = 1120},
    {id = 2468, chance = 7870},
}

mtype:register(monster)
