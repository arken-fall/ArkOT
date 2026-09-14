local mtype = Game.createMonsterType("Minotaur Bruiser")
local monster = {}

monster.name = "Minotaur Bruiser"
monster.description = "a minotaur bruiser"

monster.experience = 50
monster.race = "blood"
monster.maxHealth = 100
monster.health = 100
monster.speed = 170
monster.manaCost = 0
monster.corpse = 5969
monster.outfit = { lookType = 25 }
monster.changeTarget = {
    interval = 4000,
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
        minDamage = 0,
        maxDamage = -45,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 15,
    armor = 10,
}
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 2148, chance = 65700, maxCount = 15},
    {id = 2510, chance = 20000},
    {id = 2398, chance = 12900},
    {id = 2464, chance = 10000},
    {id = 2460, chance = 7800},
    {id = 2376, chance = 5000},
    {id = 2666, chance = 5000},
    {id = 2386, chance = 4000},
    {id = 12428, chance = 2000, maxCount = 2},
    {id = 5878, chance = 980},
    {id = 2554, chance = 310},
    {id = 2172, chance = 120},
}

mtype:register(monster)
