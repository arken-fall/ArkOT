local mtype = Game.createMonsterType("Seacrest Serpent")
local monster = {}

monster.name = "Seacrest Serpent"
monster.description = "a seacrest serpent"

monster.experience = 2600
monster.race = "venom"
monster.maxHealth = 3000
monster.health = 3000
monster.speed = 500
monster.manaCost = 0
monster.corpse = 24262
monster.outfit = { lookType = 675 }
monster.changeTarget = {
    interval = 5000,
    chance = 20,
}
monster.staticAttackChance = 90
monster.targetDistance = 0
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
        attack = 50,
        skill = 100,
        interval = 2000,
    },
    {
        name = "death",
        interval = 2000,
        chance = 7,
        range = 7,
        minDamage = -200,
        maxDamage = -250,
        target = true,
        shootEffect = CONST_ANI_EARTH,
        effect = CONST_ME_SOUND_RED,
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 11,
        minDamage = -200,
        maxDamage = -285,
        radius = 3,
        target = false,
        effect = CONST_ME_MAGIC_RED,
    },
    {
        name = "seacrest serpent wave",
        interval = 2000,
        chance = 9,
        minDamage = -150,
        maxDamage = -300,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 10,
        minDamage = -200,
        maxDamage = -300,
        length = 4,
        spread = 0,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.defenses = {
    defense = 20,
    armor = 16,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 145,
        maxDamage = 200,
        effect = CONST_ME_SOUND_BLUE,
    },
    {
        name = "melee",
        interval = 2000,
        effect = CONST_ME_SMALLPLANTS,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = 20},
    {type = COMBAT_ENERGYDAMAGE, percent = 10},
    {type = COMBAT_EARTHDAMAGE, percent = 20},
    {type = COMBAT_PHYSICALDAMAGE, percent = 15},
    {type = COMBAT_DEATHDAMAGE, percent = 5},
}
monster.immunities = {
    {type = "ice", combat = true, condition = true},
    {type = "drown", combat = true, condition = true},
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 5,
    {text = "WARAAAHAAARRRR!", yell = false},
    {text = "LOOK INTO THE LIGHT...", yell = false},
    {text = "LEAVE THESE GROUNDS...", yell = false},
    {text = "THE DARK TIDE WILL SWALLOW YOU...", yell = false},
}
monster.loot = {
    {id = 2672, chance = 13040, maxCount = 1},
    {id = 24170, chance = 12040, maxCount = 1},
    {id = 7839, chance = 7020, maxCount = 17},
    {id = 7902, chance = 980},
    {id = 24261, chance = 400},
    {id = 2152, chance = 100000, maxCount = 5},
    {id = 7588, chance = 7020, maxCount = 2},
    {id = 7589, chance = 10370, maxCount = 2},
    {id = 24116, chance = 10030, maxCount = 1},
    {id = 2143, chance = 3680, maxCount = 2},
    {id = 2144, chance = 2340, maxCount = 3},
    {id = 7632, chance = 1000, maxCount = 1},
    {id = 5944, chance = 3340, maxCount = 1},
    {id = 2145, chance = 5020, maxCount = 3},
    {id = 24169, chance = 7390, maxCount = 1},
    {id = 7888, chance = 670},
    {id = 7896, chance = 680},
    {id = 7892, chance = 910},
    {id = 18390, chance = 270},
    {id = 8921, chance = 370},
}

mtype:register(monster)
