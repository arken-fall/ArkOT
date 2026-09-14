local mtype = Game.createMonsterType("Fire Horse")
local monster = {}

monster.name = "Fire Horse"
monster.description = "a fire horse"

monster.experience = 0
monster.race = "blood"
monster.maxHealth = 75
monster.health = 75
monster.speed = 220
monster.manaCost = 260
monster.corpse = 0
monster.outfit = { lookType = 429 }
monster.changeTarget = {
    interval = 2000,
    chance = 20,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 25
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = false,
    illusionable = true,
    convinceable = true,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -2,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 2,
    armor = 2,
}

mtype:register(monster)
