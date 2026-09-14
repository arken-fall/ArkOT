local mtype = Game.createMonsterType("Instable Breach Brood")
local monster = {}

monster.name = "Instable Breach Brood"
monster.description = "a instable breach brood"

monster.experience = 10
monster.race = "undead"
monster.maxHealth = 2200
monster.health = 2200
monster.speed = 350
monster.manaCost = 0
monster.corpse = 26209
monster.outfit = { lookType = 878 }
monster.changeTarget = {
    interval = 20000,
    chance = 15,
}
monster.staticAttackChance = 85
monster.targetDistance = 1
monster.runHealth = 0
monster.light = { level = 0, color = 0 }
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 90,
        skill = 50,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 20,
        range = 6,
        minDamage = -168,
        maxDamage = -300,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_PURPLEENERGY,
    },
    {
        name = "energy strike",
        interval = 2000,
        chance = 30,
        range = 1,
        minDamage = -50,
        maxDamage = -180,
    },
    {
        name = "energycondition",
        interval = 1000,
        chance = 15,
        radius = 3,
        target = false,
        effect = CONST_ME_YELLOWENERGY,
    },
}
monster.defenses = {
    defense = 25,
    armor = 25,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 90,
        maxDamage = 150,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = -5},
    {type = COMBAT_HOLYDAMAGE, percent = -5},
    {type = COMBAT_DEATHDAMAGE, percent = -10},
    {type = COMBAT_ICEDAMAGE, percent = -30},
    {type = COMBAT_FIREDAMAGE, percent = -40},
    {type = COMBAT_EARTHDAMAGE, percent = 20},
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 20,
    {text = "Hisss!", yell = false},
}

mtype:register(monster)
