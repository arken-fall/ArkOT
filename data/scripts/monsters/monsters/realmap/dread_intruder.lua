local mtype = Game.createMonsterType("Dread Intruder")
local monster = {}

monster.name = "Dread Intruder"
monster.description = "a dread intruder"

monster.experience = 3000
monster.race = "undead"
monster.maxHealth = 4500
monster.health = 4500
monster.speed = 370
monster.manaCost = 0
monster.corpse = 26213
monster.outfit = { lookType = 882 }
monster.changeTarget = {
    interval = 20000,
    chance = 20,
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
    canPushItems = true,
}
monster.attacks = {
    {
        name = "melee",
        attack = 50,
        skill = 30,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 20,
        range = 6,
        minDamage = -168,
        maxDamage = -300,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_PURPLEENERGY,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 20,
        range = 6,
        minDamage = -100,
        maxDamage = -190,
        radius = 4,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_PURPLEENERGY,
    },
    {
        name = "energycondition",
        interval = 1000,
        chance = 15,
        radius = 4,
        target = false,
        effect = CONST_ME_YELLOWENERGY,
    },
    {
        name = "physical",
        interval = 1000,
        chance = 12,
        minDamage = 0,
        maxDamage = -200,
        radius = 4,
        target = false,
        effect = CONST_ME_POFF,
    },
}
monster.defenses = {
    defense = 25,
    armor = 25,
    {
        name = "healing",
        interval = 2000,
        chance = 15,
        minDamage = 90,
        maxDamage = 150,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "energy", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "ice", combat = true, condition = true},
}
monster.loot = {
    {id = 2148, chance = 50000, maxCount = 100},
    {id = 2152, chance = 50000, maxCount = 7},
    {id = 2150, chance = 2000, maxCount = 2},
    {id = 2147, chance = 2000, maxCount = 2},
    {id = 18418, chance = 2000},
    {id = 18419, chance = 2000},
    {id = 26179, chance = 1000},
    {id = 26191, chance = 1600},
    {id = 26201, chance = 2000},
    {id = 26175, chance = 1600},
    {id = 7591, chance = 3000},
    {id = 7590, chance = 3000},
    {id = 8473, chance = 3000},
    {id = 8472, chance = 3000},
    {id = 26172, chance = 1500},
    {id = 26166, chance = 1000},
    {id = 18414, chance = 500},
    {id = 2153, chance = 500},
}

mtype:register(monster)
