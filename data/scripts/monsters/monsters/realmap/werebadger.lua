local mtype = Game.createMonsterType("Werebadger")
local monster = {}

monster.name = "Werebadger"
monster.description = "a werebadger"

monster.experience = 1600
monster.race = "blood"
monster.maxHealth = 1700
monster.health = 1700
monster.speed = 210
monster.manaCost = 0
monster.corpse = 24723
monster.outfit = { lookType = 729 }
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
        name = "lifedrain",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -21,
        maxDamage = -150,
        target = true,
        shootEffect = CONST_ANI_EARTH,
        effect = CONST_ME_CARNIPHILA,
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        minDamage = -10,
        maxDamage = -100,
        length = 8,
        spread = 3,
        effect = CONST_ME_CARNIPHILA,
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
    {id = 8845, chance = 2000},
    {id = 2789, chance = 2000},
    {id = 7620, chance = 2210},
    {id = 7589, chance = 1200},
    {id = 2805, chance = 1900},
    {id = 24707, chance = 950},
    {id = 24711, chance = 780},
    {id = 24742, chance = 200},
    {id = 2171, chance = 160},
    {id = 2214, chance = 430},
    {id = 8910, chance = 220},
    {id = 8922, chance = 200},
    {id = 24739, chance = 150},
    {id = 24716, chance = 200},
    {id = 24757, chance = 100},
}

mtype:register(monster)
