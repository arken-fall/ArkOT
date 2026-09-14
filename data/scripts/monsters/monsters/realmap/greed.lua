local mtype = Game.createMonsterType("Greed")
local monster = {}

monster.name = "Greed"
monster.description = "a greed"

monster.experience = 10
monster.race = "energy"
monster.maxHealth = 1100
monster.health = 1100
monster.speed = 210
monster.manaCost = 0
monster.corpse = 8966
monster.outfit = { lookType = 290 }
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
        attack = 70,
        skill = 40,
        interval = 2000,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 15,
        range = 7,
        minDamage = -270,
        maxDamage = -915,
        radius = 2,
        target = true,
        shootEffect = CONST_ANI_ENERGY,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "energy",
        interval = 2000,
        chance = 20,
        range = 7,
        minDamage = -175,
        maxDamage = -505,
        target = true,
        shootEffect = CONST_ANI_ENERGYBALL,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "massive energy elemental electrify",
        interval = 2000,
        chance = 20,
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
    {type = COMBAT_PHYSICALDAMAGE, percent = 70},
    {type = COMBAT_HOLYDAMAGE, percent = 25},
    {type = COMBAT_DEATHDAMAGE, percent = 1},
    {type = COMBAT_EARTHDAMAGE, percent = -5},
}
monster.immunities = {
    {type = "ice", combat = true, condition = true},
    {type = "energy", combat = true, condition = true},
    {type = "fire", combat = true, condition = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}

mtype:register(monster)
