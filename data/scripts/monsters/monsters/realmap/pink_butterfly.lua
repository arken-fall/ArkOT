local mtype = Game.createMonsterType("Butterfly")
local monster = {}

monster.name = "Butterfly"
monster.description = "a butterfly"

monster.experience = 0
monster.race = "venom"
monster.maxHealth = 2
monster.health = 2
monster.speed = 230
monster.manaCost = 0
monster.corpse = 4313
monster.outfit = { lookType = 213 }
monster.changeTarget = {
    interval = 5000,
    chance = 20,
}
monster.staticAttackChance = 90
monster.targetDistance = 6
monster.runHealth = 2
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = false,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
    canWalkOnEnergy = false,
    canWalkOnFire = false,
    canWalkOnPoison = false,
}

mtype:register(monster)
