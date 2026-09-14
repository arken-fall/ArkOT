local mtype = Game.createMonsterType("Minotaur Poacher")
local monster = {}

monster.name = "Minotaur Poacher"
monster.description = "a minotaur poacher"

monster.experience = 55
monster.race = "blood"
monster.maxHealth = 160
monster.health = 160
monster.speed = 170
monster.manaCost = 0
monster.corpse = 5982
monster.outfit = { lookType = 24 }
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
        minDamage = 0,
        maxDamage = -15,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 40,
        range = 7,
        minDamage = 0,
        maxDamage = -20,
        shootEffect = CONST_ANI_BOLT,
    },
}
monster.defenses = {
    defense = 5,
    armor = 5,
}
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 28},
    {id = 2543, chance = 55000, maxCount = 18},
    {id = 12407, chance = 19400},
    {id = 2464, chance = 10000},
    {id = 2484, chance = 6000},
    {id = 2666, chance = 5000},
    {id = 5878, chance = 1400},
    {id = 2455, chance = 710},
    {id = 12428, chance = 710},
}

mtype:register(monster)
