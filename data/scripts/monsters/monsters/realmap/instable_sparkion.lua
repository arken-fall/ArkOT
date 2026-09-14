local mtype = Game.createMonsterType("Instable Sparkion")
local monster = {}

monster.name = "Instable Sparkion"
monster.description = "an instable sparkion"

monster.experience = 1350
monster.race = "energy"
monster.maxHealth = 1900
monster.health = 1900
monster.speed = 250
monster.manaCost = 0
monster.corpse = 26044
monster.outfit = { lookType = 877 }
monster.changeTarget = {
    interval = 4000,
    chance = 10,
}
monster.staticAttackChance = 85
monster.targetDistance = 1
monster.runHealth = 0
monster.light = { level = 0, color = 0 }
monster.flags = {
    summonable = false,
    attackable = true,
    hostile = true,
    illusionable = true,
    convinceable = false,
    pushable = false,
    canPushItems = false,
}
monster.attacks = {
    {
        name = "melee",
        attack = 120,
        skill = 60,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 10,
        range = 7,
        minDamage = -125,
        maxDamage = -350,
        radius = 2,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -100,
        maxDamage = -190,
        target = true,
        shootEffect = CONST_ANI_ENERGYBALL,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "energy elemental electrify",
        interval = 2000,
        chance = 30,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
    {
        name = "healing",
        interval = 2000,
        chance = 20,
        minDamage = 50,
        maxDamage = 80,
        effect = CONST_ME_MAGIC_BLUE,
    },
    {
        name = "speed",
        interval = 2000,
        chance = 15,
        duration = 5000,
        speed = 400,
        effect = CONST_ME_MAGIC_RED,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = -5},
    {type = COMBAT_HOLYDAMAGE, percent = -5},
    {type = COMBAT_DEATHDAMAGE, percent = -5},
    {type = COMBAT_EARTHDAMAGE, percent = 20},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "energy", combat = true, condition = true},
    {type = "ice", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}
monster.voices = {
    interval = 2000,
    chance = 15,
    {text = "Zzing!", yell = false},
    {text = "Frizzle!", yell = false},
}
monster.loot = {
    {id = 2148, chance = 50000, maxCount = 100},
    {id = 2152, chance = 50000, maxCount = 2},
    {id = 26160, chance = 5000},
    {id = 26159, chance = 3000},
    {id = 7591, chance = 3000},
    {id = 8472, chance = 3000},
    {id = 26161, chance = 2000},
    {id = 26191, chance = 2000},
    {id = 18419, chance = 1500},
}

mtype:register(monster)
