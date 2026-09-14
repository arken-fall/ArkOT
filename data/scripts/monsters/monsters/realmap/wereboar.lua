local mtype = Game.createMonsterType("Wereboar")
local monster = {}

monster.name = "Wereboar"
monster.description = "a wereboar"

monster.experience = 2000
monster.race = "blood"
monster.maxHealth = 2200
monster.health = 2200
monster.speed = 210
monster.manaCost = 0
monster.corpse = 24722
monster.outfit = { lookType = 721 }
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
        attack = 60,
        skill = 50,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -140, maxDamage = -140, interval = 4000 },
    },
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -385,
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
    {
        name = "invisible",
        interval = 2000,
        chance = 20,
        duration = 2000,
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
    chance = 7,
    {text = "SNUFFLE", yell = false},
}
monster.loot = {
    {id = 2148, chance = 97000, maxCount = 242},
    {id = 2152, chance = 18200, maxCount = 5},
    {id = 2789, chance = 2000},
    {id = 8473, chance = 2210},
    {id = 7588, chance = 1200},
    {id = 24709, chance = 1900},
    {id = 24743, chance = 950},
    {id = 24710, chance = 780},
    {id = 7439, chance = 700},
    {id = 7432, chance = 360},
    {id = 2197, chance = 430, subType = 5},
    {id = 7419, chance = 320},
    {id = 24741, chance = 200},
    {id = 24758, chance = 200},
    {id = 24429, chance = 100},
    {id = 24739, chance = 150},
}

mtype:register(monster)
