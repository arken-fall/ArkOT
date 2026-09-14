local mtype = Game.createMonsterType("Rage Of Mazoran")
local monster = {}

monster.name = "Rage Of Mazoran"
monster.description = "a rage of mazoran"

monster.experience = 3900
monster.race = "fire"
monster.maxHealth = 8800
monster.health = 8800
monster.speed = 220
monster.manaCost = 0
monster.corpse = 6324
monster.outfit = { lookType = 243 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 90
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
        maxDamage = -1520,
        interval = 2000,
    },
    {
        name = "firefield",
        interval = 2000,
        chance = 10,
        range = 7,
        radius = 3,
        target = false,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 10,
        minDamage = -392,
        maxDamage = -2000,
        length = 8,
        spread = 0,
        target = false,
        effect = CONST_ME_FIREATTACK,
    },
    {
        name = "fire",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -60,
        maxDamage = -430,
        radius = 3,
        target = false,
        effect = CONST_ME_HITBYFIRE,
    },
    {
        name = "hellfire fighter soulfire",
        interval = 2000,
        chance = 15,
    },
}
monster.defenses = {
    defense = 35,
    armor = 35,
}
monster.elements = {
    {type = COMBAT_ENERGYDAMAGE, percent = 25},
    {type = COMBAT_PHYSICALDAMAGE, percent = 50},
    {type = COMBAT_DEATHDAMAGE, percent = 20},
    {type = COMBAT_ICEDAMAGE, percent = -25},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}

mtype:register(monster)
