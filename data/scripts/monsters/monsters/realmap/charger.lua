local mtype = Game.createMonsterType("Charger")
local monster = {}

monster.name = "Charger"
monster.description = "an charger"

monster.experience = 550
monster.race = "energy"
monster.maxHealth = 1600
monster.health = 1600
monster.speed = 290
monster.manaCost = 0
monster.corpse = 8966
monster.outfit = { lookType = 293 }
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
    illusionable = false,
    convinceable = false,
    pushable = false,
    canPushItems = false,
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
        chance = 10,
        range = 7,
        minDamage = -125,
        maxDamage = -452,
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
        maxDamage = -330,
        target = true,
        shootEffect = CONST_ANI_ENERGYBALL,
        effect = CONST_ME_ENERGYHIT,
    },
    {
        name = "energy elemental electrify",
        interval = 2000,
        chance = 40,
    },
}
monster.defenses = {
    defense = 15,
    armor = 15,
    {
        name = "healing",
        interval = 2000,
        chance = 10,
        minDamage = 90,
        maxDamage = 250,
        effect = CONST_ME_MAGIC_BLUE,
    },
}
monster.elements = {
    {type = COMBAT_PHYSICALDAMAGE, percent = 30},
    {type = COMBAT_HOLYDAMAGE, percent = 10},
    {type = COMBAT_DEATHDAMAGE, percent = 5},
    {type = COMBAT_EARTHDAMAGE, percent = -15},
}
monster.immunities = {
    {type = "fire", combat = true, condition = true},
    {type = "energy", combat = true, condition = true},
    {type = "ice", combat = true, condition = true},
    {type = "lifedrain", combat = true},
    {type = "invisible", condition = true},
    {type = "paralyze", condition = true},
}

mtype:register(monster)
