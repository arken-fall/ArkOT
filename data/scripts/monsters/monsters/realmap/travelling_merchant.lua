local mtype = Game.createMonsterType("Travelling Merchant")
local monster = {}

monster.name = "Travelling Merchant"
monster.description = "a travelling merchant"

monster.experience = 65
monster.race = "blood"
monster.maxHealth = 100
monster.health = 100
monster.speed = 170
monster.manaCost = 0
monster.corpse = 13176
monster.outfit = { lookType = 132, lookHead = 110, lookBody = 90, lookLegs = 128, lookFeet = 95, lookAddons = 1 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 4
monster.staticAttackChance = 90
monster.runHealth = 100
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = false,
    illusionable = false,
    convinceable = false,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "It's quite dark in the forest, isn't it?", yell = false},
}

mtype:register(monster)
