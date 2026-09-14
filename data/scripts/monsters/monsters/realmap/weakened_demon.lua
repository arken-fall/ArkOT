local mtype = Game.createMonsterType("Weakened Demon")
local monster = {}

monster.name = "Weakened Demon"
monster.description = "a weakened demon"

monster.experience = 0
monster.race = "fire"
monster.maxHealth = 5
monster.health = 5
monster.speed = 200
monster.manaCost = 0
monster.corpse = 0
monster.outfit = { lookType = 12, lookHead = 94, lookBody = 19, lookLegs = 116, lookFeet = 81 }
monster.changeTarget = {
    interval = 10000,
    chance = 20,
}
monster.staticAttackChance = 98
monster.targetDistance = 1
monster.runHealth = 0
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
}
monster.defenses = {
    defense = 5,
    armor = 5,
    {
        name = "invisible",
        interval = 2000,
        chance = 10,
        duration = 4000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "UH?", yell = false},
}

mtype:register(monster)
