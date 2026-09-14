local mtype = Game.createMonsterType("Tromphonyte")
local monster = {}

monster.name = "Tromphonyte"
monster.description = "Tromphonyte"

monster.experience = 1300
monster.race = "blood"
monster.maxHealth = 3000
monster.health = 3000
monster.speed = 240
monster.manaCost = 0
monster.corpse = 13312
monster.outfit = { lookType = 381 }
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
        maxDamage = -215,
        interval = 2000,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 15,
        minDamage = -170,
        maxDamage = -300,
        radius = 3,
        target = false,
        effect = CONST_ME_GROUNDSHAKER,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 15,
        minDamage = -90,
        maxDamage = -130,
        target = true,
        shootEffect = CONST_ANI_SMALLSTONE,
    },
    {
        name = "stampor skill reducer",
        interval = 2000,
        chance = 10,
        range = 5,
    },
}
monster.defenses = {
    defense = 0,
    armor = 0,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 90,
        maxDamage = 120,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_HOLYDAMAGE, percent = 50},
    {type = COMBAT_DEATHDAMAGE, percent = 10},
    {type = COMBAT_FIREDAMAGE, percent = 20},
    {type = COMBAT_ENERGYDAMAGE, percent = 20},
    {type = COMBAT_ICEDAMAGE, percent = 10},
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "HRRRRRNG", yell = true},
}
monster.loot = {
    {id = 13301, chance = 100000},
    {id = 2476, chance = 100000},
    {id = 2152, chance = 100000, maxCount = 13},
    {id = 9970, chance = 100000, maxCount = 5},
    {id = 13299, chance = 100000},
    {id = 13300, chance = 100000, maxCount = 2},
    {id = 7588, chance = 100000, maxCount = 2},
    {id = 7589, chance = 100000, maxCount = 2},
    {id = 7452, chance = 50000},
}

mtype:register(monster)
