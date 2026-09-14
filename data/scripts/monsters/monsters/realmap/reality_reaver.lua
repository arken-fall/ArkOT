local mtype = Game.createMonsterType("Reality Reaver")
local monster = {}

monster.name = "Reality Reaver"
monster.description = "a reality reaver"

monster.experience = 3100
monster.race = "energy"
monster.maxHealth = 3900
monster.health = 3900
monster.speed = 390
monster.manaCost = 0
monster.corpse = 26068
monster.outfit = { lookType = 879 }
monster.changeTarget = {
    interval = 4000,
    chance = 15,
}
monster.staticAttackChance = 85
monster.targetDistance = 1
monster.runHealth = 0
monster.light = { level = 0, color = 0 }
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 170,
        skill = 60,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -170,
        maxDamage = -415,
        radius = 2,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "energy strike",
        interval = 2000,
        chance = 30,
        range = 1,
        minDamage = -210,
        maxDamage = -300,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -175,
        maxDamage = -205,
        target = true,
        shootEffect = CONST_ANI_ENERGYBALL,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "massive energy elemental electrify",
        interval = 2000,
        chance = 29,
        effect = CONST_ME_BLOCKHIT,
    },
}
monster.defenses = {
    defense = 20,
    armor = 20,
    {
        name = "healing",
        interval = 2000,
        chance = 5,
        minDamage = 190,
        maxDamage = 250,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_FIREDAMAGE, percent = -5},
    {type = COMBAT_EARTHDAMAGE, percent = 20},
    {type = COMBAT_ICEDAMAGE, percent = -20},
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 15,
    {text = "Ssshhh!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 50000, maxCount = 100},
    {id = 2148, chance = 50000, maxCount = 91},
    {id = 2152, chance = 5450, maxCount = 6},
    {id = 7591, chance = 5550, maxCount = 2},
    {id = 7590, chance = 5450, maxCount = 2},
    {id = 8472, chance = 5450, maxCount = 2},
    {id = 18413, chance = 1730},
    {id = 18418, chance = 1730},
    {id = 26171, chance = 1730},
    {id = 26191, chance = 5730, maxCount = 2},
    {id = 26201, chance = 3270, maxCount = 2},
    {id = 26164, chance = 730},
    {id = 7901, chance = 930},
    {id = 26176, chance = 730},
    {id = 26200, chance = 200},
    {id = 26162, chance = 730},
    {id = 18420, chance = 560},
    {id = 26187, chance = 150},
}

mtype:register(monster)
