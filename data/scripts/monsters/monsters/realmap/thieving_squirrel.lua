local mtype = Game.createMonsterType("Thieving Squirrel")
local monster = {}

monster.name = "Thieving Squirrel"
monster.description = "a thieving squirrel"

monster.experience = 0
monster.race = "blood"
monster.maxHealth = 55
monster.health = 55
monster.speed = 1000
monster.manaCost = 220
monster.corpse = 7628
monster.outfit = { lookType = 274 }
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.runHealth = 55
monster.flags = {
    summonable = true,
    attackable = true,
    hostile = false,
    illusionable = true,
    convinceable = true,
    pushable = true,
    canPushItems = false,
    canPushCreatures = false,
}
monster.defenses = {
    defense = 5,
    armor = 5,
    {
        name = "invisible",
        interval = 2000,
        chance = 10,
        duration = 3000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Chchch", yell = false},
}
monster.loot = {
    {id = 11100, chance = 100000},
    {id = 7910, chance = 980},
}

mtype:register(monster)
