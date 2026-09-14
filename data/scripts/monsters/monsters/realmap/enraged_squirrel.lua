local mtype = Game.createMonsterType("Enraged Squirrel")
local monster = {}

monster.name = "Enraged Squirrel"
monster.description = "an enraged squirrel"

monster.experience = 10
monster.race = "blood"
monster.maxHealth = 20
monster.health = 20
monster.speed = 300
monster.manaCost = 220
monster.corpse = 7628
monster.outfit = { lookType = 274 }
monster.changeTarget = {
    interval = 4000,
    chance = 0,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 2
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
        attack = 10,
        skill = 10,
        interval = 2000,
    },
}
monster.defenses = {
    defense = 5,
    armor = 5,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Chchch", yell = false},
}
monster.loot = {
    {id = 7909, chance = 1140},
}

mtype:register(monster)
