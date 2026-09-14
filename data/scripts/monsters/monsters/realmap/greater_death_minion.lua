local mtype = Game.createMonsterType("Greater Death Minion")
local monster = {}

monster.name = "Greater Death Minion"
monster.description = "a greater death minion"

monster.experience = 150
monster.race = "undead"
monster.maxHealth = 240
monster.health = 240
monster.speed = 150
monster.manaCost = 0
monster.corpse = 6004
monster.outfit = { lookType = 65 }
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
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -85,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -4, maxDamage = -4, interval = 4000 },
    },
    {
        name = "death",
        interval = 2000,
        chance = 20,
        range = 1,
        minDamage = -30,
        maxDamage = -40,
        target = true,
        shootEffect = CONST_ANI_DEATH,
        effect = CONST_ME_SMALLCLOUDS,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        range = 7,
        duration = 10000,
        speed = -226,
        target = true,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
}
monster.elements = {
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_HOLYDAMAGE, percent = -25},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "I will ssswallow your sssoul!", yell = false},
    {text = "Mort ulhegh dakh visss.", yell = false},
    {text = "Flesssh to dussst!", yell = false},
    {text = "I will tassste life again!", yell = false},
    {text = "Ahkahra exura belil mort!", yell = false},
    {text = "Yohag Sssetham!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 38000, maxCount = 80},
    {id = 3976, chance = 19000, maxCount = 3},
    {id = 12422, chance = 11690},
    {id = 10566, chance = 10000},
    {id = 2162, chance = 5800},
    {id = 2161, chance = 5000},
    {id = 2134, chance = 4000},
    {id = 2124, chance = 1500},
    {id = 2144, chance = 1000},
    {id = 5914, chance = 900},
    {id = 2411, chance = 450},
    {id = 2529, chance = 170},
    {id = 2170, chance = 100},
    {id = 11207, chance = 10},
}

mtype:register(monster)
