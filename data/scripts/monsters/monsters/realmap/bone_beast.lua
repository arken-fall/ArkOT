local mtype = Game.createMonsterType("Bonebeast")
local monster = {}

monster.name = "Bonebeast"
monster.description = "a bonebeast"

monster.experience = 580
monster.race = "undead"
monster.maxHealth = 515
monster.health = 515
monster.speed = 210
monster.manaCost = 0
monster.corpse = 6030
monster.outfit = { lookType = 101 }
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
    canWalkOnEnergy = false,
    canWalkOnFire = false,
}
monster.attacks = {
    {
        name = "melee",
        minDamage = 0,
        maxDamage = -200,
        interval = 2000,
        condition = { type = CONDITION_POISON, minDamage = -100, maxDamage = -100, interval = 4000 },
    },
    {
        name = "earth",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -50,
        maxDamage = -90,
        shootEffect = CONST_ANI_POISON,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -25,
        maxDamage = -47,
        radius = 3,
        target = false,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 10,
        minDamage = -50,
        maxDamage = -60,
        radius = 3,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "poisoncondition",
        interval = 2000,
        chance = 10,
        minDamage = -70,
        maxDamage = -80,
        length = 6,
        spread = 0,
        target = false,
        effect = CONST_ME_POISONAREA,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 13000,
        speed = -600,
        target = true,
    },
}
monster.defenses = {
    defense = 30,
    armor = 30,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 50,
        maxDamage = 60,
        effect = CONST_ME_HITBYPOISON,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -10},
    {type = COMBAT_HOLYDAMAGE, percent = -20},
}
monster.immunities = {
    {type = "death", combat = true, condition = true},
    {type = "earth", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
    {type = "drunk", condition = true},
}
monster.voices = {
    interval = 5000,
    chance = 10,
    {text = "Cccchhhhhhhhh!", yell = false},
    {text = "Knooorrrrr!", yell = false},
}
monster.loot = {
    {id = "gold coin", chance = 14000, maxCount = 50},
    {id = "gold coin", chance = 16000, maxCount = 40},
    {id = 2229, chance = 20000},
    {id = 2230, chance = 47750},
    {id = "bone club", chance = 4950},
    {id = "plate armor", chance = 8000},
    {id = "bone shield", chance = 2000},
    {id = "green mushroom", chance = 1350},
    {id = "hardened bone", chance = 960},
    {id = "health potion", chance = 540},
    {id = "bonebeast trophy", chance = 120},
    {id = "bony tail", chance = 9780},
}

mtype:register(monster)
