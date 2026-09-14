local mtype = Game.createMonsterType("Chikhaton")
local monster = {}

monster.name = "Chikhaton"
monster.description = "Chikhaton"

monster.experience = 20000
monster.race = "blood"
monster.maxHealth = 20000
monster.health = 20000
monster.speed = 220
monster.manaCost = 0
monster.corpse = 12273
monster.outfit = { lookType = 361 }
monster.changeTarget = {
    interval = 5000,
    chance = 30,
}
monster.staticAttackChance = 90
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
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -1130,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = 0,
        maxDamage = -500,
        shootEffect = CONST_ANI_LARGEROCK,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
    {
        name = "healing",
        interval = 4000,
        chance = 15,
        minDamage = 550,
        maxDamage = 850,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 50},
}
monster.immunities = {
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "Victis", yell = false},
}

mtype:register(monster)
