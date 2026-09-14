local mtype = Game.createMonsterType("Gorgo")
local monster = {}

monster.name = "Gorgo"
monster.description = "Gorgo"

monster.experience = 7000
monster.race = "blood"
monster.maxHealth = 4500
monster.health = 4500
monster.speed = 280
monster.manaCost = 0
monster.corpse = 10524
monster.outfit = { lookType = 330 }
monster.changeTarget = {
    interval = 4000,
    chance = 20,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 600
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
        maxDamage = -450,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -42, maxDamage = -42, interval = 4000 },
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -21,
        maxDamage = -350,
        target = true,
        shootEffect = CONST_ANI_EARTH,
        effect = CONST_ME_CARNIPHILA,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        minDamage = -250,
        maxDamage = -500,
        length = 8,
        spread = 3,
        effect = CONST_ME_CARNIPHILA,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 25,
        radius = 7,
        speed = -400,
        target = true,
        effect = CONST_ME_POFF,
    },
    {
        name = "outfit",
        interval = 2000,
        chance = 1,
        range = 7,
        duration = 3000,
        monster = "clay guardian",
        target = true,
    },
}
monster.defenses = {
    defense = 30,
    armor = 30,
    {
        name = "healing",
        interval = 2000,
        chance = 25,
        minDamage = 150,
        maxDamage = 300,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = -5},
    {type = COMBAT_ENERGYDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
    {type = "lifedrain", combat = true},
    {type = "drown", combat = true, condition = true},
}
monster.loot = {
    {id = 2536, chance = 100000},
    {id = 2152, chance = 100000, maxCount = 20},
    {id = 11226, chance = 100000},
    {id = 7590, chance = 87000, maxCount = 2},
    {id = 10219, chance = 60000},
    {id = 8473, chance = 60000, maxCount = 2},
    {id = 2149, chance = 46470, maxCount = 4},
    {id = 7887, chance = 46470},
    {id = 7884, chance = 46470},
    {id = 7885, chance = 33300},
    {id = 7413, chance = 33300},
}

mtype:register(monster)
