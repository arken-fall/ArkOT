local mtype = Game.createMonsterType("Hemming")
local monster = {}

monster.name = "Hemming"
monster.description = "Hemming"

monster.experience = 2850
monster.race = "blood"
monster.maxHealth = 3000
monster.health = 3000
monster.speed = 210
monster.manaCost = 0
monster.corpse = 20570
monster.outfit = { lookType = 308 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.targetDistance = 1
monster.staticAttackChance = 80
monster.runHealth = 300
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
    },
    {
        name = "lifedrain",
        interval = 2000,
        chance = 10,
        minDamage = -180,
        maxDamage = -265,
        radius = 3,
        target = false,
        effect = CONST_ME_SOUND_RED,
    },
    {
        name = "outfit",
        interval = 2000,
        chance = 5,
        duration = 2000,
        monster = "Werewolf",
        effect = CONST_ME_SOUND_BLUE,
    },
    {
        name = "physical",
        interval = 2000,
        chance = 40,
        radius = 3,
        target = false,
        effect = CONST_ME_SOUND_WHITE,
    },
    {
        name = "werewolf skill reducer",
        interval = 2000,
        chance = 15,
        range = 1,
    },
}
monster.defenses = {
    defense = 40,
    armor = 40,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 50,
        maxDamage = 200,
        effect = CONST_ME_MAGIC_GREEN,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        range = 7,
        duration = 5000,
        speed = 300,
        effect = CONST_ME_SOUND_PURPLE,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 30},
    {type = COMBAT_ENERGYDAMAGE, percent = 5},
    {type = COMBAT_EARTHDAMAGE, percent = 65},
    {type = COMBAT_FIREDAMAGE, percent = -5},
    {type = COMBAT_DEATHDAMAGE, percent = 50},
    {type = COMBAT_ICEDAMAGE, percent = -5},
    {type = COMBAT_HOLYDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "paralyze", condition = true},
    {type = "invisible", condition = true},
}
monster.maxSummons = 2
monster.summons = {
    {name = "War Wolf", interval = 2000, chance = 100, max = 1},
}
monster.voices = {
    interval = 2000,
    chance = 7,
    {text = "GRRR", yell = false},
    {text = "GRROARR", yell = false},
}
monster.loot = {
    {id = 2148, chance = 100000, maxCount = 99},
    {id = 11234, chance = 100000},
    {id = 5897, chance = 100000},
    {id = 8473, chance = 98000},
    {id = 2789, chance = 94000, maxCount = 5},
    {id = 2152, chance = 94000, maxCount = 10},
    {id = 7439, chance = 82000},
    {id = 2197, chance = 70000},
    {id = 2144, chance = 62000, maxCount = 5},
    {id = 5480, chance = 31000},
    {id = 2805, chance = 21000},
    {id = 11306, chance = 15000},
    {id = 7419, chance = 9800},
    {id = 2169, chance = 6000},
    {id = 7428, chance = 2000},
}

mtype:register(monster)
