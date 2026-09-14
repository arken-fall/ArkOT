local mtype = Game.createMonsterType("Werebear")
local monster = {}

monster.name = "Werebear"
monster.description = "a werebear"

monster.experience = 2000
monster.race = "blood"
monster.maxHealth = 2200
monster.health = 2200
monster.speed = 210
monster.manaCost = 0
monster.corpse = 24666
monster.outfit = { lookType = 720 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 275
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = true,
    canPushCreatures = true,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 50,
        maxDamage = -485,
        interval = 2000,
    },
    {
        name = "speed",
        interval = 4000,
        chance = 20,
        radius = 7,
        speed = -100,
        target = true,
        effect = CONST_ME_POFF,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 15,
        minDamage = -65,
        maxDamage = -335,
        radius = 4,
        target = false,
        effect = CONST_ME_MAGIC_GREEN,
    },
}
monster.defenses = {
    defense = 30,
    armor = 30,
    {
        name = "healing",
        interval = 2000,
        chance = 25,
        minDamage = 50,
        maxDamage = 100,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_ICEDAMAGE, percent = 20},
    {type = COMBAT_FIREDAMAGE, percent = -10},
    {type = COMBAT_ENERGYDAMAGE, percent = -10},
}
monster.immunities = {
    {type = "earth", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 40,
    {text = "GROOOWL", yell = false},
    {text = "GRRR", yell = false},
}
monster.loot = {
    {id = 2148, chance = 97000, maxCount = 242},
    {id = 2152, chance = 18200, maxCount = 5},
    {id = 7591, chance = 1200, maxCount = 2},
    {id = 8473, chance = 2210},
    {id = 7590, chance = 1200},
    {id = 5896, chance = 800},
    {id = 2671, chance = 1900, maxCount = 2},
    {id = 5902, chance = 450},
    {id = 24713, chance = 580},
    {id = 7439, chance = 800},
    {id = 24712, chance = 560},
    {id = 2197, chance = 430, subType = 5},
    {id = 7419, chance = 120},
    {id = 24741, chance = 300},
    {id = 7432, chance = 400},
    {id = 24716, chance = 100},
    {id = 7383, chance = 200},
    {id = 7452, chance = 300},
    {id = 2169, chance = 400},
    {id = 24759, chance = 200},
    {id = 24739, chance = 200},
}

mtype:register(monster)
