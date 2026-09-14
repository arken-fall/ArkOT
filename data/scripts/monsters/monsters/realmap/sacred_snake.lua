local mtype = Game.createMonsterType("Sacred Snake")
local monster = {}

monster.name = "Sacred Snake"
monster.description = "a sacred snake"

monster.experience = 0
monster.race = "blood"
monster.maxHealth = 10
monster.health = 10
monster.speed = 120
monster.manaCost = 205
monster.corpse = 2817
monster.outfit = { lookType = 28 }
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
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -8,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -1, maxDamage = -1, interval = 4000 },
    },
}
monster.defenses = {
    defense = 5,
    armor = 5,
}
monster.elements = {
    {type = COMBAT_EARTHDAMAGE, percent = 5},
    {type = COMBAT_ENERGYDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = -10},
    {type = COMBAT_ICEDAMAGE, percent = -10},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Zzzzzzt", yell = false},
}

mtype:register(monster)
