local mtype = Game.createMonsterType("Wounded Cave Draptor")
local monster = {}

monster.name = "Wounded Cave Draptor"
monster.description = "a wounded cave draptor"

monster.experience = 150
monster.race = "blood"
monster.maxHealth = 10
monster.health = 10
monster.speed = 150
monster.manaCost = 0
monster.corpse = 22686
monster.outfit = { lookType = 596 }
monster.changeTarget = {
    interval = 5000,
    chance = 8,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 9
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -3,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 5,
    armor = 5,
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 3},
}

mtype:register(monster)
