local mtype = Game.createMonsterType("Zamulosh")
local monster = {}

monster.name = "Zamulosh"
monster.description = "a zamulosh"

monster.experience = 5
monster.race = "blood"
monster.maxHealth = 20000
monster.health = 20000
monster.speed = 235
monster.manaCost = 200
monster.corpse = 8062
monster.outfit = { lookType = 862, lookHead = 17, lookBody = 12, lookLegs = 73, lookFeet = 92, lookAddons = 0 }
monster.changeTarget = {
    interval = 2000,
    chance = 10,
}
monster.targetDistance = 1
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
        attack = 150,
        skill = 100,
        interval = 2000,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 7,
        range = 7,
        minDamage = -100,
        maxDamage = -300,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_POFF,
    },
    {
        name = "drunk",
        interval = 1000,
        chance = 7,
        range = 7,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYAREA,
    },
    {
        name = "strength",
        interval = 1000,
        chance = 9,
        range = 7,
        shootEffect = CONST_ANI_LARGEROCK,
        effect = CONST_ME_ENERGYAREA,
    },
    {
        name = "lifedrain",
        interval = 1000,
        chance = 13,
        minDamage = -50,
        maxDamage = -100,
        radius = 8,
        target = false,
        effect = CONST_ME_LOSEENERGY,
    },
    {
        name = "manadrain",
        interval = 1000,
        chance = 10,
        minDamage = -50,
        maxDamage = -100,
        radius = 8,
        target = false,
        effect = CONST_ME_MAGIC_GREEN,
    },
    {
        name = "speed",
        interval = 1000,
        chance = 12,
        radius = 6,
        duration = 60000,
        speed = -1900,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "strength",
        interval = 1000,
        chance = 8,
        radius = 5,
        target = false,
        effect = CONST_ME_HITAREA,
    },
    {
        name = "fire",
        interval = 1000,
        chance = 34,
        range = 7,
        minDamage = -100,
        maxDamage = -300,
        radius = 7,
        target = true,
        shootEffect = CONST_ANI_FIRE,
        effect = CONST_ME_FIREAREA,
    },
    {
        name = "lifedrain",
        interval = 1000,
        chance = 15,
        minDamage = -100,
        maxDamage = -250,
        length = 8,
        spread = 0,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.defenses = {
    defense = 160,
    armor = 160,
    {
        name = "healing",
        interval = 1000,
        chance = 25,
        minDamage = 2000,
        maxDamage = 3000,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 1000,
        chance = 8,
        duration = 5000,
        speed = 1901,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "invisible",
        interval = 1000,
        chance = 17,
        duration = 2000,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "poison", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 30,
    {text = "I AM ZAMULOSH!", yell = true},
}

mtype:register(monster)
