local mtype = Game.createMonsterType("Doctor Perhaps")
local monster = {}

monster.name = "Doctor Perhaps"
monster.description = "doctor perhaps"

monster.experience = 325
monster.race = "blood"
monster.maxHealth = 475
monster.health = 475
monster.speed = 200
monster.manaCost = 0
monster.corpse = 20439
monster.outfit = { lookType = 133, lookHead = 95, lookBody = 0, lookLegs = 94, lookFeet = 114, lookAddons = 1 }
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
        maxDamage = -43,
        interval = 2000,
    },
    {
        name = "drown",
        interval = 2000,
        chance = 15,
        range = 5,
        minDamage = -17,
        maxDamage = -55,
        radius = 3,
        target = true,
        shootEffect = CONST_ANI_SMALLEARTH,
        effect = CONST_ME_LOSEENERGY,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -20,
        maxDamage = -40,
        shootEffect = CONST_ANI_POISON,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 10,
        maxDamage = 30,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 10},
    {type = COMBAT_EARTHDAMAGE, percent = 20},
    {type = COMBAT_ENERGYDAMAGE, percent = 20},
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_HOLYDAMAGE, percent = 20},
    {type = COMBAT_PHYSICALDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "invisible", condition = true},
    {type = "drown", combat = true, condition = true},
}
monster.maxSummons = 2
monster.summons = {
    {name = "Zombie", interval = 2000, chance = 10, max = 1},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "I might use some parts of you in my next creation!", yell = false},
    {text = "You're only a testsubject to me!", yell = false},
    {text = "My creations will kill you!", yell = false},
    {text = "You can't beat what you can't comprehend!", yell = false},
}
monster.loot = {
    {id = 10316, chance = 30000},
    {id = 10289, chance = 30000},
    {id = 10290, chance = 30000},
    {id = 10300, chance = 30000},
}

mtype:register(monster)
