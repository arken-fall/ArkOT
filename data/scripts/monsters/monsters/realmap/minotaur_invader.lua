local mtype = Game.createMonsterType("Minotaur Invader")
local monster = {}

monster.name = "Minotaur Invader"
monster.description = "a minotaur invader"

monster.experience = 1600
monster.race = "blood"
monster.maxHealth = 1850
monster.health = 1850
monster.speed = 250
monster.manaCost = 0
monster.corpse = 5983
monster.outfit = { lookType = 29 }
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
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -350,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 20},
}
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 2148, chance = 59640, maxCount = 160},
    {id = 12428, chance = 8330, maxCount = 2},
    {id = 12438, chance = 5040},
    {id = 2465, chance = 4390},
    {id = 2464, chance = 3000},
    {id = 2513, chance = 2000},
    {id = 5878, chance = 1000},
    {id = 2580, chance = 480},
    {id = 2387, chance = 400},
    {id = 7618, chance = 370},
    {id = 7401, chance = 90},
}

mtype:register(monster)
