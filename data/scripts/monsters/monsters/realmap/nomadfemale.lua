local mtype = Game.createMonsterType("Nomad")
local monster = {}

monster.name = "Nomad"
monster.description = "a nomad"

monster.experience = 60
monster.race = "blood"
monster.maxHealth = 160
monster.health = 160
monster.speed = 205
monster.manaCost = 0
monster.corpse = 20462
monster.outfit = { lookType = 150, lookHead = 115, lookBody = 39, lookLegs = 59, lookFeet = 2, lookAddons = 2 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
monster.runHealth = 15
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
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -80,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 10,
        radius = 1,
        target = false,
        effect = CONST_ME_SOUND_WHITE,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 20},
    {type = COMBAT_HOLYDAMAGE, percent = 20},
    {type = COMBAT_PHYSICALDAMAGE, percent = -10},
    {type = COMBAT_ICEDAMAGE, percent = -10},
    {type = COMBAT_DEATHDAMAGE, percent = -10},
}
monster.loot = {
    {id = 2148, chance = 56000, maxCount = 40},
    {id = 12448, chance = 6420},
    {id = 8838, chance = 4840, maxCount = 3},
    {id = 2386, chance = 2730},
    {id = 2465, chance = 2350},
    {id = 2398, chance = 2150},
    {id = 12412, chance = 2140},
    {id = 2509, chance = 900},
    {id = 2459, chance = 660},
    {id = 8267, chance = 210},
}

mtype:register(monster)
