local mtype = Game.createMonsterType("Lesser Death Minion")
local monster = {}

monster.name = "Lesser Death Minion"
monster.description = "a lesser death minion"

monster.experience = 35
monster.race = "undead"
monster.maxHealth = 50
monster.health = 50
monster.speed = 150
monster.manaCost = 300
monster.corpse = 5972
monster.outfit = { lookType = 33 }
monster.changeTarget = {
    interval = 4000,
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
        minDamage = 0,
        maxDamage = -17,
        interval = 2000,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 15,
        range = 1,
        minDamage = -7,
        maxDamage = -13,
    },
}
monster.defenses = {
    defense = 10,
    armor = 10,
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
}
monster.loot = {
    {id = 2230, chance = 49100},
    {id = 2148, chance = 43900, maxCount = 10},
    {id = 12437, chance = 10000},
    {id = 2050, chance = 10000},
    {id = 2473, chance = 7520},
    {id = 2398, chance = 4850},
    {id = 2388, chance = 4820},
    {id = 2511, chance = 2000},
    {id = 2376, chance = 1920},
}

mtype:register(monster)
